Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:46134 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760240AbXHHHiS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:38:18 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 23/28] iwlwifi: Endianity fix for frame control
Date: Wed,  8 Aug 2007 15:33:40 +0800
Message-Id: <1186558479530-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584771950-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
 <11865584392893-git-send-email-yi.zhu@intel.com>
 <11865584413292-git-send-email-yi.zhu@intel.com>
 <1186558443548-git-send-email-yi.zhu@intel.com>
 <11865584452614-git-send-email-yi.zhu@intel.com>
 <11865584473732-git-send-email-yi.zhu@intel.com>
 <11865584503648-git-send-email-yi.zhu@intel.com>
 <11865584521358-git-send-email-yi.zhu@intel.com>
 <11865584543903-git-send-email-yi.zhu@intel.com>
 <11865584562811-git-send-email-yi.zhu@intel.com>
 <11865584583336-git-send-email-yi.zhu@intel.com>
 <11865584603865-git-send-email-yi.zhu@intel.com>
 <11865584631842-git-send-email-yi.zhu@intel.com>
 <11865584661209-git-send-email-yi.zhu@intel.com>
 <11865584683474-git-send-email-yi.zhu@intel.com>
 <1186558470949-git-send-email-yi.zhu@intel.com>
 <11865584733882-git-send-email-yi.zhu@intel.com>
 <11865584754153-git-send-email-yi.zhu@intel.com>
 <11865584771950-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes endianity issue for frame control field
in iwl_hw_build_tx_cmd_rate function. In addition it converts
frame_ctl to fc to align name convention in driver.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-4965.c |    9 ++++-----
 drivers/net/wireless/iwl-base.c |   28 ++++++++++++++--------------
 2 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index 631bd19..eca9eed 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -2637,6 +2637,7 @@ void iwl_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 	u8 rts_retry_limit = 0;
 	u8 data_retry_limit = 0;
 	__le32 tx_flags;
+	u16 fc = le16_to_cpu(hdr->frame_control);
 
 	tx_flags = cmd->cmd.tx.tx_flags;
 
@@ -2645,7 +2646,7 @@ void iwl_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 	rts_retry_limit = (is_hcca) ?
 	    RTS_HCCA_RETRY_LIMIT : RTS_DFAULT_RETRY_LIMIT;
 
-	if (ieee80211_is_probe_response(hdr->frame_control)) {
+	if (ieee80211_is_probe_response(fc)) {
 		data_retry_limit = 3;
 		if (data_retry_limit < rts_retry_limit)
 			rts_retry_limit = data_retry_limit;
@@ -2655,10 +2656,8 @@ void iwl_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 	if (priv->data_retry_limit != -1)
 		data_retry_limit = priv->data_retry_limit;
 
-	if ((le16_to_cpu(hdr->frame_control) & IEEE80211_FCTL_FTYPE)
-			== IEEE80211_FTYPE_MGMT) {
-		switch (le16_to_cpu(hdr->frame_control) &
-			IEEE80211_FCTL_STYPE) {
+	if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) {
+		switch (fc & IEEE80211_FCTL_STYPE) {
 		case IEEE80211_STYPE_AUTH:
 		case IEEE80211_STYPE_DEAUTH:
 		case IEEE80211_STYPE_ASSOC_REQ:
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 2c107e7..a6cac9c 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -1718,7 +1718,7 @@ void iwl_report_frame(struct iwl_priv *priv,
 	u32 print_dump = 0;	/* set to 1 to dump all frames' contents */
 	u32 hundred = 0;
 	u32 dataframe = 0;
-	u16 frame_ctl;
+	u16 fc;
 	u16 seq_ctl;
 	u16 channel;
 	u16 phy_flags;
@@ -1738,7 +1738,7 @@ void iwl_report_frame(struct iwl_priv *priv,
 	u8 *data = IWL_RX_DATA(pkt);
 
 	/* MAC header */
-	frame_ctl = le16_to_cpu(header->frame_control);
+	fc = le16_to_cpu(header->frame_control);
 	seq_ctl = le16_to_cpu(header->seq_ctrl);
 
 	/* metadata */
@@ -1763,7 +1763,7 @@ void iwl_report_frame(struct iwl_priv *priv,
 
 	/* if data frame is to us and all is good,
 	 *   (optionally) print summary for only 1 out of every 100 */
-	if (to_us && (frame_ctl & ~IEEE80211_FCTL_PROTECTED) ==
+	if (to_us && (fc & ~IEEE80211_FCTL_PROTECTED) ==
 	    (IEEE80211_FCTL_FROMDS | IEEE80211_FTYPE_DATA)) {
 		dataframe = 1;
 		if (!group100)
@@ -1787,25 +1787,25 @@ void iwl_report_frame(struct iwl_priv *priv,
 
 		if (hundred)
 			title = "100Frames";
-		else if (frame_ctl & IEEE80211_FCTL_RETRY)
+		else if (fc & IEEE80211_FCTL_RETRY)
 			title = "Retry";
-		else if (ieee80211_is_assoc_response(frame_ctl))
+		else if (ieee80211_is_assoc_response(fc))
 			title = "AscRsp";
-		else if (ieee80211_is_reassoc_response(frame_ctl))
+		else if (ieee80211_is_reassoc_response(fc))
 			title = "RasRsp";
-		else if (ieee80211_is_probe_response(frame_ctl)) {
+		else if (ieee80211_is_probe_response(fc)) {
 			title = "PrbRsp";
 			print_dump = 1;	/* dump frame contents */
-		} else if (ieee80211_is_beacon(frame_ctl)) {
+		} else if (ieee80211_is_beacon(fc)) {
 			title = "Beacon";
 			print_dump = 1;	/* dump frame contents */
-		} else if (ieee80211_is_atim(frame_ctl))
+		} else if (ieee80211_is_atim(fc))
 			title = "ATIM";
-		else if (ieee80211_is_auth(frame_ctl))
+		else if (ieee80211_is_auth(fc))
 			title = "Auth";
-		else if (ieee80211_is_deauth(frame_ctl))
+		else if (ieee80211_is_deauth(fc))
 			title = "DeAuth";
-		else if (ieee80211_is_disassoc(frame_ctl))
+		else if (ieee80211_is_disassoc(fc))
 			title = "DisAssoc";
 		else
 			title = "Frame";
@@ -1822,14 +1822,14 @@ void iwl_report_frame(struct iwl_priv *priv,
 		if (dataframe)
 			IWL_DEBUG_RX("%s: mhd=0x%04x, dst=0x%02x, "
 				     "len=%u, rssi=%d, chnl=%d, rate=%u, \n",
-				     title, frame_ctl, header->addr1[5],
+				     title, fc, header->addr1[5],
 				     length, rssi, channel, rate);
 		else {
 			/* src/dst addresses assume managed mode */
 			IWL_DEBUG_RX("%s: 0x%04x, dst=0x%02x, "
 				     "src=0x%02x, rssi=%u, tim=%lu usec, "
 				     "phy=0x%02x, chnl=%d\n",
-				     title, frame_ctl, header->addr1[5],
+				     title, fc, header->addr1[5],
 				     header->addr3[5], rssi,
 				     tsf_low - priv->scan_start_tsf,
 				     phy_flags, channel);
-- 
1.5.2
