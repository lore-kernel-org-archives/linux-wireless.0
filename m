Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20196 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbZFYK2h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jun 2009 06:28:37 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 3/4] iwmc3200wifi: remove B0 hardware support
Date: Thu, 25 Jun 2009 18:28:32 +0800
Message-Id: <1245925713-14908-4-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1245925713-14908-3-git-send-email-yi.zhu@intel.com>
References: <1245925713-14908-1-git-send-email-yi.zhu@intel.com>
 <1245925713-14908-2-git-send-email-yi.zhu@intel.com>
 <1245925713-14908-3-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch removes B0 hardware support. Nobody is using it anyway.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/eeprom.c |    4 ----
 drivers/net/wireless/iwmc3200wifi/fw.c     |    6 ------
 drivers/net/wireless/iwmc3200wifi/iwm.h    |    5 -----
 drivers/net/wireless/iwmc3200wifi/main.c   |    7 -------
 drivers/net/wireless/iwmc3200wifi/rx.c     |    7 -------
 5 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/eeprom.c b/drivers/net/wireless/iwmc3200wifi/eeprom.c
index 0f34b84..365910f 100644
--- a/drivers/net/wireless/iwmc3200wifi/eeprom.c
+++ b/drivers/net/wireless/iwmc3200wifi/eeprom.c
@@ -156,10 +156,6 @@ int iwm_eeprom_init(struct iwm_priv *iwm)
 		return -ENOMEM;
 
 	for (i = IWM_EEPROM_FIRST; i < IWM_EEPROM_LAST; i++) {
-#ifdef CONFIG_IWM_B0_HW_SUPPORT
-		if (iwm->conf.hw_b0 && (i >= IWM_EEPROM_INDIRECT_OFFSET))
-			break;
-#endif
 		ret = iwm_eeprom_read(iwm, i);
 		if (ret < 0) {
 			IWM_ERR(iwm, "Couldn't read eeprom entry #%d: %s\n",
diff --git a/drivers/net/wireless/iwmc3200wifi/fw.c b/drivers/net/wireless/iwmc3200wifi/fw.c
index c58f614..0f32cab 100644
--- a/drivers/net/wireless/iwmc3200wifi/fw.c
+++ b/drivers/net/wireless/iwmc3200wifi/fw.c
@@ -319,12 +319,6 @@ int iwm_load_fw(struct iwm_priv *iwm)
 	init_calib_map = iwm->conf.calib_map & IWM_CALIB_MAP_INIT_MSK;
 	periodic_calib_map = IWM_CALIB_MAP_PER_LMAC(iwm->conf.calib_map);
 
-#ifdef CONFIG_IWM_B0_HW_SUPPORT
-	if (iwm->conf.hw_b0) {
-		clear_bit(PHY_CALIBRATE_RX_IQ_CMD, &init_calib_map);
-		clear_bit(PHY_CALIBRATE_RX_IQ_CMD, &periodic_calib_map);
-	}
-#endif
 	/* Read RX IQ calibration result from EEPROM */
 	if (test_bit(PHY_CALIBRATE_RX_IQ_CMD, &init_calib_map)) {
 		iwm_store_rxiq_calib_result(iwm);
diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index 1bad78f..79d9d89 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -52,8 +52,6 @@
 #define IWM_COPYRIGHT "Copyright(c) 2009 Intel Corporation"
 #define IWM_AUTHOR "<ilw@linux.intel.com>"
 
-#define CONFIG_IWM_B0_HW_SUPPORT	1
-
 #define IWM_SRC_LMAC	UMAC_HDI_IN_SOURCE_FHRX
 #define IWM_SRC_UDMA	UMAC_HDI_IN_SOURCE_UDMA
 #define IWM_SRC_UMAC	UMAC_HDI_IN_SOURCE_FW
@@ -86,9 +84,6 @@ struct iwm_conf {
 	u8 ibss_channel;
 
 	u8 mac_addr[ETH_ALEN];
-#ifdef CONFIG_IWM_B0_HW_SUPPORT
-	bool hw_b0;
-#endif
 };
 
 enum {
diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index 4fedb45..484f110 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -515,13 +515,6 @@ static int iwm_channels_init(struct iwm_priv *iwm)
 {
 	int ret;
 
-#ifdef CONFIG_IWM_B0_HW_SUPPORT
-	if (iwm->conf.hw_b0) {
-		IWM_INFO(iwm, "Workaround EEPROM channels for B0 hardware\n");
-		return 0;
-	}
-#endif
-
 	ret = iwm_send_umac_channel_list(iwm);
 	if (ret) {
 		IWM_ERR(iwm, "Send channel list failed\n");
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 5d2239f..3909477 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -924,13 +924,6 @@ static int iwm_ntf_eeprom_proxy(struct iwm_priv *iwm, u8 *buf,
 	if ((hdr_offset + hdr_len) > IWM_EEPROM_LEN)
 		return -EINVAL;
 
-#ifdef CONFIG_IWM_B0_HW_SUPPORT
-	if (hdr_offset == IWM_EEPROM_SKU_CAP_OFF) {
-		if (eeprom_proxy->buf[0] == 0xff)
-			iwm->conf.hw_b0 = 1;
-	}
-#endif
-
 	switch (hdr_type) {
 	case IWM_UMAC_CMD_EEPROM_TYPE_READ:
 		memcpy(iwm->eeprom + hdr_offset, eeprom_proxy->buf, hdr_len);
-- 
1.6.0.4

