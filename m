Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38012 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab0F2Tut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:50:49 -0400
Received: by wyb38 with SMTP id 38so2999610wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 12:50:47 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 01/21] rt2x00: Implement tx mpdu aggregation
Date: Tue, 29 Jun 2010 21:38:12 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201006292138.13509.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

In order to implement tx mpdu aggregation we only have to implement
the ampdu_action callback such that mac80211 allows negotiation of
blockack sessions.

The hardware will handle everything on its own as long as the ampdu
flag in the TXWI struct is set up correctly and we translate the tx
status correctly.

For now, refuse requests to start rx aggregation.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   34 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt2x00dev.c |   15 +++++++++++++
 2 files changed, 48 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 14c361a..14ff706 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2499,7 +2499,8 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 	    IEEE80211_HW_SIGNAL_DBM |
 	    IEEE80211_HW_SUPPORTS_PS |
-	    IEEE80211_HW_PS_NULLFUNC_STACK;
+	    IEEE80211_HW_PS_NULLFUNC_STACK |
+	    IEEE80211_HW_AMPDU_AGGREGATION;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -2751,6 +2752,36 @@ static u64 rt2800_get_tsf(struct ieee80211_hw *hw)
 	return tsf;
 }
 
+static int rt2800_ampdu_action(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       enum ieee80211_ampdu_mlme_action action,
+			       struct ieee80211_sta *sta,
+			       u16 tid, u16 *ssn)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	int ret = 0;
+
+	switch (action) {
+	case IEEE80211_AMPDU_RX_START:
+	case IEEE80211_AMPDU_RX_STOP:
+		/* we don't support RX aggregation yet */
+		ret = -ENOTSUPP;
+		break;
+	case IEEE80211_AMPDU_TX_START:
+		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		break;
+	case IEEE80211_AMPDU_TX_STOP:
+		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		break;
+	case IEEE80211_AMPDU_TX_OPERATIONAL:
+		break;
+	default:
+		WARNING(rt2x00dev, "Unknown AMPDU action\n");
+	}
+
+	return ret;
+}
+
 const struct ieee80211_ops rt2800_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
 	.start			= rt2x00mac_start,
@@ -2768,6 +2799,7 @@ const struct ieee80211_ops rt2800_mac80211_ops = {
 	.conf_tx		= rt2800_conf_tx,
 	.get_tsf		= rt2800_get_tsf,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
+	.ampdu_action		= rt2800_ampdu_action,
 };
 EXPORT_SYMBOL_GPL(rt2800_mac80211_ops);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 339cc84..a914855 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -286,6 +286,21 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 			rt2x00dev->low_level_stats.dot11ACKFailureCount++;
 	}
 
+	/*
+	 * Every single frame has it's own tx status, hence report
+	 * every frame as ampdu of size 1.
+	 *
+	 * TODO: if we can find out how many frames were aggregated
+	 * by the hw we could provide the real ampdu_len to mac80211
+	 * which would allow the rc algorithm to better decide on
+	 * which rates are suitable.
+	 */
+	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
+		tx_info->flags |= IEEE80211_TX_STAT_AMPDU;
+		tx_info->status.ampdu_len = 1;
+		tx_info->status.ampdu_ack_len = success ? 1 : 0;
+	}
+
 	if (rate_flags & IEEE80211_TX_RC_USE_RTS_CTS) {
 		if (success)
 			rt2x00dev->low_level_stats.dot11RTSSuccessCount++;
-- 
1.6.6.1

