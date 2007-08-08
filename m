Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758742AbXHHHhX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:37:23 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 08/28] iwlwifi: some coding styles cleanup
Date: Wed,  8 Aug 2007 15:33:25 +0800
Message-Id: <11865584452614-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1186558443548-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
 <11865584392893-git-send-email-yi.zhu@intel.com>
 <11865584413292-git-send-email-yi.zhu@intel.com>
 <1186558443548-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-base.c |   54 ++++++++++++++++-----------------------
 1 files changed, 22 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index e58dcfa..8f55f0d 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -901,15 +901,15 @@ static int iwl_check_rxon_cmd(struct iwl_rxon_cmd *rxon)
 	int counter = 1;
 
 	if (rxon->flags & RXON_FLG_BAND_24G_MSK) {
-		error |=
-			le32_to_cpu(rxon->flags & RXON_FLG_TGJ_NARROW_BAND_MSK);
-		error |= le32_to_cpu(rxon->flags & RXON_FLG_RADAR_DETECT_MSK);
+		error |= le32_to_cpu(rxon->flags &
+				(RXON_FLG_TGJ_NARROW_BAND_MSK |
+				 RXON_FLG_RADAR_DETECT_MSK));
 		if (error)
 			IWL_WARNING("check 24G fields %d | %d\n",
 				    counter++, error);
 	} else {
-		error |= ((rxon->flags & RXON_FLG_SHORT_SLOT_MSK) !=
-			RXON_FLG_SHORT_SLOT_MSK);
+		error |= (rxon->flags & RXON_FLG_SHORT_SLOT_MSK) ?
+				0 : le32_to_cpu(RXON_FLG_SHORT_SLOT_MSK);
 		if (error)
 			IWL_WARNING("check 52 fields %d | %d\n",
 				    counter++, error);
@@ -917,7 +917,6 @@ static int iwl_check_rxon_cmd(struct iwl_rxon_cmd *rxon)
 		if (error)
 			IWL_WARNING("check 52 CCK %d | %d\n",
 				    counter++, error);
-
 	}
 	error |= (rxon->node_addr[0] | rxon->bssid_addr[0]) & 0x1;
 	if (error)
@@ -925,7 +924,7 @@ static int iwl_check_rxon_cmd(struct iwl_rxon_cmd *rxon)
 
 	/* make sure basic rates 6Mbps and 1Mbps are supported */
 	error |= (((rxon->ofdm_basic_rates & IWL_RATE_6M_MASK) == 0) &&
-		((rxon->cck_basic_rates & IWL_RATE_1M_MASK) == 0));
+		  ((rxon->cck_basic_rates & IWL_RATE_1M_MASK) == 0));
 	if (error)
 		IWL_WARNING("check basic rate %d | %d\n", counter++, error);
 
@@ -933,43 +932,39 @@ static int iwl_check_rxon_cmd(struct iwl_rxon_cmd *rxon)
 	if (error)
 		IWL_WARNING("check assoc id %d | %d\n", counter++, error);
 
-	error |= ((rxon->flags &
-		   (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK)) ==
-		  (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK));
+	error |= ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK))
+			== (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK));
 	if (error)
 		IWL_WARNING("check CCK and short slot %d | %d\n",
 			    counter++, error);
 
 	error |= ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK))
-		  == (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK));
+			== (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK));
 	if (error)
 		IWL_WARNING("check CCK & auto detect %d | %d\n",
 			    counter++, error);
 
-	error |= ((rxon->flags &
-		   (RXON_FLG_AUTO_DETECT_MSK | RXON_FLG_TGG_PROTECT_MSK)) ==
-		  RXON_FLG_TGG_PROTECT_MSK);
+	error |= ((rxon->flags & (RXON_FLG_AUTO_DETECT_MSK |
+			RXON_FLG_TGG_PROTECT_MSK)) == RXON_FLG_TGG_PROTECT_MSK);
 	if (error)
-		IWL_WARNING("check TGG %d | %d\n", counter++, error);
+		IWL_WARNING("check TGG and auto detect %d | %d\n",
+			    counter++, error);
 
 #if IWL == 3945
 	if ((rxon->flags & RXON_FLG_DIS_DIV_MSK))
-		error |= ((rxon->flags &
-			   (RXON_FLG_ANT_B_MSK | RXON_FLG_ANT_A_MSK)) == 0);
+		error |= ((rxon->flags & (RXON_FLG_ANT_B_MSK |
+				RXON_FLG_ANT_A_MSK)) == 0);
 	if (error)
 		IWL_WARNING("check antenna %d %d\n", counter++, error);
 #endif
-
 	if (error)
 		IWL_WARNING("Tuning to channel %d\n",
 			    le16_to_cpu(rxon->channel));
 
 	if (error) {
-		IWL_ERROR
-		    ("Error not a valid iwl_rxon_assoc_cmd field values\n");
+		IWL_ERROR("Not a valid iwl_rxon_assoc_cmd field values\n");
 		return -1;
 	}
-
 	return 0;
 }
 
@@ -1512,7 +1507,7 @@ static int iwl_send_beacon_cmd(struct iwl_priv *priv)
 	frame = iwl_get_free_frame(priv);
 
 	if (!frame) {
-		IWL_ERROR("Coult not obtain free frame buffer for beacon "
+		IWL_ERROR("Could not obtain free frame buffer for beacon "
 			  "command.\n");
 		return -ENOMEM;
 	}
@@ -1642,9 +1637,6 @@ void iwl_report_frame(struct iwl_priv *priv,
 	u32 print_dump = 0;	/* set to 1 to dump all frames' contents */
 	u32 hundred = 0;
 	u32 dataframe = 0;
-
-	/* these are declared without "=" to avoid compiler warnings if we
-	 *   don't use them in the debug messages below */
 	u16 frame_ctl;
 	u16 seq_ctl;
 	u16 channel;
@@ -1659,7 +1651,6 @@ void iwl_report_frame(struct iwl_priv *priv,
 	u8 agc;
 	u16 sig_avg;
 	u16 noise_diff;
-
 	struct iwl_rx_frame_stats *rx_stats = IWL_RX_STATS(pkt);
 	struct iwl_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
 	struct iwl_rx_frame_end *rx_end = IWL_RX_END(pkt);
@@ -2325,12 +2316,10 @@ static int iwl_scan_cancel(struct iwl_priv *priv, unsigned long ms)
 		} else
 			IWL_DEBUG_SCAN("Scan abort already in progress.\n");
 
-
 		mutex_unlock(&priv->mutex);
 		if (ms)
-			while (!time_after(jiffies,
-					   now + msecs_to_jiffies(ms)) &&
-			       priv->status & STATUS_SCANNING)
+			while (!time_after(jiffies, now + msecs_to_jiffies(ms))
+					&& priv->status & STATUS_SCANNING)
 				msleep(1);
 
 		mutex_lock(&priv->mutex);
@@ -3914,8 +3903,9 @@ static void iwl_rx_reply_scan(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl_scanreq_notification *notif =
-	    (struct iwl_scanreq_notification *)pkt->u.raw;
+	struct iwl_scanstart_notification *notif =
+	    (struct iwl_scanstart_notification *)pkt->u.raw;
+
 	IWL_DEBUG_RX("Scan request status = 0x%x\n", notif->status);
 }
 
-- 
1.5.2
