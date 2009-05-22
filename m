Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25545 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757383AbZEVRzM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 13:55:12 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/10] iwlwifi: support NVM access (EEPROM/OTP)
Date: Fri, 22 May 2009 11:01:46 -0700
Message-Id: <1243015315-13848-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1243015315-13848-1-git-send-email-reinette.chatre@intel.com>
References: <1243015315-13848-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Two type of NVM available for devices 1000, 6000 and after, adding
support to read OTP lower blocks if OTP is used instead of EEPROM.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    6 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h     |    5 +
 drivers/net/wireless/iwlwifi/iwl-debug.h   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   18 +++-
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    6 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.c  |  147 ++++++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-eeprom.h  |    4 +
 7 files changed, 161 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index eb89752..fd36734 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2298,8 +2298,10 @@ static ssize_t show_version(struct device *d,
 
 	if (priv->eeprom) {
 		eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
-		pos += sprintf(buf + pos, "EEPROM version: 0x%x\n",
-				 eeprom_ver);
+		pos += sprintf(buf + pos, "NVM Type: %s, version: 0x%x\n",
+			       (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
+			       ? "OTP" : "EEPROM", eeprom_ver);
+
 	} else {
 		pos += sprintf(buf + pos, "EEPROM not initialzed\n");
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 6e98314..3d50ef9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -89,6 +89,7 @@
 /* EEPROM reads */
 #define CSR_EEPROM_REG          (CSR_BASE+0x02c)
 #define CSR_EEPROM_GP           (CSR_BASE+0x030)
+#define CSR_OTP_GP_REG   	(CSR_BASE+0x034)
 #define CSR_GIO_REG		(CSR_BASE+0x03C)
 #define CSR_GP_UCODE		(CSR_BASE+0x044)
 #define CSR_UCODE_DRV_GP1       (CSR_BASE+0x054)
@@ -226,6 +227,10 @@
 #define CSR_EEPROM_GP_VALID_MSK		(0x00000007)
 #define CSR_EEPROM_GP_BAD_SIGNATURE	(0x00000000)
 #define CSR_EEPROM_GP_IF_OWNER_MSK	(0x00000180)
+#define CSR_OTP_GP_REG_DEVICE_SELECT	(0x00010000) /* 0 - EEPROM, 1 - OTP */
+#define CSR_OTP_GP_REG_OTP_ACCESS_MODE	(0x00020000) /* 0 - absolute, 1 - relative */
+#define CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK          (0x00100000) /* bit 20 */
+#define CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK        (0x00200000) /* bit 21 */
 
 /* CSR GIO */
 #define CSR_GIO_REG_VAL_L0S_ENABLED	(0x00000002)
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index db06980..2cf014f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -68,7 +68,7 @@ struct iwl_debugfs {
 	struct dentry *dir_rf;
 	struct dir_data_files {
 		struct dentry *file_sram;
-		struct dentry *file_eeprom;
+		struct dentry *file_nvm;
 		struct dentry *file_stations;
 		struct dentry *file_rx_statistics;
 		struct dentry *file_tx_statistics;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index ffc4be3..713f9ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -292,7 +292,7 @@ static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 	return ret;
 }
 
-static ssize_t iwl_dbgfs_eeprom_read(struct file *file,
+static ssize_t iwl_dbgfs_nvm_read(struct file *file,
 				       char __user *user_buf,
 				       size_t count,
 				       loff_t *ppos)
@@ -306,7 +306,7 @@ static ssize_t iwl_dbgfs_eeprom_read(struct file *file,
 	buf_size = 4 * eeprom_len + 256;
 
 	if (eeprom_len % 16) {
-		IWL_ERR(priv, "EEPROM size is not multiple of 16.\n");
+		IWL_ERR(priv, "NVM size is not multiple of 16.\n");
 		return -ENODATA;
 	}
 
@@ -318,6 +318,13 @@ static ssize_t iwl_dbgfs_eeprom_read(struct file *file,
 	}
 
 	ptr = priv->eeprom;
+	if (!ptr) {
+		IWL_ERR(priv, "Invalid EEPROM/OTP memory\n");
+		return -ENOMEM;
+	}
+	pos += scnprintf(buf + pos, buf_size - pos, "NVM Type: %s\n",
+			(priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
+			? "OTP" : "EEPROM");
 	for (ofs = 0 ; ofs < eeprom_len ; ofs += 16) {
 		pos += scnprintf(buf + pos, buf_size - pos, "0x%.4x ", ofs);
 		hex_dump_to_buffer(ptr + ofs, 16 , 16, 2, buf + pos,
@@ -419,7 +426,6 @@ static ssize_t iwl_dbgfs_channels_read(struct file *file, char __user *user_buf,
 				channels[i].flags &
 				IEEE80211_CHAN_PASSIVE_SCAN ?
 				"passive only" : "active/passive");
-
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
 	return ret;
@@ -564,7 +570,7 @@ static ssize_t iwl_dbgfs_interrupt_write(struct file *file,
 
 DEBUGFS_READ_WRITE_FILE_OPS(sram);
 DEBUGFS_WRITE_FILE_OPS(log_event);
-DEBUGFS_READ_FILE_OPS(eeprom);
+DEBUGFS_READ_FILE_OPS(nvm);
 DEBUGFS_READ_FILE_OPS(stations);
 DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
@@ -598,7 +604,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 
 	DEBUGFS_ADD_DIR(data, dbgfs->dir_drv);
 	DEBUGFS_ADD_DIR(rf, dbgfs->dir_drv);
-	DEBUGFS_ADD_FILE(eeprom, data);
+	DEBUGFS_ADD_FILE(nvm, data);
 	DEBUGFS_ADD_FILE(sram, data);
 	DEBUGFS_ADD_FILE(log_event, data);
 	DEBUGFS_ADD_FILE(stations, data);
@@ -629,7 +635,7 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	if (!priv->dbgfs)
 		return;
 
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_eeprom);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_nvm);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_rx_statistics);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_tx_statistics);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_sram);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index b6b8327..8282def 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -814,6 +814,11 @@ enum {
 	MEASUREMENT_ACTIVE = (1 << 1),
 };
 
+enum iwl_nvm_type {
+	NVM_DEVICE_TYPE_EEPROM = 0,
+	NVM_DEVICE_TYPE_OTP,
+};
+
 /* interrupt statistics */
 struct isr_statistics {
 	u32 hw;
@@ -1024,6 +1029,7 @@ struct iwl_priv {
 
 	/* eeprom */
 	u8 *eeprom;
+	int    nvm_device_type;
 	struct iwl_eeprom_calib_info *calib_info;
 
 	enum nl80211_iftype iw_mode;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index b400bd5..9cc063b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -152,6 +152,32 @@ int iwlcore_eeprom_verify_signature(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwlcore_eeprom_verify_signature);
 
+static int iwlcore_get_nvm_type(struct iwl_priv *priv)
+{
+	u32 otpgp;
+	int nvm_type;
+
+	/* OTP only valid for CP/PP and after */
+	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
+	case CSR_HW_REV_TYPE_3945:
+	case CSR_HW_REV_TYPE_4965:
+	case CSR_HW_REV_TYPE_5300:
+	case CSR_HW_REV_TYPE_5350:
+	case CSR_HW_REV_TYPE_5100:
+	case CSR_HW_REV_TYPE_5150:
+		nvm_type = NVM_DEVICE_TYPE_EEPROM;
+		break;
+	default:
+		otpgp = iwl_read32(priv, CSR_OTP_GP_REG);
+		if (otpgp & CSR_OTP_GP_REG_DEVICE_SELECT)
+			nvm_type = NVM_DEVICE_TYPE_OTP;
+		else
+			nvm_type = NVM_DEVICE_TYPE_EEPROM;
+		break;
+	}
+	return  nvm_type;
+}
+
 /*
  * The device's EEPROM semaphore prevents conflicts between driver and uCode
  * when accessing the EEPROM; each access is a series of pulses to/from the
@@ -198,6 +224,35 @@ const u8 *iwlcore_eeprom_query_addr(const struct iwl_priv *priv, size_t offset)
 }
 EXPORT_SYMBOL(iwlcore_eeprom_query_addr);
 
+static int iwl_init_otp_access(struct iwl_priv *priv)
+{
+	int ret;
+
+	/* Enable 40MHz radio clock */
+	_iwl_write32(priv, CSR_GP_CNTRL,
+		     _iwl_read32(priv, CSR_GP_CNTRL) |
+		     CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+
+	/* wait for clock to be ready */
+	ret = iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
+				  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+				  25000);
+	if (ret < 0)
+		IWL_ERR(priv, "Time out access OTP\n");
+	else {
+		ret = iwl_grab_nic_access(priv);
+		if (!ret) {
+			iwl_set_bits_prph(priv, APMG_PS_CTRL_REG,
+					  APMG_PS_CTRL_VAL_RESET_REQ);
+			udelay(5);
+			iwl_clear_bits_prph(priv, APMG_PS_CTRL_REG,
+					    APMG_PS_CTRL_VAL_RESET_REQ);
+			iwl_release_nic_access(priv);
+		}
+	}
+	return ret;
+}
+
 /**
  * iwl_eeprom_init - read EEPROM contents
  *
@@ -209,11 +264,18 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 {
 	u16 *e;
 	u32 gp = iwl_read32(priv, CSR_EEPROM_GP);
-	int sz = priv->cfg->eeprom_size;
+	int sz;
 	int ret;
 	u16 addr;
+	u32 otpgp;
+
+	priv->nvm_device_type = iwlcore_get_nvm_type(priv);
 
 	/* allocate eeprom */
+	if (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
+		priv->cfg->eeprom_size =
+			OTP_BLOCK_SIZE * OTP_LOWER_BLOCKS_TOTAL;
+	sz = priv->cfg->eeprom_size;
 	priv->eeprom = kzalloc(sz, GFP_KERNEL);
 	if (!priv->eeprom) {
 		ret = -ENOMEM;
@@ -235,30 +297,77 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 		ret = -ENOENT;
 		goto err;
 	}
-
-	/* eeprom is an array of 16bit values */
-	for (addr = 0; addr < sz; addr += sizeof(u16)) {
-		u32 r;
-
-		_iwl_write32(priv, CSR_EEPROM_REG,
-			     CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
-
-		ret = iwl_poll_direct_bit(priv, CSR_EEPROM_REG,
-					  CSR_EEPROM_REG_READ_VALID_MSK,
-					  IWL_EEPROM_ACCESS_TIMEOUT);
-		if (ret < 0) {
-			IWL_ERR(priv, "Time out reading EEPROM[%d]\n", addr);
-			goto done;
+	if (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP) {
+		ret = iwl_init_otp_access(priv);
+		if (ret) {
+			IWL_ERR(priv, "Failed to initialize OTP access.\n");
+			ret = -ENOENT;
+			goto err;
+		}
+		_iwl_write32(priv, CSR_EEPROM_GP,
+			     iwl_read32(priv, CSR_EEPROM_GP) &
+			     ~CSR_EEPROM_GP_IF_OWNER_MSK);
+		/* clear */
+		_iwl_write32(priv, CSR_OTP_GP_REG,
+			     iwl_read32(priv, CSR_OTP_GP_REG) |
+			     CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK |
+			     CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
+
+		for (addr = 0; addr < sz; addr += sizeof(u16)) {
+			u32 r;
+
+			_iwl_write32(priv, CSR_EEPROM_REG,
+				     CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
+
+			ret = iwl_poll_direct_bit(priv, CSR_EEPROM_REG,
+						  CSR_EEPROM_REG_READ_VALID_MSK,
+						  IWL_EEPROM_ACCESS_TIMEOUT);
+			if (ret < 0) {
+				IWL_ERR(priv, "Time out reading OTP[%d]\n", addr);
+				goto done;
+			}
+			r = _iwl_read_direct32(priv, CSR_EEPROM_REG);
+			/* check for ECC errors: */
+			otpgp = iwl_read32(priv, CSR_OTP_GP_REG);
+			if (otpgp & CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK) {
+				/* stop in this case */
+				IWL_ERR(priv, "Uncorrectable OTP ECC error, Abort OTP read\n");
+				goto done;
+			}
+			if (otpgp & CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK) {
+				/* continue in this case */
+				_iwl_write32(priv, CSR_OTP_GP_REG,
+					     iwl_read32(priv, CSR_OTP_GP_REG) |
+					     CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK);
+				IWL_ERR(priv, "Correctable OTP ECC error, continue read\n");
+			}
+			e[addr / 2] = le16_to_cpu((__force __le16)(r >> 16));
+		}
+	} else {
+		/* eeprom is an array of 16bit values */
+		for (addr = 0; addr < sz; addr += sizeof(u16)) {
+			u32 r;
+
+			_iwl_write32(priv, CSR_EEPROM_REG,
+				     CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
+
+			ret = iwl_poll_direct_bit(priv, CSR_EEPROM_REG,
+						  CSR_EEPROM_REG_READ_VALID_MSK,
+						  IWL_EEPROM_ACCESS_TIMEOUT);
+			if (ret < 0) {
+				IWL_ERR(priv, "Time out reading EEPROM[%d]\n", addr);
+				goto done;
+			}
+			r = _iwl_read_direct32(priv, CSR_EEPROM_REG);
+			e[addr / 2] = le16_to_cpu((__force __le16)(r >> 16));
 		}
-		r = _iwl_read_direct32(priv, CSR_EEPROM_REG);
-		e[addr / 2] = le16_to_cpu((__force __le16)(r >> 16));
 	}
 	ret = 0;
 done:
 	priv->cfg->ops->lib->eeprom_ops.release_semaphore(priv);
 err:
 	if (ret)
-		kfree(priv->eeprom);
+		iwl_eeprom_free(priv);
 alloc_err:
 	return ret;
 }
@@ -301,6 +410,8 @@ EXPORT_SYMBOL(iwl_eeprom_query_addr);
 
 u16 iwl_eeprom_query16(const struct iwl_priv *priv, size_t offset)
 {
+	if (!priv->eeprom)
+		return 0;
 	return (u16)priv->eeprom[offset] | ((u16)priv->eeprom[offset + 1] << 8);
 }
 EXPORT_SYMBOL(iwl_eeprom_query16);
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 3479153..195b4ef 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -179,6 +179,10 @@ struct iwl_eeprom_channel {
 #define EEPROM_5050_TX_POWER_VERSION    (4)
 #define EEPROM_5050_EEPROM_VERSION	(0x21E)
 
+/* OTP */
+#define OTP_LOWER_BLOCKS_TOTAL		(3)
+#define OTP_BLOCK_SIZE			(0x400)
+
 /* 2.4 GHz */
 extern const u8 iwl_eeprom_band_1[14];
 
-- 
1.5.6.3

