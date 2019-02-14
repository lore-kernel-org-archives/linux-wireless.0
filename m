Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLACK,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BABAC10F05
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 22:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4803B21B18
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 22:37:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B+3VPjRY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730552AbfBNWhF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 17:37:05 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46446 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729717AbfBNWg6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 17:36:58 -0500
Received: by mail-ot1-f66.google.com with SMTP id w25so13314444otm.13
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 14:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aQWJt7RRljNzYijZcDKDaI3AVQ7HSq/U9BAN+gDuqow=;
        b=B+3VPjRYiQUOtdZd7dIz9r6Gz3iwibu+FuMVNA23cNjiEwLe4S86WDlUvvJ01P1hkg
         lSUuuwxuSSV7ZvhudHMSEhlsZwH7Hbjg063kZmEBNA9tA8oTK0vSG3tvfjh89JdzPcl0
         YQ2DSNpWFR+FuK0HCLRn82mWJyYzmN55q/xDFX+RwroroFooZAvCk1grCak3x2Nz9v0r
         rs0kETgGGAvC61EhZZYJ0ev3/UWD/w43o3cuqxUpzu9dk6JXLD0f8AbuE2D28xt4Sekr
         lsW0CLI0SDdypgPKxlayRa+nTOEF4dGvlzIOWhSUDicO4BDlh+BpY8PhRpTHqNQrPbUK
         vmcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=aQWJt7RRljNzYijZcDKDaI3AVQ7HSq/U9BAN+gDuqow=;
        b=odoinhqbJmx6m5Mv9LGrXh017i4h44BWolV8TqXmDvnmUmKwP4XZhItWXq6Pjjhkbo
         APeFNYMBNwHG3sbPS9ObaTAPoYhV5NZVA5FTorrw2f4gBzuz5k3JVW/YF6xha5JGy+2f
         H8rVAIjJPUZC0EHbO3EmfNxbiCZDx4q33d5HEtlMBBBoC2a1aH3dSUQdzEhPtiAKI9fS
         OhK6QCopHoF067XA+fdVGyGeBZID0kyT1iuL1yjg92IdJVz77k+h8zlC1OXEDReQj42S
         hPyvEDJAA/gJG3fxhWp5CLOpy9cAafaBGo+cooU1fNqIl6SHvNf9uXDFRPKckXAvs1zt
         54Cg==
X-Gm-Message-State: AHQUAuZdObvAAVBQGyB2DDx6ziqPU1kEpcS98tcrRNPlkymdmwrkUm1Y
        KMF4KHDDKgfFL57R10WbO78=
X-Google-Smtp-Source: AHgI3Iax7UNyWcsRkNab/kJAKIjaRlmnQwtrFIJDqfuldd0R/5uYsK8Kl3FDxLLnTPvUIIUboRAQ6A==
X-Received: by 2002:a9d:3d24:: with SMTP id a33mr3894977otc.365.1550183816286;
        Thu, 14 Feb 2019 14:36:56 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id h1sm1463938otm.0.2019.02.14.14.36.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 14:36:55 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 7/8] rtlwifi: rtl8723{be,ae}: Remove CamelCase variables
Date:   Thu, 14 Feb 2019 16:36:43 -0600
Message-Id: <20190214223644.8035-8-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190214223644.8035-1-Larry.Finger@lwfinger.net>
References: <20190214223644.8035-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

If a macro is in CamelCase, it it converted to upper case. Variables
and routine names are converted to lower case.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 .../wireless/realtek/rtlwifi/rtl8723ae/def.h   |  2 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/hw.c    |  8 ++++----
 .../wireless/realtek/rtlwifi/rtl8723ae/phy.c   |  2 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/phy.h   |  2 +-
 .../realtek/rtlwifi/rtl8723ae/pwrseq.h         | 18 +++++++++---------
 .../wireless/realtek/rtlwifi/rtl8723ae/sw.c    |  2 +-
 .../wireless/realtek/rtlwifi/rtl8723be/hw.c    | 14 +++++++-------
 7 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/def.h
index d79b23528f9a..132e0fd83812 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/def.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/def.h
@@ -94,7 +94,7 @@
 #define IS_VENDOR_8723A_B_CUT(version)	((IS_8723_SERIES(version))\
 		? ((GET_CVID_CUT_VERSION(version) == \
 		B_CUT_VERSION) ? true : false) : false)
-#define IS_81xxC_VENDOR_UMC_B_CUT(version)	((IS_CHIP_VENDOR_UMC(version))\
+#define IS_81XXC_VENDOR_UMC_B_CUT(version)	((IS_CHIP_VENDOR_UMC(version))\
 		? ((GET_CVID_CUT_VERSION(version) == \
 		B_CUT_VERSION) ? true : false) : false)
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
index b9afc34705e2..1669718fa38d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
@@ -676,7 +676,7 @@ static bool _rtl8712e_init_mac(struct ieee80211_hw *hw)
 
 	/* HW Power on sequence */
 	if (!rtl_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,
-		PWR_INTF_PCI_MSK, Rtl8723_NIC_ENABLE_FLOW))
+		PWR_INTF_PCI_MSK, RTL8723_NIC_ENABLE_FLOW))
 		return false;
 
 	bytetmp = rtl_read_byte(rtlpriv, REG_PCIE_CTRL_REG+2);
@@ -966,7 +966,7 @@ int rtl8723e_hw_init(struct ieee80211_hw *hw)
 	if (IS_VENDOR_UMC_A_CUT(rtlhal->version)) {
 		rtl_set_rfreg(hw, RF90_PATH_A, RF_RX_G1, MASKDWORD, 0x30255);
 		rtl_set_rfreg(hw, RF90_PATH_A, RF_RX_G2, MASKDWORD, 0x50a00);
-	} else if (IS_81xxC_VENDOR_UMC_B_CUT(rtlhal->version)) {
+	} else if (IS_81XXC_VENDOR_UMC_B_CUT(rtlhal->version)) {
 		rtl_set_rfreg(hw, RF90_PATH_A, 0x0C, MASKDWORD, 0x894AE);
 		rtl_set_rfreg(hw, RF90_PATH_A, 0x0A, MASKDWORD, 0x1AF31);
 		rtl_set_rfreg(hw, RF90_PATH_A, RF_IPA, MASKDWORD, 0x8F425);
@@ -1262,7 +1262,7 @@ static void _rtl8723e_poweroff_adapter(struct ieee80211_hw *hw)
 	/* Combo (PCIe + USB) Card and PCIe-MF Card */
 	/* 1. Run LPS WL RFOFF flow */
 	rtl_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,
-				 PWR_INTF_PCI_MSK, Rtl8723_NIC_LPS_ENTER_FLOW);
+				 PWR_INTF_PCI_MSK, RTL8723_NIC_LPS_ENTER_FLOW);
 
 	/* 2. 0x1F[7:0] = 0 */
 	/* turn off RF */
@@ -1282,7 +1282,7 @@ static void _rtl8723e_poweroff_adapter(struct ieee80211_hw *hw)
 
 	/* HW card disable configuration. */
 	rtl_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,
-		PWR_INTF_PCI_MSK, Rtl8723_NIC_DISABLE_FLOW);
+		PWR_INTF_PCI_MSK, RTL8723_NIC_DISABLE_FLOW);
 
 	/* Reset MCU IO Wrapper */
 	u1b_tmp = rtl_read_byte(rtlpriv, REG_RSV_CTRL + 1);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
index e5518375303d..b5642f782e69 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
@@ -883,7 +883,7 @@ static void _rtl8723e_phy_sw_rf_seting(struct ieee80211_hw *hw, u8 channel)
 	struct rtl_phy *rtlphy = &rtlpriv->phy;
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 
-	if (IS_81xxC_VENDOR_UMC_B_CUT(rtlhal->version)) {
+	if (IS_81XXC_VENDOR_UMC_B_CUT(rtlhal->version)) {
 		if (channel == 6 && rtlphy->current_chan_bw ==
 				HT_CHANNEL_WIDTH_20)
 			rtl_set_rfreg(hw, RF90_PATH_A, RF_RX_G1,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.h
index c252cce6f111..b0a944fc2025 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.h
@@ -26,7 +26,7 @@
 #define MAX_STALL_TIME				50
 #define ANTENNADIVERSITYVALUE			0x80
 #define MAX_TXPWR_IDX_NMODE_92S			63
-#define Reset_Cnt_Limit				3
+#define reset_cnt_limit				3
 
 #define IQK_ADDA_REG_NUM			16
 #define IQK_MAC_REG_NUM				4
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.h
index 7453007a4ece..85cc8fe6f163 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.h
@@ -305,14 +305,14 @@ extern struct wlan_pwr_cfg rtl8723A_leave_lps_flow
 		[RTL8723A_TRANS_LPS_TO_ACT_STEPS + RTL8723A_TRANS_END_STEPS];
 
 /* RTL8723 Power Configuration CMDs for PCIe interface */
-#define Rtl8723_NIC_PWR_ON_FLOW		rtl8723A_power_on_flow
-#define Rtl8723_NIC_RF_OFF_FLOW		rtl8723A_radio_off_flow
-#define Rtl8723_NIC_DISABLE_FLOW	rtl8723A_card_disable_flow
-#define Rtl8723_NIC_ENABLE_FLOW		rtl8723A_card_enable_flow
-#define Rtl8723_NIC_SUSPEND_FLOW	rtl8723A_suspend_flow
-#define Rtl8723_NIC_RESUME_FLOW		rtl8723A_resume_flow
-#define Rtl8723_NIC_PDN_FLOW		rtl8723A_hwpdn_flow
-#define Rtl8723_NIC_LPS_ENTER_FLOW	rtl8723A_enter_lps_flow
-#define Rtl8723_NIC_LPS_LEAVE_FLOW	rtl8723A_leave_lps_flow
+#define RTL8723_NIC_PWR_ON_FLOW		rtl8723A_power_on_flow
+#define RTL8723_NIC_RF_OFF_FLOW		rtl8723A_radio_off_flow
+#define RTL8723_NIC_DISABLE_FLOW	rtl8723A_card_disable_flow
+#define RTL8723_NIC_ENABLE_FLOW		rtl8723A_card_enable_flow
+#define RTL8723_NIC_SUSPEND_FLOW	rtl8723A_suspend_flow
+#define RTL8723_NIC_RESUME_FLOW		rtl8723A_resume_flow
+#define RTL8723_NIC_PDN_FLOW		rtl8723A_hwpdn_flow
+#define RTL8723_NIC_LPS_ENTER_FLOW	rtl8723A_enter_lps_flow
+#define RTL8723_NIC_LPS_LEAVE_FLOW	rtl8723A_leave_lps_flow
 
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
index 52d46cc5e793..c263ff6bd04e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
@@ -153,7 +153,7 @@ int rtl8723e_init_sw_vars(struct ieee80211_hw *hw)
 		return 1;
 	}
 
-	if (IS_81xxC_VENDOR_UMC_B_CUT(rtlhal->version))
+	if (IS_81XXC_VENDOR_UMC_B_CUT(rtlhal->version))
 		fw_name = "rtlwifi/rtl8723fw_B.bin";
 
 	rtlpriv->max_fw_size = 0x6000;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index d6e985bcb43d..18cc2e26046c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -297,12 +297,12 @@ void rtl8723be_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		*((enum rf_pwrstate *)(val)) = ppsc->rfpwr_state;
 		break;
 	case HW_VAR_FWLPS_RF_ON:{
-		enum rf_pwrstate rfState;
+		enum rf_pwrstate rfstate;
 		u32 val_rcr;
 
 		rtlpriv->cfg->ops->get_hw_reg(hw, HW_VAR_RF_STATE,
-					      (u8 *)(&rfState));
-		if (rfState == ERFOFF) {
+					      (u8 *)(&rfstate));
+		if (rfstate == ERFOFF) {
 			*((bool *)(val)) = true;
 		} else {
 			val_rcr = rtl_read_dword(rtlpriv, REG_RCR);
@@ -742,10 +742,10 @@ static bool _rtl8723be_llt_table_init(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	unsigned short i;
 	u8 txpktbuf_bndy;
-	u8 maxPage;
+	u8 maxpage;
 	bool status;
 
-	maxPage = 255;
+	maxpage = 255;
 	txpktbuf_bndy = 245;
 
 	rtl_write_dword(rtlpriv, REG_TRXFF_BNDY,
@@ -770,13 +770,13 @@ static bool _rtl8723be_llt_table_init(struct ieee80211_hw *hw)
 	if (!status)
 		return status;
 
-	for (i = txpktbuf_bndy; i < maxPage; i++) {
+	for (i = txpktbuf_bndy; i < maxpage; i++) {
 		status = _rtl8723be_llt_write(hw, i, (i + 1));
 		if (!status)
 			return status;
 	}
 
-	status = _rtl8723be_llt_write(hw, maxPage, txpktbuf_bndy);
+	status = _rtl8723be_llt_write(hw, maxpage, txpktbuf_bndy);
 	if (!status)
 		return status;
 
-- 
2.20.1

