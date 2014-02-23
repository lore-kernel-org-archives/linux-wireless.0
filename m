Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:46597 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751205AbaBWOI4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 09:08:56 -0500
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@nbd.name, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v1 5/6] mac80211: move flag IEEE80211_TX_CTL_TX_OFFCHAN into info->control.flags
Date: Sun, 23 Feb 2014 15:08:46 +0100
Message-Id: <1393164527-13800-6-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20140223_150931_137624_772EB089)
In-Reply-To: <1393164527-13800-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1393164527-13800-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Flag IEEE80211_TX_CTL_TX_OFFCHAN is only used within the tx path while
ieee80211_tx_info->control is valid. Therefore this patch moves this flag
from info->flags structure into the info->control.flags and renames it to
IEEE80211_TX_CTRL_TX_OFFCHAN.

Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 drivers/net/wireless/ath/ath10k/mac.c |    2 +-
 drivers/net/wireless/ti/wlcore/tx.c   |    2 +-
 include/net/mac80211.h                |   22 +++++++++++-----------
 net/mac80211/cfg.c                    |    5 +++--
 net/mac80211/rx.c                     |    4 ++--
 net/mac80211/tx.c                     |    2 +-
 6 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 776e364..6ca1202 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2017,7 +2017,7 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 	ATH10K_SKB_CB(skb)->htt.is_offchan = false;
 	ATH10K_SKB_CB(skb)->htt.tid = tid;
 
-	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) {
+	if (info->control.flags & IEEE80211_TX_CTRL_TX_OFFCHAN) {
 		spin_lock_bh(&ar->data_lock);
 		ATH10K_SKB_CB(skb)->htt.is_offchan = true;
 		ATH10K_SKB_CB(skb)->vdev_id = ar->scan.vdev_id;
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 40b4311..39ba78e 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -181,7 +181,7 @@ u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		return wl12xx_tx_get_hlid_ap(wl, wlvif, skb, sta);
 
 	control = IEEE80211_SKB_CB(skb);
-	if (control->flags & IEEE80211_TX_CTL_TX_OFFCHAN) {
+	if (control->control.flags & IEEE80211_TX_CTRL_TX_OFFCHAN) {
 		wl1271_debug(DEBUG_TX, "tx offchannel");
 		return wlvif->dev_hlid;
 	}
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 696aa5a..fbca4dd 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -425,10 +425,6 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_LDPC: tells the driver to use LDPC for this frame
  * @IEEE80211_TX_CTL_STBC: Enables Space-Time Block Coding (STBC) for this
  *	frame and selects the maximum number of streams that it can use.
- * @IEEE80211_TX_CTL_TX_OFFCHAN: Marks this packet to be transmitted on
- *	the off-channel channel when a remain-on-channel offload is done
- *	in hardware -- normal packets still flow and are expected to be
- *	handled properly by the device.
  * @IEEE80211_TX_INTFL_TKIP_MIC_FAILURE: Marks this packet to be used for TKIP
  *	testing. It will be sent out with incorrect Michael MIC key to allow
  *	TKIP countermeasures to be tested.
@@ -473,13 +469,12 @@ enum mac80211_tx_info_flags {
 	IEEE80211_TX_INTFL_NL80211_FRAME_TX	= BIT(17),
 	IEEE80211_TX_CTL_LDPC			= BIT(18),
 	IEEE80211_TX_CTL_STBC			= BIT(19) | BIT(20),
-	IEEE80211_TX_CTL_TX_OFFCHAN		= BIT(21),
-	IEEE80211_TX_INTFL_TKIP_MIC_FAILURE	= BIT(22),
-	IEEE80211_TX_CTL_NO_CCK_RATE		= BIT(23),
-	IEEE80211_TX_STATUS_EOSP		= BIT(24),
-	IEEE80211_TX_CTL_USE_MINRATE		= BIT(25),
-	IEEE80211_TX_CTL_DONTFRAG		= BIT(26),
-	IEEE80211_TX_CTL_PS_RESPONSE		= BIT(27),
+	IEEE80211_TX_INTFL_TKIP_MIC_FAILURE	= BIT(21),
+	IEEE80211_TX_CTL_NO_CCK_RATE		= BIT(22),
+	IEEE80211_TX_STATUS_EOSP		= BIT(23),
+	IEEE80211_TX_CTL_USE_MINRATE		= BIT(24),
+	IEEE80211_TX_CTL_DONTFRAG		= BIT(25),
+	IEEE80211_TX_CTL_PS_RESPONSE		= BIT(26),
 };
 
 #define IEEE80211_TX_CTL_STBC_SHIFT		19
@@ -506,6 +501,10 @@ enum mac80211_tx_info_flags {
  *	transmit function after the current frame, this can be used
  *	by drivers to kick the DMA queue only if unset or when the
  *	queue gets full.
+ * @IEEE80211_TX_CTRL_TX_OFFCHAN: Marks this packet to be transmitted on
+ *	the off-channel channel when a remain-on-channel offload is done
+ *	in hardware -- normal packets still flow and are expected to be
+ *	handled properly by the device.
  *
  * These flags are used in tx_info->control.flags.
  */
@@ -515,6 +514,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTRL_FIRST_FRAGMENT        = BIT(3),
 	IEEE80211_TX_CTRL_NO_PS_BUFFER          = BIT(4),
 	IEEE80211_TX_CTRL_MORE_FRAMES           = BIT(5),
+	IEEE80211_TX_CTRL_TX_OFFCHAN            = BIT(6),
 };
 
 /*
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1acb291..afdd1a3 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3388,8 +3388,9 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		goto out_unlock;
 	}
 
-	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_TX_OFFCHAN |
-					IEEE80211_TX_INTFL_OFFCHAN_TX_OK;
+	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_OFFCHAN_TX_OK;
+	IEEE80211_SKB_CB(skb)->control.flags |= IEEE80211_TX_CTRL_TX_OFFCHAN;
+
 	if (local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)
 		IEEE80211_SKB_CB(skb)->hw_queue =
 			local->hw.offchannel_tx_hw_queue;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 58e4b70..eb54b51 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2750,9 +2750,9 @@ ieee80211_rx_h_action_return(struct ieee80211_rx_data *rx)
 		if (rx->sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE) {
 			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(nskb);
 
-			info->flags = IEEE80211_TX_CTL_TX_OFFCHAN |
-				      IEEE80211_TX_INTFL_OFFCHAN_TX_OK |
+			info->flags = IEEE80211_TX_INTFL_OFFCHAN_TX_OK |
 				      IEEE80211_TX_CTL_NO_CCK_RATE;
+			info->control.flags |= IEEE80211_TX_CTRL_TX_OFFCHAN;
 			if (local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)
 				info->hw_queue =
 					local->hw.offchannel_tx_hw_queue;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6cb6ba3..62b80ef 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1434,7 +1434,7 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 	info->band = band;
 
 	/* set up hw_queue value early */
-	if (!(info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) ||
+	if (!(info->control.flags & IEEE80211_TX_CTRL_TX_OFFCHAN) ||
 	    !(local->hw.flags & IEEE80211_HW_QUEUE_CONTROL))
 		info->hw_queue =
 			sdata->vif.hw_queue[skb_get_queue_mapping(skb)];
-- 
1.7.9.5

