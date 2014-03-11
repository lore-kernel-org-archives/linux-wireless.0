Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:57020 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753410AbaCKPPS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 11:15:18 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@nbd.name, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v2 2/3] mac80211: move flag IEEE80211_TX_CTL_NO_PS_BUFFER into info->control.flags
Date: Tue, 11 Mar 2014 16:15:01 +0100
Message-Id: <1394550902-1228-3-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20140311_161525_973974_06079FB3)
In-Reply-To: <1394550902-1228-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1394550902-1228-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Flag IEEE80211_TX_CTL_NO_PS_BUFFER is only used within the tx path while
ieee80211_tx_info->control is valid. Therefore this patch moves this flag
from info->flags structure into the info->control.flags and renames it to
IEEE80211_TX_CTRL_NO_PS_BUFFER.

Signed-off-by: Benjamin Vahl <bvahl@net.t-labs.tu-berlin.de>
Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 drivers/net/wireless/ath/carl9170/tx.c      |    4 +--
 drivers/net/wireless/iwlegacy/4965-mac.c    |    2 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c       |    2 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    2 +-
 drivers/net/wireless/p54/txrx.c             |    2 +-
 include/net/mac80211.h                      |   47 +++++++++++++--------------
 net/mac80211/mesh_ps.c                      |    6 ++--
 net/mac80211/sta_info.c                     |   13 ++++----
 net/mac80211/tx.c                           |    5 +--
 9 files changed, 42 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 4cadfd4..f059546 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -1295,8 +1295,8 @@ static bool carl9170_tx_ps_drop(struct ar9170 *ar, struct sk_buff *skb)
 	tx_info = IEEE80211_SKB_CB(skb);
 
 	if (unlikely(sta_info->sleeping) &&
-	    !(tx_info->flags & (IEEE80211_TX_CTL_NO_PS_BUFFER |
-				IEEE80211_TX_CTL_CLEAR_PS_FILT))) {
+	    !(tx_info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT) &&
+	    !(tx_info->control.flags & IEEE80211_TX_CTRL_NO_PS_BUFFER)) {
 		rcu_read_unlock();
 
 		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU)
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 43f488a..647a678 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -1721,7 +1721,7 @@ il4965_tx_skb(struct il_priv *il,
 		sta_priv = (void *)sta->drv_priv;
 
 	if (sta_priv && sta_priv->asleep &&
-	    (info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER)) {
+	    (info->control.flags & IEEE80211_TX_CTRL_NO_PS_BUFFER)) {
 		/*
 		 * This sends an asynchronous command to the device,
 		 * but we can rely on it being processed before the
diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index a6839df..97be0a9 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -344,7 +344,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv,
 		sta_priv = (void *)sta->drv_priv;
 
 	if (sta_priv && sta_priv->asleep &&
-	    (info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER)) {
+	    (info->control.flags & IEEE80211_TX_CTRL_NO_PS_BUFFER)) {
 		/*
 		 * This sends an asynchronous command to the device,
 		 * but we can rely on it being processed before the
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 7492fc0..2582e3f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -439,7 +439,7 @@ static void iwl_mvm_mac_tx(struct ieee80211_hw *hw,
 		goto drop;
 
 	/* treat non-bufferable MMPDUs as broadcast if sta is sleeping */
-	if (unlikely(info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER &&
+	if (unlikely(info->control.flags & IEEE80211_TX_CTRL_NO_PS_BUFFER &&
 		     ieee80211_is_mgmt(hdr->frame_control) &&
 		     !ieee80211_is_deauth(hdr->frame_control) &&
 		     !ieee80211_is_disassoc(hdr->frame_control) &&
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 153c615..5d0eaed 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -694,7 +694,7 @@ static void p54_tx_80211_header(struct p54_common *priv, struct sk_buff *skb,
 	if (!(info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ))
 		*flags |= P54_HDR_FLAG_DATA_OUT_SEQNR;
 
-	if (info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER)
+	if (info->control.flags & IEEE80211_TX_CTRL_NO_PS_BUFFER)
 		*flags |= P54_HDR_FLAG_DATA_OUT_NOCANCEL;
 
 	if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT)
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 33710ee..9ab0d69 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -424,9 +424,6 @@ struct ieee80211_bss_conf {
  *	used to indicate that a frame was already retried due to PS
  * @IEEE80211_TX_INTFL_DONT_ENCRYPT: completely internal to mac80211,
  *	used to indicate frame should not be encrypted
- * @IEEE80211_TX_CTL_NO_PS_BUFFER: This frame is a response to a poll
- *	frame (PS-Poll or uAPSD) or a non-bufferable MMPDU and must
- *	be sent although the station is in powersave mode.
  * @IEEE80211_TX_CTL_MORE_FRAMES: More frames will be passed to the
  *	transmit function after the current frame, this can be used
  *	by drivers to kick the DMA queue only if unset or when the
@@ -487,23 +484,22 @@ enum mac80211_tx_info_flags {
 	IEEE80211_TX_INTFL_NEED_TXPROCESSING	= BIT(13),
 	IEEE80211_TX_INTFL_RETRIED		= BIT(14),
 	IEEE80211_TX_INTFL_DONT_ENCRYPT		= BIT(15),
-	IEEE80211_TX_CTL_NO_PS_BUFFER		= BIT(16),
-	IEEE80211_TX_CTL_MORE_FRAMES		= BIT(17),
-	IEEE80211_TX_INTFL_RETRANSMISSION	= BIT(18),
-	IEEE80211_TX_INTFL_MLME_CONN_TX		= BIT(19),
-	IEEE80211_TX_INTFL_NL80211_FRAME_TX	= BIT(20),
-	IEEE80211_TX_CTL_LDPC			= BIT(21),
-	IEEE80211_TX_CTL_STBC			= BIT(22) | BIT(23),
-	IEEE80211_TX_CTL_TX_OFFCHAN		= BIT(24),
-	IEEE80211_TX_INTFL_TKIP_MIC_FAILURE	= BIT(25),
-	IEEE80211_TX_CTL_NO_CCK_RATE		= BIT(26),
-	IEEE80211_TX_STATUS_EOSP		= BIT(27),
-	IEEE80211_TX_CTL_USE_MINRATE		= BIT(28),
-	IEEE80211_TX_CTL_DONTFRAG		= BIT(29),
-	IEEE80211_TX_CTL_PS_RESPONSE		= BIT(30),
+	IEEE80211_TX_CTL_MORE_FRAMES		= BIT(16),
+	IEEE80211_TX_INTFL_RETRANSMISSION	= BIT(17),
+	IEEE80211_TX_INTFL_MLME_CONN_TX		= BIT(18),
+	IEEE80211_TX_INTFL_NL80211_FRAME_TX	= BIT(19),
+	IEEE80211_TX_CTL_LDPC			= BIT(20),
+	IEEE80211_TX_CTL_STBC			= BIT(21) | BIT(22),
+	IEEE80211_TX_CTL_TX_OFFCHAN		= BIT(23),
+	IEEE80211_TX_INTFL_TKIP_MIC_FAILURE	= BIT(24),
+	IEEE80211_TX_CTL_NO_CCK_RATE		= BIT(25),
+	IEEE80211_TX_STATUS_EOSP		= BIT(26),
+	IEEE80211_TX_CTL_USE_MINRATE		= BIT(27),
+	IEEE80211_TX_CTL_DONTFRAG		= BIT(28),
+	IEEE80211_TX_CTL_PS_RESPONSE		= BIT(29),
 };
 
-#define IEEE80211_TX_CTL_STBC_SHIFT		22
+#define IEEE80211_TX_CTL_STBC_SHIFT		21
 
 /**
  * enum mac80211_tx_control_flags - flags to describe transmit control
@@ -511,12 +507,16 @@ enum mac80211_tx_info_flags {
  * @IEEE80211_TX_CTRL_PORT_CTRL_PROTO: this frame is a port control
  *	protocol frame (e.g. EAP)
  * @IEEE80211_TX_CTRL_FIRST_FRAGMENT: this is a first fragment of the frame
+ * @IEEE80211_TX_CTL_NO_PS_BUFFER: This frame is a response to a poll
+ *      frame (PS-Poll or uAPSD) or a non-bufferable MMPDU and must
+ *      be sent although the station is in powersave mode.
  *
  * These flags are used in tx_info->control.flags.
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTRL_PORT_CTRL_PROTO	= BIT(0),
 	IEEE80211_TX_CTRL_FIRST_FRAGMENT        = BIT(1),
+	IEEE80211_TX_CTRL_NO_PS_BUFFER          = BIT(2),
 };
 
 /*
@@ -528,9 +528,8 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_SEND_AFTER_DTIM | IEEE80211_TX_CTL_AMPDU |	      \
 	IEEE80211_TX_STAT_TX_FILTERED |	IEEE80211_TX_STAT_ACK |		      \
 	IEEE80211_TX_STAT_AMPDU | IEEE80211_TX_STAT_AMPDU_NO_BACK |	      \
-	IEEE80211_TX_CTL_RATE_CTRL_PROBE | IEEE80211_TX_CTL_NO_PS_BUFFER |    \
-	IEEE80211_TX_CTL_MORE_FRAMES | IEEE80211_TX_CTL_LDPC |		      \
-	IEEE80211_TX_CTL_STBC)
+	IEEE80211_TX_CTL_RATE_CTRL_PROBE | IEEE80211_TX_CTL_STBC |	      \
+	IEEE80211_TX_CTL_MORE_FRAMES | IEEE80211_TX_CTL_LDPC)
 
 /**
  * enum mac80211_rate_control_flags - per-rate flags set by the
@@ -2058,7 +2057,7 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
  * the station sends a PS-Poll or a uAPSD trigger frame, mac80211
  * will inform the driver of this with the @allow_buffered_frames
  * callback; this callback is optional. mac80211 will then transmit
- * the frames as usual and set the %IEEE80211_TX_CTL_NO_PS_BUFFER
+ * the frames as usual and set the %IEEE80211_TX_CTRL_NO_PS_BUFFER
  * on each frame. The last frame in the service period (or the only
  * response to a PS-Poll) also has %IEEE80211_TX_STATUS_EOSP set to
  * indicate that it ends the service period; as this frame must have
@@ -2067,7 +2066,7 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
  * marked has having ended and a new one can be started by the peer.
  *
  * Additionally, non-bufferable MMPDUs can also be transmitted by
- * mac80211 with the %IEEE80211_TX_CTL_NO_PS_BUFFER set in them.
+ * mac80211 with the %IEEE80211_TX_CTRL_NO_PS_BUFFER set in them.
  *
  * Another race condition can happen on some devices like iwlwifi
  * when there are frames queued for the station and it wakes up
@@ -2675,7 +2674,7 @@ enum ieee80211_roc_type {
  * @allow_buffered_frames: Prepare device to allow the given number of frames
  *	to go out to the given station. The frames will be sent by mac80211
  *	via the usual TX path after this call. The TX information for frames
- *	released will also have the %IEEE80211_TX_CTL_NO_PS_BUFFER flag set
+ *	released will also have the %IEEE80211_TX_CTRL_NO_PS_BUFFER flag set
  *	and the last one will also have %IEEE80211_TX_STATUS_EOSP set. In case
  *	frames from multiple TIDs are released and the driver might reorder
  *	them between the TIDs, it must set the %IEEE80211_TX_STATUS_EOSP flag
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index 2802f9d..6bd9bef 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -391,8 +391,8 @@ static void mpsp_trigger_send(struct sta_info *sta, bool rspi, bool eosp)
 
 	info = IEEE80211_SKB_CB(skb);
 
-	info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER |
-		       IEEE80211_TX_CTL_REQ_TX_STATUS;
+	info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+	info->control.flags |= IEEE80211_TX_CTRL_NO_PS_BUFFER;
 
 	mps_dbg(sdata, "sending MPSP trigger%s%s to %pM\n",
 		rspi ? " RSPI" : "", eosp ? " EOSP" : "", sta->sta.addr);
@@ -499,7 +499,7 @@ static void mps_frame_deliver(struct sta_info *sta, int n_frames)
 		 * STA may still remain is PS mode after this frame
 		 * exchange.
 		 */
-		info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;
+		info->control.flags |= IEEE80211_TX_CTRL_NO_PS_BUFFER;
 
 		if (more_data || !skb_queue_is_last(&frames, skb))
 			hdr->frame_control |=
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index decd30c..ca0ca1b 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1207,10 +1207,11 @@ static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
 	 * exchange. Also set EOSP to indicate this packet
 	 * ends the poll/service period.
 	 */
-	info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER |
-		       IEEE80211_TX_CTL_PS_RESPONSE |
-		       IEEE80211_TX_STATUS_EOSP |
-		       IEEE80211_TX_CTL_REQ_TX_STATUS;
+	info->flags |= IEEE80211_TX_CTL_PS_RESPONSE |
+		IEEE80211_TX_STATUS_EOSP |
+		IEEE80211_TX_CTL_REQ_TX_STATUS;
+	
+	info->control.flags |= IEEE80211_TX_CTRL_NO_PS_BUFFER;
 
 	if (call_driver)
 		drv_allow_buffered_frames(local, sta, BIT(tid), 1,
@@ -1359,8 +1360,8 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 			 * STA may still remain is PS mode after this frame
 			 * exchange.
 			 */
-			info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER |
-				       IEEE80211_TX_CTL_PS_RESPONSE;
+			info->flags |= IEEE80211_TX_CTL_PS_RESPONSE;
+			info->control.flags |= IEEE80211_TX_CTRL_NO_PS_BUFFER;
 
 			/*
 			 * Use MoreData flag to indicate whether there are
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index de1a7da..09988fc 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -470,7 +470,8 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 
 	if (unlikely((test_sta_flag(sta, WLAN_STA_PS_STA) ||
 		      test_sta_flag(sta, WLAN_STA_PS_DRIVER)) &&
-		     !(info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER))) {
+		     !(info->control.flags &
+		       IEEE80211_TX_CTRL_NO_PS_BUFFER))) {
 		int ac = skb_get_queue_mapping(tx->skb);
 
 		ps_dbg(sta->sdata, "STA %pM aid %d: PS buffer for AC %d\n",
@@ -525,7 +526,7 @@ ieee80211_tx_h_ps_buf(struct ieee80211_tx_data *tx)
 	if (ieee80211_is_mgmt(hdr->frame_control) &&
 	    !ieee80211_is_bufferable_mmpdu(hdr->frame_control)) {
 		if (tx->flags & IEEE80211_TX_UNICAST)
-			info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;
+			info->control.flags |= IEEE80211_TX_CTRL_NO_PS_BUFFER;
 		return TX_CONTINUE;
 	}
 
-- 
1.7.9.5

