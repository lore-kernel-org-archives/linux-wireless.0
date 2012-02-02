Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30243 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287Ab2BCAQ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:59 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 26/28] iwlwifi: move all ucode routines to iwl-ucode.c
Date: Thu,  2 Feb 2012 15:09:17 -0800
Message-Id: <1328224159-18134-27-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011733_155582_E176F0C3)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

The routines dealing with the ucode are spread through several files.
Move them all to the same file and create a iwl-ucode.h file with the
ucode file definitions.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  609 +--------------------------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |  108 -----
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h    |    2 -
 drivers/net/wireless/iwlwifi/iwl-ucode.c    |  610 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-ucode.h    |  178 ++++++++
 7 files changed, 791 insertions(+), 719 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-ucode.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c41c394..8837171 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -34,7 +34,6 @@
 #include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
-#include <linux/firmware.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 
@@ -42,6 +41,7 @@
 
 #include <asm/div64.h>
 
+#include "iwl-ucode.h"
 #include "iwl-eeprom.h"
 #include "iwl-wifi.h"
 #include "iwl-dev.h"
@@ -490,7 +490,7 @@ static void iwl_bg_tx_flush(struct work_struct *work)
 	iwlagn_dev_txfifo_flush(priv, IWL_DROP_ALL);
 }
 
-static void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
+void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
 {
 	int i;
 
@@ -548,611 +548,6 @@ static void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
 	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
 }
 
-static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context);
-
-#define UCODE_EXPERIMENTAL_INDEX	100
-#define UCODE_EXPERIMENTAL_TAG		"exp"
-
-static int __must_check iwl_request_firmware(struct iwl_priv *priv, bool first)
-{
-	const char *name_pre = cfg(priv)->fw_name_pre;
-	char tag[8];
-
-	if (first) {
-#ifdef CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
-		priv->fw_index = UCODE_EXPERIMENTAL_INDEX;
-		strcpy(tag, UCODE_EXPERIMENTAL_TAG);
-	} else if (priv->fw_index == UCODE_EXPERIMENTAL_INDEX) {
-#endif
-		priv->fw_index = cfg(priv)->ucode_api_max;
-		sprintf(tag, "%d", priv->fw_index);
-	} else {
-		priv->fw_index--;
-		sprintf(tag, "%d", priv->fw_index);
-	}
-
-	if (priv->fw_index < cfg(priv)->ucode_api_min) {
-		IWL_ERR(priv, "no suitable firmware found!\n");
-		return -ENOENT;
-	}
-
-	sprintf(priv->firmware_name, "%s%s%s", name_pre, tag, ".ucode");
-
-	IWL_DEBUG_INFO(priv, "attempting to load firmware %s'%s'\n",
-		       (priv->fw_index == UCODE_EXPERIMENTAL_INDEX)
-				? "EXPERIMENTAL " : "",
-		       priv->firmware_name);
-
-	return request_firmware_nowait(THIS_MODULE, 1, priv->firmware_name,
-				       trans(priv)->dev,
-				       GFP_KERNEL, priv, iwl_ucode_callback);
-}
-
-struct iwlagn_firmware_pieces {
-	const void *inst, *data, *init, *init_data, *wowlan_inst, *wowlan_data;
-	size_t inst_size, data_size, init_size, init_data_size,
-	       wowlan_inst_size, wowlan_data_size;
-
-	u32 build;
-
-	u32 init_evtlog_ptr, init_evtlog_size, init_errlog_ptr;
-	u32 inst_evtlog_ptr, inst_evtlog_size, inst_errlog_ptr;
-};
-
-static int iwlagn_load_legacy_firmware(struct iwl_priv *priv,
-				       const struct firmware *ucode_raw,
-				       struct iwlagn_firmware_pieces *pieces)
-{
-	struct iwl_ucode_header *ucode = (void *)ucode_raw->data;
-	u32 api_ver, hdr_size;
-	const u8 *src;
-
-	priv->ucode_ver = le32_to_cpu(ucode->ver);
-	api_ver = IWL_UCODE_API(priv->ucode_ver);
-
-	switch (api_ver) {
-	default:
-		hdr_size = 28;
-		if (ucode_raw->size < hdr_size) {
-			IWL_ERR(priv, "File size too small!\n");
-			return -EINVAL;
-		}
-		pieces->build = le32_to_cpu(ucode->u.v2.build);
-		pieces->inst_size = le32_to_cpu(ucode->u.v2.inst_size);
-		pieces->data_size = le32_to_cpu(ucode->u.v2.data_size);
-		pieces->init_size = le32_to_cpu(ucode->u.v2.init_size);
-		pieces->init_data_size = le32_to_cpu(ucode->u.v2.init_data_size);
-		src = ucode->u.v2.data;
-		break;
-	case 0:
-	case 1:
-	case 2:
-		hdr_size = 24;
-		if (ucode_raw->size < hdr_size) {
-			IWL_ERR(priv, "File size too small!\n");
-			return -EINVAL;
-		}
-		pieces->build = 0;
-		pieces->inst_size = le32_to_cpu(ucode->u.v1.inst_size);
-		pieces->data_size = le32_to_cpu(ucode->u.v1.data_size);
-		pieces->init_size = le32_to_cpu(ucode->u.v1.init_size);
-		pieces->init_data_size = le32_to_cpu(ucode->u.v1.init_data_size);
-		src = ucode->u.v1.data;
-		break;
-	}
-
-	/* Verify size of file vs. image size info in file's header */
-	if (ucode_raw->size != hdr_size + pieces->inst_size +
-				pieces->data_size + pieces->init_size +
-				pieces->init_data_size) {
-
-		IWL_ERR(priv,
-			"uCode file size %d does not match expected size\n",
-			(int)ucode_raw->size);
-		return -EINVAL;
-	}
-
-	pieces->inst = src;
-	src += pieces->inst_size;
-	pieces->data = src;
-	src += pieces->data_size;
-	pieces->init = src;
-	src += pieces->init_size;
-	pieces->init_data = src;
-	src += pieces->init_data_size;
-
-	return 0;
-}
-
-static int iwlagn_load_firmware(struct iwl_priv *priv,
-				const struct firmware *ucode_raw,
-				struct iwlagn_firmware_pieces *pieces,
-				struct iwlagn_ucode_capabilities *capa)
-{
-	struct iwl_tlv_ucode_header *ucode = (void *)ucode_raw->data;
-	struct iwl_ucode_tlv *tlv;
-	size_t len = ucode_raw->size;
-	const u8 *data;
-	int wanted_alternative = iwlagn_mod_params.wanted_ucode_alternative;
-	int tmp;
-	u64 alternatives;
-	u32 tlv_len;
-	enum iwl_ucode_tlv_type tlv_type;
-	const u8 *tlv_data;
-
-	if (len < sizeof(*ucode)) {
-		IWL_ERR(priv, "uCode has invalid length: %zd\n", len);
-		return -EINVAL;
-	}
-
-	if (ucode->magic != cpu_to_le32(IWL_TLV_UCODE_MAGIC)) {
-		IWL_ERR(priv, "invalid uCode magic: 0X%x\n",
-			le32_to_cpu(ucode->magic));
-		return -EINVAL;
-	}
-
-	/*
-	 * Check which alternatives are present, and "downgrade"
-	 * when the chosen alternative is not present, warning
-	 * the user when that happens. Some files may not have
-	 * any alternatives, so don't warn in that case.
-	 */
-	alternatives = le64_to_cpu(ucode->alternatives);
-	tmp = wanted_alternative;
-	if (wanted_alternative > 63)
-		wanted_alternative = 63;
-	while (wanted_alternative && !(alternatives & BIT(wanted_alternative)))
-		wanted_alternative--;
-	if (wanted_alternative && wanted_alternative != tmp)
-		IWL_WARN(priv,
-			 "uCode alternative %d not available, choosing %d\n",
-			 tmp, wanted_alternative);
-
-	priv->ucode_ver = le32_to_cpu(ucode->ver);
-	pieces->build = le32_to_cpu(ucode->build);
-	data = ucode->data;
-
-	len -= sizeof(*ucode);
-
-	while (len >= sizeof(*tlv)) {
-		u16 tlv_alt;
-
-		len -= sizeof(*tlv);
-		tlv = (void *)data;
-
-		tlv_len = le32_to_cpu(tlv->length);
-		tlv_type = le16_to_cpu(tlv->type);
-		tlv_alt = le16_to_cpu(tlv->alternative);
-		tlv_data = tlv->data;
-
-		if (len < tlv_len) {
-			IWL_ERR(priv, "invalid TLV len: %zd/%u\n",
-				len, tlv_len);
-			return -EINVAL;
-		}
-		len -= ALIGN(tlv_len, 4);
-		data += sizeof(*tlv) + ALIGN(tlv_len, 4);
-
-		/*
-		 * Alternative 0 is always valid.
-		 *
-		 * Skip alternative TLVs that are not selected.
-		 */
-		if (tlv_alt != 0 && tlv_alt != wanted_alternative)
-			continue;
-
-		switch (tlv_type) {
-		case IWL_UCODE_TLV_INST:
-			pieces->inst = tlv_data;
-			pieces->inst_size = tlv_len;
-			break;
-		case IWL_UCODE_TLV_DATA:
-			pieces->data = tlv_data;
-			pieces->data_size = tlv_len;
-			break;
-		case IWL_UCODE_TLV_INIT:
-			pieces->init = tlv_data;
-			pieces->init_size = tlv_len;
-			break;
-		case IWL_UCODE_TLV_INIT_DATA:
-			pieces->init_data = tlv_data;
-			pieces->init_data_size = tlv_len;
-			break;
-		case IWL_UCODE_TLV_BOOT:
-			IWL_ERR(priv, "Found unexpected BOOT ucode\n");
-			break;
-		case IWL_UCODE_TLV_PROBE_MAX_LEN:
-			if (tlv_len != sizeof(u32))
-				goto invalid_tlv_len;
-			capa->max_probe_length =
-					le32_to_cpup((__le32 *)tlv_data);
-			break;
-		case IWL_UCODE_TLV_PAN:
-			if (tlv_len)
-				goto invalid_tlv_len;
-			capa->flags |= IWL_UCODE_TLV_FLAGS_PAN;
-			break;
-		case IWL_UCODE_TLV_FLAGS:
-			/* must be at least one u32 */
-			if (tlv_len < sizeof(u32))
-				goto invalid_tlv_len;
-			/* and a proper number of u32s */
-			if (tlv_len % sizeof(u32))
-				goto invalid_tlv_len;
-			/*
-			 * This driver only reads the first u32 as
-			 * right now no more features are defined,
-			 * if that changes then either the driver
-			 * will not work with the new firmware, or
-			 * it'll not take advantage of new features.
-			 */
-			capa->flags = le32_to_cpup((__le32 *)tlv_data);
-			break;
-		case IWL_UCODE_TLV_INIT_EVTLOG_PTR:
-			if (tlv_len != sizeof(u32))
-				goto invalid_tlv_len;
-			pieces->init_evtlog_ptr =
-					le32_to_cpup((__le32 *)tlv_data);
-			break;
-		case IWL_UCODE_TLV_INIT_EVTLOG_SIZE:
-			if (tlv_len != sizeof(u32))
-				goto invalid_tlv_len;
-			pieces->init_evtlog_size =
-					le32_to_cpup((__le32 *)tlv_data);
-			break;
-		case IWL_UCODE_TLV_INIT_ERRLOG_PTR:
-			if (tlv_len != sizeof(u32))
-				goto invalid_tlv_len;
-			pieces->init_errlog_ptr =
-					le32_to_cpup((__le32 *)tlv_data);
-			break;
-		case IWL_UCODE_TLV_RUNT_EVTLOG_PTR:
-			if (tlv_len != sizeof(u32))
-				goto invalid_tlv_len;
-			pieces->inst_evtlog_ptr =
-					le32_to_cpup((__le32 *)tlv_data);
-			break;
-		case IWL_UCODE_TLV_RUNT_EVTLOG_SIZE:
-			if (tlv_len != sizeof(u32))
-				goto invalid_tlv_len;
-			pieces->inst_evtlog_size =
-					le32_to_cpup((__le32 *)tlv_data);
-			break;
-		case IWL_UCODE_TLV_RUNT_ERRLOG_PTR:
-			if (tlv_len != sizeof(u32))
-				goto invalid_tlv_len;
-			pieces->inst_errlog_ptr =
-					le32_to_cpup((__le32 *)tlv_data);
-			break;
-		case IWL_UCODE_TLV_ENHANCE_SENS_TBL:
-			if (tlv_len)
-				goto invalid_tlv_len;
-			priv->enhance_sensitivity_table = true;
-			break;
-		case IWL_UCODE_TLV_WOWLAN_INST:
-			pieces->wowlan_inst = tlv_data;
-			pieces->wowlan_inst_size = tlv_len;
-			break;
-		case IWL_UCODE_TLV_WOWLAN_DATA:
-			pieces->wowlan_data = tlv_data;
-			pieces->wowlan_data_size = tlv_len;
-			break;
-		case IWL_UCODE_TLV_PHY_CALIBRATION_SIZE:
-			if (tlv_len != sizeof(u32))
-				goto invalid_tlv_len;
-			capa->standard_phy_calibration_size =
-					le32_to_cpup((__le32 *)tlv_data);
-			break;
-		default:
-			IWL_DEBUG_INFO(priv, "unknown TLV: %d\n", tlv_type);
-			break;
-		}
-	}
-
-	if (len) {
-		IWL_ERR(priv, "invalid TLV after parsing: %zd\n", len);
-		iwl_print_hex_dump(priv, IWL_DL_FW, (u8 *)data, len);
-		return -EINVAL;
-	}
-
-	return 0;
-
- invalid_tlv_len:
-	IWL_ERR(priv, "TLV %d has invalid size: %u\n", tlv_type, tlv_len);
-	iwl_print_hex_dump(priv, IWL_DL_FW, tlv_data, tlv_len);
-
-	return -EINVAL;
-}
-
-/**
- * iwl_ucode_callback - callback when firmware was loaded
- *
- * If loaded successfully, copies the firmware into buffers
- * for the card to fetch (via DMA).
- */
-static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
-{
-	struct iwl_priv *priv = context;
-	struct iwl_ucode_header *ucode;
-	int err;
-	struct iwlagn_firmware_pieces pieces;
-	const unsigned int api_max = cfg(priv)->ucode_api_max;
-	unsigned int api_ok = cfg(priv)->ucode_api_ok;
-	const unsigned int api_min = cfg(priv)->ucode_api_min;
-	u32 api_ver;
-	char buildstr[25];
-	u32 build;
-	struct iwlagn_ucode_capabilities ucode_capa = {
-		.max_probe_length = 200,
-		.standard_phy_calibration_size =
-			IWL_DEFAULT_STANDARD_PHY_CALIBRATE_TBL_SIZE,
-	};
-
-	if (!api_ok)
-		api_ok = api_max;
-
-	memset(&pieces, 0, sizeof(pieces));
-
-	if (!ucode_raw) {
-		if (priv->fw_index <= api_ok)
-			IWL_ERR(priv,
-				"request for firmware file '%s' failed.\n",
-				priv->firmware_name);
-		goto try_again;
-	}
-
-	IWL_DEBUG_INFO(priv, "Loaded firmware file '%s' (%zd bytes).\n",
-		       priv->firmware_name, ucode_raw->size);
-
-	/* Make sure that we got at least the API version number */
-	if (ucode_raw->size < 4) {
-		IWL_ERR(priv, "File size way too small!\n");
-		goto try_again;
-	}
-
-	/* Data from ucode file:  header followed by uCode images */
-	ucode = (struct iwl_ucode_header *)ucode_raw->data;
-
-	if (ucode->ver)
-		err = iwlagn_load_legacy_firmware(priv, ucode_raw, &pieces);
-	else
-		err = iwlagn_load_firmware(priv, ucode_raw, &pieces,
-					   &ucode_capa);
-
-	if (err)
-		goto try_again;
-
-	api_ver = IWL_UCODE_API(priv->ucode_ver);
-	build = pieces.build;
-
-	/*
-	 * api_ver should match the api version forming part of the
-	 * firmware filename ... but we don't check for that and only rely
-	 * on the API version read from firmware header from here on forward
-	 */
-	/* no api version check required for experimental uCode */
-	if (priv->fw_index != UCODE_EXPERIMENTAL_INDEX) {
-		if (api_ver < api_min || api_ver > api_max) {
-			IWL_ERR(priv,
-				"Driver unable to support your firmware API. "
-				"Driver supports v%u, firmware is v%u.\n",
-				api_max, api_ver);
-			goto try_again;
-		}
-
-		if (api_ver < api_ok) {
-			if (api_ok != api_max)
-				IWL_ERR(priv, "Firmware has old API version, "
-					"expected v%u through v%u, got v%u.\n",
-					api_ok, api_max, api_ver);
-			else
-				IWL_ERR(priv, "Firmware has old API version, "
-					"expected v%u, got v%u.\n",
-					api_max, api_ver);
-			IWL_ERR(priv, "New firmware can be obtained from "
-				      "http://www.intellinuxwireless.org/.\n");
-		}
-	}
-
-	if (build)
-		sprintf(buildstr, " build %u%s", build,
-		       (priv->fw_index == UCODE_EXPERIMENTAL_INDEX)
-				? " (EXP)" : "");
-	else
-		buildstr[0] = '\0';
-
-	IWL_INFO(priv, "loaded firmware version %u.%u.%u.%u%s\n",
-		 IWL_UCODE_MAJOR(priv->ucode_ver),
-		 IWL_UCODE_MINOR(priv->ucode_ver),
-		 IWL_UCODE_API(priv->ucode_ver),
-		 IWL_UCODE_SERIAL(priv->ucode_ver),
-		 buildstr);
-
-	snprintf(priv->hw->wiphy->fw_version,
-		 sizeof(priv->hw->wiphy->fw_version),
-		 "%u.%u.%u.%u%s",
-		 IWL_UCODE_MAJOR(priv->ucode_ver),
-		 IWL_UCODE_MINOR(priv->ucode_ver),
-		 IWL_UCODE_API(priv->ucode_ver),
-		 IWL_UCODE_SERIAL(priv->ucode_ver),
-		 buildstr);
-
-	/*
-	 * For any of the failures below (before allocating pci memory)
-	 * we will try to load a version with a smaller API -- maybe the
-	 * user just got a corrupted version of the latest API.
-	 */
-
-	IWL_DEBUG_INFO(priv, "f/w package hdr ucode version raw = 0x%x\n",
-		       priv->ucode_ver);
-	IWL_DEBUG_INFO(priv, "f/w package hdr runtime inst size = %Zd\n",
-		       pieces.inst_size);
-	IWL_DEBUG_INFO(priv, "f/w package hdr runtime data size = %Zd\n",
-		       pieces.data_size);
-	IWL_DEBUG_INFO(priv, "f/w package hdr init inst size = %Zd\n",
-		       pieces.init_size);
-	IWL_DEBUG_INFO(priv, "f/w package hdr init data size = %Zd\n",
-		       pieces.init_data_size);
-
-	/* Verify that uCode images will fit in card's SRAM */
-	if (pieces.inst_size > hw_params(priv).max_inst_size) {
-		IWL_ERR(priv, "uCode instr len %Zd too large to fit in\n",
-			pieces.inst_size);
-		goto try_again;
-	}
-
-	if (pieces.data_size > hw_params(priv).max_data_size) {
-		IWL_ERR(priv, "uCode data len %Zd too large to fit in\n",
-			pieces.data_size);
-		goto try_again;
-	}
-
-	if (pieces.init_size > hw_params(priv).max_inst_size) {
-		IWL_ERR(priv, "uCode init instr len %Zd too large to fit in\n",
-			pieces.init_size);
-		goto try_again;
-	}
-
-	if (pieces.init_data_size > hw_params(priv).max_data_size) {
-		IWL_ERR(priv, "uCode init data len %Zd too large to fit in\n",
-			pieces.init_data_size);
-		goto try_again;
-	}
-
-	/* Allocate ucode buffers for card's bus-master loading ... */
-
-	/* Runtime instructions and 2 copies of data:
-	 * 1) unmodified from disk
-	 * 2) backup cache for save/restore during power-downs */
-	if (iwl_alloc_fw_desc(trans(priv), &trans(priv)->ucode_rt.code,
-			      pieces.inst, pieces.inst_size))
-		goto err_pci_alloc;
-	if (iwl_alloc_fw_desc(trans(priv), &trans(priv)->ucode_rt.data,
-			      pieces.data, pieces.data_size))
-		goto err_pci_alloc;
-
-	/* Initialization instructions and data */
-	if (pieces.init_size && pieces.init_data_size) {
-		if (iwl_alloc_fw_desc(trans(priv),
-				      &trans(priv)->ucode_init.code,
-				      pieces.init, pieces.init_size))
-			goto err_pci_alloc;
-		if (iwl_alloc_fw_desc(trans(priv),
-				      &trans(priv)->ucode_init.data,
-				      pieces.init_data, pieces.init_data_size))
-			goto err_pci_alloc;
-	}
-
-	/* WoWLAN instructions and data */
-	if (pieces.wowlan_inst_size && pieces.wowlan_data_size) {
-		if (iwl_alloc_fw_desc(trans(priv),
-				      &trans(priv)->ucode_wowlan.code,
-				      pieces.wowlan_inst,
-				      pieces.wowlan_inst_size))
-			goto err_pci_alloc;
-		if (iwl_alloc_fw_desc(trans(priv),
-				      &trans(priv)->ucode_wowlan.data,
-				      pieces.wowlan_data,
-				      pieces.wowlan_data_size))
-			goto err_pci_alloc;
-	}
-
-	/* Now that we can no longer fail, copy information */
-
-	/*
-	 * The (size - 16) / 12 formula is based on the information recorded
-	 * for each event, which is of mode 1 (including timestamp) for all
-	 * new microcodes that include this information.
-	 */
-	priv->init_evtlog_ptr = pieces.init_evtlog_ptr;
-	if (pieces.init_evtlog_size)
-		priv->init_evtlog_size = (pieces.init_evtlog_size - 16)/12;
-	else
-		priv->init_evtlog_size =
-			cfg(priv)->base_params->max_event_log_size;
-	priv->init_errlog_ptr = pieces.init_errlog_ptr;
-	priv->inst_evtlog_ptr = pieces.inst_evtlog_ptr;
-	if (pieces.inst_evtlog_size)
-		priv->inst_evtlog_size = (pieces.inst_evtlog_size - 16)/12;
-	else
-		priv->inst_evtlog_size =
-			cfg(priv)->base_params->max_event_log_size;
-	priv->inst_errlog_ptr = pieces.inst_errlog_ptr;
-#ifndef CONFIG_IWLWIFI_P2P
-	ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
-#endif
-
-	priv->new_scan_threshold_behaviour =
-		!!(ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWSCAN);
-
-	if (!(cfg(priv)->sku & EEPROM_SKU_CAP_IPAN_ENABLE))
-		ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
-
-	/*
-	 * if not PAN, then don't support P2P -- might be a uCode
-	 * packaging bug or due to the eeprom check above
-	 */
-	if (!(ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN))
-		ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_P2P;
-
-	if (ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN) {
-		priv->sta_key_max_num = STA_KEY_MAX_NUM_PAN;
-		priv->shrd->cmd_queue = IWL_IPAN_CMD_QUEUE_NUM;
-	} else {
-		priv->sta_key_max_num = STA_KEY_MAX_NUM;
-		priv->shrd->cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
-	}
-	/*
-	 * figure out the offset of chain noise reset and gain commands
-	 * base on the size of standard phy calibration commands table size
-	 */
-	if (ucode_capa.standard_phy_calibration_size >
-	    IWL_MAX_PHY_CALIBRATE_TBL_SIZE)
-		ucode_capa.standard_phy_calibration_size =
-			IWL_MAX_STANDARD_PHY_CALIBRATE_TBL_SIZE;
-
-	priv->phy_calib_chain_noise_reset_cmd =
-		ucode_capa.standard_phy_calibration_size;
-	priv->phy_calib_chain_noise_gain_cmd =
-		ucode_capa.standard_phy_calibration_size + 1;
-
-	/* initialize all valid contexts */
-	iwl_init_context(priv, ucode_capa.flags);
-
-	/**************************************************
-	 * This is still part of probe() in a sense...
-	 *
-	 * 9. Setup and register with mac80211 and debugfs
-	 **************************************************/
-	err = iwlagn_mac_setup_register(priv, &ucode_capa);
-	if (err)
-		goto out_unbind;
-
-	err = iwl_dbgfs_register(priv, DRV_NAME);
-	if (err)
-		IWL_ERR(priv, "failed to create debugfs files. Ignoring error: %d\n", err);
-
-	/* We have our copies now, allow OS release its copies */
-	release_firmware(ucode_raw);
-	complete(&priv->firmware_loading_complete);
-	return;
-
- try_again:
-	/* try next, if any */
-	if (iwl_request_firmware(priv, false))
-		goto out_unbind;
-	release_firmware(ucode_raw);
-	return;
-
- err_pci_alloc:
-	IWL_ERR(priv, "failed to allocate pci memory\n");
-	iwl_dealloc_ucode(trans(priv));
- out_unbind:
-	complete(&priv->firmware_loading_complete);
-	device_release_driver(trans(priv)->dev);
-	release_firmware(ucode_raw);
-}
-
 static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 {
 	struct iwl_ct_kill_config cmd;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 0f5133a..37c325f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -107,6 +107,7 @@ void iwlagn_config_ht40(struct ieee80211_conf *conf,
 int iwlagn_rx_calib_result(struct iwl_priv *priv,
 			    struct iwl_rx_mem_buffer *rxb,
 			    struct iwl_device_cmd *cmd);
+void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags);
 
 /* lib */
 int iwlagn_send_tx_power(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index fff5b62..aa99457 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -292,114 +292,6 @@ struct iwl_vif_priv {
 	u8 ibss_bssid_sta_id;
 };
 
-/* v1/v2 uCode file layout */
-struct iwl_ucode_header {
-	__le32 ver;	/* major/minor/API/serial */
-	union {
-		struct {
-			__le32 inst_size;	/* bytes of runtime code */
-			__le32 data_size;	/* bytes of runtime data */
-			__le32 init_size;	/* bytes of init code */
-			__le32 init_data_size;	/* bytes of init data */
-			__le32 boot_size;	/* bytes of bootstrap code */
-			u8 data[0];		/* in same order as sizes */
-		} v1;
-		struct {
-			__le32 build;		/* build number */
-			__le32 inst_size;	/* bytes of runtime code */
-			__le32 data_size;	/* bytes of runtime data */
-			__le32 init_size;	/* bytes of init code */
-			__le32 init_data_size;	/* bytes of init data */
-			__le32 boot_size;	/* bytes of bootstrap code */
-			u8 data[0];		/* in same order as sizes */
-		} v2;
-	} u;
-};
-
-/*
- * new TLV uCode file layout
- *
- * The new TLV file format contains TLVs, that each specify
- * some piece of data. To facilitate "groups", for example
- * different instruction image with different capabilities,
- * bundled with the same init image, an alternative mechanism
- * is provided:
- * When the alternative field is 0, that means that the item
- * is always valid. When it is non-zero, then it is only
- * valid in conjunction with items of the same alternative,
- * in which case the driver (user) selects one alternative
- * to use.
- */
-
-enum iwl_ucode_tlv_type {
-	IWL_UCODE_TLV_INVALID		= 0, /* unused */
-	IWL_UCODE_TLV_INST		= 1,
-	IWL_UCODE_TLV_DATA		= 2,
-	IWL_UCODE_TLV_INIT		= 3,
-	IWL_UCODE_TLV_INIT_DATA		= 4,
-	IWL_UCODE_TLV_BOOT		= 5,
-	IWL_UCODE_TLV_PROBE_MAX_LEN	= 6, /* a u32 value */
-	IWL_UCODE_TLV_PAN		= 7,
-	IWL_UCODE_TLV_RUNT_EVTLOG_PTR	= 8,
-	IWL_UCODE_TLV_RUNT_EVTLOG_SIZE	= 9,
-	IWL_UCODE_TLV_RUNT_ERRLOG_PTR	= 10,
-	IWL_UCODE_TLV_INIT_EVTLOG_PTR	= 11,
-	IWL_UCODE_TLV_INIT_EVTLOG_SIZE	= 12,
-	IWL_UCODE_TLV_INIT_ERRLOG_PTR	= 13,
-	IWL_UCODE_TLV_ENHANCE_SENS_TBL	= 14,
-	IWL_UCODE_TLV_PHY_CALIBRATION_SIZE = 15,
-	IWL_UCODE_TLV_WOWLAN_INST	= 16,
-	IWL_UCODE_TLV_WOWLAN_DATA	= 17,
-	IWL_UCODE_TLV_FLAGS		= 18,
-};
-
-/**
- * enum iwl_ucode_tlv_flag - ucode API flags
- * @IWL_UCODE_TLV_FLAGS_PAN: This is PAN capable microcode; this previously
- *	was a separate TLV but moved here to save space.
- * @IWL_UCODE_TLV_FLAGS_NEWSCAN: new uCode scan behaviour on hidden SSID,
- *	treats good CRC threshold as a boolean
- * @IWL_UCODE_TLV_FLAGS_MFP: This uCode image supports MFP (802.11w).
- * @IWL_UCODE_TLV_FLAGS_P2P: This uCode image supports P2P.
- */
-enum iwl_ucode_tlv_flag {
-	IWL_UCODE_TLV_FLAGS_PAN		= BIT(0),
-	IWL_UCODE_TLV_FLAGS_NEWSCAN	= BIT(1),
-	IWL_UCODE_TLV_FLAGS_MFP		= BIT(2),
-	IWL_UCODE_TLV_FLAGS_P2P		= BIT(3),
-};
-
-struct iwl_ucode_tlv {
-	__le16 type;		/* see above */
-	__le16 alternative;	/* see comment */
-	__le32 length;		/* not including type/length fields */
-	u8 data[0];
-} __packed;
-
-#define IWL_TLV_UCODE_MAGIC	0x0a4c5749
-
-struct iwl_tlv_ucode_header {
-	/*
-	 * The TLV style ucode header is distinguished from
-	 * the v1/v2 style header by first four bytes being
-	 * zero, as such is an invalid combination of
-	 * major/minor/API/serial versions.
-	 */
-	__le32 zero;
-	__le32 magic;
-	u8 human_readable[64];
-	__le32 ver;		/* major/minor/API/serial */
-	__le32 build;
-	__le64 alternatives;	/* bitmask of valid alternatives */
-	/*
-	 * The data contained herein has a TLV layout,
-	 * see above for the TLV header and types.
-	 * Note that each TLV is padded to a length
-	 * that is a multiple of 4 for alignment.
-	 */
-	u8 data[0];
-};
-
 struct iwl_sensitivity_ranges {
 	u16 min_nrg_cck;
 	u16 max_nrg_cck;
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 7177fd7..d8025fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -35,7 +35,6 @@
 #include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
-#include <linux/firmware.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 
@@ -43,6 +42,7 @@
 
 #include <asm/div64.h>
 
+#include "iwl-ucode.h"
 #include "iwl-eeprom.h"
 #include "iwl-wifi.h"
 #include "iwl-dev.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index a305e96..ae68c51 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -410,8 +410,6 @@ static inline u32 iwl_trans_read32(struct iwl_trans *trans, u32 ofs)
 /*****************************************************
 * Utils functions
 ******************************************************/
-int iwl_alloc_fw_desc(struct iwl_trans *trans, struct fw_desc *desc,
-		      const void *data, size_t len);
 void iwl_dealloc_ucode(struct iwl_trans *trans);
 
 int iwl_send_calib_results(struct iwl_trans *trans);
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 87ce587..11b659a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -32,7 +32,9 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/dma-mapping.h>
+#include <linux/firmware.h>
 
+#include "iwl-ucode.h"
 #include "iwl-wifi.h"
 #include "iwl-dev.h"
 #include "iwl-core.h"
@@ -102,7 +104,7 @@ void iwl_dealloc_ucode(struct iwl_trans *trans)
 	iwl_free_fw_img(trans, &trans->ucode_wowlan);
 }
 
-int iwl_alloc_fw_desc(struct iwl_trans *trans, struct fw_desc *desc,
+static int iwl_alloc_fw_desc(struct iwl_trans *trans, struct fw_desc *desc,
 		      const void *data, size_t len)
 {
 	if (!len) {
@@ -680,3 +682,609 @@ int iwl_run_init_ucode(struct iwl_trans *trans)
 	iwl_trans_stop_device(trans);
 	return ret;
 }
+
+static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context);
+
+#define UCODE_EXPERIMENTAL_INDEX	100
+#define UCODE_EXPERIMENTAL_TAG		"exp"
+
+int __must_check iwl_request_firmware(struct iwl_priv *priv, bool first)
+{
+	const char *name_pre = cfg(priv)->fw_name_pre;
+	char tag[8];
+
+	if (first) {
+#ifdef CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
+		priv->fw_index = UCODE_EXPERIMENTAL_INDEX;
+		strcpy(tag, UCODE_EXPERIMENTAL_TAG);
+	} else if (priv->fw_index == UCODE_EXPERIMENTAL_INDEX) {
+#endif
+		priv->fw_index = cfg(priv)->ucode_api_max;
+		sprintf(tag, "%d", priv->fw_index);
+	} else {
+		priv->fw_index--;
+		sprintf(tag, "%d", priv->fw_index);
+	}
+
+	if (priv->fw_index < cfg(priv)->ucode_api_min) {
+		IWL_ERR(priv, "no suitable firmware found!\n");
+		return -ENOENT;
+	}
+
+	sprintf(priv->firmware_name, "%s%s%s", name_pre, tag, ".ucode");
+
+	IWL_DEBUG_INFO(priv, "attempting to load firmware %s'%s'\n",
+		       (priv->fw_index == UCODE_EXPERIMENTAL_INDEX)
+				? "EXPERIMENTAL " : "",
+		       priv->firmware_name);
+
+	return request_firmware_nowait(THIS_MODULE, 1, priv->firmware_name,
+				       trans(priv)->dev,
+				       GFP_KERNEL, priv, iwl_ucode_callback);
+}
+
+struct iwlagn_firmware_pieces {
+	const void *inst, *data, *init, *init_data, *wowlan_inst, *wowlan_data;
+	size_t inst_size, data_size, init_size, init_data_size,
+	       wowlan_inst_size, wowlan_data_size;
+
+	u32 build;
+
+	u32 init_evtlog_ptr, init_evtlog_size, init_errlog_ptr;
+	u32 inst_evtlog_ptr, inst_evtlog_size, inst_errlog_ptr;
+};
+
+static int iwlagn_load_legacy_firmware(struct iwl_priv *priv,
+				       const struct firmware *ucode_raw,
+				       struct iwlagn_firmware_pieces *pieces)
+{
+	struct iwl_ucode_header *ucode = (void *)ucode_raw->data;
+	u32 api_ver, hdr_size;
+	const u8 *src;
+
+	priv->ucode_ver = le32_to_cpu(ucode->ver);
+	api_ver = IWL_UCODE_API(priv->ucode_ver);
+
+	switch (api_ver) {
+	default:
+		hdr_size = 28;
+		if (ucode_raw->size < hdr_size) {
+			IWL_ERR(priv, "File size too small!\n");
+			return -EINVAL;
+		}
+		pieces->build = le32_to_cpu(ucode->u.v2.build);
+		pieces->inst_size = le32_to_cpu(ucode->u.v2.inst_size);
+		pieces->data_size = le32_to_cpu(ucode->u.v2.data_size);
+		pieces->init_size = le32_to_cpu(ucode->u.v2.init_size);
+		pieces->init_data_size = le32_to_cpu(ucode->u.v2.init_data_size);
+		src = ucode->u.v2.data;
+		break;
+	case 0:
+	case 1:
+	case 2:
+		hdr_size = 24;
+		if (ucode_raw->size < hdr_size) {
+			IWL_ERR(priv, "File size too small!\n");
+			return -EINVAL;
+		}
+		pieces->build = 0;
+		pieces->inst_size = le32_to_cpu(ucode->u.v1.inst_size);
+		pieces->data_size = le32_to_cpu(ucode->u.v1.data_size);
+		pieces->init_size = le32_to_cpu(ucode->u.v1.init_size);
+		pieces->init_data_size = le32_to_cpu(ucode->u.v1.init_data_size);
+		src = ucode->u.v1.data;
+		break;
+	}
+
+	/* Verify size of file vs. image size info in file's header */
+	if (ucode_raw->size != hdr_size + pieces->inst_size +
+				pieces->data_size + pieces->init_size +
+				pieces->init_data_size) {
+
+		IWL_ERR(priv,
+			"uCode file size %d does not match expected size\n",
+			(int)ucode_raw->size);
+		return -EINVAL;
+	}
+
+	pieces->inst = src;
+	src += pieces->inst_size;
+	pieces->data = src;
+	src += pieces->data_size;
+	pieces->init = src;
+	src += pieces->init_size;
+	pieces->init_data = src;
+	src += pieces->init_data_size;
+
+	return 0;
+}
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
+	int wanted_alternative = iwlagn_mod_params.wanted_ucode_alternative;
+	int tmp;
+	u64 alternatives;
+	u32 tlv_len;
+	enum iwl_ucode_tlv_type tlv_type;
+	const u8 *tlv_data;
+
+	if (len < sizeof(*ucode)) {
+		IWL_ERR(priv, "uCode has invalid length: %zd\n", len);
+		return -EINVAL;
+	}
+
+	if (ucode->magic != cpu_to_le32(IWL_TLV_UCODE_MAGIC)) {
+		IWL_ERR(priv, "invalid uCode magic: 0X%x\n",
+			le32_to_cpu(ucode->magic));
+		return -EINVAL;
+	}
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
+		u16 tlv_alt;
+
+		len -= sizeof(*tlv);
+		tlv = (void *)data;
+
+		tlv_len = le32_to_cpu(tlv->length);
+		tlv_type = le16_to_cpu(tlv->type);
+		tlv_alt = le16_to_cpu(tlv->alternative);
+		tlv_data = tlv->data;
+
+		if (len < tlv_len) {
+			IWL_ERR(priv, "invalid TLV len: %zd/%u\n",
+				len, tlv_len);
+			return -EINVAL;
+		}
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
+			IWL_ERR(priv, "Found unexpected BOOT ucode\n");
+			break;
+		case IWL_UCODE_TLV_PROBE_MAX_LEN:
+			if (tlv_len != sizeof(u32))
+				goto invalid_tlv_len;
+			capa->max_probe_length =
+					le32_to_cpup((__le32 *)tlv_data);
+			break;
+		case IWL_UCODE_TLV_PAN:
+			if (tlv_len)
+				goto invalid_tlv_len;
+			capa->flags |= IWL_UCODE_TLV_FLAGS_PAN;
+			break;
+		case IWL_UCODE_TLV_FLAGS:
+			/* must be at least one u32 */
+			if (tlv_len < sizeof(u32))
+				goto invalid_tlv_len;
+			/* and a proper number of u32s */
+			if (tlv_len % sizeof(u32))
+				goto invalid_tlv_len;
+			/*
+			 * This driver only reads the first u32 as
+			 * right now no more features are defined,
+			 * if that changes then either the driver
+			 * will not work with the new firmware, or
+			 * it'll not take advantage of new features.
+			 */
+			capa->flags = le32_to_cpup((__le32 *)tlv_data);
+			break;
+		case IWL_UCODE_TLV_INIT_EVTLOG_PTR:
+			if (tlv_len != sizeof(u32))
+				goto invalid_tlv_len;
+			pieces->init_evtlog_ptr =
+					le32_to_cpup((__le32 *)tlv_data);
+			break;
+		case IWL_UCODE_TLV_INIT_EVTLOG_SIZE:
+			if (tlv_len != sizeof(u32))
+				goto invalid_tlv_len;
+			pieces->init_evtlog_size =
+					le32_to_cpup((__le32 *)tlv_data);
+			break;
+		case IWL_UCODE_TLV_INIT_ERRLOG_PTR:
+			if (tlv_len != sizeof(u32))
+				goto invalid_tlv_len;
+			pieces->init_errlog_ptr =
+					le32_to_cpup((__le32 *)tlv_data);
+			break;
+		case IWL_UCODE_TLV_RUNT_EVTLOG_PTR:
+			if (tlv_len != sizeof(u32))
+				goto invalid_tlv_len;
+			pieces->inst_evtlog_ptr =
+					le32_to_cpup((__le32 *)tlv_data);
+			break;
+		case IWL_UCODE_TLV_RUNT_EVTLOG_SIZE:
+			if (tlv_len != sizeof(u32))
+				goto invalid_tlv_len;
+			pieces->inst_evtlog_size =
+					le32_to_cpup((__le32 *)tlv_data);
+			break;
+		case IWL_UCODE_TLV_RUNT_ERRLOG_PTR:
+			if (tlv_len != sizeof(u32))
+				goto invalid_tlv_len;
+			pieces->inst_errlog_ptr =
+					le32_to_cpup((__le32 *)tlv_data);
+			break;
+		case IWL_UCODE_TLV_ENHANCE_SENS_TBL:
+			if (tlv_len)
+				goto invalid_tlv_len;
+			priv->enhance_sensitivity_table = true;
+			break;
+		case IWL_UCODE_TLV_WOWLAN_INST:
+			pieces->wowlan_inst = tlv_data;
+			pieces->wowlan_inst_size = tlv_len;
+			break;
+		case IWL_UCODE_TLV_WOWLAN_DATA:
+			pieces->wowlan_data = tlv_data;
+			pieces->wowlan_data_size = tlv_len;
+			break;
+		case IWL_UCODE_TLV_PHY_CALIBRATION_SIZE:
+			if (tlv_len != sizeof(u32))
+				goto invalid_tlv_len;
+			capa->standard_phy_calibration_size =
+					le32_to_cpup((__le32 *)tlv_data);
+			break;
+		default:
+			IWL_DEBUG_INFO(priv, "unknown TLV: %d\n", tlv_type);
+			break;
+		}
+	}
+
+	if (len) {
+		IWL_ERR(priv, "invalid TLV after parsing: %zd\n", len);
+		iwl_print_hex_dump(priv, IWL_DL_FW, (u8 *)data, len);
+		return -EINVAL;
+	}
+
+	return 0;
+
+ invalid_tlv_len:
+	IWL_ERR(priv, "TLV %d has invalid size: %u\n", tlv_type, tlv_len);
+	iwl_print_hex_dump(priv, IWL_DL_FW, tlv_data, tlv_len);
+
+	return -EINVAL;
+}
+
+/**
+ * iwl_ucode_callback - callback when firmware was loaded
+ *
+ * If loaded successfully, copies the firmware into buffers
+ * for the card to fetch (via DMA).
+ */
+static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
+{
+	struct iwl_priv *priv = context;
+	struct iwl_ucode_header *ucode;
+	int err;
+	struct iwlagn_firmware_pieces pieces;
+	const unsigned int api_max = cfg(priv)->ucode_api_max;
+	unsigned int api_ok = cfg(priv)->ucode_api_ok;
+	const unsigned int api_min = cfg(priv)->ucode_api_min;
+	u32 api_ver;
+	char buildstr[25];
+	u32 build;
+	struct iwlagn_ucode_capabilities ucode_capa = {
+		.max_probe_length = 200,
+		.standard_phy_calibration_size =
+			IWL_DEFAULT_STANDARD_PHY_CALIBRATE_TBL_SIZE,
+	};
+
+	if (!api_ok)
+		api_ok = api_max;
+
+	memset(&pieces, 0, sizeof(pieces));
+
+	if (!ucode_raw) {
+		if (priv->fw_index <= api_ok)
+			IWL_ERR(priv,
+				"request for firmware file '%s' failed.\n",
+				priv->firmware_name);
+		goto try_again;
+	}
+
+	IWL_DEBUG_INFO(priv, "Loaded firmware file '%s' (%zd bytes).\n",
+		       priv->firmware_name, ucode_raw->size);
+
+	/* Make sure that we got at least the API version number */
+	if (ucode_raw->size < 4) {
+		IWL_ERR(priv, "File size way too small!\n");
+		goto try_again;
+	}
+
+	/* Data from ucode file:  header followed by uCode images */
+	ucode = (struct iwl_ucode_header *)ucode_raw->data;
+
+	if (ucode->ver)
+		err = iwlagn_load_legacy_firmware(priv, ucode_raw, &pieces);
+	else
+		err = iwlagn_load_firmware(priv, ucode_raw, &pieces,
+					   &ucode_capa);
+
+	if (err)
+		goto try_again;
+
+	api_ver = IWL_UCODE_API(priv->ucode_ver);
+	build = pieces.build;
+
+	/*
+	 * api_ver should match the api version forming part of the
+	 * firmware filename ... but we don't check for that and only rely
+	 * on the API version read from firmware header from here on forward
+	 */
+	/* no api version check required for experimental uCode */
+	if (priv->fw_index != UCODE_EXPERIMENTAL_INDEX) {
+		if (api_ver < api_min || api_ver > api_max) {
+			IWL_ERR(priv,
+				"Driver unable to support your firmware API. "
+				"Driver supports v%u, firmware is v%u.\n",
+				api_max, api_ver);
+			goto try_again;
+		}
+
+		if (api_ver < api_ok) {
+			if (api_ok != api_max)
+				IWL_ERR(priv, "Firmware has old API version, "
+					"expected v%u through v%u, got v%u.\n",
+					api_ok, api_max, api_ver);
+			else
+				IWL_ERR(priv, "Firmware has old API version, "
+					"expected v%u, got v%u.\n",
+					api_max, api_ver);
+			IWL_ERR(priv, "New firmware can be obtained from "
+				      "http://www.intellinuxwireless.org/.\n");
+		}
+	}
+
+	if (build)
+		sprintf(buildstr, " build %u%s", build,
+		       (priv->fw_index == UCODE_EXPERIMENTAL_INDEX)
+				? " (EXP)" : "");
+	else
+		buildstr[0] = '\0';
+
+	IWL_INFO(priv, "loaded firmware version %u.%u.%u.%u%s\n",
+		 IWL_UCODE_MAJOR(priv->ucode_ver),
+		 IWL_UCODE_MINOR(priv->ucode_ver),
+		 IWL_UCODE_API(priv->ucode_ver),
+		 IWL_UCODE_SERIAL(priv->ucode_ver),
+		 buildstr);
+
+	snprintf(priv->hw->wiphy->fw_version,
+		 sizeof(priv->hw->wiphy->fw_version),
+		 "%u.%u.%u.%u%s",
+		 IWL_UCODE_MAJOR(priv->ucode_ver),
+		 IWL_UCODE_MINOR(priv->ucode_ver),
+		 IWL_UCODE_API(priv->ucode_ver),
+		 IWL_UCODE_SERIAL(priv->ucode_ver),
+		 buildstr);
+
+	/*
+	 * For any of the failures below (before allocating pci memory)
+	 * we will try to load a version with a smaller API -- maybe the
+	 * user just got a corrupted version of the latest API.
+	 */
+
+	IWL_DEBUG_INFO(priv, "f/w package hdr ucode version raw = 0x%x\n",
+		       priv->ucode_ver);
+	IWL_DEBUG_INFO(priv, "f/w package hdr runtime inst size = %Zd\n",
+		       pieces.inst_size);
+	IWL_DEBUG_INFO(priv, "f/w package hdr runtime data size = %Zd\n",
+		       pieces.data_size);
+	IWL_DEBUG_INFO(priv, "f/w package hdr init inst size = %Zd\n",
+		       pieces.init_size);
+	IWL_DEBUG_INFO(priv, "f/w package hdr init data size = %Zd\n",
+		       pieces.init_data_size);
+
+	/* Verify that uCode images will fit in card's SRAM */
+	if (pieces.inst_size > hw_params(priv).max_inst_size) {
+		IWL_ERR(priv, "uCode instr len %Zd too large to fit in\n",
+			pieces.inst_size);
+		goto try_again;
+	}
+
+	if (pieces.data_size > hw_params(priv).max_data_size) {
+		IWL_ERR(priv, "uCode data len %Zd too large to fit in\n",
+			pieces.data_size);
+		goto try_again;
+	}
+
+	if (pieces.init_size > hw_params(priv).max_inst_size) {
+		IWL_ERR(priv, "uCode init instr len %Zd too large to fit in\n",
+			pieces.init_size);
+		goto try_again;
+	}
+
+	if (pieces.init_data_size > hw_params(priv).max_data_size) {
+		IWL_ERR(priv, "uCode init data len %Zd too large to fit in\n",
+			pieces.init_data_size);
+		goto try_again;
+	}
+
+	/* Allocate ucode buffers for card's bus-master loading ... */
+
+	/* Runtime instructions and 2 copies of data:
+	 * 1) unmodified from disk
+	 * 2) backup cache for save/restore during power-downs */
+	if (iwl_alloc_fw_desc(trans(priv), &trans(priv)->ucode_rt.code,
+			      pieces.inst, pieces.inst_size))
+		goto err_pci_alloc;
+	if (iwl_alloc_fw_desc(trans(priv), &trans(priv)->ucode_rt.data,
+			      pieces.data, pieces.data_size))
+		goto err_pci_alloc;
+
+	/* Initialization instructions and data */
+	if (pieces.init_size && pieces.init_data_size) {
+		if (iwl_alloc_fw_desc(trans(priv),
+				      &trans(priv)->ucode_init.code,
+				      pieces.init, pieces.init_size))
+			goto err_pci_alloc;
+		if (iwl_alloc_fw_desc(trans(priv),
+				      &trans(priv)->ucode_init.data,
+				      pieces.init_data, pieces.init_data_size))
+			goto err_pci_alloc;
+	}
+
+	/* WoWLAN instructions and data */
+	if (pieces.wowlan_inst_size && pieces.wowlan_data_size) {
+		if (iwl_alloc_fw_desc(trans(priv),
+				      &trans(priv)->ucode_wowlan.code,
+				      pieces.wowlan_inst,
+				      pieces.wowlan_inst_size))
+			goto err_pci_alloc;
+		if (iwl_alloc_fw_desc(trans(priv),
+				      &trans(priv)->ucode_wowlan.data,
+				      pieces.wowlan_data,
+				      pieces.wowlan_data_size))
+			goto err_pci_alloc;
+	}
+
+	/* Now that we can no longer fail, copy information */
+
+	/*
+	 * The (size - 16) / 12 formula is based on the information recorded
+	 * for each event, which is of mode 1 (including timestamp) for all
+	 * new microcodes that include this information.
+	 */
+	priv->init_evtlog_ptr = pieces.init_evtlog_ptr;
+	if (pieces.init_evtlog_size)
+		priv->init_evtlog_size = (pieces.init_evtlog_size - 16)/12;
+	else
+		priv->init_evtlog_size =
+			cfg(priv)->base_params->max_event_log_size;
+	priv->init_errlog_ptr = pieces.init_errlog_ptr;
+	priv->inst_evtlog_ptr = pieces.inst_evtlog_ptr;
+	if (pieces.inst_evtlog_size)
+		priv->inst_evtlog_size = (pieces.inst_evtlog_size - 16)/12;
+	else
+		priv->inst_evtlog_size =
+			cfg(priv)->base_params->max_event_log_size;
+	priv->inst_errlog_ptr = pieces.inst_errlog_ptr;
+#ifndef CONFIG_IWLWIFI_P2P
+	ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
+#endif
+
+	priv->new_scan_threshold_behaviour =
+		!!(ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWSCAN);
+
+	if (!(cfg(priv)->sku & EEPROM_SKU_CAP_IPAN_ENABLE))
+		ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
+
+	/*
+	 * if not PAN, then don't support P2P -- might be a uCode
+	 * packaging bug or due to the eeprom check above
+	 */
+	if (!(ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN))
+		ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_P2P;
+
+	if (ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN) {
+		priv->sta_key_max_num = STA_KEY_MAX_NUM_PAN;
+		priv->shrd->cmd_queue = IWL_IPAN_CMD_QUEUE_NUM;
+	} else {
+		priv->sta_key_max_num = STA_KEY_MAX_NUM;
+		priv->shrd->cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
+	}
+	/*
+	 * figure out the offset of chain noise reset and gain commands
+	 * base on the size of standard phy calibration commands table size
+	 */
+	if (ucode_capa.standard_phy_calibration_size >
+	    IWL_MAX_PHY_CALIBRATE_TBL_SIZE)
+		ucode_capa.standard_phy_calibration_size =
+			IWL_MAX_STANDARD_PHY_CALIBRATE_TBL_SIZE;
+
+	priv->phy_calib_chain_noise_reset_cmd =
+		ucode_capa.standard_phy_calibration_size;
+	priv->phy_calib_chain_noise_gain_cmd =
+		ucode_capa.standard_phy_calibration_size + 1;
+
+	/* initialize all valid contexts */
+	iwl_init_context(priv, ucode_capa.flags);
+
+	/**************************************************
+	 * This is still part of probe() in a sense...
+	 *
+	 * 9. Setup and register with mac80211 and debugfs
+	 **************************************************/
+	err = iwlagn_mac_setup_register(priv, &ucode_capa);
+	if (err)
+		goto out_unbind;
+
+	err = iwl_dbgfs_register(priv, DRV_NAME);
+	if (err)
+		IWL_ERR(priv, "failed to create debugfs files. Ignoring error: %d\n", err);
+
+	/* We have our copies now, allow OS release its copies */
+	release_firmware(ucode_raw);
+	complete(&priv->firmware_loading_complete);
+	return;
+
+ try_again:
+	/* try next, if any */
+	if (iwl_request_firmware(priv, false))
+		goto out_unbind;
+	release_firmware(ucode_raw);
+	return;
+
+ err_pci_alloc:
+	IWL_ERR(priv, "failed to allocate pci memory\n");
+	iwl_dealloc_ucode(trans(priv));
+ out_unbind:
+	complete(&priv->firmware_loading_complete);
+	device_release_driver(trans(priv)->dev);
+	release_firmware(ucode_raw);
+}
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.h b/drivers/net/wireless/iwlwifi/iwl-ucode.h
new file mode 100644
index 0000000..eccf925
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.h
@@ -0,0 +1,178 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *****************************************************************************/
+
+#ifndef __iwl_ucode_h__
+#define __iwl_ucode_h__
+
+/* v1/v2 uCode file layout */
+struct iwl_ucode_header {
+	__le32 ver;	/* major/minor/API/serial */
+	union {
+		struct {
+			__le32 inst_size;	/* bytes of runtime code */
+			__le32 data_size;	/* bytes of runtime data */
+			__le32 init_size;	/* bytes of init code */
+			__le32 init_data_size;	/* bytes of init data */
+			__le32 boot_size;	/* bytes of bootstrap code */
+			u8 data[0];		/* in same order as sizes */
+		} v1;
+		struct {
+			__le32 build;		/* build number */
+			__le32 inst_size;	/* bytes of runtime code */
+			__le32 data_size;	/* bytes of runtime data */
+			__le32 init_size;	/* bytes of init code */
+			__le32 init_data_size;	/* bytes of init data */
+			__le32 boot_size;	/* bytes of bootstrap code */
+			u8 data[0];		/* in same order as sizes */
+		} v2;
+	} u;
+};
+
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
+	IWL_UCODE_TLV_PAN		= 7,
+	IWL_UCODE_TLV_RUNT_EVTLOG_PTR	= 8,
+	IWL_UCODE_TLV_RUNT_EVTLOG_SIZE	= 9,
+	IWL_UCODE_TLV_RUNT_ERRLOG_PTR	= 10,
+	IWL_UCODE_TLV_INIT_EVTLOG_PTR	= 11,
+	IWL_UCODE_TLV_INIT_EVTLOG_SIZE	= 12,
+	IWL_UCODE_TLV_INIT_ERRLOG_PTR	= 13,
+	IWL_UCODE_TLV_ENHANCE_SENS_TBL	= 14,
+	IWL_UCODE_TLV_PHY_CALIBRATION_SIZE = 15,
+	IWL_UCODE_TLV_WOWLAN_INST	= 16,
+	IWL_UCODE_TLV_WOWLAN_DATA	= 17,
+	IWL_UCODE_TLV_FLAGS		= 18,
+};
+
+/**
+ * enum iwl_ucode_tlv_flag - ucode API flags
+ * @IWL_UCODE_TLV_FLAGS_PAN: This is PAN capable microcode; this previously
+ *	was a separate TLV but moved here to save space.
+ * @IWL_UCODE_TLV_FLAGS_NEWSCAN: new uCode scan behaviour on hidden SSID,
+ *	treats good CRC threshold as a boolean
+ * @IWL_UCODE_TLV_FLAGS_MFP: This uCode image supports MFP (802.11w).
+ * @IWL_UCODE_TLV_FLAGS_P2P: This uCode image supports P2P.
+ */
+enum iwl_ucode_tlv_flag {
+	IWL_UCODE_TLV_FLAGS_PAN		= BIT(0),
+	IWL_UCODE_TLV_FLAGS_NEWSCAN	= BIT(1),
+	IWL_UCODE_TLV_FLAGS_MFP		= BIT(2),
+	IWL_UCODE_TLV_FLAGS_P2P		= BIT(3),
+};
+
+struct iwl_ucode_tlv {
+	__le16 type;		/* see above */
+	__le16 alternative;	/* see comment */
+	__le32 length;		/* not including type/length fields */
+	u8 data[0];
+};
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
+struct iwl_priv;
+
+int __must_check iwl_request_firmware(struct iwl_priv *priv, bool first);
+
+#endif  /* __iwl_ucode_h__ */
-- 
1.7.0.4

