Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46093 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab2BQUXx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:53 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/26] iwlwifi: Move ucode pointers to iwl_fw
Date: Fri, 17 Feb 2012 11:13:40 -0800
Message-Id: <1329506034-1394-13-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212434_611695_7BD0ED50)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

The ucode image is a ucode related thing not a transport one.  Move them.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |   11 +++++----
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    8 +++---
 drivers/net/wireless/iwlwifi/iwl-testmode.c |   12 +++++-----
 drivers/net/wireless/iwlwifi/iwl-trans.h    |   16 +------------
 drivers/net/wireless/iwlwifi/iwl-ucode.c    |   33 ++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-ucode.h    |   14 +++++++++-
 6 files changed, 46 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 136de6f..ad74138 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -40,6 +40,7 @@
 #include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-agn.h"
+#include "iwl-wifi.h"
 
 /* create and remove of files */
 #define DEBUGFS_ADD_FILE(name, parent, mode) do {			\
@@ -234,12 +235,12 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 
 	/* default is to dump the entire data segment */
 	if (!priv->dbgfs_sram_offset && !priv->dbgfs_sram_len) {
-		struct iwl_trans *trans = trans(priv);
+		struct iwl_nic *nic = nic(priv);
 		priv->dbgfs_sram_offset = 0x800000;
-		if (trans->shrd->ucode_type == IWL_UCODE_INIT)
-			priv->dbgfs_sram_len = trans->ucode_init.data.len;
+		if (nic->shrd->ucode_type == IWL_UCODE_INIT)
+			priv->dbgfs_sram_len = nic->fw.ucode_init.data.len;
 		else
-			priv->dbgfs_sram_len = trans->ucode_rt.data.len;
+			priv->dbgfs_sram_len = nic->fw.ucode_rt.data.len;
 	}
 	len = priv->dbgfs_sram_len;
 
@@ -342,7 +343,7 @@ static ssize_t iwl_dbgfs_wowlan_sram_read(struct file *file,
 
 	return simple_read_from_buffer(user_buf, count, ppos,
 				       priv->wowlan_sram,
-				       trans(priv)->ucode_wowlan.data.len);
+				       nic(priv)->fw.ucode_wowlan.data.len);
 }
 static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 					size_t count, loff_t *ppos)
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 17358cf..ca0c465 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -195,7 +195,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS |
 			    WIPHY_FLAG_IBSS_RSN;
 
-	if (trans(priv)->ucode_wowlan.code.len &&
+	if (nic(priv)->fw.ucode_wowlan.code.len &&
 	    device_can_wakeup(trans(priv)->dev)) {
 		hw->wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
 					  WIPHY_WOWLAN_DISCONNECT |
@@ -453,17 +453,17 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 		if (ret == 0) {
-			struct iwl_trans *trans = trans(priv);
+			struct iwl_nic *nic = nic(priv);
 			if (!priv->wowlan_sram)
 				priv->wowlan_sram =
-					kzalloc(trans->ucode_wowlan.data.len,
+					kzalloc(nic->fw.ucode_wowlan.data.len,
 						GFP_KERNEL);
 
 			if (priv->wowlan_sram)
 				_iwl_read_targ_mem_words(
 					trans(priv), 0x800000,
 					priv->wowlan_sram,
-					trans->ucode_wowlan.data.len / 4);
+					nic->fw.ucode_wowlan.data.len / 4);
 		}
 #endif
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index 963cc6c..5f00a37 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -591,16 +591,16 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 		}
 		switch (priv->shrd->ucode_type) {
 		case IWL_UCODE_REGULAR:
-			inst_size = trans(priv)->ucode_rt.code.len;
-			data_size = trans(priv)->ucode_rt.data.len;
+			inst_size = nic(priv)->fw.ucode_rt.code.len;
+			data_size = nic(priv)->fw.ucode_rt.data.len;
 			break;
 		case IWL_UCODE_INIT:
-			inst_size = trans(priv)->ucode_init.code.len;
-			data_size = trans(priv)->ucode_init.data.len;
+			inst_size = nic(priv)->fw.ucode_init.code.len;
+			data_size = nic(priv)->fw.ucode_init.data.len;
 			break;
 		case IWL_UCODE_WOWLAN:
-			inst_size = trans(priv)->ucode_wowlan.code.len;
-			data_size = trans(priv)->ucode_wowlan.data.len;
+			inst_size = nic(priv)->fw.ucode_wowlan.code.len;
+			data_size = nic(priv)->fw.ucode_wowlan.data.len;
 			break;
 		case IWL_UCODE_NONE:
 			IWL_ERR(priv, "No uCode has not been loaded\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index ae68c51..913df93 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -68,6 +68,7 @@
 
 #include "iwl-shared.h"
 #include "iwl-commands.h"
+#include "iwl-ucode.h"
 
  /*This file includes the declaration that are exported from the transport
  * layer */
@@ -131,18 +132,6 @@ struct iwl_host_cmd {
 	u8 id;
 };
 
-/* one for each uCode image (inst/data, boot/init/runtime) */
-struct fw_desc {
-	dma_addr_t p_addr;	/* hardware address */
-	void *v_addr;		/* software address */
-	u32 len;		/* size in bytes */
-};
-
-struct fw_img {
-	struct fw_desc code;	/* firmware code image */
-	struct fw_desc data;	/* firmware data image */
-};
-
 /**
  * struct iwl_trans_ops - transport specific operations
  * @start_hw: starts the HW- from that point on, the HW can send interrupts
@@ -258,9 +247,6 @@ struct iwl_trans {
 	char hw_id_str[52];
 
 	u8 ucode_write_complete;	/* the image write is complete */
-	struct fw_img ucode_rt;
-	struct fw_img ucode_init;
-	struct fw_img ucode_wowlan;
 
 	/* eeprom related variables */
 	int    nvm_device_type;
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 51a8fb3..36039eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -99,9 +99,10 @@ static void iwl_free_fw_img(struct iwl_trans *trans, struct fw_img *img)
 
 void iwl_dealloc_ucode(struct iwl_trans *trans)
 {
-	iwl_free_fw_img(trans, &trans->ucode_rt);
-	iwl_free_fw_img(trans, &trans->ucode_init);
-	iwl_free_fw_img(trans, &trans->ucode_wowlan);
+	struct iwl_nic *nic = nic(trans);
+	iwl_free_fw_img(trans, &nic->fw.ucode_rt);
+	iwl_free_fw_img(trans, &nic->fw.ucode_init);
+	iwl_free_fw_img(trans, &nic->fw.ucode_wowlan);
 }
 
 static int iwl_alloc_fw_desc(struct iwl_trans *trans, struct fw_desc *desc,
@@ -122,16 +123,16 @@ static int iwl_alloc_fw_desc(struct iwl_trans *trans, struct fw_desc *desc,
 	return 0;
 }
 
-static inline struct fw_img *iwl_get_ucode_image(struct iwl_trans *trans,
+static inline struct fw_img *iwl_get_ucode_image(struct iwl_nic *nic,
 					enum iwl_ucode_type ucode_type)
 {
 	switch (ucode_type) {
 	case IWL_UCODE_INIT:
-		return &trans->ucode_init;
+		return &nic->fw.ucode_init;
 	case IWL_UCODE_WOWLAN:
-		return &trans->ucode_wowlan;
+		return &nic->fw.ucode_wowlan;
 	case IWL_UCODE_REGULAR:
-		return &trans->ucode_rt;
+		return &nic->fw.ucode_rt;
 	case IWL_UCODE_NONE:
 		break;
 	}
@@ -456,7 +457,7 @@ static void iwl_print_mismatch_inst(struct iwl_trans *trans,
 static int iwl_verify_ucode(struct iwl_trans *trans,
 			    enum iwl_ucode_type ucode_type)
 {
-	struct fw_img *img = iwl_get_ucode_image(trans, ucode_type);
+	struct fw_img *img = iwl_get_ucode_image(nic(trans), ucode_type);
 
 	if (!img) {
 		IWL_ERR(trans, "Invalid ucode requested (%d)\n", ucode_type);
@@ -583,7 +584,7 @@ int iwl_load_ucode_wait_alive(struct iwl_trans *trans,
 
 	old_type = trans->shrd->ucode_type;
 	trans->shrd->ucode_type = ucode_type;
-	fw = iwl_get_ucode_image(trans, ucode_type);
+	fw = iwl_get_ucode_image(nic(trans), ucode_type);
 
 	if (!fw)
 		return -EINVAL;
@@ -647,7 +648,7 @@ int iwl_run_init_ucode(struct iwl_trans *trans)
 	lockdep_assert_held(&trans->shrd->mutex);
 
 	/* No init ucode required? Curious, but maybe ok */
-	if (!trans->ucode_init.code.len)
+	if (!nic(trans)->fw.ucode_init.code.len)
 		return 0;
 
 	if (trans->shrd->ucode_type != IWL_UCODE_NONE)
@@ -1163,21 +1164,21 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	/* Runtime instructions and 2 copies of data:
 	 * 1) unmodified from disk
 	 * 2) backup cache for save/restore during power-downs */
-	if (iwl_alloc_fw_desc(trans(priv), &trans(priv)->ucode_rt.code,
+	if (iwl_alloc_fw_desc(trans(priv), &nic(priv)->fw.ucode_rt.code,
 			      pieces.inst, pieces.inst_size))
 		goto err_pci_alloc;
-	if (iwl_alloc_fw_desc(trans(priv), &trans(priv)->ucode_rt.data,
+	if (iwl_alloc_fw_desc(trans(priv), &nic(priv)->fw.ucode_rt.data,
 			      pieces.data, pieces.data_size))
 		goto err_pci_alloc;
 
 	/* Initialization instructions and data */
 	if (pieces.init_size && pieces.init_data_size) {
 		if (iwl_alloc_fw_desc(trans(priv),
-				      &trans(priv)->ucode_init.code,
+				      &nic(priv)->fw.ucode_init.code,
 				      pieces.init, pieces.init_size))
 			goto err_pci_alloc;
 		if (iwl_alloc_fw_desc(trans(priv),
-				      &trans(priv)->ucode_init.data,
+				      &nic(priv)->fw.ucode_init.data,
 				      pieces.init_data, pieces.init_data_size))
 			goto err_pci_alloc;
 	}
@@ -1185,12 +1186,12 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	/* WoWLAN instructions and data */
 	if (pieces.wowlan_inst_size && pieces.wowlan_data_size) {
 		if (iwl_alloc_fw_desc(trans(priv),
-				      &trans(priv)->ucode_wowlan.code,
+				      &nic(priv)->fw.ucode_wowlan.code,
 				      pieces.wowlan_inst,
 				      pieces.wowlan_inst_size))
 			goto err_pci_alloc;
 		if (iwl_alloc_fw_desc(trans(priv),
-				      &trans(priv)->ucode_wowlan.data,
+				      &nic(priv)->fw.ucode_wowlan.data,
 				      pieces.wowlan_data,
 				      pieces.wowlan_data_size))
 			goto err_pci_alloc;
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.h b/drivers/net/wireless/iwlwifi/iwl-ucode.h
index 18c77e9..5e4b88e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.h
@@ -63,8 +63,6 @@
 #ifndef __iwl_ucode_h__
 #define __iwl_ucode_h__
 
-#include "iwl-trans.h"
-
 #include <linux/netdevice.h>
 
 /* v1/v2 uCode file layout */
@@ -181,6 +179,18 @@ struct iwl_ucode_capabilities {
 	u32 flags;
 };
 
+/* one for each uCode image (inst/data, boot/init/runtime) */
+struct fw_desc {
+	dma_addr_t p_addr;	/* hardware address */
+	void *v_addr;		/* software address */
+	u32 len;		/* size in bytes */
+};
+
+struct fw_img {
+	struct fw_desc code;	/* firmware code image */
+	struct fw_desc data;	/* firmware data image */
+};
+
 /**
  * struct iwl_fw - variables associated with the firmware
  *
-- 
1.7.0.4

