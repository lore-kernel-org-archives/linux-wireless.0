Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33262 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbYLSCpL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:11 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <sameo@linux.intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/43] iwl3945: Have consistant and not redefined HW constants
Date: Fri, 19 Dec 2008 10:37:11 +0800
Message-Id: <1229654263-21454-12-git-send-email-yi.zhu@intel.com> (sfid-20081219_034531_680539_A380AC64)
In-Reply-To: <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

SRAM addresses are different for 3945, 4065, and 5000, let's give them
different names.
Also, the RSSI_OFFSET is different for 3945 and 4965, thus they should be
named differently.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |   26 ++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h  |   20 +++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h  |   10 ++++++++--
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    9 +++++----
 drivers/net/wireless/iwlwifi/iwl-core.c     |    5 +++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   19 ++++++++++---------
 8 files changed, 55 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index b6145b0..1182e68 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -82,7 +82,7 @@
 #define LONG_SLOT_TIME 20
 
 /* RSSI to dBm */
-#define IWL_RSSI_OFFSET	95
+#define IWL39_RSSI_OFFSET	95
 
 /*
  * EEPROM related constants, enums, and structures.
@@ -276,27 +276,29 @@ struct iwl3945_eeprom {
 
 /* Sizes and addresses for instruction and data memory (SRAM) in
  * 3945's embedded processor.  Driver access is via HBUS_TARG_MEM_* regs. */
-#define RTC_INST_LOWER_BOUND			(0x000000)
-#define ALM_RTC_INST_UPPER_BOUND		(0x014000)
+#define IWL39_RTC_INST_LOWER_BOUND		(0x000000)
+#define IWL39_RTC_INST_UPPER_BOUND		(0x014000)
 
-#define RTC_DATA_LOWER_BOUND			(0x800000)
-#define ALM_RTC_DATA_UPPER_BOUND		(0x808000)
+#define IWL39_RTC_DATA_LOWER_BOUND		(0x800000)
+#define IWL39_RTC_DATA_UPPER_BOUND		(0x808000)
 
-#define ALM_RTC_INST_SIZE (ALM_RTC_INST_UPPER_BOUND - RTC_INST_LOWER_BOUND)
-#define ALM_RTC_DATA_SIZE (ALM_RTC_DATA_UPPER_BOUND - RTC_DATA_LOWER_BOUND)
+#define IWL39_RTC_INST_SIZE (IWL39_RTC_INST_UPPER_BOUND - \
+				IWL39_RTC_INST_LOWER_BOUND)
+#define IWL39_RTC_DATA_SIZE (IWL39_RTC_DATA_UPPER_BOUND - \
+				IWL39_RTC_DATA_LOWER_BOUND)
 
-#define IWL_MAX_INST_SIZE ALM_RTC_INST_SIZE
-#define IWL_MAX_DATA_SIZE ALM_RTC_DATA_SIZE
+#define IWL39_MAX_INST_SIZE IWL39_RTC_INST_SIZE
+#define IWL39_MAX_DATA_SIZE IWL39_RTC_DATA_SIZE
 
 /* Size of uCode instruction memory in bootstrap state machine */
-#define IWL_MAX_BSM_SIZE ALM_RTC_INST_SIZE
+#define IWL39_MAX_BSM_SIZE IWL39_RTC_INST_SIZE
 
 #define IWL39_MAX_NUM_QUEUES	8
 
 static inline int iwl3945_hw_valid_rtc_data_addr(u32 addr)
 {
-	return (addr >= RTC_DATA_LOWER_BOUND) &&
-	       (addr < ALM_RTC_DATA_UPPER_BOUND);
+	return (addr >= IWL39_RTC_DATA_LOWER_BOUND) &&
+	       (addr < IWL39_RTC_DATA_UPPER_BOUND);
 }
 
 /* Base physical address of iwl3945_shared is provided to FH_TSSR_CBB_BASE
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 10d6537..4455475 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -661,7 +661,7 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 
 
 	/* Convert 3945's rssi indicator to dBm */
-	rx_status.signal = rx_stats->rssi - IWL_RSSI_OFFSET;
+	rx_status.signal = rx_stats->rssi - IWL39_RSSI_OFFSET;
 
 	/* Set default noise value to -127 */
 	if (priv->last_rx_noise == 0)
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 6649f7b..9330b5a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -89,7 +89,7 @@
 #define LONG_SLOT_TIME 20
 
 /* RSSI to dBm */
-#define IWL_RSSI_OFFSET	44
+#define IWL49_RSSI_OFFSET	44
 
 
 
@@ -129,24 +129,26 @@
 
 /* Sizes and addresses for instruction and data memory (SRAM) in
  * 4965's embedded processor.  Driver access is via HBUS_TARG_MEM_* regs. */
-#define RTC_INST_LOWER_BOUND			(0x000000)
+#define IWL49_RTC_INST_LOWER_BOUND		(0x000000)
 #define IWL49_RTC_INST_UPPER_BOUND		(0x018000)
 
-#define RTC_DATA_LOWER_BOUND			(0x800000)
+#define IWL49_RTC_DATA_LOWER_BOUND		(0x800000)
 #define IWL49_RTC_DATA_UPPER_BOUND		(0x80A000)
 
-#define IWL49_RTC_INST_SIZE  (IWL49_RTC_INST_UPPER_BOUND - RTC_INST_LOWER_BOUND)
-#define IWL49_RTC_DATA_SIZE  (IWL49_RTC_DATA_UPPER_BOUND - RTC_DATA_LOWER_BOUND)
+#define IWL49_RTC_INST_SIZE  (IWL49_RTC_INST_UPPER_BOUND - \
+				IWL49_RTC_INST_LOWER_BOUND)
+#define IWL49_RTC_DATA_SIZE  (IWL49_RTC_DATA_UPPER_BOUND - \
+				IWL49_RTC_DATA_LOWER_BOUND)
 
-#define IWL_MAX_INST_SIZE IWL49_RTC_INST_SIZE
-#define IWL_MAX_DATA_SIZE IWL49_RTC_DATA_SIZE
+#define IWL49_MAX_INST_SIZE IWL49_RTC_INST_SIZE
+#define IWL49_MAX_DATA_SIZE IWL49_RTC_DATA_SIZE
 
 /* Size of uCode instruction memory in bootstrap state machine */
-#define IWL_MAX_BSM_SIZE BSM_SRAM_SIZE
+#define IWL49_MAX_BSM_SIZE BSM_SRAM_SIZE
 
 static inline int iwl4965_hw_valid_rtc_data_addr(u32 addr)
 {
-	return (addr >= RTC_DATA_LOWER_BOUND) &&
+	return (addr >= IWL49_RTC_DATA_LOWER_BOUND) &&
 	       (addr < IWL49_RTC_DATA_UPPER_BOUND);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index bb96170..4822362 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -149,7 +149,7 @@ static int iwl4965_load_bsm(struct iwl_priv *priv)
 	priv->ucode_type = UCODE_RT;
 
 	/* make sure bootstrap program is no larger than BSM's SRAM size */
-	if (len > IWL_MAX_BSM_SIZE)
+	if (len > IWL49_MAX_BSM_SIZE)
 		return -EINVAL;
 
 	/* Tell bootstrap uCode where to find the "Initialize" uCode
@@ -186,7 +186,7 @@ static int iwl4965_load_bsm(struct iwl_priv *priv)
 
 	/* Tell BSM to copy from BSM SRAM into instruction SRAM, when asked */
 	iwl_write_prph(priv, BSM_WR_MEM_SRC_REG, 0x0);
-	iwl_write_prph(priv, BSM_WR_MEM_DST_REG, RTC_INST_LOWER_BOUND);
+	iwl_write_prph(priv, BSM_WR_MEM_DST_REG, IWL49_RTC_INST_LOWER_BOUND);
 	iwl_write_prph(priv, BSM_WR_DWCOUNT_REG, len / sizeof(u32));
 
 	/* Load bootstrap code into instruction SRAM now,
@@ -2246,7 +2246,7 @@ static int iwl4965_calc_rssi(struct iwl_priv *priv,
 
 	/* dBm = max_rssi dB - agc dB - constant.
 	 * Higher AGC (higher radio gain) means lower signal. */
-	return max_rssi - agc - IWL_RSSI_OFFSET;
+	return max_rssi - agc - IWL49_RSSI_OFFSET;
 }
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index 82c3859..d83e605 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -68,10 +68,16 @@
 #ifndef __iwl_5000_hw_h__
 #define __iwl_5000_hw_h__
 
+#define IWL50_RTC_INST_LOWER_BOUND		(0x000000)
 #define IWL50_RTC_INST_UPPER_BOUND		(0x020000)
+
+#define IWL50_RTC_DATA_LOWER_BOUND		(0x800000)
 #define IWL50_RTC_DATA_UPPER_BOUND		(0x80C000)
-#define IWL50_RTC_INST_SIZE (IWL50_RTC_INST_UPPER_BOUND - RTC_INST_LOWER_BOUND)
-#define IWL50_RTC_DATA_SIZE (IWL50_RTC_DATA_UPPER_BOUND - RTC_DATA_LOWER_BOUND)
+
+#define IWL50_RTC_INST_SIZE (IWL50_RTC_INST_UPPER_BOUND - \
+				IWL50_RTC_INST_LOWER_BOUND)
+#define IWL50_RTC_DATA_SIZE (IWL50_RTC_DATA_UPPER_BOUND - \
+				IWL50_RTC_DATA_LOWER_BOUND)
 
 /* EEPROM */
 #define IWL_5000_EEPROM_IMG_SIZE			2048
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 66d053d..338444a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -580,7 +580,8 @@ static int iwl5000_load_given_ucode(struct iwl_priv *priv,
 {
 	int ret = 0;
 
-	ret = iwl5000_load_section(priv, inst_image, RTC_INST_LOWER_BOUND);
+	ret = iwl5000_load_section(priv, inst_image,
+				   IWL50_RTC_INST_LOWER_BOUND);
 	if (ret)
 		return ret;
 
@@ -600,7 +601,7 @@ static int iwl5000_load_given_ucode(struct iwl_priv *priv,
 	priv->ucode_write_complete = 0;
 
 	ret = iwl5000_load_section(
-		priv, data_image, RTC_DATA_LOWER_BOUND);
+		priv, data_image, IWL50_RTC_DATA_LOWER_BOUND);
 	if (ret)
 		return ret;
 
@@ -1356,7 +1357,7 @@ static void iwl5000_rx_handler_setup(struct iwl_priv *priv)
 
 static int iwl5000_hw_valid_rtc_data_addr(u32 addr)
 {
-	return (addr >= RTC_DATA_LOWER_BOUND) &&
+	return (addr >= IWL50_RTC_DATA_LOWER_BOUND) &&
 		(addr < IWL50_RTC_DATA_UPPER_BOUND);
 }
 
@@ -1460,7 +1461,7 @@ static int iwl5000_calc_rssi(struct iwl_priv *priv,
 
 	/* dBm = max_rssi dB - agc dB - constant.
 	 * Higher AGC (higher radio gain) means lower signal. */
-	return max_rssi - agc - IWL_RSSI_OFFSET;
+	return max_rssi - agc - IWL49_RSSI_OFFSET;
 }
 
 static struct iwl_hcmd_ops iwl5000_hcmd = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 32de3d3..6425943 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1020,7 +1020,7 @@ static int iwlcore_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IWL_DL_IO is set */
 		iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR,
-			i + RTC_INST_LOWER_BOUND);
+			i + IWL49_RTC_INST_LOWER_BOUND);
 		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
 			ret = -EIO;
@@ -1053,7 +1053,8 @@ static int iwl_verify_inst_full(struct iwl_priv *priv, __le32 *image,
 	if (ret)
 		return ret;
 
-	iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR, RTC_INST_LOWER_BOUND);
+	iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR,
+			   IWL49_RTC_INST_LOWER_BOUND);
 
 	errcnt = 0;
 	for (; len > 0; len -= sizeof(u32), image++) {
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 49ac18f..8c2d30d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5028,7 +5028,8 @@ static int iwl3945_verify_inst_full(struct iwl3945_priv *priv, __le32 *image, u3
 	if (rc)
 		return rc;
 
-	iwl3945_write_direct32(priv, HBUS_TARG_MEM_RADDR, RTC_INST_LOWER_BOUND);
+	iwl3945_write_direct32(priv, HBUS_TARG_MEM_RADDR,
+			       IWL39_RTC_INST_LOWER_BOUND);
 
 	errcnt = 0;
 	for (; len > 0; len -= sizeof(u32), image++) {
@@ -5079,7 +5080,7 @@ static int iwl3945_verify_inst_sparse(struct iwl3945_priv *priv, __le32 *image,
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IWL_DL_IO is set */
 		iwl3945_write_direct32(priv, HBUS_TARG_MEM_RADDR,
-			i + RTC_INST_LOWER_BOUND);
+			i + IWL39_RTC_INST_LOWER_BOUND);
 		val = _iwl3945_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
 #if 0 /* Enable this if you want to see details */
@@ -5229,7 +5230,7 @@ static int iwl3945_load_bsm(struct iwl3945_priv *priv)
 	IWL_DEBUG_INFO("Begin load bsm\n");
 
 	/* make sure bootstrap program is no larger than BSM's SRAM size */
-	if (len > IWL_MAX_BSM_SIZE)
+	if (len > IWL39_MAX_BSM_SIZE)
 		return -EINVAL;
 
 	/* Tell bootstrap uCode where to find the "Initialize" uCode
@@ -5267,7 +5268,7 @@ static int iwl3945_load_bsm(struct iwl3945_priv *priv)
 	/* Tell BSM to copy from BSM SRAM into instruction SRAM, when asked */
 	iwl3945_write_prph(priv, BSM_WR_MEM_SRC_REG, 0x0);
 	iwl3945_write_prph(priv, BSM_WR_MEM_DST_REG,
-				 RTC_INST_LOWER_BOUND);
+				 IWL39_RTC_INST_LOWER_BOUND);
 	iwl3945_write_prph(priv, BSM_WR_DWCOUNT_REG, len / sizeof(u32));
 
 	/* Load bootstrap code into instruction SRAM now,
@@ -5411,32 +5412,32 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 	}
 
 	/* Verify that uCode images will fit in card's SRAM */
-	if (inst_size > IWL_MAX_INST_SIZE) {
+	if (inst_size > IWL39_MAX_INST_SIZE) {
 		IWL_DEBUG_INFO("uCode instr len %d too large to fit in\n",
 			       inst_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
 
-	if (data_size > IWL_MAX_DATA_SIZE) {
+	if (data_size > IWL39_MAX_DATA_SIZE) {
 		IWL_DEBUG_INFO("uCode data len %d too large to fit in\n",
 			       data_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
-	if (init_size > IWL_MAX_INST_SIZE) {
+	if (init_size > IWL39_MAX_INST_SIZE) {
 		IWL_DEBUG_INFO("uCode init instr len %d too large to fit in\n",
 				init_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
-	if (init_data_size > IWL_MAX_DATA_SIZE) {
+	if (init_data_size > IWL39_MAX_DATA_SIZE) {
 		IWL_DEBUG_INFO("uCode init data len %d too large to fit in\n",
 				init_data_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
-	if (boot_size > IWL_MAX_BSM_SIZE) {
+	if (boot_size > IWL39_MAX_BSM_SIZE) {
 		IWL_DEBUG_INFO("uCode boot instr len %d too large to fit in\n",
 				boot_size);
 		ret = -EINVAL;
-- 
1.5.3.6

