Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756423Ab0EJW2Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:25 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 22/47] iwlagn: implement loading a new firmware file type
Date: Mon, 10 May 2010 15:27:53 -0700
Message-Id: <1273530498-11876-23-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The old firmware file type does not allow indicating
any firmware capabilities, which we frequently want
to make things easier.

This implements a new firmware type that is based on
a TLV structure, and adds a TLV for the maximum length
of probe requests in scans.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  133 +++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   58 ++++++++++++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 +-
 4 files changed, 187 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 65ae636..97184e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1505,9 +1505,13 @@ static void iwl_nic_start(struct iwl_priv *priv)
 	iwl_write32(priv, CSR_RESET, 0);
 }
 
+struct iwlagn_ucode_capabilities {
+	u32 max_probe_length;
+};
 
 static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context);
-static int iwl_mac_setup_register(struct iwl_priv *priv);
+static int iwl_mac_setup_register(struct iwl_priv *priv,
+				  struct iwlagn_ucode_capabilities *capa);
 
 static int __must_check iwl_request_firmware(struct iwl_priv *priv, bool first)
 {
@@ -1619,6 +1623,114 @@ static int iwlagn_load_legacy_firmware(struct iwl_priv *priv,
 	return 0;
 }
 
+static int iwlagn_wanted_ucode_alternative = 1;
+
+static int iwlagn_load_firmware(struct iwl_priv *priv,
+				const struct firmware *ucode_raw,
+				struct iwlagn_firmware_pieces *pieces,
+				struct iwlagn_ucode_capabilities *capa)
+{
+	struct iwl_tlv_ucode_header *ucode = (void *)ucode_raw->data;
+	struct iwl_ucode_tlv *tlv;
+	size_t len = ucode_raw->size;
+	const u8 *data;
+	int wanted_alternative = iwlagn_wanted_ucode_alternative, tmp;
+	u64 alternatives;
+
+	if (len < sizeof(*ucode))
+		return -EINVAL;
+
+	if (ucode->magic != cpu_to_le32(IWL_TLV_UCODE_MAGIC))
+		return -EINVAL;
+
+	/*
+	 * Check which alternatives are present, and "downgrade"
+	 * when the chosen alternative is not present, warning
+	 * the user when that happens. Some files may not have
+	 * any alternatives, so don't warn in that case.
+	 */
+	alternatives = le64_to_cpu(ucode->alternatives);
+	tmp = wanted_alternative;
+	if (wanted_alternative > 63)
+		wanted_alternative = 63;
+	while (wanted_alternative && !(alternatives & BIT(wanted_alternative)))
+		wanted_alternative--;
+	if (wanted_alternative && wanted_alternative != tmp)
+		IWL_WARN(priv,
+			 "uCode alternative %d not available, choosing %d\n",
+			 tmp, wanted_alternative);
+
+	priv->ucode_ver = le32_to_cpu(ucode->ver);
+	pieces->build = le32_to_cpu(ucode->build);
+	data = ucode->data;
+
+	len -= sizeof(*ucode);
+
+	while (len >= sizeof(*tlv)) {
+		u32 tlv_len;
+		enum iwl_ucode_tlv_type tlv_type;
+		u16 tlv_alt;
+		const u8 *tlv_data;
+
+		len -= sizeof(*tlv);
+		tlv = (void *)data;
+
+		tlv_len = le32_to_cpu(tlv->length);
+		tlv_type = le16_to_cpu(tlv->type);
+		tlv_alt = le16_to_cpu(tlv->alternative);
+		tlv_data = tlv->data;
+
+		if (len < tlv_len)
+			return -EINVAL;
+		len -= ALIGN(tlv_len, 4);
+		data += sizeof(*tlv) + ALIGN(tlv_len, 4);
+
+		/*
+		 * Alternative 0 is always valid.
+		 *
+		 * Skip alternative TLVs that are not selected.
+		 */
+		if (tlv_alt != 0 && tlv_alt != wanted_alternative)
+			continue;
+
+		switch (tlv_type) {
+		case IWL_UCODE_TLV_INST:
+			pieces->inst = tlv_data;
+			pieces->inst_size = tlv_len;
+			break;
+		case IWL_UCODE_TLV_DATA:
+			pieces->data = tlv_data;
+			pieces->data_size = tlv_len;
+			break;
+		case IWL_UCODE_TLV_INIT:
+			pieces->init = tlv_data;
+			pieces->init_size = tlv_len;
+			break;
+		case IWL_UCODE_TLV_INIT_DATA:
+			pieces->init_data = tlv_data;
+			pieces->init_data_size = tlv_len;
+			break;
+		case IWL_UCODE_TLV_BOOT:
+			pieces->boot = tlv_data;
+			pieces->boot_size = tlv_len;
+			break;
+		case IWL_UCODE_TLV_PROBE_MAX_LEN:
+			if (tlv_len != 4)
+				return -EINVAL;
+			capa->max_probe_length =
+				le32_to_cpup((__le32 *)tlv_data);
+			break;
+		default:
+			break;
+		}
+	}
+
+	if (len)
+		return -EINVAL;
+
+	return 0;
+}
+
 /**
  * iwl_ucode_callback - callback when firmware was loaded
  *
@@ -1636,6 +1748,9 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	u32 api_ver;
 	char buildstr[25];
 	u32 build;
+	struct iwlagn_ucode_capabilities ucode_capa = {
+		.max_probe_length = 200,
+	};
 
 	memset(&pieces, 0, sizeof(pieces));
 
@@ -1660,7 +1775,8 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	if (ucode->ver)
 		err = iwlagn_load_legacy_firmware(priv, ucode_raw, &pieces);
 	else
-		err = -EINVAL;
+		err = iwlagn_load_firmware(priv, ucode_raw, &pieces,
+					   &ucode_capa);
 
 	if (err)
 		goto try_again;
@@ -1757,7 +1873,6 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		goto try_again;
 	}
 
-
 	/* Allocate ucode buffers for card's bus-master loading ... */
 
 	/* Runtime instructions and 2 copies of data:
@@ -1841,7 +1956,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	 *
 	 * 9. Setup and register with mac80211 and debugfs
 	 **************************************************/
-	err = iwl_mac_setup_register(priv);
+	err = iwl_mac_setup_register(priv, &ucode_capa);
 	if (err)
 		goto out_unbind;
 
@@ -2716,7 +2831,8 @@ void iwl_post_associate(struct iwl_priv *priv)
  * Not a mac80211 entry point function, but it fits in with all the
  * other mac80211 functions grouped here.
  */
-static int iwl_mac_setup_register(struct iwl_priv *priv)
+static int iwl_mac_setup_register(struct iwl_priv *priv,
+				  struct iwlagn_ucode_capabilities *capa)
 {
 	int ret;
 	struct ieee80211_hw *hw = priv->hw;
@@ -2751,7 +2867,7 @@ static int iwl_mac_setup_register(struct iwl_priv *priv)
 
 	hw->wiphy->max_scan_ssids = PROBE_OPTION_MAX;
 	/* we create the 802.11 header and a zero-length SSID element */
-	hw->wiphy->max_scan_ie_len = IWL_MAX_PROBE_REQUEST - 24 - 2;
+	hw->wiphy->max_scan_ie_len = capa->max_probe_length - 24 - 2;
 
 	/* Default value; 4 EDCA QOS priorities */
 	hw->queues = 4;
@@ -3974,3 +4090,8 @@ MODULE_PARM_DESC(fw_restart, "restart firmware in case of error");
 module_param_named(
 	disable_hw_scan, iwlagn_mod_params.disable_hw_scan, int, S_IRUGO);
 MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
+
+module_param_named(ucode_alternative, iwlagn_wanted_ucode_alternative, int,
+		   S_IRUGO);
+MODULE_PARM_DESC(ucode_alternative,
+		 "specify ucode alternative to use from ucode file");
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 0086019..449d41f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2668,7 +2668,6 @@ struct iwl_ssid_ie {
 #define IWL_GOOD_CRC_TH_NEVER		cpu_to_le16(0xffff)
 #define IWL_MAX_SCAN_SIZE 1024
 #define IWL_MAX_CMD_SIZE 4096
-#define IWL_MAX_PROBE_REQUEST		200
 
 /*
  * REPLY_SCAN_CMD = 0x80 (command)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index fe938d9..19a5c89 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -518,7 +518,7 @@ struct fw_desc {
 	u32 len;		/* bytes */
 };
 
-/* uCode file layout */
+/* v1/v2 uCode file layout */
 struct iwl_ucode_header {
 	__le32 ver;	/* major/minor/API/serial */
 	union {
@@ -542,6 +542,62 @@ struct iwl_ucode_header {
 	} u;
 };
 
+/*
+ * new TLV uCode file layout
+ *
+ * The new TLV file format contains TLVs, that each specify
+ * some piece of data. To facilitate "groups", for example
+ * different instruction image with different capabilities,
+ * bundled with the same init image, an alternative mechanism
+ * is provided:
+ * When the alternative field is 0, that means that the item
+ * is always valid. When it is non-zero, then it is only
+ * valid in conjunction with items of the same alternative,
+ * in which case the driver (user) selects one alternative
+ * to use.
+ */
+
+enum iwl_ucode_tlv_type {
+	IWL_UCODE_TLV_INVALID		= 0, /* unused */
+	IWL_UCODE_TLV_INST		= 1,
+	IWL_UCODE_TLV_DATA		= 2,
+	IWL_UCODE_TLV_INIT		= 3,
+	IWL_UCODE_TLV_INIT_DATA		= 4,
+	IWL_UCODE_TLV_BOOT		= 5,
+	IWL_UCODE_TLV_PROBE_MAX_LEN	= 6, /* a u32 value */
+};
+
+struct iwl_ucode_tlv {
+	__le16 type;		/* see above */
+	__le16 alternative;	/* see comment */
+	__le32 length;		/* not including type/length fields */
+	u8 data[0];
+} __attribute__ ((packed));
+
+#define IWL_TLV_UCODE_MAGIC	0x0a4c5749
+
+struct iwl_tlv_ucode_header {
+	/*
+	 * The TLV style ucode header is distinguished from
+	 * the v1/v2 style header by first four bytes being
+	 * zero, as such is an invalid combination of
+	 * major/minor/API/serial versions.
+	 */
+	__le32 zero;
+	__le32 magic;
+	u8 human_readable[64];
+	__le32 ver;		/* major/minor/API/serial */
+	__le32 build;
+	__le64 alternatives;	/* bitmask of valid alternatives */
+	/*
+	 * The data contained herein has a TLV layout,
+	 * see above for the TLV header and types.
+	 * Note that each TLV is padded to a length
+	 * that is a multiple of 4 for alignment.
+	 */
+	u8 data[0];
+};
+
 struct iwl4965_ibss_seq {
 	u8 mac[ETH_ALEN];
 	u16 seq_num;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 59c85f5..77ab00b 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3875,6 +3875,8 @@ err:
 	return ret;
 }
 
+#define IWL3945_MAX_PROBE_REQUEST	200
+
 static int iwl3945_setup_mac(struct iwl_priv *priv)
 {
 	int ret;
@@ -3900,7 +3902,7 @@ static int iwl3945_setup_mac(struct iwl_priv *priv)
 
 	hw->wiphy->max_scan_ssids = PROBE_OPTION_MAX_3945;
 	/* we create the 802.11 header and a zero-length SSID element */
-	hw->wiphy->max_scan_ie_len = IWL_MAX_PROBE_REQUEST - 24 - 2;
+	hw->wiphy->max_scan_ie_len = IWL3945_MAX_PROBE_REQUEST - 24 - 2;
 
 	/* Default value; 4 EDCA QOS priorities */
 	hw->queues = 4;
-- 
1.6.3.3

