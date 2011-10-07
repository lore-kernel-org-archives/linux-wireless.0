Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43412 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760205Ab1JGQoS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 12:44:18 -0400
Received: by mail-yw0-f46.google.com with SMTP id 5so3801334ywb.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Oct 2011 09:44:18 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>
Subject: [PATCH 3/5] rtlwifi: rtl8192ce: Add new chip revisions
Date: Fri,  7 Oct 2011 11:43:20 -0500
Message-Id: <1318005802-29057-4-git-send-email-Larry.Finger@lwfinger.net> (sfid-20111007_184423_235507_EA84F284)
In-Reply-To: <1318005802-29057-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1318005802-29057-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming Li <chaoming_li@realsil.com.cn>

This patch incorporate the differences between the 06/20/2011 and
08/16/2011 Realtek releases of the rtlwifi driver.

The changes include:

1. Adding new chip revisions including new firmware.

Signed-off-by: Chaoming Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h |   14 ++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c  |   14 ++++++++++++--
 drivers/net/wireless/rtlwifi/rtl8192cu/def.h |    4 ----
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/def.h b/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
index 11f4319..a816459 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
@@ -142,8 +142,22 @@ enum version_8192c {
 	VERSION_UNKNOWN = 0x88,
 };
 
+#define CUT_VERSION_MASK		(BIT(6)|BIT(7))
+#define CHIP_VENDOR_UMC			BIT(5)
+#define CHIP_VENDOR_UMC_B_CUT		BIT(6) /* Chip version for ECO */
+#define IS_VENDOR_UMC_A_CUT(version)	((IS_CHIP_VENDOR_UMC(version)) ? \
+	((GET_CVID_CUT_VERSION(version)) ? false : true) : false)
 #define IS_CHIP_VER_B(version)  ((version & CHIP_VER_B) ? true : false)
+#define IS_VENDOR_UMC_A_CUT(version)	((IS_CHIP_VENDOR_UMC(version)) ? \
+	((GET_CVID_CUT_VERSION(version)) ? false : true) : false)
 #define IS_92C_SERIAL(version)  ((version & CHIP_92C_BITMASK) ? true : false)
+#define IS_CHIP_VENDOR_UMC(version)		\
+	((version & CHIP_VENDOR_UMC) ? true : false)
+#define GET_CVID_CUT_VERSION(version)	((version) & CUT_VERSION_MASK)
+#define IS_81xxC_VENDOR_UMC_B_CUT(version)		\
+	((IS_CHIP_VENDOR_UMC(version)) ? \
+	((GET_CVID_CUT_VERSION(version) == CHIP_VENDOR_UMC_B_CUT) ?	\
+	true : false) : false)
 
 enum rtl819x_loopback_e {
 	RTL819X_NO_LOOPBACK = 0,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
index 07a75d3..f515bf7 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -92,6 +92,8 @@ int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	const struct firmware *firmware;
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	char *fw_name = NULL;
 
 	rtl8192ce_bt_reg_init(hw);
 
@@ -159,8 +161,14 @@ int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
 	}
 
 	/* request fw */
-	err = request_firmware(&firmware, rtlpriv->cfg->fw_name,
-			rtlpriv->io.dev);
+	if (IS_VENDOR_UMC_A_CUT(rtlhal->version) &&
+	    !IS_92C_SERIAL(rtlhal->version))
+		fw_name = "rtlwifi/rtl8192cfwU.bin";
+	else if (IS_81xxC_VENDOR_UMC_B_CUT(rtlhal->version))
+		fw_name = "rtlwifi/rtl8192cfwU_B.bin";
+	else
+		fw_name = rtlpriv->cfg->fw_name;
+	err = request_firmware(&firmware, fw_name, rtlpriv->io.dev);
 	if (err) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 ("Failed to request firmware!\n"));
@@ -355,6 +363,8 @@ MODULE_AUTHOR("Larry Finger	<Larry.Finger@lwfinger.net>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Realtek 8192C/8188C 802.11n PCI wireless");
 MODULE_FIRMWARE("rtlwifi/rtl8192cfw.bin");
+MODULE_FIRMWARE("rtlwifi/rtl8192cfwU.bin");
+MODULE_FIRMWARE("rtlwifi/rtl8192cfwU_B.bin");
 
 module_param_named(swenc, rtl92ce_mod_params.sw_crypto, bool, 0444);
 module_param_named(ips, rtl92ce_mod_params.inactiveps, bool, 0444);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/def.h b/drivers/net/wireless/rtlwifi/rtl8192cu/def.h
index c54940e..d097efb 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/def.h
@@ -50,10 +50,6 @@
 #define IS_VENDOR_UMC(version)		\
 	(((version) & CHIP_VENDOR_UMC) ? true : false)
 
-#define IS_VENDOR_UMC_A_CUT(version)	\
-	(((version) & CHIP_VENDOR_UMC) ? (((version) & (BIT(6) | BIT(7))) ? \
-	false : true) : false)
-
 #define IS_VENDOR_8723_A_CUT(version)	\
 	(((version) & CHIP_VENDOR_UMC) ? (((version) & (BIT(6))) ? \
 	false : true) : false)
-- 
1.7.6.4

