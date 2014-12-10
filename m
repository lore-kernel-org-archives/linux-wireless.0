Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:35513 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324AbaLJPyN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 10:54:13 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] mac80211: Move IEEE80211_TX_CTL_PS_RESPONSE
Date: Wed, 10 Dec 2014 21:26:10 +0530
Message-Id: <1418226973-13779-1-git-send-email-sujith@msujith.org> (sfid-20141210_165421_248226_3D261803)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Move IEEE80211_TX_CTL_PS_RESPONSE to info->control.flags since
this is used only in the TX path (by ath9k). This frees up
a bit which can be used for other purposes.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 6 ++++--
 include/net/mac80211.h                | 6 +++---
 net/mac80211/sta_info.c               | 7 ++++---
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index e9bd02c..4caee66 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2259,7 +2259,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ath_txq *txq = txctl->txq;
 	struct ath_atx_tid *tid = NULL;
 	struct ath_buf *bf;
-	bool queue, skip_uapsd = false;
+	bool queue, skip_uapsd = false, ps_resp;
 	int q, ret;
 
 	if (vif)
@@ -2268,6 +2268,8 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN)
 		txctl->force_channel = true;
 
+	ps_resp = !!(info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE);
+
 	ret = ath_tx_prepare(hw, skb, txctl);
 	if (ret)
 	    return ret;
@@ -2310,7 +2312,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	if (txctl->an && queue)
 		tid = ath_get_skb_tid(sc, txctl->an, skb);
 
-	if (!skip_uapsd && (info->flags & IEEE80211_TX_CTL_PS_RESPONSE)) {
+	if (!skip_uapsd && ps_resp) {
 		ath_txq_unlock(sc, txq);
 		txq = sc->tx.uapsdq;
 		ath_txq_lock(sc, txq);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 58d719d..b36e60d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -505,8 +505,6 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_DONTFRAG: Don't fragment this packet even if it
  *	would be fragmented by size (this is optional, only used for
  *	monitor injection).
- * @IEEE80211_TX_CTL_PS_RESPONSE: This frame is a response to a poll
- *	frame (PS-Poll or uAPSD).
  *
  * Note: If you have to add new flags to the enumeration, then don't
  *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
@@ -542,7 +540,6 @@ enum mac80211_tx_info_flags {
 	IEEE80211_TX_STATUS_EOSP		= BIT(28),
 	IEEE80211_TX_CTL_USE_MINRATE		= BIT(29),
 	IEEE80211_TX_CTL_DONTFRAG		= BIT(30),
-	IEEE80211_TX_CTL_PS_RESPONSE		= BIT(31),
 };
 
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
@@ -552,11 +549,14 @@ enum mac80211_tx_info_flags {
  *
  * @IEEE80211_TX_CTRL_PORT_CTRL_PROTO: this frame is a port control
  *	protocol frame (e.g. EAP)
+ * @IEEE80211_TX_CTRL_PS_RESPONSE: This frame is a response to a poll
+ *	frame (PS-Poll or uAPSD).
  *
  * These flags are used in tx_info->control.flags.
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTRL_PORT_CTRL_PROTO	= BIT(0),
+	IEEE80211_TX_CTRL_PS_RESPONSE		= BIT(1),
 };
 
 /*
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index a42f5b2..db8b07a 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1243,10 +1243,11 @@ static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
 	 * ends the poll/service period.
 	 */
 	info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER |
-		       IEEE80211_TX_CTL_PS_RESPONSE |
 		       IEEE80211_TX_STATUS_EOSP |
 		       IEEE80211_TX_CTL_REQ_TX_STATUS;
 
+	info->control.flags |= IEEE80211_TX_CTRL_PS_RESPONSE;
+
 	if (call_driver)
 		drv_allow_buffered_frames(local, sta, BIT(tid), 1,
 					  reason, false);
@@ -1395,8 +1396,8 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 			 * STA may still remain is PS mode after this frame
 			 * exchange.
 			 */
-			info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER |
-				       IEEE80211_TX_CTL_PS_RESPONSE;
+			info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;
+			info->control.flags |= IEEE80211_TX_CTRL_PS_RESPONSE;
 
 			/*
 			 * Use MoreData flag to indicate whether there are
-- 
2.1.3

