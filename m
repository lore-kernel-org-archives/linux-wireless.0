Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f66.google.com ([209.85.210.66]:37295 "EHLO
	mail-pz0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab2FGAcp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 20:32:45 -0400
Received: by dado14 with SMTP id o14so24667dad.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 17:32:44 -0700 (PDT)
From: Jason Abele <jason@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 1/5] mac80211_hwsim: Report rate info in tx status
Date: Wed,  6 Jun 2012 17:29:37 -0700
Message-Id: <1339028981-17097-2-git-send-email-jason@cozybit.com> (sfid-20120607_023248_114778_D624100E)
In-Reply-To: <1339028981-17097-1-git-send-email-jason@cozybit.com>
References: <1339028981-17097-1-git-send-email-jason@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Timo Lindhorst <tlnd@online.de>

Assuming an ideal channel, always the first transmission is considered
successful if an ACK is received. If no ACK is received, the
rates/attempts are reported as set by the rate control.

Signed-off-by: Timo Lindhorst <tlnd@online.de>
---
 drivers/net/wireless/mac80211_hwsim.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 4c9336c..52ba3e6 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -715,6 +715,14 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	bool ack;
 	struct ieee80211_tx_info *txi;
 	u32 _pid;
+	u8 tx_count[IEEE80211_TX_MAX_RATES];
+	int i;
+	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) skb->data;
+	struct mac80211_hwsim_data *data = hw->priv;
+
+	if (ieee80211_is_beacon(mgmt->frame_control) ||
+	    ieee80211_is_probe_resp(mgmt->frame_control))
+		mgmt->u.beacon.timestamp = __mac80211_hwsim_get_tsf(data);
 
 	mac80211_hwsim_monitor_rx(hw, skb);
 
@@ -745,6 +753,10 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (txi->control.sta)
 		hwsim_check_sta_magic(txi->control.sta);
 
+	if (!ack)
+		for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
+			tx_count[i] = txi->control.rates[i].count;
+
 	ieee80211_tx_info_clear_status(txi);
 
 	/* frame was transmitted at most favorable rate at first attempt */
@@ -753,6 +765,15 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	if (!(txi->flags & IEEE80211_TX_CTL_NO_ACK) && ack)
 		txi->flags |= IEEE80211_TX_STAT_ACK;
+
+	if (ack) {
+		txi->status.rates[0].count = 1;
+		txi->status.rates[1].idx = -1;
+	} else {
+		for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
+			txi->control.rates[i].count = tx_count[i];
+	}
+
 	ieee80211_tx_status_irqsafe(hw, skb);
 }
 
-- 
1.7.9.5

