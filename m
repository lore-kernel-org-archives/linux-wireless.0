Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34499 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762163Ab0J2Xfl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 19:35:41 -0400
Received: by bwz11 with SMTP id 11so3037812bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Oct 2010 16:35:40 -0700 (PDT)
Message-Id: <8ce627c3355d74c9431812dad5fcf8327d6534b5.1288393804.git.chunkeey@googlemail.com>
In-Reply-To: <cover.1288393804.git.chunkeey@googlemail.com>
References: <cover.1288393804.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Fri, 29 Oct 2010 23:41:16 +0200
Subject: [PATCH 5/6] carl9170: stop stale uplink BA sessions
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a possible lengthy stall if the device
is operating as an experimental 11n AP and an STA
[during heavy txrx action] suddenly signalized to go
off-channel (old NetworkManager), or (sleep - which is
unlikely, because then it wouldn't be *active* at all!?).

Because the driver has to manage the BA Window, the
sudden PSM transition can leave active uplink BA
sessions to the STA in a bad state and a proper
cleanup is needed.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/tx.c |   54 ++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index b575c86..b27969c 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -524,6 +524,59 @@ next:
 	}
 }
 
+static void carl9170_tx_ampdu_timeout(struct ar9170 *ar)
+{
+	struct carl9170_sta_tid *iter;
+	struct sk_buff *skb;
+	struct ieee80211_tx_info *txinfo;
+	struct carl9170_tx_info *arinfo;
+	struct _carl9170_tx_superframe *super;
+	struct ieee80211_sta *sta;
+	struct ieee80211_vif *vif;
+	struct ieee80211_hdr *hdr;
+	unsigned int vif_id;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(iter, &ar->tx_ampdu_list, list) {
+		if (iter->state < CARL9170_TID_STATE_IDLE)
+			continue;
+
+		spin_lock_bh(&iter->lock);
+		skb = skb_peek(&iter->queue);
+		if (!skb)
+			goto unlock;
+
+		txinfo = IEEE80211_SKB_CB(skb);
+		arinfo = (void *)txinfo->rate_driver_data;
+		if (time_is_after_jiffies(arinfo->timeout +
+		    msecs_to_jiffies(CARL9170_QUEUE_TIMEOUT)))
+			goto unlock;
+
+		super = (void *) skb->data;
+		hdr = (void *) super->frame_data;
+
+		vif_id = (super->s.misc & CARL9170_TX_SUPER_MISC_VIF_ID) >>
+			 CARL9170_TX_SUPER_MISC_VIF_ID_S;
+
+		if (WARN_ON(vif_id >= AR9170_MAX_VIRTUAL_MAC))
+			goto unlock;
+
+		vif = rcu_dereference(ar->vif_priv[vif_id].vif);
+		if (WARN_ON(!vif))
+			goto unlock;
+
+		sta = ieee80211_find_sta(vif, hdr->addr1);
+		if (WARN_ON(!sta))
+			goto unlock;
+
+		ieee80211_stop_tx_ba_session(sta, iter->tid);
+unlock:
+		spin_unlock_bh(&iter->lock);
+
+	}
+	rcu_read_unlock();
+}
+
 void carl9170_tx_janitor(struct work_struct *work)
 {
 	struct ar9170 *ar = container_of(work, struct ar9170,
@@ -534,6 +587,7 @@ void carl9170_tx_janitor(struct work_struct *work)
 	ar->tx_janitor_last_run = jiffies;
 
 	carl9170_check_queue_stop_timeout(ar);
+	carl9170_tx_ampdu_timeout(ar);
 
 	if (!atomic_read(&ar->tx_total_queued))
 		return;
-- 
1.7.2.3

