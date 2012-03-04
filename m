Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51544 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036Ab2CDUnD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:03 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 035/101] iwlwifi: split out firmware store
Date: Sun,  4 Mar 2012 11:28:49 -0800
Message-Id: <1330889395-533-36-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214615_288663_0CC3ADB5)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Through the driver, struct iwl_fw will
store the firmware. Split this out into
a separate file, iwl-fw.h, and make all
other code use it. To do this, also move
the log pointers into it, and remove the
knowledge of "nic" from everything.

Now the op_mode has a fw pointer, and
(unfortunately) for now the shared data
also needs to keep one for the transport
to access dump the error log -- I think
that will move later.

Since I wanted to constify the firmware
pointers, some more changes were needed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c     |    5 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c           |   10 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h      |   12 --
 drivers/net/wireless/iwlwifi/iwl-debugfs.c       |    9 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h           |    1 +
 drivers/net/wireless/iwlwifi/iwl-drv.c           |   49 +++++---
 drivers/net/wireless/iwlwifi/iwl-fw.h            |  146 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-mac80211.c      |   10 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    5 +-
 drivers/net/wireless/iwlwifi/iwl-testmode.c      |   16 ++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |   23 ++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |    9 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h         |    5 +-
 drivers/net/wireless/iwlwifi/iwl-ucode.c         |   21 ++--
 drivers/net/wireless/iwlwifi/iwl-ucode.h         |   60 ---------
 drivers/net/wireless/iwlwifi/iwl-wifi.h          |   10 --
 19 files changed, 236 insertions(+), 163 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-fw.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 29f9459..4928f6f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -69,7 +69,6 @@
 #include "iwl-trans.h"
 #include "iwl-agn.h"
 #include "iwl-wifi.h"
-#include "iwl-ucode.h"
 
 /*****************************************************************************
  * INIT calibrations framework
@@ -644,7 +643,7 @@ void iwl_init_sensitivity(struct iwl_priv *priv)
 	data->last_bad_plcp_cnt_cck = 0;
 	data->last_fa_cnt_cck = 0;
 
-	if (nic(priv)->fw.enhance_sensitivity_table)
+	if (priv->fw->enhance_sensitivity_table)
 		ret |= iwl_enhance_sensitivity_write(priv);
 	else
 		ret |= iwl_sensitivity_write(priv);
@@ -754,7 +753,7 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv)
 
 	iwl_sens_auto_corr_ofdm(priv, norm_fa_ofdm, rx_enable_time);
 	iwl_sens_energy_cck(priv, norm_fa_cck, rx_enable_time, &statis);
-	if (nic(priv)->fw.enhance_sensitivity_table)
+	if (priv->fw->enhance_sensitivity_table)
 		iwl_enhance_sensitivity_write(priv);
 	else
 		iwl_sensitivity_write(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 45b060a..89be056 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -77,7 +77,7 @@ int iwlagn_send_tx_power(struct iwl_priv *priv)
 	tx_power_cmd.flags = IWLAGN_TX_POWER_NO_CLOSED;
 	tx_power_cmd.srv_chan_lmt = IWLAGN_TX_POWER_AUTO;
 
-	if (IWL_UCODE_API(nic(priv)->fw.ucode_ver) == 1)
+	if (IWL_UCODE_API(priv->fw->ucode_ver) == 1)
 		tx_ant_cfg_cmd = REPLY_TX_POWER_DBM_CMD_V1;
 	else
 		tx_ant_cfg_cmd = REPLY_TX_POWER_DBM_CMD;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f53308f..c3040ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -41,7 +41,6 @@
 
 #include <asm/div64.h>
 
-#include "iwl-ucode.h"
 #include "iwl-eeprom.h"
 #include "iwl-wifi.h"
 #include "iwl-dev.h"
@@ -616,7 +615,7 @@ static int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant)
 	  .valid = cpu_to_le32(valid_tx_ant),
 	};
 
-	if (IWL_UCODE_API(nic(priv)->fw.ucode_ver) > 1) {
+	if (IWL_UCODE_API(priv->fw->ucode_ver) > 1) {
 		IWL_DEBUG_HC(priv, "select valid tx ant: %u\n", valid_tx_ant);
 		return iwl_trans_send_cmd_pdu(trans(priv),
 					TX_ANT_CONFIGURATION_CMD,
@@ -1174,9 +1173,9 @@ static void iwl_debug_config(struct iwl_priv *priv)
 #endif
 }
 
-static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans)
+static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
+						 const struct iwl_fw *fw)
 {
-	struct iwl_fw *fw = &nic(trans)->fw;
 	int err = 0;
 	struct iwl_priv *priv;
 	struct ieee80211_hw *hw;
@@ -1200,6 +1199,9 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans)
 	priv = IWL_OP_MODE_GET_DVM(op_mode);
 	priv->shrd = trans->shrd;
 	priv->shrd->priv = priv;
+	priv->fw = fw;
+	/* TODO: remove fw from shared data later */
+	priv->shrd->fw = fw;
 
 	iwl_trans_configure(trans(priv), op_mode);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 2a90d77..f552438 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -93,7 +93,7 @@ void iwl_nic_error(struct iwl_op_mode *op_mode);
 /* MAC80211 */
 struct ieee80211_hw *iwl_alloc_all(void);
 int iwlagn_mac_setup_register(struct iwl_priv *priv,
-			      struct iwl_ucode_capabilities *capa);
+			      const struct iwl_ucode_capabilities *capa);
 void iwlagn_mac_unregister(struct iwl_priv *priv);
 
 /* RXON */
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index c20618d..aa89930 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -74,13 +74,6 @@
 
 struct iwl_priv;
 
-/* uCode version contains 4 values: Major/Minor/API/Serial */
-#define IWL_UCODE_MAJOR(ver)	(((ver) & 0xFF000000) >> 24)
-#define IWL_UCODE_MINOR(ver)	(((ver) & 0x00FF0000) >> 16)
-#define IWL_UCODE_API(ver)	(((ver) & 0x0000FF00) >> 8)
-#define IWL_UCODE_SERIAL(ver)	((ver) & 0x000000FF)
-
-
 /* Tx rates */
 #define IWL_CCK_RATES	4
 #define IWL_OFDM_RATES	8
@@ -3151,8 +3144,6 @@ struct iwl_enhance_sensitivity_cmd {
  */
 
 /* Phy calibration command for series */
-/* The default calibrate table size if not specified by firmware */
-#define IWL_DEFAULT_STANDARD_PHY_CALIBRATE_TBL_SIZE	18
 enum {
 	IWL_PHY_CALIBRATE_DC_CMD		= 8,
 	IWL_PHY_CALIBRATE_LO_CMD		= 9,
@@ -3161,11 +3152,8 @@ enum {
 	IWL_PHY_CALIBRATE_BASE_BAND_CMD		= 16,
 	IWL_PHY_CALIBRATE_TX_IQ_PERD_CMD	= 17,
 	IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD	= 18,
-	IWL_MAX_STANDARD_PHY_CALIBRATE_TBL_SIZE	= 19,
 };
 
-#define IWL_MAX_PHY_CALIBRATE_TBL_SIZE		(253)
-
 /* This enum defines the bitmap of various calibrations to enable in both
  * init ucode and runtime ucode through CALIBRATION_CFG_CMD.
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index b6740c3..0e63cb7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -235,12 +235,11 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 
 	/* default is to dump the entire data segment */
 	if (!priv->dbgfs_sram_offset && !priv->dbgfs_sram_len) {
-		struct iwl_nic *nic = nic(priv);
 		priv->dbgfs_sram_offset = 0x800000;
-		if (nic->shrd->ucode_type == IWL_UCODE_INIT)
-			priv->dbgfs_sram_len = nic->fw.ucode_init.data.len;
+		if (priv->shrd->ucode_type == IWL_UCODE_INIT)
+			priv->dbgfs_sram_len = priv->fw->ucode_init.data.len;
 		else
-			priv->dbgfs_sram_len = nic->fw.ucode_rt.data.len;
+			priv->dbgfs_sram_len = priv->fw->ucode_rt.data.len;
 	}
 	len = priv->dbgfs_sram_len;
 
@@ -343,7 +342,7 @@ static ssize_t iwl_dbgfs_wowlan_sram_read(struct file *file,
 
 	return simple_read_from_buffer(user_buf, count, ppos,
 				       priv->wowlan_sram,
-				       nic(priv)->fw.ucode_wowlan.data.len);
+				       priv->fw->ucode_wowlan.data.len);
 }
 static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 					size_t count, loff_t *ppos)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 7199748..4def9f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -715,6 +715,7 @@ struct iwl_priv {
 
 	/*data shared among all the driver's layers */
 	struct iwl_shared *shrd;
+	const struct iwl_fw *fw;
 
 	spinlock_t sta_lock;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 1a588f3..351b2f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -71,6 +71,9 @@
 #include "iwl-shared.h"
 #include "iwl-op-mode.h"
 
+/* private includes */
+#include "iwl-ucode.h"
+
 static void iwl_free_fw_desc(struct iwl_nic *nic, struct fw_desc *desc)
 {
 	if (desc->v_addr)
@@ -641,20 +644,20 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	 * for each event, which is of mode 1 (including timestamp) for all
 	 * new microcodes that include this information.
 	 */
-	nic->init_evtlog_ptr = pieces.init_evtlog_ptr;
+	fw->init_evtlog_ptr = pieces.init_evtlog_ptr;
 	if (pieces.init_evtlog_size)
-		nic->init_evtlog_size = (pieces.init_evtlog_size - 16)/12;
+		fw->init_evtlog_size = (pieces.init_evtlog_size - 16)/12;
 	else
-		nic->init_evtlog_size =
+		fw->init_evtlog_size =
 			cfg->base_params->max_event_log_size;
-	nic->init_errlog_ptr = pieces.init_errlog_ptr;
-	nic->inst_evtlog_ptr = pieces.inst_evtlog_ptr;
+	fw->init_errlog_ptr = pieces.init_errlog_ptr;
+	fw->inst_evtlog_ptr = pieces.inst_evtlog_ptr;
 	if (pieces.inst_evtlog_size)
-		nic->inst_evtlog_size = (pieces.inst_evtlog_size - 16)/12;
+		fw->inst_evtlog_size = (pieces.inst_evtlog_size - 16)/12;
 	else
-		nic->inst_evtlog_size =
+		fw->inst_evtlog_size =
 			cfg->base_params->max_event_log_size;
-	nic->inst_errlog_ptr = pieces.inst_errlog_ptr;
+	fw->inst_errlog_ptr = pieces.inst_errlog_ptr;
 
 	/*
 	 * figure out the offset of chain noise reset and gain commands
@@ -669,7 +672,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	release_firmware(ucode_raw);
 	complete(&nic->request_firmware_complete);
 
-	nic->op_mode = iwl_dvm_ops.start(nic->shrd->trans);
+	nic->op_mode = iwl_dvm_ops.start(nic->shrd->trans, &nic->fw);
 
 	if (!nic->op_mode)
 		goto out_unbind;
@@ -695,24 +698,27 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 int iwl_drv_start(struct iwl_shared *shrd,
 		  struct iwl_trans *trans, const struct iwl_cfg *cfg)
 {
+	struct iwl_nic *nic;
 	int ret;
 
 	shrd->cfg = cfg;
 
-	shrd->nic = kzalloc(sizeof(*shrd->nic), GFP_KERNEL);
-	if (!shrd->nic) {
+	nic = kzalloc(sizeof(*nic), GFP_KERNEL);
+	if (!nic) {
 		dev_printk(KERN_ERR, trans->dev, "Couldn't allocate iwl_nic");
 		return -ENOMEM;
 	}
-	shrd->nic->shrd = shrd;
+	nic->shrd = shrd;
+	shrd->nic = nic;
 
-	init_completion(&shrd->nic->request_firmware_complete);
+	init_completion(&nic->request_firmware_complete);
 
-	ret = iwl_request_firmware(shrd->nic, true);
+	ret = iwl_request_firmware(nic, true);
 
 	if (ret) {
 		dev_printk(KERN_ERR, trans->dev, "Couldn't request the fw");
-		kfree(shrd->nic);
+		kfree(nic);
+		shrd->nic = NULL;
 	}
 
 	return ret;
@@ -720,13 +726,16 @@ int iwl_drv_start(struct iwl_shared *shrd,
 
 void iwl_drv_stop(struct iwl_shared *shrd)
 {
-	wait_for_completion(&shrd->nic->request_firmware_complete);
+	struct iwl_nic *nic = shrd->nic;
+
+	wait_for_completion(&nic->request_firmware_complete);
 
 	/* op_mode can be NULL if its start failed */
-	if (shrd->nic->op_mode)
-		iwl_op_mode_stop(shrd->nic->op_mode);
+	if (nic->op_mode)
+		iwl_op_mode_stop(nic->op_mode);
 
-	iwl_dealloc_ucode(shrd->nic);
+	iwl_dealloc_ucode(nic);
 
-	kfree(shrd->nic);
+	kfree(nic);
+	shrd->nic = NULL;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
new file mode 100644
index 0000000..453812a
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -0,0 +1,146 @@
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
+#ifndef __iwl_fw_h__
+#define __iwl_fw_h__
+#include <linux/types.h>
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
+/* The default calibrate table size if not specified by firmware file */
+#define IWL_DEFAULT_STANDARD_PHY_CALIBRATE_TBL_SIZE	18
+#define IWL_MAX_STANDARD_PHY_CALIBRATE_TBL_SIZE		19
+#define IWL_MAX_PHY_CALIBRATE_TBL_SIZE			253
+
+struct iwl_ucode_capabilities {
+	u32 max_probe_length;
+	u32 standard_phy_calibration_size;
+	u32 flags;
+};
+
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
+/* uCode version contains 4 values: Major/Minor/API/Serial */
+#define IWL_UCODE_MAJOR(ver)	(((ver) & 0xFF000000) >> 24)
+#define IWL_UCODE_MINOR(ver)	(((ver) & 0x00FF0000) >> 16)
+#define IWL_UCODE_API(ver)	(((ver) & 0x0000FF00) >> 8)
+#define IWL_UCODE_SERIAL(ver)	((ver) & 0x000000FF)
+
+/**
+ * struct iwl_fw - variables associated with the firmware
+ *
+ * @ucode_ver: ucode version from the ucode file
+ * @fw_version: firmware version string
+ * @ucode_rt: run time ucode image
+ * @ucode_init: init ucode image
+ * @ucode_wowlan: wake on wireless ucode image (optional)
+ * @ucode_capa: capabilities parsed from the ucode file.
+ * @enhance_sensitivity_table: device can do enhanced sensitivity.
+ * @init_evtlog_ptr: event log offset for init ucode.
+ * @init_evtlog_size: event log size for init ucode.
+ * @init_errlog_ptr: error log offfset for init ucode.
+ * @inst_evtlog_ptr: event log offset for runtime ucode.
+ * @inst_evtlog_size: event log size for runtime ucode.
+ * @inst_errlog_ptr: error log offfset for runtime ucode.
+ */
+struct iwl_fw {
+	u32 ucode_ver;
+
+	char fw_version[ETHTOOL_BUSINFO_LEN];
+
+	/* ucode images */
+	struct fw_img ucode_rt;
+	struct fw_img ucode_init;
+	struct fw_img ucode_wowlan;
+
+	struct iwl_ucode_capabilities ucode_capa;
+	bool enhance_sensitivity_table;
+
+	u32 init_evtlog_ptr, init_evtlog_size, init_errlog_ptr;
+	u32 inst_evtlog_ptr, inst_evtlog_size, inst_errlog_ptr;
+};
+
+#endif  /* __iwl_fw_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 37330ad..3bcd2a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -42,7 +42,6 @@
 
 #include <asm/div64.h>
 
-#include "iwl-ucode.h"
 #include "iwl-eeprom.h"
 #include "iwl-wifi.h"
 #include "iwl-dev.h"
@@ -136,7 +135,7 @@ iwlagn_iface_combinations_p2p[] = {
  * other mac80211 functions grouped here.
  */
 int iwlagn_mac_setup_register(struct iwl_priv *priv,
-				  struct iwl_ucode_capabilities *capa)
+			      const struct iwl_ucode_capabilities *capa)
 {
 	int ret;
 	struct ieee80211_hw *hw = priv->hw;
@@ -195,7 +194,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS |
 			    WIPHY_FLAG_IBSS_RSN;
 
-	if (nic(priv)->fw.ucode_wowlan.code.len &&
+	if (priv->fw->ucode_wowlan.code.len &&
 	    trans(priv)->ops->wowlan_suspend &&
 	    device_can_wakeup(trans(priv)->dev)) {
 		hw->wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
@@ -456,17 +455,16 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 		if (ret == 0) {
-			struct iwl_nic *nic = nic(priv);
 			if (!priv->wowlan_sram)
 				priv->wowlan_sram =
-					kzalloc(nic->fw.ucode_wowlan.data.len,
+					kzalloc(priv->fw->ucode_wowlan.data.len,
 						GFP_KERNEL);
 
 			if (priv->wowlan_sram)
 				_iwl_read_targ_mem_words(
 					trans(priv), 0x800000,
 					priv->wowlan_sram,
-					nic->fw.ucode_wowlan.data.len / 4);
+					priv->fw->ucode_wowlan.data.len / 4);
 		}
 #endif
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index 41e58a1..55b8b27 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -68,6 +68,7 @@ struct iwl_trans;
 struct sk_buff;
 struct iwl_device_cmd;
 struct iwl_rx_cmd_buffer;
+struct iwl_fw;
 
 /**
  * DOC: Operational mode - what is it ?
@@ -123,7 +124,8 @@ struct iwl_rx_cmd_buffer;
  * @nic_error: error notification. Must be atomic
  */
 struct iwl_op_mode_ops {
-	struct iwl_op_mode *(*start)(struct iwl_trans *trans);
+	struct iwl_op_mode *(*start)(struct iwl_trans *trans,
+				     const struct iwl_fw *fw);
 	void (*stop)(struct iwl_op_mode *op_mode);
 	int (*rx)(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb,
 		  struct iwl_device_cmd *cmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index dc55446..3754c35 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -70,6 +70,7 @@
 #include <net/mac80211.h>
 
 #include "iwl-commands.h"
+#include "iwl-fw.h"
 
 /**
  * DOC: shared area - role and goal
@@ -418,8 +419,9 @@ struct iwl_shared {
 	const struct iwl_cfg *cfg;
 	struct iwl_priv *priv;
 	struct iwl_trans *trans;
-	struct iwl_nic *nic;
+	void *nic;
 	struct iwl_hw_params hw_params;
+	const struct iwl_fw *fw;
 
 	struct mutex mutex;
 
@@ -446,7 +448,6 @@ struct iwl_shared {
 /*Whatever _m is (iwl_trans, iwl_priv, these macros will work */
 #define priv(_m)	((_m)->shrd->priv)
 #define cfg(_m)		((_m)->shrd->cfg)
-#define nic(_m)		((_m)->shrd->nic)
 #define trans(_m)	((_m)->shrd->trans)
 #define hw_params(_m)	((_m)->shrd->hw_params)
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index ec803ea..fd25dd1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -553,7 +553,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 
 	case IWL_TM_CMD_APP2DEV_GET_FW_VERSION:
 		IWL_INFO(priv, "uCode version raw: 0x%x\n",
-			 nic(priv)->fw.ucode_ver);
+			 priv->fw->ucode_ver);
 
 		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
 		if (!skb) {
@@ -561,7 +561,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 			return -ENOMEM;
 		}
 		NLA_PUT_U32(skb, IWL_TM_ATTR_FW_VERSION,
-			    nic(priv)->fw.ucode_ver);
+			    priv->fw->ucode_ver);
 		status = cfg80211_testmode_reply(skb);
 		if (status < 0)
 			IWL_ERR(priv, "Error sending msg : %d\n", status);
@@ -590,16 +590,16 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 		}
 		switch (priv->shrd->ucode_type) {
 		case IWL_UCODE_REGULAR:
-			inst_size = nic(priv)->fw.ucode_rt.code.len;
-			data_size = nic(priv)->fw.ucode_rt.data.len;
+			inst_size = priv->fw->ucode_rt.code.len;
+			data_size = priv->fw->ucode_rt.data.len;
 			break;
 		case IWL_UCODE_INIT:
-			inst_size = nic(priv)->fw.ucode_init.code.len;
-			data_size = nic(priv)->fw.ucode_init.data.len;
+			inst_size = priv->fw->ucode_init.code.len;
+			data_size = priv->fw->ucode_init.data.len;
 			break;
 		case IWL_UCODE_WOWLAN:
-			inst_size = nic(priv)->fw.ucode_wowlan.code.len;
-			data_size = nic(priv)->fw.ucode_wowlan.data.len;
+			inst_size = priv->fw->ucode_wowlan.code.len;
+			data_size = priv->fw->ucode_wowlan.data.len;
 			break;
 		case IWL_UCODE_NONE:
 			IWL_ERR(priv, "No uCode has not been loaded\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index bf560e9..69e4544 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -602,17 +602,16 @@ static void iwl_dump_nic_error_log(struct iwl_trans *trans)
 {
 	u32 base;
 	struct iwl_error_event_table table;
-	struct iwl_nic *nic = nic(trans);
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	base = trans->shrd->device_pointers.error_event_table;
 	if (trans->shrd->ucode_type == IWL_UCODE_INIT) {
 		if (!base)
-			base = nic->init_errlog_ptr;
+			base = trans->shrd->fw->init_errlog_ptr;
 	} else {
 		if (!base)
-			base = nic->inst_errlog_ptr;
+			base = trans->shrd->fw->inst_errlog_ptr;
 	}
 
 	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
@@ -634,7 +633,7 @@ static void iwl_dump_nic_error_log(struct iwl_trans *trans)
 
 	trans_pcie->isr_stats.err_code = table.error_id;
 
-	trace_iwlwifi_dev_ucode_error(priv(nic), table.error_id, table.tsf_low,
+	trace_iwlwifi_dev_ucode_error(priv(trans), table.error_id, table.tsf_low,
 				      table.data1, table.data2, table.line,
 				      table.blink1, table.blink2, table.ilink1,
 				      table.ilink2, table.bcon_time, table.gp1,
@@ -700,7 +699,7 @@ static void iwl_irq_handle_error(struct iwl_trans *trans)
 	}
 
 	IWL_ERR(trans, "Loaded firmware version: %s\n",
-		nic(trans)->fw.fw_version);
+		trans->shrd->fw->fw_version);
 
 	iwl_dump_nic_error_log(trans);
 	iwl_dump_csr(trans);
@@ -726,7 +725,6 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 	u32 ptr;        /* SRAM byte address of log data */
 	u32 ev, time, data; /* event log data */
 	unsigned long reg_flags;
-	struct iwl_nic *nic = nic(trans);
 
 	if (num_events == 0)
 		return pos;
@@ -734,10 +732,10 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 	base = trans->shrd->device_pointers.log_event_table;
 	if (trans->shrd->ucode_type == IWL_UCODE_INIT) {
 		if (!base)
-			base = nic->init_evtlog_ptr;
+			base = trans->shrd->fw->init_evtlog_ptr;
 	} else {
 		if (!base)
-			base = nic->inst_evtlog_ptr;
+			base = trans->shrd->fw->inst_evtlog_ptr;
 	}
 
 	if (mode == 0)
@@ -843,17 +841,16 @@ int iwl_dump_nic_event_log(struct iwl_trans *trans, bool full_log,
 	u32 logsize;
 	int pos = 0;
 	size_t bufsz = 0;
-	struct iwl_nic *nic = nic(trans);
 
 	base = trans->shrd->device_pointers.log_event_table;
 	if (trans->shrd->ucode_type == IWL_UCODE_INIT) {
-		logsize = nic->init_evtlog_size;
+		logsize = trans->shrd->fw->init_evtlog_size;
 		if (!base)
-			base = nic->init_evtlog_ptr;
+			base = trans->shrd->fw->init_evtlog_ptr;
 	} else {
-		logsize = nic->inst_evtlog_size;
+		logsize = trans->shrd->fw->inst_evtlog_size;
 		if (!base)
-			base = nic->inst_evtlog_ptr;
+			base = trans->shrd->fw->inst_evtlog_ptr;
 	}
 
 	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index f49aa18..d7dbd80 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -76,7 +76,6 @@
 #include "iwl-eeprom.h"
 #include "iwl-agn-hw.h"
 #include "iwl-core.h"
-#include "iwl-ucode.h"
 
 #define IWL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
 
@@ -947,7 +946,7 @@ static const u8 iwlagn_pan_ac_to_queue[] = {
  * ucode
  */
 static int iwl_load_section(struct iwl_trans *trans, const char *name,
-				struct fw_desc *image, u32 dst_addr)
+			    const struct fw_desc *image, u32 dst_addr)
 {
 	dma_addr_t phy_addr = image->p_addr;
 	u32 byte_cnt = image->len;
@@ -995,7 +994,8 @@ static int iwl_load_section(struct iwl_trans *trans, const char *name,
 	return 0;
 }
 
-static int iwl_load_given_ucode(struct iwl_trans *trans, struct fw_img *image)
+static int iwl_load_given_ucode(struct iwl_trans *trans,
+				const struct fw_img *image)
 {
 	int ret = 0;
 
@@ -1015,7 +1015,8 @@ static int iwl_load_given_ucode(struct iwl_trans *trans, struct fw_img *image)
 	return 0;
 }
 
-static int iwl_trans_pcie_start_fw(struct iwl_trans *trans, struct fw_img *fw)
+static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
+				   const struct fw_img *fw)
 {
 	int ret;
 	struct iwl_trans_pcie *trans_pcie =
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 6fa0c86..ec5249c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -272,7 +272,7 @@ struct iwl_trans_ops {
 
 	int (*start_hw)(struct iwl_trans *iwl_trans);
 	void (*stop_hw)(struct iwl_trans *iwl_trans);
-	int (*start_fw)(struct iwl_trans *trans, struct fw_img *fw);
+	int (*start_fw)(struct iwl_trans *trans, const struct fw_img *fw);
 	void (*fw_alive)(struct iwl_trans *trans);
 	void (*stop_device)(struct iwl_trans *trans);
 
@@ -400,7 +400,8 @@ static inline void iwl_trans_fw_alive(struct iwl_trans *trans)
 	trans->state = IWL_TRANS_FW_ALIVE;
 }
 
-static inline int iwl_trans_start_fw(struct iwl_trans *trans, struct fw_img *fw)
+static inline int iwl_trans_start_fw(struct iwl_trans *trans,
+				     const struct fw_img *fw)
 {
 	might_sleep();
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 340575a..f78b155 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -31,7 +31,6 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 
-#include "iwl-ucode.h"
 #include "iwl-wifi.h"
 #include "iwl-dev.h"
 #include "iwl-core.h"
@@ -80,16 +79,16 @@ static struct iwl_wimax_coex_event_entry cu_priorities[COEX_NUM_OF_EVENTS] = {
  *
  ******************************************************************************/
 
-static inline struct fw_img *iwl_get_ucode_image(struct iwl_priv *priv,
-						 enum iwl_ucode_type ucode_type)
+static inline const struct fw_img *
+iwl_get_ucode_image(struct iwl_priv *priv, enum iwl_ucode_type ucode_type)
 {
 	switch (ucode_type) {
 	case IWL_UCODE_INIT:
-		return &nic(priv)->fw.ucode_init;
+		return &priv->fw->ucode_init;
 	case IWL_UCODE_WOWLAN:
-		return &nic(priv)->fw.ucode_wowlan;
+		return &priv->fw->ucode_wowlan;
 	case IWL_UCODE_REGULAR:
-		return &nic(priv)->fw.ucode_rt;
+		return &priv->fw->ucode_rt;
 	case IWL_UCODE_NONE:
 		break;
 	}
@@ -355,7 +354,7 @@ static int iwl_alive_notify(struct iwl_priv *priv)
  *   it's a pretty good bet that everything between them is good, too.
  */
 static int iwl_verify_inst_sparse(struct iwl_priv *priv,
-				  struct fw_desc *fw_desc)
+				  const struct fw_desc *fw_desc)
 {
 	__le32 *image = (__le32 *)fw_desc->v_addr;
 	u32 len = fw_desc->len;
@@ -379,7 +378,7 @@ static int iwl_verify_inst_sparse(struct iwl_priv *priv,
 }
 
 static void iwl_print_mismatch_inst(struct iwl_priv *priv,
-				    struct fw_desc *fw_desc)
+				    const struct fw_desc *fw_desc)
 {
 	__le32 *image = (__le32 *)fw_desc->v_addr;
 	u32 len = fw_desc->len;
@@ -413,7 +412,7 @@ static void iwl_print_mismatch_inst(struct iwl_priv *priv,
 static int iwl_verify_ucode(struct iwl_priv *priv,
 			    enum iwl_ucode_type ucode_type)
 {
-	struct fw_img *img = iwl_get_ucode_image(priv, ucode_type);
+	const struct fw_img *img = iwl_get_ucode_image(priv, ucode_type);
 
 	if (!img) {
 		IWL_ERR(priv, "Invalid ucode requested (%d)\n", ucode_type);
@@ -531,7 +530,7 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 {
 	struct iwl_notification_wait alive_wait;
 	struct iwl_alive_data alive_data;
-	struct fw_img *fw;
+	const struct fw_img *fw;
 	int ret;
 	enum iwl_ucode_type old_type;
 
@@ -604,7 +603,7 @@ int iwl_run_init_ucode(struct iwl_priv *priv)
 	lockdep_assert_held(&priv->shrd->mutex);
 
 	/* No init ucode required? Curious, but maybe ok */
-	if (!nic(priv)->fw.ucode_init.code.len)
+	if (!priv->fw->ucode_init.code.len)
 		return 0;
 
 	if (priv->shrd->ucode_type != IWL_UCODE_NONE)
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.h b/drivers/net/wireless/iwlwifi/iwl-ucode.h
index 8bebeb0..cdab287 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.h
@@ -126,22 +126,6 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_FLAGS		= 18,
 };
 
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
 struct iwl_ucode_tlv {
 	__le16 type;		/* see above */
 	__le16 alternative;	/* see comment */
@@ -173,48 +157,4 @@ struct iwl_tlv_ucode_header {
 	u8 data[0];
 };
 
-struct iwl_ucode_capabilities {
-	u32 max_probe_length;
-	u32 standard_phy_calibration_size;
-	u32 flags;
-};
-
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
-/**
- * struct iwl_fw - variables associated with the firmware
- *
- * @ucode_ver: ucode version from the ucode file
- * @fw_version: firmware version string
- * @ucode_rt: run time ucode image
- * @ucode_init: init ucode image
- * @ucode_wowlan: wake on wireless ucode image (optional)
- * @ucode_capa: capabilities parsed from the ucode file.
- * @enhance_sensitivity_table: device can do enhanced sensitivity.
- */
-struct iwl_fw {
-
-	u32 ucode_ver;
-
-	char fw_version[ETHTOOL_BUSINFO_LEN];
-
-	/* ucode images */
-	struct fw_img ucode_rt;
-	struct fw_img ucode_init;
-	struct fw_img ucode_wowlan;
-
-	struct iwl_ucode_capabilities ucode_capa;
-	bool enhance_sensitivity_table;
-};
-
 #endif  /* __iwl_ucode_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-wifi.h b/drivers/net/wireless/iwlwifi/iwl-wifi.h
index 753e338..a71624d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-wifi.h
+++ b/drivers/net/wireless/iwlwifi/iwl-wifi.h
@@ -64,7 +64,6 @@
 #define __iwl_wifi_h__
 
 #include "iwl-shared.h"
-#include "iwl-ucode.h"
 
 /**
  * struct iwl_nic - nic common data
@@ -73,12 +72,6 @@
  * @op_mode: the running op_mode
  * @fw_index: firmware revision to try loading
  * @firmware_name: composite filename of ucode file to load
- * @init_evtlog_ptr: event log offset for init ucode.
- * @init_evtlog_size: event log size for init ucode.
- * @init_errlog_ptr: error log offfset for init ucode.
- * @inst_evtlog_ptr: event log offset for runtime ucode.
- * @inst_evtlog_size: event log size for runtime ucode.
- * @inst_errlog_ptr: error log offfset for runtime ucode.
  * @request_firmware_complete: the firmware has been obtained from user space
  */
 struct iwl_nic {
@@ -90,9 +83,6 @@ struct iwl_nic {
 	int fw_index;                   /* firmware we're trying to load */
 	char firmware_name[25];         /* name of firmware file to load */
 
-	u32 init_evtlog_ptr, init_evtlog_size, init_errlog_ptr;
-	u32 inst_evtlog_ptr, inst_evtlog_size, inst_errlog_ptr;
-
 	struct completion request_firmware_complete;
 };
 #endif  /* __iwl_wifi_h__ */
-- 
1.7.0.4

