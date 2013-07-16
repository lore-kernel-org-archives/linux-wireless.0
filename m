Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:46537 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436Ab3GPHjK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 03:39:10 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 07/10] ath10k: make sure all resources are freed upon ath10k_stop()
Date: Tue, 16 Jul 2013 09:38:56 +0200
Message-ID: <1373960339-8525-8-git-send-email-michal.kazior@tieto.com> (sfid-20130716_093919_652835_90A7887D)
In-Reply-To: <1373960339-8525-1-git-send-email-michal.kazior@tieto.com>
References: <1371041642-20273-1-git-send-email-michal.kazior@tieto.com>
 <1373960339-8525-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is necessary for proper hw reconfiguration
and to avoid memory leaks.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index febba7d..b9663e9 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -369,6 +369,20 @@ static void ath10k_peer_cleanup(struct ath10k *ar, u32 vdev_id)
 	spin_unlock_bh(&ar->data_lock);
 }
 
+static void ath10k_peer_cleanup_all(struct ath10k *ar)
+{
+	struct ath10k_peer *peer, *tmp;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	spin_lock_bh(&ar->data_lock);
+	list_for_each_entry_safe(peer, tmp, &ar->peers, list) {
+		list_del(&peer->list);
+		kfree(peer);
+	}
+	spin_unlock_bh(&ar->data_lock);
+}
+
 /************************/
 /* Interface management */
 /************************/
@@ -1753,7 +1767,18 @@ static void ath10k_stop(struct ieee80211_hw *hw)
 	struct ath10k *ar = hw->priv;
 
 	mutex_lock(&ar->conf_mutex);
+	del_timer_sync(&ar->scan.timeout);
 	ath10k_offchan_tx_purge(ar);
+	ath10k_peer_cleanup_all(ar);
+
+	spin_lock_bh(&ar->data_lock);
+	if (ar->scan.in_progress) {
+		del_timer(&ar->scan.timeout);
+		ar->scan.in_progress = false;
+		ieee80211_scan_completed(ar->hw, true);
+	}
+	spin_unlock_bh(&ar->data_lock);
+
 	ar->state = ATH10K_STATE_OFF;
 	mutex_unlock(&ar->conf_mutex);
 
-- 
1.7.9.5

