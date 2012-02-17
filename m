Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64433 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659Ab2BQUXw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:52 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/26] iwlwifi: move ucode_ver to iwl_nic
Date: Fri, 17 Feb 2012 11:13:36 -0800
Message-Id: <1329506034-1394-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212432_452057_1D7DD37F)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Delete ucode_ver from iwl_priv and use iwl_nic instead.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    3 --
 drivers/net/wireless/iwlwifi/iwl-testmode.c |    6 +++-
 drivers/net/wireless/iwlwifi/iwl-ucode.c    |   29 ++++++++++++++------------
 5 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 30b99b9..c368433 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -77,7 +77,7 @@ int iwlagn_send_tx_power(struct iwl_priv *priv)
 	tx_power_cmd.flags = IWLAGN_TX_POWER_NO_CLOSED;
 	tx_power_cmd.srv_chan_lmt = IWLAGN_TX_POWER_AUTO;
 
-	if (IWL_UCODE_API(priv->ucode_ver) == 1)
+	if (IWL_UCODE_API(nic(priv)->fw.ucode_ver) == 1)
 		tx_ant_cfg_cmd = REPLY_TX_POWER_DBM_CMD_V1;
 	else
 		tx_ant_cfg_cmd = REPLY_TX_POWER_DBM_CMD;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 1cf99a5..9e902f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -618,7 +618,7 @@ static int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant)
 	  .valid = cpu_to_le32(valid_tx_ant),
 	};
 
-	if (IWL_UCODE_API(priv->ucode_ver) > 1) {
+	if (IWL_UCODE_API(nic(priv)->fw.ucode_ver) > 1) {
 		IWL_DEBUG_HC(priv, "select valid tx ant: %u\n", valid_tx_ant);
 		return iwl_trans_send_cmd_pdu(trans(priv),
 					TX_ANT_CONFIGURATION_CMD,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index db37877..f3dc67c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -789,9 +789,6 @@ struct iwl_priv {
 
 	/* uCode images, save to reload in case of failure */
 	int fw_index;			/* firmware we're trying to load */
-	u32 ucode_ver;			/* version of ucode, copy of
-					   iwl_ucode.ver */
-
 	char firmware_name[25];
 
 	struct iwl_rxon_context contexts[NUM_IWL_RXON_CTX];
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index e54a1dd..963cc6c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -553,14 +553,16 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 		break;
 
 	case IWL_TM_CMD_APP2DEV_GET_FW_VERSION:
-		IWL_INFO(priv, "uCode version raw: 0x%x\n", priv->ucode_ver);
+		IWL_INFO(priv, "uCode version raw: 0x%x\n",
+			 nic(priv)->fw.ucode_ver);
 
 		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
 		if (!skb) {
 			IWL_ERR(priv, "Memory allocation fail\n");
 			return -ENOMEM;
 		}
-		NLA_PUT_U32(skb, IWL_TM_ATTR_FW_VERSION, priv->ucode_ver);
+		NLA_PUT_U32(skb, IWL_TM_ATTR_FW_VERSION,
+			    nic(priv)->fw.ucode_ver);
 		status = cfg80211_testmode_reply(skb);
 		if (status < 0)
 			IWL_ERR(priv, "Error sending msg : %d\n", status);
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 11b659a..ca3cd8a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -738,12 +738,13 @@ static int iwlagn_load_legacy_firmware(struct iwl_priv *priv,
 				       const struct firmware *ucode_raw,
 				       struct iwlagn_firmware_pieces *pieces)
 {
+	struct iwl_nic *nic = nic(priv);
 	struct iwl_ucode_header *ucode = (void *)ucode_raw->data;
 	u32 api_ver, hdr_size;
 	const u8 *src;
 
-	priv->ucode_ver = le32_to_cpu(ucode->ver);
-	api_ver = IWL_UCODE_API(priv->ucode_ver);
+	nic->fw.ucode_ver = le32_to_cpu(ucode->ver);
+	api_ver = IWL_UCODE_API(nic->fw.ucode_ver);
 
 	switch (api_ver) {
 	default:
@@ -804,6 +805,7 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 				struct iwlagn_firmware_pieces *pieces,
 				struct iwlagn_ucode_capabilities *capa)
 {
+	struct iwl_nic *nic = nic(priv);
 	struct iwl_tlv_ucode_header *ucode = (void *)ucode_raw->data;
 	struct iwl_ucode_tlv *tlv;
 	size_t len = ucode_raw->size;
@@ -843,7 +845,7 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 			 "uCode alternative %d not available, choosing %d\n",
 			 tmp, wanted_alternative);
 
-	priv->ucode_ver = le32_to_cpu(ucode->ver);
+	nic->fw.ucode_ver = le32_to_cpu(ucode->ver);
 	pieces->build = le32_to_cpu(ucode->build);
 	data = ucode->data;
 
@@ -1008,6 +1010,7 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 {
 	struct iwl_priv *priv = context;
+	struct iwl_nic *nic = nic(priv);
 	struct iwl_ucode_header *ucode;
 	int err;
 	struct iwlagn_firmware_pieces pieces;
@@ -1057,7 +1060,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	if (err)
 		goto try_again;
 
-	api_ver = IWL_UCODE_API(priv->ucode_ver);
+	api_ver = IWL_UCODE_API(nic->fw.ucode_ver);
 	build = pieces.build;
 
 	/*
@@ -1097,19 +1100,19 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		buildstr[0] = '\0';
 
 	IWL_INFO(priv, "loaded firmware version %u.%u.%u.%u%s\n",
-		 IWL_UCODE_MAJOR(priv->ucode_ver),
-		 IWL_UCODE_MINOR(priv->ucode_ver),
-		 IWL_UCODE_API(priv->ucode_ver),
-		 IWL_UCODE_SERIAL(priv->ucode_ver),
+		 IWL_UCODE_MAJOR(nic->fw.ucode_ver),
+		 IWL_UCODE_MINOR(nic->fw.ucode_ver),
+		 IWL_UCODE_API(nic->fw.ucode_ver),
+		 IWL_UCODE_SERIAL(nic->fw.ucode_ver),
 		 buildstr);
 
 	snprintf(priv->hw->wiphy->fw_version,
 		 sizeof(priv->hw->wiphy->fw_version),
 		 "%u.%u.%u.%u%s",
-		 IWL_UCODE_MAJOR(priv->ucode_ver),
-		 IWL_UCODE_MINOR(priv->ucode_ver),
-		 IWL_UCODE_API(priv->ucode_ver),
-		 IWL_UCODE_SERIAL(priv->ucode_ver),
+		 IWL_UCODE_MAJOR(nic->fw.ucode_ver),
+		 IWL_UCODE_MINOR(nic->fw.ucode_ver),
+		 IWL_UCODE_API(nic->fw.ucode_ver),
+		 IWL_UCODE_SERIAL(nic->fw.ucode_ver),
 		 buildstr);
 
 	/*
@@ -1119,7 +1122,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	 */
 
 	IWL_DEBUG_INFO(priv, "f/w package hdr ucode version raw = 0x%x\n",
-		       priv->ucode_ver);
+		       nic->fw.ucode_ver);
 	IWL_DEBUG_INFO(priv, "f/w package hdr runtime inst size = %Zd\n",
 		       pieces.inst_size);
 	IWL_DEBUG_INFO(priv, "f/w package hdr runtime data size = %Zd\n",
-- 
1.7.0.4

