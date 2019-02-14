Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLACK,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3311C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 22:37:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6137121B18
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 22:37:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LxTjHpxo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503422AbfBNWhH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 17:37:07 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43767 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729020AbfBNWg4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 17:36:56 -0500
Received: by mail-ot1-f65.google.com with SMTP id n71so13349183ota.10
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 14:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eUXEGGD/p/FsAY3y2DRmrkPnBissd4NQ+POcw0T1RzU=;
        b=LxTjHpxoMo+ae9GjWvrY3OanWa1l9rpyjOyEydBOQjjt0g0q9sEWJ0ECSHGiwzjEWF
         x06xBk3OiOZQguCm43D3DlNwc8xVAopdBkBHrfCSJNKQAXEsf3evgtaXxGRLwlUCmNW7
         xxOcXFy+rzqZDtmX3wI5foeYdwlqULXpGaAw+RoDjIrU5k2axfxYUNWQk4udzJnB5Ycm
         Vi4GIOrbH3ehaDIQpKdwEBAoWdXtv2SLUfTWkRY74dPc+rw6Lg4vPnI7lMsEymmq4s7e
         N5RkDkmBEAO7I3hloATGjAaztIUaG22GRIgWwqMnmfbgMdmHJ996StfbaebLKNLgB9oU
         6wGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=eUXEGGD/p/FsAY3y2DRmrkPnBissd4NQ+POcw0T1RzU=;
        b=s2jqmbqgBAOns70n/fUfCF2SE0+xXL/6PLQC3aydjaEfXrfoeNsx87LrrikAY2OIdE
         L7fpgEfDfxDipzyTZmUXlzDg9fHn1N8jP7jRdZoJli0apQrtyYS+qPnOhDkHKGUqqVuS
         XehqU+5n/jLsET8hZuyF/aVmEp/jqyCF+jdr0rm7FiPghZM8OJU4eXmEC1wac+4U00gb
         jTvg3ZsnSQ/Rz51MHnfKq7BkdwrVbSnfXg0+o8Lvqcvm8quyygTdeWTM5r7AkgzBJwv5
         Q3r+o4ZG9gPY9qnla4GR3sMtNaBCjSGQMMYZZ/CRJXipCZllzlW7Y6aV/cCDxwxIvXW8
         JVEg==
X-Gm-Message-State: AHQUAuYXA7mZvvRfXZ26Om45B2qSDOlQPS21aqLKzE/Z96Fe4zE+v4Qe
        X5XPHqbWOcf3R1VXI4lrzaw=
X-Google-Smtp-Source: AHgI3IYxPApsdO23KUDd7PqKFMN5k2lGA3YOKkDDQJsawYyHMOMGKeuv69oRW56C9BsnCE66LnqmxQ==
X-Received: by 2002:aca:39d7:: with SMTP id g206mr4060673oia.142.1550183812568;
        Thu, 14 Feb 2019 14:36:52 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id h1sm1463938otm.0.2019.02.14.14.36.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 14:36:51 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 4/8] rtlwifi: rtl8192{c,u}: Remove CamelCase variables
Date:   Thu, 14 Feb 2019 16:36:40 -0600
Message-Id: <20190214223644.8035-5-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190214223644.8035-1-Larry.Finger@lwfinger.net>
References: <20190214223644.8035-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch affects modules rtl8192ce, rtl8192cu, and rtl8192com.

The following checkpatch exceptions are also fixed:

CHECK: No space is necessary after a cast
#237: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c:90:
+                                                     (u8 *) (&rfstate));

CHECK: No space is necessary after a cast
#744: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.c:329:
+                       pwr_val[i] = (u8) ((writeval & (0x7f <<

CHECK: No space is necessary after a cast
#784: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.c:365:
+                                              (u8) writeval);

CHECK: spaces preferred around that '/' (ctx:VxV)
#963: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c:513:
+               txqpageunit = txqpagenum/outepnum;
                                        ^

CHECK: Unnecessary parentheses around 'outepnum > 1'
#975: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c:521:
+               if ((outepnum > 1) && (txqremaininpage))

CHECK: Alignment should match open parenthesis
#1059: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c:617:
+static void _rtl92cu_init_chipn_two_out_ep_priority(struct ieee80211_hw *hw,
                                                                bool wmm_enable,

ERROR: "foo * bar" should be "foo *bar"
#1940: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c:591:
+void rtl92cu_fill_fake_txdesc(struct ieee80211_hw *hw, u8 *pdesc,

Note that not all checkpatch exceptions are addressed. Those will be
handled in later patches.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 .../realtek/rtlwifi/rtl8192c/dm_common.h      |   4 +-
 .../realtek/rtlwifi/rtl8192c/fw_common.c      |  14 +-
 .../realtek/rtlwifi/rtl8192c/phy_common.c     |  24 +-
 .../realtek/rtlwifi/rtl8192c/phy_common.h     |   6 +-
 .../wireless/realtek/rtlwifi/rtl8192ce/dm.h   |   4 +-
 .../wireless/realtek/rtlwifi/rtl8192ce/hw.c   |  42 +--
 .../wireless/realtek/rtlwifi/rtl8192ce/phy.c  |  10 +-
 .../wireless/realtek/rtlwifi/rtl8192ce/phy.h  |   6 +-
 .../wireless/realtek/rtlwifi/rtl8192ce/reg.h  |  59 ++--
 .../wireless/realtek/rtlwifi/rtl8192ce/rf.c   | 112 +++----
 .../wireless/realtek/rtlwifi/rtl8192cu/hw.c   | 276 +++++++++---------
 .../wireless/realtek/rtlwifi/rtl8192cu/hw.h   |   4 +-
 .../wireless/realtek/rtlwifi/rtl8192cu/led.c  |   6 +-
 .../wireless/realtek/rtlwifi/rtl8192cu/phy.c  |  16 +-
 .../wireless/realtek/rtlwifi/rtl8192cu/rf.c   | 112 +++----
 .../realtek/rtlwifi/rtl8192cu/table.c         |   8 +-
 .../realtek/rtlwifi/rtl8192cu/table.h         |  16 +-
 .../wireless/realtek/rtlwifi/rtl8192cu/trx.c  |  58 ++--
 .../wireless/realtek/rtlwifi/rtl8192cu/trx.h  |   4 +-
 19 files changed, 390 insertions(+), 391 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.h
index 2cad719e2970..d23150b98ef2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.h
@@ -27,7 +27,7 @@
 #define DM_DIG_FA_TH1				0x100
 #define DM_DIG_FA_TH2				0x200
 
-#define RXPATHSELECTION_SS_TH_lOW		30
+#define RXPATHSELECTION_SS_TH_LOW		30
 #define RXPATHSELECTION_DIFF_TH			18
 
 #define DM_RATR_STA_INIT			0
@@ -38,7 +38,7 @@
 #define CTS2SELF_THVAL				30
 #define REGC38_TH				20
 
-#define WAIOTTHVal				25
+#define WAIOTTHVAL				25
 
 #define TXHIGHPWRLEVEL_NORMAL			0
 #define TXHIGHPWRLEVEL_LEVEL1			1
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
index 44e896374fc4..ad3fcc84a1a5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
@@ -57,27 +57,27 @@ static void _rtl92c_write_fw(struct ieee80211_hw *hw,
 	RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE, "FW size is %d bytes,\n", size);
 	is_version_b = IS_NORMAL_CHIP(version);
 	if (is_version_b) {
-		u32 pageNums, remainsize;
+		u32 pagenums, remainsize;
 		u32 page, offset;
 
 		if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192CE)
 			rtl_fill_dummy(bufferptr, &size);
 
-		pageNums = size / FW_8192C_PAGE_SIZE;
+		pagenums = size / FW_8192C_PAGE_SIZE;
 		remainsize = size % FW_8192C_PAGE_SIZE;
 
-		if (pageNums > 4)
+		if (pagenums > 4)
 			pr_err("Page numbers should not greater then 4\n");
 
-		for (page = 0; page < pageNums; page++) {
+		for (page = 0; page < pagenums; page++) {
 			offset = page * FW_8192C_PAGE_SIZE;
 			rtl_fw_page_write(hw, page, (bufferptr + offset),
 					  FW_8192C_PAGE_SIZE);
 		}
 
 		if (remainsize) {
-			offset = pageNums * FW_8192C_PAGE_SIZE;
-			page = pageNums;
+			offset = pagenums * FW_8192C_PAGE_SIZE;
+			page = pagenums;
 			rtl_fw_page_write(hw, page, (bufferptr + offset),
 					  remainsize);
 		}
@@ -96,7 +96,7 @@ static int _rtl92c_fw_free_to_go(struct ieee80211_hw *hw)
 	do {
 		value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL);
 	} while ((counter++ < FW_8192C_POLLING_TIMEOUT_COUNT) &&
-		 (!(value32 & FWDL_ChkSum_rpt)));
+		 (!(value32 & FWDL_CHKSUM_RPT)));
 
 	if (counter >= FW_8192C_POLLING_TIMEOUT_COUNT) {
 		pr_err("chksum report fail! REG_MCUFWDL:0x%08x .\n",
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
index 49fb4bd7df61..d16913b49a65 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
@@ -217,7 +217,7 @@ bool _rtl92c_phy_bb8192c_config_parafile(struct ieee80211_hw *hw)
 
 EXPORT_SYMBOL(_rtl92c_phy_bb8192c_config_parafile);
 
-void _rtl92c_store_pwrIndex_diffrate_offset(struct ieee80211_hw *hw,
+void _rtl92c_store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 					    u32 regaddr, u32 bitmask,
 					    u32 data)
 {
@@ -371,7 +371,7 @@ void _rtl92c_store_pwrIndex_diffrate_offset(struct ieee80211_hw *hw,
 		rtlphy->pwrgroup_cnt++;
 	}
 }
-EXPORT_SYMBOL(_rtl92c_store_pwrIndex_diffrate_offset);
+EXPORT_SYMBOL(_rtl92c_store_pwrindex_diffrate_offset);
 
 void rtl92c_phy_get_hw_reg_originalvalue(struct ieee80211_hw *hw)
 {
@@ -430,10 +430,10 @@ void _rtl92c_phy_init_bb_rf_register_definition(struct ieee80211_hw *hw)
 	rtlphy->phyreg_def[RF90_PATH_B].rf3wire_offset =
 	    RFPGA0_XB_LSSIPARAMETER;
 
-	rtlphy->phyreg_def[RF90_PATH_A].rflssi_select = rFPGA0_XAB_RFPARAMETER;
-	rtlphy->phyreg_def[RF90_PATH_B].rflssi_select = rFPGA0_XAB_RFPARAMETER;
-	rtlphy->phyreg_def[RF90_PATH_C].rflssi_select = rFPGA0_XCD_RFPARAMETER;
-	rtlphy->phyreg_def[RF90_PATH_D].rflssi_select = rFPGA0_XCD_RFPARAMETER;
+	rtlphy->phyreg_def[RF90_PATH_A].rflssi_select = RFPGA0_XAB_RFPARAMETER;
+	rtlphy->phyreg_def[RF90_PATH_B].rflssi_select = RFPGA0_XAB_RFPARAMETER;
+	rtlphy->phyreg_def[RF90_PATH_C].rflssi_select = RFPGA0_XCD_RFPARAMETER;
+	rtlphy->phyreg_def[RF90_PATH_D].rflssi_select = RFPGA0_XCD_RFPARAMETER;
 
 	rtlphy->phyreg_def[RF90_PATH_A].rftxgain_stage = RFPGA0_TXGAINSTAGE;
 	rtlphy->phyreg_def[RF90_PATH_B].rftxgain_stage = RFPGA0_TXGAINSTAGE;
@@ -1098,19 +1098,19 @@ static void _rtl92c_phy_reload_mac_registers(struct ieee80211_hw *hw,
 static void _rtl92c_phy_path_adda_on(struct ieee80211_hw *hw,
 				     u32 *addareg, bool is_patha_on, bool is2t)
 {
-	u32 pathOn;
+	u32 pathon;
 	u32 i;
 
-	pathOn = is_patha_on ? 0x04db25a4 : 0x0b1b25a4;
+	pathon = is_patha_on ? 0x04db25a4 : 0x0b1b25a4;
 	if (false == is2t) {
-		pathOn = 0x0bdb25a0;
+		pathon = 0x0bdb25a0;
 		rtl_set_bbreg(hw, addareg[0], MASKDWORD, 0x0b1b25a0);
 	} else {
-		rtl_set_bbreg(hw, addareg[0], MASKDWORD, pathOn);
+		rtl_set_bbreg(hw, addareg[0], MASKDWORD, pathon);
 	}
 
 	for (i = 1; i < IQK_ADDA_REG_NUM; i++)
-		rtl_set_bbreg(hw, addareg[i], MASKDWORD, pathOn);
+		rtl_set_bbreg(hw, addareg[i], MASKDWORD, pathon);
 }
 
 static void _rtl92c_phy_mac_setting_calibration(struct ieee80211_hw *hw,
@@ -1339,7 +1339,7 @@ static void _rtl92c_phy_set_rfpath_switch(struct ieee80211_hw *hw,
 
 	if (is_hal_stop(rtlhal)) {
 		rtl_set_bbreg(hw, REG_LEDCFG0, BIT(23), 0x01);
-		rtl_set_bbreg(hw, rFPGA0_XAB_RFPARAMETER, BIT(13), 0x01);
+		rtl_set_bbreg(hw, RFPGA0_XAB_RFPARAMETER, BIT(13), 0x01);
 	}
 	if (is2t) {
 		if (bmain)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.h
index f1ed1a999b8f..c4d28bf175eb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.h
@@ -22,9 +22,9 @@
 
 #define LOOP_LIMIT			5
 #define MAX_STALL_TIME			50
-#define AntennaDiversityValue		0x80
+#define ANTENNADIVERSITYVALUE		0x80
 #define MAX_TXPWR_IDX_NMODE_92S		63
-#define Reset_Cnt_Limit			3
+#define RESET_CNT_LIMIT			3
 
 #define IQK_ADDA_REG_NUM		16
 #define IQK_MAC_REG_NUM			4
@@ -220,7 +220,7 @@ void _rtl92c_phy_rf_serial_write(struct ieee80211_hw *hw,
 				 enum radio_path rfpath, u32 offset,
 				 u32 data);
 bool _rtl92c_phy_bb8192c_config_parafile(struct ieee80211_hw *hw);
-void _rtl92c_store_pwrIndex_diffrate_offset(struct ieee80211_hw *hw,
+void _rtl92c_store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 					    u32 regaddr, u32 bitmask,
 					    u32 data);
 bool rtl92c_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/dm.h
index 7132696a4f50..69cd65421a0c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/dm.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/dm.h
@@ -22,7 +22,7 @@
 #define DM_DIG_FA_TH1				0x100
 #define DM_DIG_FA_TH2				0x200
 
-#define RXPATHSELECTION_SS_TH_lOW		30
+#define RXPATHSELECTION_SS_TH_LOW		30
 #define RXPATHSELECTION_DIFF_TH			18
 
 #define DM_RATR_STA_INIT			0
@@ -33,7 +33,7 @@
 #define CTS2SELF_THVAL				30
 #define REGC38_TH				20
 
-#define WAIOTTHVal				25
+#define WAIOTTHVAL				25
 
 #define TXHIGHPWRLEVEL_NORMAL			0
 #define TXHIGHPWRLEVEL_LEVEL1			1
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
index 2602e384fa94..87a2541eb434 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
@@ -82,13 +82,13 @@ void rtl92ce_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		*((enum rf_pwrstate *)(val)) = ppsc->rfpwr_state;
 		break;
 	case HW_VAR_FWLPS_RF_ON:{
-			enum rf_pwrstate rfState;
+			enum rf_pwrstate rfstate;
 			u32 val_rcr;
 
 			rtlpriv->cfg->ops->get_hw_reg(hw,
 						      HW_VAR_RF_STATE,
-						      (u8 *) (&rfState));
-			if (rfState == ERFOFF) {
+						      (u8 *)(&rfstate));
+			if (rfstate == ERFOFF) {
 				*((bool *) (val)) = true;
 			} else {
 				val_rcr = rtl_read_dword(rtlpriv, REG_RCR);
@@ -314,13 +314,13 @@ void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 			if (acm) {
 				switch (e_aci) {
 				case AC0_BE:
-					acm_ctrl |= AcmHw_BeqEn;
+					acm_ctrl |= ACMHW_BEQEN;
 					break;
 				case AC2_VI:
-					acm_ctrl |= AcmHw_ViqEn;
+					acm_ctrl |= ACMHW_VIQEN;
 					break;
 				case AC3_VO:
-					acm_ctrl |= AcmHw_VoqEn;
+					acm_ctrl |= ACMHW_VOQEN;
 					break;
 				default:
 					RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
@@ -331,13 +331,13 @@ void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 			} else {
 				switch (e_aci) {
 				case AC0_BE:
-					acm_ctrl &= (~AcmHw_BeqEn);
+					acm_ctrl &= (~ACMHW_BEQEN);
 					break;
 				case AC2_VI:
-					acm_ctrl &= (~AcmHw_ViqEn);
+					acm_ctrl &= (~ACMHW_VIQEN);
 					break;
 				case AC3_VO:
-					acm_ctrl &= (~AcmHw_VoqEn);
+					acm_ctrl &= (~ACMHW_VOQEN);
 					break;
 				default:
 					pr_err("switch case %#x not processed\n",
@@ -562,23 +562,23 @@ static bool _rtl92ce_llt_table_init(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	unsigned short i;
 	u8 txpktbuf_bndy;
-	u8 maxPage;
+	u8 maxpage;
 	bool status;
 
 #if LLT_CONFIG == 1
-	maxPage = 255;
+	maxpage = 255;
 	txpktbuf_bndy = 252;
 #elif LLT_CONFIG == 2
-	maxPage = 127;
+	maxpage = 127;
 	txpktbuf_bndy = 124;
 #elif LLT_CONFIG == 3
-	maxPage = 255;
+	maxpage = 255;
 	txpktbuf_bndy = 174;
 #elif LLT_CONFIG == 4
-	maxPage = 255;
+	maxpage = 255;
 	txpktbuf_bndy = 246;
 #elif LLT_CONFIG == 5
-	maxPage = 255;
+	maxpage = 255;
 	txpktbuf_bndy = 246;
 #endif
 
@@ -617,13 +617,13 @@ static bool _rtl92ce_llt_table_init(struct ieee80211_hw *hw)
 	if (true != status)
 		return status;
 
-	for (i = txpktbuf_bndy; i < maxPage; i++) {
+	for (i = txpktbuf_bndy; i < maxpage; i++) {
 		status = _rtl92ce_llt_write(hw, i, (i + 1));
 		if (true != status)
 			return status;
 	}
 
-	status = _rtl92ce_llt_write(hw, maxPage, txpktbuf_bndy);
+	status = _rtl92ce_llt_write(hw, maxpage, txpktbuf_bndy);
 	if (true != status)
 		return status;
 
@@ -876,7 +876,7 @@ void rtl92ce_enable_hw_security_config(struct ieee80211_hw *hw)
 	u8 sec_reg_value;
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
-		 "PairwiseEncAlgorithm = %d GroupEncAlgorithm = %d\n",
+		 "PairwiseENcAlgorithm = %d GroupEncAlgorithm = %d\n",
 		 rtlpriv->sec.pairwise_enc_algorithm,
 		 rtlpriv->sec.group_enc_algorithm);
 
@@ -886,11 +886,11 @@ void rtl92ce_enable_hw_security_config(struct ieee80211_hw *hw)
 		return;
 	}
 
-	sec_reg_value = SCR_TxEncEnable | SCR_RxDecEnable;
+	sec_reg_value = SCR_TXENCENABLE | SCR_RXDECENABLE;
 
 	if (rtlpriv->sec.use_defaultkey) {
-		sec_reg_value |= SCR_TxUseDK;
-		sec_reg_value |= SCR_RxUseDK;
+		sec_reg_value |= SCR_TXUSEDK;
+		sec_reg_value |= SCR_RXUSEDK;
 	}
 
 	sec_reg_value |= (SCR_RXBCUSEDK | SCR_TXBCUSEDK);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
index f9a86a5d74e0..aea4df9814ba 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
@@ -82,7 +82,7 @@ bool rtl92c_phy_bb_config(struct ieee80211_hw *hw)
 	rtl_write_byte(rtlpriv, REG_RF_CTRL, RF_EN | RF_RSTB | RF_SDMRSTB);
 	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN,
 		       FEN_PPLL | FEN_PCIEA | FEN_DIO_PCIE |
-		       FEN_BB_GLB_RSTn | FEN_BBRSTB);
+		       FEN_BB_GLB_RSTN | FEN_BBRSTB);
 	rtl_write_byte(rtlpriv, REG_AFE_XTAL_CTRL + 1, 0x80);
 	regvaldw = rtl_read_dword(rtlpriv, REG_LEDCFG0);
 	rtl_write_dword(rtlpriv, REG_LEDCFG0, regvaldw | BIT(23));
@@ -214,7 +214,7 @@ bool _rtl92ce_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
 		for (i = 0; i < phy_regarray_pg_len; i = i + 3) {
 			rtl_addr_delay(phy_regarray_table_pg[i]);
 
-			_rtl92c_store_pwrIndex_diffrate_offset(hw,
+			_rtl92c_store_pwrindex_diffrate_offset(hw,
 					       phy_regarray_table_pg[i],
 					       phy_regarray_table_pg[i + 1],
 					       phy_regarray_table_pg[i + 2]);
@@ -442,13 +442,13 @@ static bool _rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
 			if ((ppsc->rfpwr_state == ERFOFF) &&
 			    RT_IN_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC)) {
 				bool rtstatus;
-				u32 InitializeCount = 0;
+				u32 initializecount = 0;
 				do {
-					InitializeCount++;
+					initializecount++;
 					RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
 						 "IPS Set eRf nic enable\n");
 					rtstatus = rtl_ps_enable_nic(hw);
-				} while (!rtstatus && (InitializeCount < 10));
+				} while (!rtstatus && (initializecount < 10));
 				RT_CLEAR_PS_LEVEL(ppsc,
 						  RT_RF_OFF_LEVL_HALT_NIC);
 			} else {
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.h
index f86dcd7cfe1c..a7f6f30729da 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.h
@@ -22,9 +22,9 @@
 
 #define LOOP_LIMIT			5
 #define MAX_STALL_TIME			50
-#define AntennaDiversityValue		0x80
+#define ANTENNADIVERSITYVALUE		0x80
 #define MAX_TXPWR_IDX_NMODE_92S		63
-#define Reset_Cnt_Limit			3
+#define RESET_CNT_LIMIT			3
 
 #define IQK_ADDA_REG_NUM		16
 #define IQK_MAC_REG_NUM			4
@@ -100,7 +100,7 @@ void _rtl92c_phy_rf_serial_write(struct ieee80211_hw *hw,
 void _rtl92c_phy_fw_rf_serial_write(struct ieee80211_hw *hw,
 				    enum radio_path rfpath, u32 offset,
 				    u32 data);
-void _rtl92c_store_pwrIndex_diffrate_offset(struct ieee80211_hw *hw,
+void _rtl92c_store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 					    u32 regaddr, u32 bitmask, u32 data);
 bool _rtl92ce_phy_config_mac_with_headerfile(struct ieee80211_hw *hw);
 void _rtl92c_phy_init_bb_rf_register_definition(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/reg.h
index 4f003ff83630..2301b30c8caf 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/reg.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/reg.h
@@ -680,7 +680,7 @@
 #define PWC_EV12V				BIT(15)
 
 #define FEN_BBRSTB				BIT(0)
-#define FEN_BB_GLB_RSTn				BIT(1)
+#define FEN_BB_GLB_RSTN				BIT(1)
 #define FEN_USBA				BIT(2)
 #define FEN_UPLL				BIT(3)
 #define FEN_USBD				BIT(4)
@@ -700,7 +700,7 @@
 #define PFM_ALDN				BIT(1)
 #define PFM_LDKP				BIT(2)
 #define PFM_WOWL				BIT(3)
-#define EnPDN					BIT(4)
+#define ENPDN					BIT(4)
 #define PDN_PL					BIT(5)
 #define APFM_ONMAC				BIT(8)
 #define APFM_OFF				BIT(9)
@@ -815,19 +815,19 @@
 #define LDOE25_EN				BIT(31)
 
 #define RSM_EN					BIT(0)
-#define Timer_EN				BIT(4)
+#define TIMER_EN				BIT(4)
 
 #define TRSW0EN					BIT(2)
 #define TRSW1EN					BIT(3)
 #define EROM_EN					BIT(4)
-#define EnBT					BIT(5)
-#define EnUart					BIT(8)
-#define Uart_910				BIT(9)
-#define EnPMAC					BIT(10)
+#define ENBT					BIT(5)
+#define ENUART					BIT(8)
+#define UART_910				BIT(9)
+#define ENPMAC					BIT(10)
 #define SIC_SWRST				BIT(11)
-#define EnSIC					BIT(12)
+#define ENSIC					BIT(12)
 #define SIC_23					BIT(13)
-#define EnHDP					BIT(14)
+#define ENHDP					BIT(14)
 #define SIC_LBK					BIT(15)
 
 #define LED0PL					BIT(4)
@@ -836,7 +836,7 @@
 
 #define MCUFWDL_EN				BIT(0)
 #define MCUFWDL_RDY				BIT(1)
-#define FWDL_ChkSum_rpt				BIT(2)
+#define FWDL_CHKSUM_RPT				BIT(2)
 #define MACINI_RDY				BIT(3)
 #define BBINI_RDY				BIT(4)
 #define RFINI_RDY				BIT(5)
@@ -1054,13 +1054,13 @@
 #define	DIS_TSF_UDT0_NORMAL_CHIP		BIT(4)
 #define	DIS_TSF_UDT0_TEST_CHIP			BIT(5)
 
-#define	AcmHw_HwEn				BIT(0)
-#define	AcmHw_BeqEn				BIT(1)
-#define	AcmHw_ViqEn				BIT(2)
-#define	AcmHw_VoqEn				BIT(3)
-#define	AcmHw_BeqStatus				BIT(4)
-#define	AcmHw_ViqStatus				BIT(5)
-#define	AcmHw_VoqStatus				BIT(6)
+#define	ACMHW_HWEN				BIT(0)
+#define	ACMHW_BEQEN				BIT(1)
+#define	ACMHW_VIQEN				BIT(2)
+#define	ACMHW_VOQEN				BIT(3)
+#define	ACMHW_BEQSTATUS				BIT(4)
+#define	ACMHW_VIQSTATUS				BIT(5)
+#define	ACMHW_VOQSTATUS				BIT(6)
 
 #define APSDOFF					BIT(6)
 #define APSDOFF_STATUS				BIT(7)
@@ -1099,7 +1099,7 @@
 #define BM_DATA_EN				BIT(17)
 #define MFBEN					BIT(22)
 #define LSIGEN					BIT(23)
-#define EnMBID					BIT(24)
+#define ENMBID					BIT(24)
 #define APP_BASSN				BIT(27)
 #define APP_PHYSTS				BIT(28)
 #define APP_ICV					BIT(29)
@@ -1128,12 +1128,12 @@
 #define RXERR_RPT_RST				BIT(27)
 #define _RXERR_RPT_SEL(type)			((type) << 28)
 
-#define	SCR_TxUseDK				BIT(0)
-#define	SCR_RxUseDK				BIT(1)
-#define	SCR_TxEncEnable				BIT(2)
-#define	SCR_RxDecEnable				BIT(3)
-#define	SCR_SKByA2				BIT(4)
-#define	SCR_NoSKMC				BIT(5)
+#define	SCR_TXUSEDK				BIT(0)
+#define	SCR_RXUSEDK				BIT(1)
+#define	SCR_TXENCENABLE				BIT(2)
+#define	SCR_RXDECENABLE				BIT(3)
+#define	SCR_SKBYA2				BIT(4)
+#define	SCR_NOSKMC				BIT(5)
 #define SCR_TXBCUSEDK				BIT(6)
 #define SCR_RXBCUSEDK				BIT(7)
 
@@ -1186,7 +1186,7 @@
 #define	RPMAC_CCKPLCPHEADER			0x144
 #define	RPMAC_CCKCRC16				0x148
 #define	RPMAC_OFDMRXCRC32OK			0x170
-#define	RPMAC_OFDMRXCRC32Er			0x174
+#define	RPMAC_OFDMRXCRC32ER			0x174
 #define	RPMAC_OFDMRXPARITYER			0x178
 #define	RPMAC_OFDMRXCRC8ER			0x17c
 #define	RPMAC_CCKCRXRC16ER			0x180
@@ -1224,8 +1224,8 @@
 #define	RFPGA0_XAB_RFINTERFACESW		0x870
 #define	RFPGA0_XCD_RFINTERFACESW		0x874
 
-#define	rFPGA0_XAB_RFPARAMETER			0x878
-#define	rFPGA0_XCD_RFPARAMETER			0x87c
+#define	RFPGA0_XAB_RFPARAMETER			0x878
+#define	RFPGA0_XCD_RFPARAMETER			0x87c
 
 #define	RFPGA0_ANALOGPARAMETER1			0x880
 #define	RFPGA0_ANALOGPARAMETER2			0x884
@@ -1499,8 +1499,8 @@
 #define	BCCKTXCRC16				0xffff
 #define	BCCKTXSTATUS				0x1
 #define	BOFDMTXSTATUS				0x2
-#define IS_BB_REG_OFFSET_92S(_Offset)		\
-	((_Offset >= 0x800) && (_Offset <= 0xfff))
+#define IS_BB_REG_OFFSET_92S(_offset)		\
+	(((_offset) >= 0x800) && ((_offset) <= 0xfff))
 
 #define	BRFMOD					0x1
 #define	BJAPANMODE				0x2
@@ -1693,7 +1693,6 @@
 #define	BCCK_RF_EXTEND				0x20000000
 #define	BCCK_RXAGC_SATLEVEL			0x1f000000
 #define	BCCK_RXAGC_SATCOUNT			0xe0
-#define	bCCKRxRFSettle				0x1f
 #define	BCCK_FIXED_RXAGC			0x8000
 #define	BCCK_ANTENNA_POLARITY			0x2000
 #define	BCCK_TXFILTER_TYPE			0x0c00
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.c
index cf150e6f6d75..20768e9ef0be 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.c
@@ -128,18 +128,18 @@ static void rtl92c_phy_get_power_base(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
-	u32 powerBase0, powerBase1;
+	u32 powerbase0, powerbase1;
 	u8 legacy_pwrdiff, ht20_pwrdiff;
 	u8 i, powerlevel[2];
 
 	for (i = 0; i < 2; i++) {
 		powerlevel[i] = ppowerlevel[i];
 		legacy_pwrdiff = rtlefuse->txpwr_legacyhtdiff[i][channel - 1];
-		powerBase0 = powerlevel[i] + legacy_pwrdiff;
+		powerbase0 = powerlevel[i] + legacy_pwrdiff;
 
-		powerBase0 = (powerBase0 << 24) | (powerBase0 << 16) |
-		    (powerBase0 << 8) | powerBase0;
-		*(ofdmbase + i) = powerBase0;
+		powerbase0 = (powerbase0 << 24) | (powerbase0 << 16) |
+		    (powerbase0 << 8) | powerbase0;
+		*(ofdmbase + i) = powerbase0;
 		RTPRINT(rtlpriv, FPHY, PHY_TXPWR,
 			" [OFDM power base index rf(%c) = 0x%x]\n",
 			i == 0 ? 'A' : 'B', *(ofdmbase + i));
@@ -150,11 +150,11 @@ static void rtl92c_phy_get_power_base(struct ieee80211_hw *hw,
 			ht20_pwrdiff = rtlefuse->txpwr_ht20diff[i][channel - 1];
 			powerlevel[i] += ht20_pwrdiff;
 		}
-		powerBase1 = powerlevel[i];
-		powerBase1 = (powerBase1 << 24) |
-		    (powerBase1 << 16) | (powerBase1 << 8) | powerBase1;
+		powerbase1 = powerlevel[i];
+		powerbase1 = (powerbase1 << 24) |
+		    (powerbase1 << 16) | (powerbase1 << 8) | powerbase1;
 
-		*(mcsbase + i) = powerBase1;
+		*(mcsbase + i) = powerbase1;
 
 		RTPRINT(rtlpriv, FPHY, PHY_TXPWR,
 			" [MCS power base index rf(%c) = 0x%x]\n",
@@ -164,37 +164,37 @@ static void rtl92c_phy_get_power_base(struct ieee80211_hw *hw,
 
 static void _rtl92c_get_txpower_writeval_by_regulatory(struct ieee80211_hw *hw,
 						       u8 channel, u8 index,
-						       u32 *powerBase0,
-						       u32 *powerBase1,
+						       u32 *powerbase0,
+						       u32 *powerbase1,
 						       u32 *p_outwriteval)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	u8 i, chnlgroup = 0, pwr_diff_limit[4];
-	u32 writeVal, customer_limit, rf;
+	u32 writeval, customer_limit, rf;
 
 	for (rf = 0; rf < 2; rf++) {
 		switch (rtlefuse->eeprom_regulatory) {
 		case 0:
 			chnlgroup = 0;
 
-			writeVal = rtlphy->mcs_offset[chnlgroup][index +
+			writeval = rtlphy->mcs_offset[chnlgroup][index +
 			    (rf ? 8 : 0)]
-			    + ((index < 2) ? powerBase0[rf] : powerBase1[rf]);
+			    + ((index < 2) ? powerbase0[rf] : powerbase1[rf]);
 
 			RTPRINT(rtlpriv, FPHY, PHY_TXPWR,
-				"RTK better performance, writeVal(%c) = 0x%x\n",
-				rf == 0 ? 'A' : 'B', writeVal);
+				"RTK better performance, writeval(%c) = 0x%x\n",
+				rf == 0 ? 'A' : 'B', writeval);
 			break;
 		case 1:
 			if (rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20_40) {
-				writeVal = ((index < 2) ? powerBase0[rf] :
-					    powerBase1[rf]);
+				writeval = ((index < 2) ? powerbase0[rf] :
+					    powerbase1[rf]);
 
 				RTPRINT(rtlpriv, FPHY, PHY_TXPWR,
-					"Realtek regulatory, 40MHz, writeVal(%c) = 0x%x\n",
-					rf == 0 ? 'A' : 'B', writeVal);
+					"Realtek regulatory, 40MHz, writeval(%c) = 0x%x\n",
+					rf == 0 ? 'A' : 'B', writeval);
 			} else {
 				if (rtlphy->pwrgroup_cnt == 1)
 					chnlgroup = 0;
@@ -209,23 +209,23 @@ static void _rtl92c_get_txpower_writeval_by_regulatory(struct ieee80211_hw *hw,
 						chnlgroup++;
 				}
 
-				writeVal = rtlphy->mcs_offset[chnlgroup]
+				writeval = rtlphy->mcs_offset[chnlgroup]
 				    [index + (rf ? 8 : 0)] + ((index < 2) ?
-							      powerBase0[rf] :
-							      powerBase1[rf]);
+							      powerbase0[rf] :
+							      powerbase1[rf]);
 
 				RTPRINT(rtlpriv, FPHY, PHY_TXPWR,
-					"Realtek regulatory, 20MHz, writeVal(%c) = 0x%x\n",
-					rf == 0 ? 'A' : 'B', writeVal);
+					"Realtek regulatory, 20MHz, writeval(%c) = 0x%x\n",
+					rf == 0 ? 'A' : 'B', writeval);
 			}
 			break;
 		case 2:
-			writeVal =
-			    ((index < 2) ? powerBase0[rf] : powerBase1[rf]);
+			writeval =
+			    ((index < 2) ? powerbase0[rf] : powerbase1[rf]);
 
 			RTPRINT(rtlpriv, FPHY, PHY_TXPWR,
-				"Better regulatory, writeVal(%c) = 0x%x\n",
-				rf == 0 ? 'A' : 'B', writeVal);
+				"Better regulatory, writeval(%c) = 0x%x\n",
+				rf == 0 ? 'A' : 'B', writeval);
 			break;
 		case 3:
 			chnlgroup = 0;
@@ -275,36 +275,36 @@ static void _rtl92c_get_txpower_writeval_by_regulatory(struct ieee80211_hw *hw,
 				"Customer's limit rf(%c) = 0x%x\n",
 				rf == 0 ? 'A' : 'B', customer_limit);
 
-			writeVal = customer_limit +
-			    ((index < 2) ? powerBase0[rf] : powerBase1[rf]);
+			writeval = customer_limit +
+			    ((index < 2) ? powerbase0[rf] : powerbase1[rf]);
 
 			RTPRINT(rtlpriv, FPHY, PHY_TXPWR,
-				"Customer, writeVal rf(%c)= 0x%x\n",
-				rf == 0 ? 'A' : 'B', writeVal);
+				"Customer, writeval rf(%c)= 0x%x\n",
+				rf == 0 ? 'A' : 'B', writeval);
 			break;
 		default:
 			chnlgroup = 0;
-			writeVal = rtlphy->mcs_offset[chnlgroup]
+			writeval = rtlphy->mcs_offset[chnlgroup]
 			    [index + (rf ? 8 : 0)]
-			    + ((index < 2) ? powerBase0[rf] : powerBase1[rf]);
+			    + ((index < 2) ? powerbase0[rf] : powerbase1[rf]);
 
 			RTPRINT(rtlpriv, FPHY, PHY_TXPWR,
-				"RTK better performance, writeVal rf(%c) = 0x%x\n",
-				rf == 0 ? 'A' : 'B', writeVal);
+				"RTK better performance, writeval rf(%c) = 0x%x\n",
+				rf == 0 ? 'A' : 'B', writeval);
 			break;
 		}
 
 		if (rtlpriv->dm.dynamic_txhighpower_lvl == TXHIGHPWRLEVEL_BT1)
-			writeVal = writeVal - 0x06060606;
+			writeval = writeval - 0x06060606;
 		else if (rtlpriv->dm.dynamic_txhighpower_lvl ==
 			 TXHIGHPWRLEVEL_BT2)
-			writeVal = writeVal - 0x0c0c0c0c;
-		*(p_outwriteval + rf) = writeVal;
+			writeval = writeval - 0x0c0c0c0c;
+		*(p_outwriteval + rf) = writeval;
 	}
 }
 
 static void _rtl92c_write_ofdm_power_reg(struct ieee80211_hw *hw,
-					 u8 index, u32 *pValue)
+					 u8 index, u32 *value)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -320,29 +320,29 @@ static void _rtl92c_write_ofdm_power_reg(struct ieee80211_hw *hw,
 		RTXAGC_B_MCS11_MCS08, RTXAGC_B_MCS15_MCS12
 	};
 	u8 i, rf, pwr_val[4];
-	u32 writeVal;
+	u32 writeval;
 	u16 regoffset;
 
 	for (rf = 0; rf < 2; rf++) {
-		writeVal = pValue[rf];
+		writeval = value[rf];
 		for (i = 0; i < 4; i++) {
-			pwr_val[i] = (u8) ((writeVal & (0x7f <<
+			pwr_val[i] = (u8)((writeval & (0x7f <<
 							(i * 8))) >> (i * 8));
 
 			if (pwr_val[i] > RF6052_MAX_TX_PWR)
 				pwr_val[i] = RF6052_MAX_TX_PWR;
 		}
-		writeVal = (pwr_val[3] << 24) | (pwr_val[2] << 16) |
+		writeval = (pwr_val[3] << 24) | (pwr_val[2] << 16) |
 		    (pwr_val[1] << 8) | pwr_val[0];
 
 		if (rf == 0)
 			regoffset = regoffset_a[index];
 		else
 			regoffset = regoffset_b[index];
-		rtl_set_bbreg(hw, regoffset, MASKDWORD, writeVal);
+		rtl_set_bbreg(hw, regoffset, MASKDWORD, writeval);
 
 		RTPRINT(rtlpriv, FPHY, PHY_TXPWR,
-			"Set 0x%x = %08x\n", regoffset, writeVal);
+			"Set 0x%x = %08x\n", regoffset, writeval);
 
 		if (((get_rf_type(rtlphy) == RF_2T2R) &&
 		     (regoffset == RTXAGC_A_MCS15_MCS12 ||
@@ -351,7 +351,7 @@ static void _rtl92c_write_ofdm_power_reg(struct ieee80211_hw *hw,
 		     (regoffset == RTXAGC_A_MCS07_MCS04 ||
 		      regoffset == RTXAGC_B_MCS07_MCS04))) {
 
-			writeVal = pwr_val[3];
+			writeval = pwr_val[3];
 			if (regoffset == RTXAGC_A_MCS15_MCS12 ||
 			    regoffset == RTXAGC_A_MCS07_MCS04)
 				regoffset = 0xc90;
@@ -360,9 +360,9 @@ static void _rtl92c_write_ofdm_power_reg(struct ieee80211_hw *hw,
 				regoffset = 0xc98;
 
 			for (i = 0; i < 3; i++) {
-				writeVal = (writeVal > 6) ? (writeVal - 6) : 0;
+				writeval = (writeval > 6) ? (writeval - 6) : 0;
 				rtl_write_byte(rtlpriv, (u32) (regoffset + i),
-					       (u8) writeVal);
+					       (u8)writeval);
 			}
 		}
 	}
@@ -371,20 +371,20 @@ static void _rtl92c_write_ofdm_power_reg(struct ieee80211_hw *hw,
 void rtl92ce_phy_rf6052_set_ofdm_txpower(struct ieee80211_hw *hw,
 					u8 *ppowerlevel, u8 channel)
 {
-	u32 writeVal[2], powerBase0[2], powerBase1[2];
+	u32 writeval[2], powerbase0[2], powerbase1[2];
 	u8 index;
 
 	rtl92c_phy_get_power_base(hw, ppowerlevel,
-				  channel, &powerBase0[0], &powerBase1[0]);
+				  channel, &powerbase0[0], &powerbase1[0]);
 
 	for (index = 0; index < 6; index++) {
 		_rtl92c_get_txpower_writeval_by_regulatory(hw,
 							   channel, index,
-							   &powerBase0[0],
-							   &powerBase1[0],
-							   &writeVal[0]);
+							   &powerbase0[0],
+							   &powerbase1[0],
+							   &writeval[0]);
 
-		_rtl92c_write_ofdm_power_reg(hw, index, &writeVal[0]);
+		_rtl92c_write_ofdm_power_reg(hw, index, &writeval[0]);
 	}
 }
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
index 7557d23f56e2..58599d1f6bb8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
@@ -31,9 +31,9 @@ static void _rtl92cu_phy_param_tab_init(struct ieee80211_hw *hw)
 	rtlphy->hwparam_tables[MAC_REG].pdata = RTL8192CUMAC_2T_ARRAY;
 	if (IS_HIGHT_PA(rtlefuse->board_type)) {
 		rtlphy->hwparam_tables[PHY_REG_PG].length =
-			RTL8192CUPHY_REG_Array_PG_HPLength;
+			RTL8192CUPHY_REG_ARRAY_PG_HPLENGTH;
 		rtlphy->hwparam_tables[PHY_REG_PG].pdata =
-			RTL8192CUPHY_REG_Array_PG_HP;
+			RTL8192CUPHY_REG_ARRAY_PG_HP;
 	} else {
 		rtlphy->hwparam_tables[PHY_REG_PG].length =
 			RTL8192CUPHY_REG_ARRAY_PGLENGTH;
@@ -60,21 +60,21 @@ static void _rtl92cu_phy_param_tab_init(struct ieee80211_hw *hw)
 	/* 1T */
 	if (IS_HIGHT_PA(rtlefuse->board_type)) {
 		rtlphy->hwparam_tables[PHY_REG_1T].length =
-			RTL8192CUPHY_REG_1T_HPArrayLength;
+			RTL8192CUPHY_REG_1T_HPARRAYLENGTH;
 		rtlphy->hwparam_tables[PHY_REG_1T].pdata =
-			RTL8192CUPHY_REG_1T_HPArray;
+			RTL8192CUPHY_REG_1T_HPARRAY;
 		rtlphy->hwparam_tables[RADIOA_1T].length =
-			RTL8192CURadioA_1T_HPArrayLength;
+			RTL8192CURADIOA_1T_HPARRAYLENGTH;
 		rtlphy->hwparam_tables[RADIOA_1T].pdata =
-			RTL8192CURadioA_1T_HPArray;
+			RTL8192CURADIOA_1T_HPARRAY;
 		rtlphy->hwparam_tables[RADIOB_1T].length =
 			RTL8192CURADIOB_1TARRAYLENGTH;
 		rtlphy->hwparam_tables[RADIOB_1T].pdata =
 			RTL8192CU_RADIOB_1TARRAY;
 		rtlphy->hwparam_tables[AGCTAB_1T].length =
-			RTL8192CUAGCTAB_1T_HPArrayLength;
+			RTL8192CUAGCTAB_1T_HPARRAYLENGTH;
 		rtlphy->hwparam_tables[AGCTAB_1T].pdata =
-			Rtl8192CUAGCTAB_1T_HPArray;
+			RTL8192CUAGCTAB_1T_HPARRAY;
 	} else {
 		rtlphy->hwparam_tables[PHY_REG_1T].length =
 			 RTL8192CUPHY_REG_1TARRAY_LENGTH;
@@ -301,16 +301,16 @@ static void _rtl92cu_read_board_type(struct ieee80211_hw *hw, u8 *contents)
 {
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	u8 boardType;
+	u8 boardtype;
 
 	if (IS_NORMAL_CHIP(rtlhal->version)) {
-		boardType = ((contents[EEPROM_RF_OPT1]) &
+		boardtype = ((contents[EEPROM_RF_OPT1]) &
 			    BOARD_TYPE_NORMAL_MASK) >> 5; /*bit[7:5]*/
 	} else {
-		boardType = contents[EEPROM_RF_OPT4];
-		boardType &= BOARD_TYPE_TEST_MASK;
+		boardtype = contents[EEPROM_RF_OPT4];
+		boardtype &= BOARD_TYPE_TEST_MASK;
 	}
-	rtlefuse->board_type = boardType;
+	rtlefuse->board_type = boardtype;
 	if (IS_HIGHT_PA(rtlefuse->board_type))
 		rtlefuse->external_pa = 1;
 	pr_info("Board Type %x\n", rtlefuse->board_type);
@@ -420,7 +420,7 @@ static int _rtl92cu_init_power_on(struct ieee80211_hw *hw)
 	u16		value16;
 	u8		value8;
 	/*  polling autoload done. */
-	u32	pollingCount = 0;
+	u32	pollingcount = 0;
 
 	do {
 		if (rtl_read_byte(rtlpriv, REG_APS_FSMCO) & PFM_ALDN) {
@@ -428,7 +428,7 @@ static int _rtl92cu_init_power_on(struct ieee80211_hw *hw)
 				 "Autoload Done!\n");
 			break;
 		}
-		if (pollingCount++ > 100) {
+		if (pollingcount++ > 100) {
 			pr_err("Failed to polling REG_APS_FSMCO[PFM_ALDN] done!\n");
 			return -ENODEV;
 		}
@@ -452,7 +452,7 @@ static int _rtl92cu_init_power_on(struct ieee80211_hw *hw)
 		rtl_write_byte(rtlpriv, REG_SYS_ISO_CTRL, value8);
 	}
 	/*  auto enable WLAN */
-	pollingCount = 0;
+	pollingcount = 0;
 	value16 = rtl_read_word(rtlpriv, REG_APS_FSMCO);
 	value16 |= APFM_ONMAC;
 	rtl_write_word(rtlpriv, REG_APS_FSMCO, value16);
@@ -461,7 +461,7 @@ static int _rtl92cu_init_power_on(struct ieee80211_hw *hw)
 			pr_info("MAC auto ON okay!\n");
 			break;
 		}
-		if (pollingCount++ > 1000) {
+		if (pollingcount++ > 1000) {
 			pr_err("Failed to polling REG_APS_FSMCO[APFM_ONMAC] done!\n");
 			return -ENODEV;
 		}
@@ -473,12 +473,12 @@ static int _rtl92cu_init_power_on(struct ieee80211_hw *hw)
 	value16 &= ~ISO_DIOR;
 	rtl_write_word(rtlpriv, REG_SYS_ISO_CTRL, value16);
 	/* Reconsider when to do this operation after asking HWSD. */
-	pollingCount = 0;
+	pollingcount = 0;
 	rtl_write_byte(rtlpriv, REG_APSD_CTRL, (rtl_read_byte(rtlpriv,
 						REG_APSD_CTRL) & ~BIT(6)));
 	do {
-		pollingCount++;
-	} while ((pollingCount < 200) &&
+		pollingcount++;
+	} while ((pollingcount < 200) &&
 		 (rtl_read_byte(rtlpriv, REG_APSD_CTRL) & BIT(7)));
 	/* Enable MAC DMA/WMAC/SCHEDULE/SEC block */
 	value16 = rtl_read_word(rtlpriv,  REG_CR);
@@ -495,60 +495,60 @@ static void _rtl92cu_init_queue_reserved_page(struct ieee80211_hw *hw,
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	bool isChipN = IS_NORMAL_CHIP(rtlhal->version);
-	u32 outEPNum = (u32)out_ep_num;
-	u32 numHQ = 0;
-	u32 numLQ = 0;
-	u32 numNQ = 0;
-	u32 numPubQ;
+	bool ischipn = IS_NORMAL_CHIP(rtlhal->version);
+	u32 outepnum = (u32)out_ep_num;
+	u32 numhq = 0;
+	u32 numlq = 0;
+	u32 numnq = 0;
+	u32 numpubq;
 	u32 value32;
 	u8 value8;
-	u32 txQPageNum, txQPageUnit, txQRemainPage;
+	u32 txqpagenum, txqpageunit, txqremaininpage;
 
 	if (!wmm_enable) {
-		numPubQ = (isChipN) ? CHIP_B_PAGE_NUM_PUBQ :
+		numpubq = (ischipn) ? CHIP_B_PAGE_NUM_PUBQ :
 			  CHIP_A_PAGE_NUM_PUBQ;
-		txQPageNum = TX_TOTAL_PAGE_NUMBER - numPubQ;
+		txqpagenum = TX_TOTAL_PAGE_NUMBER - numpubq;
 
-		txQPageUnit = txQPageNum/outEPNum;
-		txQRemainPage = txQPageNum % outEPNum;
+		txqpageunit = txqpagenum / outepnum;
+		txqremaininpage = txqpagenum % outepnum;
 		if (queue_sel & TX_SELE_HQ)
-			numHQ = txQPageUnit;
+			numhq = txqpageunit;
 		if (queue_sel & TX_SELE_LQ)
-			numLQ = txQPageUnit;
+			numlq = txqpageunit;
 		/* HIGH priority queue always present in the configuration of
 		 * 2 out-ep. Remainder pages have assigned to High queue */
-		if ((outEPNum > 1) && (txQRemainPage))
-			numHQ += txQRemainPage;
+		if (outepnum > 1 && txqremaininpage)
+			numhq += txqremaininpage;
 		/* NOTE: This step done before writting REG_RQPN. */
-		if (isChipN) {
+		if (ischipn) {
 			if (queue_sel & TX_SELE_NQ)
-				numNQ = txQPageUnit;
-			value8 = (u8)_NPQ(numNQ);
+				numnq = txqpageunit;
+			value8 = (u8)_NPQ(numnq);
 			rtl_write_byte(rtlpriv,  REG_RQPN_NPQ, value8);
 		}
 	} else {
 		/* for WMM ,number of out-ep must more than or equal to 2! */
-		numPubQ = isChipN ? WMM_CHIP_B_PAGE_NUM_PUBQ :
+		numpubq = ischipn ? WMM_CHIP_B_PAGE_NUM_PUBQ :
 			  WMM_CHIP_A_PAGE_NUM_PUBQ;
 		if (queue_sel & TX_SELE_HQ) {
-			numHQ = isChipN ? WMM_CHIP_B_PAGE_NUM_HPQ :
+			numhq = ischipn ? WMM_CHIP_B_PAGE_NUM_HPQ :
 				WMM_CHIP_A_PAGE_NUM_HPQ;
 		}
 		if (queue_sel & TX_SELE_LQ) {
-			numLQ = isChipN ? WMM_CHIP_B_PAGE_NUM_LPQ :
+			numlq = ischipn ? WMM_CHIP_B_PAGE_NUM_LPQ :
 				WMM_CHIP_A_PAGE_NUM_LPQ;
 		}
 		/* NOTE: This step done before writting REG_RQPN. */
-		if (isChipN) {
+		if (ischipn) {
 			if (queue_sel & TX_SELE_NQ)
-				numNQ = WMM_CHIP_B_PAGE_NUM_NPQ;
-			value8 = (u8)_NPQ(numNQ);
+				numnq = WMM_CHIP_B_PAGE_NUM_NPQ;
+			value8 = (u8)_NPQ(numnq);
 			rtl_write_byte(rtlpriv, REG_RQPN_NPQ, value8);
 		}
 	}
 	/* TX DMA */
-	value32 = _HPQ(numHQ) | _LPQ(numLQ) | _PUBQ(numPubQ) | LD_RQPN;
+	value32 = _HPQ(numhq) | _LPQ(numlq) | _PUBQ(numpubq) | LD_RQPN;
 	rtl_write_dword(rtlpriv, REG_RQPN, value32);
 }
 
@@ -575,20 +575,20 @@ static void _rtl92c_init_trx_buffer(struct ieee80211_hw *hw, bool wmm_enable)
 	rtl_write_byte(rtlpriv, REG_PBP, value8);
 }
 
-static void _rtl92c_init_chipN_reg_priority(struct ieee80211_hw *hw, u16 beQ,
-					    u16 bkQ, u16 viQ, u16 voQ,
-					    u16 mgtQ, u16 hiQ)
+static void _rtl92c_init_chipn_reg_priority(struct ieee80211_hw *hw, u16 beq,
+					    u16 bkq, u16 viq, u16 voq,
+					    u16 mgtq, u16 hiq)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u16 value16 = (rtl_read_word(rtlpriv, REG_TRXDMA_CTRL) & 0x7);
 
-	value16 |= _TXDMA_BEQ_MAP(beQ) | _TXDMA_BKQ_MAP(bkQ) |
-		   _TXDMA_VIQ_MAP(viQ) | _TXDMA_VOQ_MAP(voQ) |
-		   _TXDMA_MGQ_MAP(mgtQ) | _TXDMA_HIQ_MAP(hiQ);
+	value16 |= _TXDMA_BEQ_MAP(beq) | _TXDMA_BKQ_MAP(bkq) |
+		   _TXDMA_VIQ_MAP(viq) | _TXDMA_VOQ_MAP(voq) |
+		   _TXDMA_MGQ_MAP(mgtq) | _TXDMA_HIQ_MAP(hiq);
 	rtl_write_word(rtlpriv,  REG_TRXDMA_CTRL, value16);
 }
 
-static void _rtl92cu_init_chipN_one_out_ep_priority(struct ieee80211_hw *hw,
+static void _rtl92cu_init_chipn_one_out_ep_priority(struct ieee80211_hw *hw,
 						    bool wmm_enable,
 						    u8 queue_sel)
 {
@@ -608,96 +608,96 @@ static void _rtl92cu_init_chipN_one_out_ep_priority(struct ieee80211_hw *hw,
 		WARN_ON(1); /* Shall not reach here! */
 		break;
 	}
-	_rtl92c_init_chipN_reg_priority(hw, value, value, value, value,
+	_rtl92c_init_chipn_reg_priority(hw, value, value, value, value,
 					value, value);
 	pr_info("Tx queue select: 0x%02x\n", queue_sel);
 }
 
-static void _rtl92cu_init_chipN_two_out_ep_priority(struct ieee80211_hw *hw,
-								bool wmm_enable,
-								u8 queue_sel)
+static void _rtl92cu_init_chipn_two_out_ep_priority(struct ieee80211_hw *hw,
+						     bool wmm_enable,
+						     u8 queue_sel)
 {
-	u16 beQ, bkQ, viQ, voQ, mgtQ, hiQ;
-	u16 uninitialized_var(valueHi);
-	u16 uninitialized_var(valueLow);
+	u16 beq, bkq, viq, voq, mgtq, hiq;
+	u16 uninitialized_var(valuehi);
+	u16 uninitialized_var(valuelow);
 
 	switch (queue_sel) {
 	case (TX_SELE_HQ | TX_SELE_LQ):
-		valueHi = QUEUE_HIGH;
-		valueLow = QUEUE_LOW;
+		valuehi = QUEUE_HIGH;
+		valuelow = QUEUE_LOW;
 		break;
 	case (TX_SELE_NQ | TX_SELE_LQ):
-		valueHi = QUEUE_NORMAL;
-		valueLow = QUEUE_LOW;
+		valuehi = QUEUE_NORMAL;
+		valuelow = QUEUE_LOW;
 		break;
 	case (TX_SELE_HQ | TX_SELE_NQ):
-		valueHi = QUEUE_HIGH;
-		valueLow = QUEUE_NORMAL;
+		valuehi = QUEUE_HIGH;
+		valuelow = QUEUE_NORMAL;
 		break;
 	default:
 		WARN_ON(1);
 		break;
 	}
 	if (!wmm_enable) {
-		beQ = valueLow;
-		bkQ = valueLow;
-		viQ = valueHi;
-		voQ = valueHi;
-		mgtQ = valueHi;
-		hiQ = valueHi;
+		beq = valuelow;
+		bkq = valuelow;
+		viq = valuehi;
+		voq = valuehi;
+		mgtq = valuehi;
+		hiq = valuehi;
 	} else {/* for WMM ,CONFIG_OUT_EP_WIFI_MODE */
-		beQ = valueHi;
-		bkQ = valueLow;
-		viQ = valueLow;
-		voQ = valueHi;
-		mgtQ = valueHi;
-		hiQ = valueHi;
+		beq = valuehi;
+		bkq = valuelow;
+		viq = valuelow;
+		voq = valuehi;
+		mgtq = valuehi;
+		hiq = valuehi;
 	}
-	_rtl92c_init_chipN_reg_priority(hw, beQ, bkQ, viQ, voQ, mgtQ, hiQ);
+	_rtl92c_init_chipn_reg_priority(hw, beq, bkq, viq, voq, mgtq, hiq);
 	pr_info("Tx queue select: 0x%02x\n", queue_sel);
 }
 
-static void _rtl92cu_init_chipN_three_out_ep_priority(struct ieee80211_hw *hw,
+static void _rtl92cu_init_chipn_three_out_ep_priority(struct ieee80211_hw *hw,
 						      bool wmm_enable,
 						      u8 queue_sel)
 {
-	u16 beQ, bkQ, viQ, voQ, mgtQ, hiQ;
+	u16 beq, bkq, viq, voq, mgtq, hiq;
 
 	if (!wmm_enable) { /* typical setting */
-		beQ	= QUEUE_LOW;
-		bkQ	= QUEUE_LOW;
-		viQ	= QUEUE_NORMAL;
-		voQ	= QUEUE_HIGH;
-		mgtQ	= QUEUE_HIGH;
-		hiQ	= QUEUE_HIGH;
+		beq	= QUEUE_LOW;
+		bkq	= QUEUE_LOW;
+		viq	= QUEUE_NORMAL;
+		voq	= QUEUE_HIGH;
+		mgtq	= QUEUE_HIGH;
+		hiq	= QUEUE_HIGH;
 	} else { /* for WMM */
-		beQ	= QUEUE_LOW;
-		bkQ	= QUEUE_NORMAL;
-		viQ	= QUEUE_NORMAL;
-		voQ	= QUEUE_HIGH;
-		mgtQ	= QUEUE_HIGH;
-		hiQ	= QUEUE_HIGH;
+		beq	= QUEUE_LOW;
+		bkq	= QUEUE_NORMAL;
+		viq	= QUEUE_NORMAL;
+		voq	= QUEUE_HIGH;
+		mgtq	= QUEUE_HIGH;
+		hiq	= QUEUE_HIGH;
 	}
-	_rtl92c_init_chipN_reg_priority(hw, beQ, bkQ, viQ, voQ, mgtQ, hiQ);
+	_rtl92c_init_chipn_reg_priority(hw, beq, bkq, viq, voq, mgtq, hiq);
 	pr_info("Tx queue select :0x%02x..\n", queue_sel);
 }
 
-static void _rtl92cu_init_chipN_queue_priority(struct ieee80211_hw *hw,
+static void _rtl92cu_init_chipn_queue_priority(struct ieee80211_hw *hw,
 					       bool wmm_enable,
 					       u8 out_ep_num,
 					       u8 queue_sel)
 {
 	switch (out_ep_num) {
 	case 1:
-		_rtl92cu_init_chipN_one_out_ep_priority(hw, wmm_enable,
+		_rtl92cu_init_chipn_one_out_ep_priority(hw, wmm_enable,
 							queue_sel);
 		break;
 	case 2:
-		_rtl92cu_init_chipN_two_out_ep_priority(hw, wmm_enable,
+		_rtl92cu_init_chipn_two_out_ep_priority(hw, wmm_enable,
 							queue_sel);
 		break;
 	case 3:
-		_rtl92cu_init_chipN_three_out_ep_priority(hw, wmm_enable,
+		_rtl92cu_init_chipn_three_out_ep_priority(hw, wmm_enable,
 							  queue_sel);
 		break;
 	default:
@@ -706,7 +706,7 @@ static void _rtl92cu_init_chipN_queue_priority(struct ieee80211_hw *hw,
 	}
 }
 
-static void _rtl92cu_init_chipT_queue_priority(struct ieee80211_hw *hw,
+static void _rtl92cu_init_chipt_queue_priority(struct ieee80211_hw *hw,
 					       bool wmm_enable,
 					       u8 out_ep_num,
 					       u8 queue_sel)
@@ -748,10 +748,10 @@ static void _rtl92cu_init_queue_priority(struct ieee80211_hw *hw,
 {
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	if (IS_NORMAL_CHIP(rtlhal->version))
-		_rtl92cu_init_chipN_queue_priority(hw, wmm_enable, out_ep_num,
+		_rtl92cu_init_chipn_queue_priority(hw, wmm_enable, out_ep_num,
 						   queue_sel);
 	else
-		_rtl92cu_init_chipT_queue_priority(hw, wmm_enable, out_ep_num,
+		_rtl92cu_init_chipt_queue_priority(hw, wmm_enable, out_ep_num,
 						   queue_sel);
 }
 
@@ -867,10 +867,10 @@ void rtl92cu_enable_hw_security_config(struct ieee80211_hw *hw)
 			 "not open sw encryption\n");
 		return;
 	}
-	sec_reg_value = SCR_TxEncEnable | SCR_RxDecEnable;
+	sec_reg_value = SCR_TXENCENABLE | SCR_RXDECENABLE;
 	if (rtlpriv->sec.use_defaultkey) {
-		sec_reg_value |= SCR_TxUseDK;
-		sec_reg_value |= SCR_RxUseDK;
+		sec_reg_value |= SCR_TXUSEDK;
+		sec_reg_value |= SCR_RXUSEDK;
 	}
 	if (IS_NORMAL_CHIP(rtlhal->version))
 		sec_reg_value |= (SCR_RXBCUSEDK | SCR_TXBCUSEDK);
@@ -899,7 +899,7 @@ static void _rtl92cu_hw_configure(struct ieee80211_hw *hw)
 	rtl_write_byte(rtlpriv, REG_BCN_CTRL, (u8)rtlusb->reg_bcn_ctrl_val);
 }
 
-static void _InitPABias(struct ieee80211_hw *hw)
+static void _initpabias(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -995,14 +995,14 @@ int rtl92cu_hw_init(struct ieee80211_hw *hw)
 		rtl92c_phy_lc_calibrate(hw);
 	}
 	_rtl92cu_hw_configure(hw);
-	_InitPABias(hw);
+	_initpabias(hw);
 	rtl92c_dm_init(hw);
 exit:
 	local_irq_restore(flags);
 	return err;
 }
 
-static void _DisableRFAFEAndResetBB(struct ieee80211_hw *hw)
+static void disable_rfafeandresetbb(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 /**************************************
@@ -1012,20 +1012,20 @@ c.	APSD_CTRL 0x600[7:0] = 0x40
 d.	SYS_FUNC_EN 0x02[7:0] = 0x16	reset BB state machine
 e.	SYS_FUNC_EN 0x02[7:0] = 0x14	reset BB state machine
 ***************************************/
-	u8 eRFPath = 0, value8 = 0;
+	u8 erfpath = 0, value8 = 0;
 	rtl_write_byte(rtlpriv, REG_TXPAUSE, 0xFF);
-	rtl_set_rfreg(hw, (enum radio_path)eRFPath, 0x0, MASKBYTE0, 0x0);
+	rtl_set_rfreg(hw, (enum radio_path)erfpath, 0x0, MASKBYTE0, 0x0);
 
 	value8 |= APSDOFF;
 	rtl_write_byte(rtlpriv, REG_APSD_CTRL, value8); /*0x40*/
 	value8 = 0;
-	value8 |= (FEN_USBD | FEN_USBA | FEN_BB_GLB_RSTn);
+	value8 |= (FEN_USBD | FEN_USBA | FEN_BB_GLB_RSTN);
 	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN, value8);/*0x16*/
-	value8 &= (~FEN_BB_GLB_RSTn);
+	value8 &= (~FEN_BB_GLB_RSTN);
 	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN, value8); /*0x14*/
 }
 
-static void  _ResetDigitalProcedure1(struct ieee80211_hw *hw, bool bWithoutHWSM)
+static void  _resetdigitalprocedure1(struct ieee80211_hw *hw, bool withouthwsm)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -1076,7 +1076,7 @@ static void  _ResetDigitalProcedure1(struct ieee80211_hw *hw, bool bWithoutHWSM)
 		rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN + 1, 0x54);
 		rtl_write_byte(rtlpriv, REG_MCUFWDL, 0);
 	}
-	if (bWithoutHWSM) {
+	if (withouthwsm) {
 		/*****************************
 		  Without HW auto state machine
 		g.SYS_CLKR 0x08[15:0] = 0x30A3		disable MAC clock
@@ -1091,7 +1091,7 @@ static void  _ResetDigitalProcedure1(struct ieee80211_hw *hw, bool bWithoutHWSM)
 	}
 }
 
-static void _ResetDigitalProcedure2(struct ieee80211_hw *hw)
+static void _resetdigitalprocedure2(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 /*****************************
@@ -1103,7 +1103,7 @@ m. SYS_ISO_CTRL 0x01[7:0] = 0x83	isolated ELDR to PON
 	rtl_write_byte(rtlpriv, REG_SYS_ISO_CTRL+1, 0x82);
 }
 
-static void _DisableGPIO(struct ieee80211_hw *hw)
+static void _disablegpio(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 /***************************************
@@ -1133,13 +1133,13 @@ n. LEDCFG 0x4C[15:0] = 0x8080
 	rtl_write_word(rtlpriv, REG_LEDCFG0, 0x8080);
 }
 
-static void _DisableAnalog(struct ieee80211_hw *hw, bool bWithoutHWSM)
+static void disable_analog(struct ieee80211_hw *hw, bool withouthwsm)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u16 value16 = 0;
 	u8 value8 = 0;
 
-	if (bWithoutHWSM) {
+	if (withouthwsm) {
 		/*****************************
 		n. LDOA15_CTRL 0x20[7:0] = 0x04	 disable A15 power
 		o. LDOV12D_CTRL 0x21[7:0] = 0x54 disable digital core power
@@ -1162,30 +1162,30 @@ i. APS_FSMCO 0x04[15:0] = 0x4802	set USB suspend
 	rtl_write_byte(rtlpriv, REG_RSV_CTRL, 0x0E);
 }
 
-static void _CardDisableHWSM(struct ieee80211_hw *hw)
+static void carddisable_hwsm(struct ieee80211_hw *hw)
 {
 	/* ==== RF Off Sequence ==== */
-	_DisableRFAFEAndResetBB(hw);
+	disable_rfafeandresetbb(hw);
 	/* ==== Reset digital sequence   ====== */
-	_ResetDigitalProcedure1(hw, false);
+	_resetdigitalprocedure1(hw, false);
 	/*  ==== Pull GPIO PIN to balance level and LED control ====== */
-	_DisableGPIO(hw);
+	_disablegpio(hw);
 	/* ==== Disable analog sequence === */
-	_DisableAnalog(hw, false);
+	disable_analog(hw, false);
 }
 
-static void _CardDisableWithoutHWSM(struct ieee80211_hw *hw)
+static void carddisablewithout_hwsm(struct ieee80211_hw *hw)
 {
 	/*==== RF Off Sequence ==== */
-	_DisableRFAFEAndResetBB(hw);
+	disable_rfafeandresetbb(hw);
 	/*  ==== Reset digital sequence   ====== */
-	_ResetDigitalProcedure1(hw, true);
+	_resetdigitalprocedure1(hw, true);
 	/*  ==== Pull GPIO PIN to balance level and LED control ====== */
-	_DisableGPIO(hw);
+	_disablegpio(hw);
 	/*  ==== Reset digital sequence   ====== */
-	_ResetDigitalProcedure2(hw);
+	_resetdigitalprocedure2(hw);
 	/*  ==== Disable analog sequence === */
-	_DisableAnalog(hw, true);
+	disable_analog(hw, true);
 }
 
 static void _rtl92cu_set_bcn_ctrl_reg(struct ieee80211_hw *hw,
@@ -1332,9 +1332,9 @@ void rtl92cu_card_disable(struct ieee80211_hw *hw)
 	rtlpriv->cfg->ops->led_control(hw, LED_CTL_POWER_OFF);
 	RT_SET_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
 	if (rtlusb->disablehwsm)
-		_CardDisableHWSM(hw);
+		carddisable_hwsm(hw);
 	else
-		_CardDisableWithoutHWSM(hw);
+		carddisablewithout_hwsm(hw);
 
 	/* after power off we should do iqk again */
 	rtlpriv->phy.iqk_initialized = false;
@@ -1476,12 +1476,12 @@ void rtl92cu_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		*((enum rf_pwrstate *)(val)) = ppsc->rfpwr_state;
 		break;
 	case HW_VAR_FWLPS_RF_ON:{
-			enum rf_pwrstate rfState;
+			enum rf_pwrstate rfstate;
 			u32 val_rcr;
 
 			rtlpriv->cfg->ops->get_hw_reg(hw, HW_VAR_RF_STATE,
-						      (u8 *)(&rfState));
-			if (rfState == ERFOFF) {
+						      (u8 *)(&rfstate));
+			if (rfstate == ERFOFF) {
 				*((bool *) (val)) = true;
 			} else {
 				val_rcr = rtl_read_dword(rtlpriv, REG_RCR);
@@ -1608,7 +1608,7 @@ void rtl92cu_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 								&e_aci);
 			} else {
 				u8 sifstime = 0;
-				u8	u1bAIFS;
+				u8	u1baifs;
 
 				if (IS_WIRELESS_MODE_A(wirelessmode) ||
 				    IS_WIRELESS_MODE_N_24G(wirelessmode) ||
@@ -1616,15 +1616,15 @@ void rtl92cu_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 					sifstime = 16;
 				else
 					sifstime = 10;
-				u1bAIFS = sifstime + (2 *  val[0]);
+				u1baifs = sifstime + (2 *  val[0]);
 				rtl_write_byte(rtlpriv, REG_EDCA_VO_PARAM,
-					       u1bAIFS);
+					       u1baifs);
 				rtl_write_byte(rtlpriv, REG_EDCA_VI_PARAM,
-					       u1bAIFS);
+					       u1baifs);
 				rtl_write_byte(rtlpriv, REG_EDCA_BE_PARAM,
-					       u1bAIFS);
+					       u1baifs);
 				rtl_write_byte(rtlpriv, REG_EDCA_BK_PARAM,
-					       u1bAIFS);
+					       u1baifs);
 			}
 			break;
 		}
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h
index 988af26ae598..6ff52dc28d1c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h
@@ -49,14 +49,14 @@
 /* should be renamed and moved to another file */
 enum _BOARD_TYPE_8192CUSB {
 	BOARD_USB_DONGLE		= 0,	/* USB dongle */
-	BOARD_USB_High_PA		= 1,	/* USB dongle - high power PA */
+	BOARD_USB_HIGH_PA		= 1,	/* USB dongle - high power PA */
 	BOARD_MINICARD			= 2,	/* Minicard */
 	BOARD_USB_SOLO			= 3,	/* USB solo-Slim module */
 	BOARD_USB_COMBO			= 4,	/* USB Combo-Slim module */
 };
 
 #define IS_HIGHT_PA(boardtype)		\
-	((boardtype == BOARD_USB_High_PA) ? true : false)
+	((boardtype == BOARD_USB_HIGH_PA) ? true : false)
 
 #define RTL92C_DRIVER_INFO_SIZE				4
 void rtl92cu_read_eeprom_info(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.c
index 065f3c9267b7..436ba2baaa92 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.c
@@ -14,7 +14,7 @@ static void _rtl92cu_init_led(struct ieee80211_hw *hw,
 	pled->ledon = false;
 }
 
-static void _rtl92cu_deInit_led(struct rtl_led *pled)
+static void rtl92cu_deinit_led(struct rtl_led *pled)
 {
 }
 
@@ -88,8 +88,8 @@ void rtl92cu_deinit_sw_leds(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
-	_rtl92cu_deInit_led(&rtlpriv->ledctl.sw_led0);
-	_rtl92cu_deInit_led(&rtlpriv->ledctl.sw_led1);
+	rtl92cu_deinit_led(&rtlpriv->ledctl.sw_led0);
+	rtl92cu_deinit_led(&rtlpriv->ledctl.sw_led1);
 }
 
 static void _rtl92cu_sw_led_control(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
index 87a0a200f846..09d0cd510cb8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
@@ -103,7 +103,7 @@ bool rtl92cu_phy_bb_config(struct ieee80211_hw *hw)
 	rtl_write_byte(rtlpriv, REG_AFE_PLL_CTRL + 1, 0xdb);
 	rtl_write_byte(rtlpriv, REG_RF_CTRL, RF_EN | RF_RSTB | RF_SDMRSTB);
 	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN, FEN_USBA | FEN_USBD |
-		       FEN_BB_GLB_RSTn | FEN_BBRSTB);
+		       FEN_BB_GLB_RSTN | FEN_BBRSTB);
 	regval32 = rtl_read_dword(rtlpriv, 0x87c);
 	rtl_write_dword(rtlpriv, 0x87c, regval32 & (~BIT(31)));
 	rtl_write_byte(rtlpriv, REG_LDOHCI12_CTRL, 0x0f);
@@ -121,7 +121,7 @@ bool _rtl92cu_phy_config_mac_with_headerfile(struct ieee80211_hw *hw)
 	u32 arraylength;
 	u32 *ptrarray;
 
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, "Read Rtl819XMACPHY_Array\n");
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, "Read Rtl819XMACPHY_ARRAY\n");
 	arraylength =  rtlphy->hwparam_tables[MAC_REG].length ;
 	ptrarray = rtlphy->hwparam_tables[MAC_REG].pdata;
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, "Img:RTL8192CUMAC_2T_ARRAY\n");
@@ -159,7 +159,7 @@ bool _rtl92cu_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
 				      phy_regarray_table[i + 1]);
 			udelay(1);
 			RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-				 "The phy_regarray_table[0] is %x Rtl819XPHY_REGArray[1] is %x\n",
+				 "The phy_regarray_table[0] is %x Rtl819XPHY_REGARRAY[1] is %x\n",
 				 phy_regarray_table[i],
 				 phy_regarray_table[i + 1]);
 		}
@@ -169,7 +169,7 @@ bool _rtl92cu_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
 				      agctab_array_table[i + 1]);
 			udelay(1);
 			RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-				 "The agctab_array_table[0] is %x Rtl819XPHY_REGArray[1] is %x\n",
+				 "The agctab_array_table[0] is %x Rtl819XPHY_REGARRAY[1] is %x\n",
 				 agctab_array_table[i],
 				 agctab_array_table[i + 1]);
 		}
@@ -192,7 +192,7 @@ bool _rtl92cu_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
 	if (configtype == BASEBAND_CONFIG_PHY_REG) {
 		for (i = 0; i < phy_regarray_pg_len; i = i + 3) {
 			rtl_addr_delay(phy_regarray_table_pg[i]);
-			_rtl92c_store_pwrIndex_diffrate_offset(hw,
+			_rtl92c_store_pwrindex_diffrate_offset(hw,
 						  phy_regarray_table_pg[i],
 						  phy_regarray_table_pg[i + 1],
 						  phy_regarray_table_pg[i + 2]);
@@ -386,14 +386,14 @@ static bool _rtl92cu_phy_set_rf_power_state(struct ieee80211_hw *hw,
 		if ((ppsc->rfpwr_state == ERFOFF) &&
 		    RT_IN_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC)) {
 			bool rtstatus;
-			u32 InitializeCount = 0;
+			u32 init_count = 0;
 
 			do {
-				InitializeCount++;
+				init_count++;
 				RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
 					 "IPS Set eRf nic enable\n");
 				rtstatus = rtl_ps_enable_nic(hw);
-			} while (!rtstatus && (InitializeCount < 10));
+			} while (!rtstatus && (init_count < 10));
 			RT_CLEAR_PS_LEVEL(ppsc,
 					  RT_RF_OFF_LEVL_HALT_NIC);
 		} else {
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
index 09fb3ced68b3..aa902fe54ffa 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
@@ -126,17 +126,17 @@ static void rtl92c_phy_get_power_base(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
-	u32 powerBase0, powerBase1;
+	u32 powerbase0, powerbase1;
 	u8 legacy_pwrdiff = 0, ht20_pwrdiff = 0;
 	u8 i, powerlevel[2];
 
 	for (i = 0; i < 2; i++) {
 		powerlevel[i] = ppowerlevel[i];
 		legacy_pwrdiff = rtlefuse->txpwr_legacyhtdiff[i][channel - 1];
-		powerBase0 = powerlevel[i] + legacy_pwrdiff;
-		powerBase0 = (powerBase0 << 24) | (powerBase0 << 16) |
-		    (powerBase0 << 8) | powerBase0;
-		*(ofdmbase + i) = powerBase0;
+		powerbase0 = powerlevel[i] + legacy_pwrdiff;
+		powerbase0 = (powerbase0 << 24) | (powerbase0 << 16) |
+		    (powerbase0 << 8) | powerbase0;
+		*(ofdmbase + i) = powerbase0;
 		RTPRINT(rtlpriv, FPHY, PHY_TXPWR,
 			" [OFDM power base index rf(%c) = 0x%x]\n",
 			i == 0 ? 'A' : 'B', *(ofdmbase + i));
@@ -146,10 +146,10 @@ static void rtl92c_phy_get_power_base(struct ieee80211_hw *hw,
 			ht20_pwrdiff = rtlefuse->txpwr_ht20diff[i][channel - 1];
 			powerlevel[i] += ht20_pwrdiff;
 		}
-		powerBase1 = powerlevel[i];
-		powerBase1 = (powerBase1 << 24) |
-		    (powerBase1 << 16) | (powerBase1 << 8) | powerBase1;
-		*(mcsbase + i) = powerBase1;
+		powerbase1 = powerlevel[i];
+		powerbase1 = (powerbase1 << 24) |
+		    (powerbase1 << 16) | (powerbase1 << 8) | powerbase1;
+		*(mcsbase + i) = powerbase1;
 		RTPRINT(rtlpriv, FPHY, PHY_TXPWR,
 			" [MCS power base index rf(%c) = 0x%x]\n",
 			i == 0 ? 'A' : 'B', *(mcsbase + i));
@@ -158,26 +158,26 @@ static void rtl92c_phy_get_power_base(struct ieee80211_hw *hw,
 
 static void _rtl92c_get_txpower_writeval_by_regulatory(struct ieee80211_hw *hw,
 						       u8 channel, u8 index,
-						       u32 *powerBase0,
-						       u32 *powerBase1,
+						       u32 *powerbase0,
+						       u32 *powerbase1,
 						       u32 *p_outwriteval)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	u8 i, chnlgroup = 0, pwr_diff_limit[4];
-	u32 writeVal, customer_limit, rf;
+	u32 writeval, customer_limit, rf;
 
 	for (rf = 0; rf < 2; rf++) {
 		switch (rtlefuse->eeprom_regulatory) {
 		case 0:
 			chnlgroup = 0;
-			writeVal = rtlphy->mcs_offset
+			writeval = rtlphy->mcs_offset
 			    [chnlgroup][index + (rf ? 8 : 0)]
-			    + ((index < 2) ? powerBase0[rf] : powerBase1[rf]);
+			    + ((index < 2) ? powerbase0[rf] : powerbase1[rf]);
 			RTPRINT(rtlpriv, FPHY, PHY_TXPWR,
-				"RTK better performance,writeVal(%c) = 0x%x\n",
-				rf == 0 ? 'A' : 'B', writeVal);
+				"RTK better performance,writeval(%c) = 0x%x\n",
+				rf == 0 ? 'A' : 'B', writeval);
 			break;
 		case 1:
 			if (rtlphy->pwrgroup_cnt == 1)
@@ -195,20 +195,20 @@ static void _rtl92c_get_txpower_writeval_by_regulatory(struct ieee80211_hw *hw,
 				else
 					chnlgroup += 4;
 			}
-			writeVal = rtlphy->mcs_offset[chnlgroup][index +
+			writeval = rtlphy->mcs_offset[chnlgroup][index +
 					(rf ? 8 : 0)] +
-					((index < 2) ? powerBase0[rf] :
-					powerBase1[rf]);
+					((index < 2) ? powerbase0[rf] :
+					powerbase1[rf]);
 			RTPRINT(rtlpriv, FPHY, PHY_TXPWR,
-				"Realtek regulatory, 20MHz, writeVal(%c) = 0x%x\n",
-				rf == 0 ? 'A' : 'B', writeVal);
+				"Realtek regulatory, 20MHz, writeval(%c) = 0x%x\n",
+				rf == 0 ? 'A' : 'B', writeval);
 			break;
 		case 2:
-			writeVal = ((index < 2) ? powerBase0[rf] :
-				   powerBase1[rf]);
+			writeval = ((index < 2) ? powerbase0[rf] :
+				   powerbase1[rf]);
 			RTPRINT(rtlpriv, FPHY, PHY_TXPWR,
-				"Better regulatory,writeVal(%c) = 0x%x\n",
-				rf == 0 ? 'A' : 'B', writeVal);
+				"Better regulatory,writeval(%c) = 0x%x\n",
+				rf == 0 ? 'A' : 'B', writeval);
 			break;
 		case 3:
 			chnlgroup = 0;
@@ -253,36 +253,36 @@ static void _rtl92c_get_txpower_writeval_by_regulatory(struct ieee80211_hw *hw,
 			RTPRINT(rtlpriv, FPHY, PHY_TXPWR,
 				"Customer's limit rf(%c) = 0x%x\n",
 				rf == 0 ? 'A' : 'B', customer_limit);
-			writeVal = customer_limit + ((index < 2) ?
-				   powerBase0[rf] : powerBase1[rf]);
+			writeval = customer_limit + ((index < 2) ?
+				   powerbase0[rf] : powerbase1[rf]);
 			RTPRINT(rtlpriv, FPHY, PHY_TXPWR,
-				"Customer, writeVal rf(%c)= 0x%x\n",
-				rf == 0 ? 'A' : 'B', writeVal);
+				"Customer, writeval rf(%c)= 0x%x\n",
+				rf == 0 ? 'A' : 'B', writeval);
 			break;
 		default:
 			chnlgroup = 0;
-			writeVal = rtlphy->mcs_offset[chnlgroup]
+			writeval = rtlphy->mcs_offset[chnlgroup]
 				   [index + (rf ? 8 : 0)] + ((index < 2) ?
-				   powerBase0[rf] : powerBase1[rf]);
+				   powerbase0[rf] : powerbase1[rf]);
 			RTPRINT(rtlpriv, FPHY, PHY_TXPWR,
-				"RTK better performance, writeValrf(%c) = 0x%x\n",
-				rf == 0 ? 'A' : 'B', writeVal);
+				"RTK better performance, writevalrf(%c) = 0x%x\n",
+				rf == 0 ? 'A' : 'B', writeval);
 			break;
 		}
 		if (rtlpriv->dm.dynamic_txhighpower_lvl ==
 		    TXHIGHPWRLEVEL_LEVEL1)
-			writeVal = 0x14141414;
+			writeval = 0x14141414;
 		else if (rtlpriv->dm.dynamic_txhighpower_lvl ==
 			 TXHIGHPWRLEVEL_LEVEL2)
-			writeVal = 0x00000000;
+			writeval = 0x00000000;
 		if (rtlpriv->dm.dynamic_txhighpower_lvl == TXHIGHPWRLEVEL_BT1)
-			writeVal = writeVal - 0x06060606;
-		*(p_outwriteval + rf) = writeVal;
+			writeval = writeval - 0x06060606;
+		*(p_outwriteval + rf) = writeval;
 	}
 }
 
 static void _rtl92c_write_ofdm_power_reg(struct ieee80211_hw *hw,
-					 u8 index, u32 *pValue)
+					 u8 index, u32 *value)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -297,33 +297,33 @@ static void _rtl92c_write_ofdm_power_reg(struct ieee80211_hw *hw,
 		RTXAGC_B_MCS11_MCS08, RTXAGC_B_MCS15_MCS12
 	};
 	u8 i, rf, pwr_val[4];
-	u32 writeVal;
+	u32 writeval;
 	u16 regoffset;
 
 	for (rf = 0; rf < 2; rf++) {
-		writeVal = pValue[rf];
+		writeval = value[rf];
 		for (i = 0; i < 4; i++) {
-			pwr_val[i] = (u8)((writeVal & (0x7f << (i * 8))) >>
+			pwr_val[i] = (u8)((writeval & (0x7f << (i * 8))) >>
 					  (i * 8));
 			if (pwr_val[i] > RF6052_MAX_TX_PWR)
 				pwr_val[i] = RF6052_MAX_TX_PWR;
 		}
-		writeVal = (pwr_val[3] << 24) | (pwr_val[2] << 16) |
+		writeval = (pwr_val[3] << 24) | (pwr_val[2] << 16) |
 		    (pwr_val[1] << 8) | pwr_val[0];
 		if (rf == 0)
 			regoffset = regoffset_a[index];
 		else
 			regoffset = regoffset_b[index];
-		rtl_set_bbreg(hw, regoffset, MASKDWORD, writeVal);
+		rtl_set_bbreg(hw, regoffset, MASKDWORD, writeval);
 		RTPRINT(rtlpriv, FPHY, PHY_TXPWR,
-			"Set 0x%x = %08x\n", regoffset, writeVal);
+			"Set 0x%x = %08x\n", regoffset, writeval);
 		if (((get_rf_type(rtlphy) == RF_2T2R) &&
 		     (regoffset == RTXAGC_A_MCS15_MCS12 ||
 		      regoffset == RTXAGC_B_MCS15_MCS12)) ||
 		    ((get_rf_type(rtlphy) != RF_2T2R) &&
 		     (regoffset == RTXAGC_A_MCS07_MCS04 ||
 		      regoffset == RTXAGC_B_MCS07_MCS04))) {
-			writeVal = pwr_val[3];
+			writeval = pwr_val[3];
 			if (regoffset == RTXAGC_A_MCS15_MCS12 ||
 			    regoffset == RTXAGC_A_MCS07_MCS04)
 				regoffset = 0xc90;
@@ -332,13 +332,13 @@ static void _rtl92c_write_ofdm_power_reg(struct ieee80211_hw *hw,
 				regoffset = 0xc98;
 			for (i = 0; i < 3; i++) {
 				if (i != 2)
-					writeVal = (writeVal > 8) ?
-						   (writeVal - 8) : 0;
+					writeval = (writeval > 8) ?
+						   (writeval - 8) : 0;
 				else
-					writeVal = (writeVal > 6) ?
-						   (writeVal - 6) : 0;
+					writeval = (writeval > 6) ?
+						   (writeval - 6) : 0;
 				rtl_write_byte(rtlpriv, (u32)(regoffset + i),
-					      (u8)writeVal);
+					      (u8)writeval);
 			}
 		}
 	}
@@ -347,18 +347,18 @@ static void _rtl92c_write_ofdm_power_reg(struct ieee80211_hw *hw,
 void rtl92cu_phy_rf6052_set_ofdm_txpower(struct ieee80211_hw *hw,
 					 u8 *ppowerlevel, u8 channel)
 {
-	u32 writeVal[2], powerBase0[2], powerBase1[2];
+	u32 writeval[2], powerbase0[2], powerbase1[2];
 	u8 index = 0;
 
 	rtl92c_phy_get_power_base(hw, ppowerlevel,
-				  channel, &powerBase0[0], &powerBase1[0]);
+				  channel, &powerbase0[0], &powerbase1[0]);
 	for (index = 0; index < 6; index++) {
 		_rtl92c_get_txpower_writeval_by_regulatory(hw,
 							   channel, index,
-							   &powerBase0[0],
-							   &powerBase1[0],
-							   &writeVal[0]);
-		_rtl92c_write_ofdm_power_reg(hw, index, &writeVal[0]);
+							   &powerbase0[0],
+							   &powerbase1[0],
+							   &writeval[0]);
+		_rtl92c_write_ofdm_power_reg(hw, index, &writeval[0]);
 	}
 }
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.c
index 468a896d89b8..2a9164cf7d6a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.c
@@ -1247,7 +1247,7 @@ u32 RTL8192CUAGCTAB_1TARRAY[RTL8192CUAGCTAB_1TARRAYLENGTH] = {
 	0xc78, 0x621f001e,
 };
 
-u32 RTL8192CUPHY_REG_1T_HPArray[RTL8192CUPHY_REG_1T_HPArrayLength] = {
+u32 RTL8192CUPHY_REG_1T_HPARRAY[RTL8192CUPHY_REG_1T_HPARRAYLENGTH] = {
 	0x024, 0x0011800f,
 	0x028, 0x00ffdb83,
 	0x040, 0x000c0004,
@@ -1439,7 +1439,7 @@ u32 RTL8192CUPHY_REG_1T_HPArray[RTL8192CUPHY_REG_1T_HPArrayLength] = {
 	0xf00, 0x00000300,
 };
 
-u32 RTL8192CUPHY_REG_Array_PG_HP[RTL8192CUPHY_REG_Array_PG_HPLength] = {
+u32 RTL8192CUPHY_REG_ARRAY_PG_HP[RTL8192CUPHY_REG_ARRAY_PG_HPLENGTH] = {
 	0xe00, 0xffffffff, 0x06080808,
 	0xe04, 0xffffffff, 0x00040406,
 	0xe08, 0x0000ff00, 0x00000000,
@@ -1554,7 +1554,7 @@ u32 RTL8192CUPHY_REG_Array_PG_HP[RTL8192CUPHY_REG_Array_PG_HPLength] = {
 	0x868, 0xffffffff, 0x00000000,
 };
 
-u32 RTL8192CURadioA_1T_HPArray[RTL8192CURadioA_1T_HPArrayLength] = {
+u32 RTL8192CURADIOA_1T_HPARRAY[RTL8192CURADIOA_1T_HPARRAYLENGTH] = {
 	0x000, 0x00030159,
 	0x001, 0x00031284,
 	0x002, 0x00098000,
@@ -1698,7 +1698,7 @@ u32 RTL8192CURadioA_1T_HPArray[RTL8192CURadioA_1T_HPArrayLength] = {
 	0x000, 0x00030159,
 };
 
-u32 Rtl8192CUAGCTAB_1T_HPArray[RTL8192CUAGCTAB_1T_HPArrayLength] = {
+u32 RTL8192CUAGCTAB_1T_HPARRAY[RTL8192CUAGCTAB_1T_HPARRAYLENGTH] = {
 	0xc78, 0x7b000001,
 	0xc78, 0x7b010001,
 	0xc78, 0x7b020001,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.h
index 9a9805808541..9efe57ab7bc4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.h
@@ -31,15 +31,15 @@ extern u32 RTL8192CUAGCTAB_2TARRAY[RTL8192CUAGCTAB_2TARRAYLENGTH];
 #define RTL8192CUAGCTAB_1TARRAYLENGTH	320
 extern u32 RTL8192CUAGCTAB_1TARRAY[RTL8192CUAGCTAB_1TARRAYLENGTH];
 
-#define RTL8192CUPHY_REG_1T_HPArrayLength 378
-extern u32 RTL8192CUPHY_REG_1T_HPArray[RTL8192CUPHY_REG_1T_HPArrayLength];
+#define RTL8192CUPHY_REG_1T_HPARRAYLENGTH 378
+extern u32 RTL8192CUPHY_REG_1T_HPARRAY[RTL8192CUPHY_REG_1T_HPARRAYLENGTH];
 
-#define RTL8192CUPHY_REG_Array_PG_HPLength 336
-extern u32 RTL8192CUPHY_REG_Array_PG_HP[RTL8192CUPHY_REG_Array_PG_HPLength];
+#define RTL8192CUPHY_REG_ARRAY_PG_HPLENGTH 336
+extern u32 RTL8192CUPHY_REG_ARRAY_PG_HP[RTL8192CUPHY_REG_ARRAY_PG_HPLENGTH];
 
-#define RTL8192CURadioA_1T_HPArrayLength 282
-extern u32 RTL8192CURadioA_1T_HPArray[RTL8192CURadioA_1T_HPArrayLength];
-#define RTL8192CUAGCTAB_1T_HPArrayLength 320
-extern u32 Rtl8192CUAGCTAB_1T_HPArray[RTL8192CUAGCTAB_1T_HPArrayLength];
+#define RTL8192CURADIOA_1T_HPARRAYLENGTH 282
+extern u32 RTL8192CURADIOA_1T_HPARRAY[RTL8192CURADIOA_1T_HPARRAYLENGTH];
+#define RTL8192CUAGCTAB_1T_HPARRAYLENGTH 320
+extern u32 RTL8192CUAGCTAB_1T_HPARRAY[RTL8192CUAGCTAB_1T_HPARRAYLENGTH];
 
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
index be2330f3aec8..1e310a630db2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
@@ -14,7 +14,7 @@
 #include "trx.h"
 #include "../rtl8192c/fw_common.h"
 
-static int _ConfigVerTOutEP(struct ieee80211_hw *hw)
+static int configvertoutep(struct ieee80211_hw *hw)
 {
 	u8 ep_cfg, txqsele;
 	u8 ep_nums = 0;
@@ -47,7 +47,7 @@ static int _ConfigVerTOutEP(struct ieee80211_hw *hw)
 	return (rtlusb->out_ep_nums == ep_nums) ? 0 : -EINVAL;
 }
 
-static int _ConfigVerNOutEP(struct ieee80211_hw *hw)
+static int configvernoutep(struct ieee80211_hw *hw)
 {
 	u8 ep_cfg;
 	u8 ep_nums = 0;
@@ -76,7 +76,7 @@ static int _ConfigVerNOutEP(struct ieee80211_hw *hw)
 	return (rtlusb->out_ep_nums == ep_nums) ? 0 : -EINVAL;
 }
 
-static void _TwoOutEpMapping(struct ieee80211_hw *hw, bool bIsChipB,
+static void twooutepmapping(struct ieee80211_hw *hw, bool is_chip8,
 			     bool  bwificfg, struct rtl_ep_map *ep_map)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -104,7 +104,7 @@ static void _TwoOutEpMapping(struct ieee80211_hw *hw, bool bIsChipB,
 	}
 }
 
-static void _ThreeOutEpMapping(struct ieee80211_hw *hw, bool  bwificfg,
+static void threeoutepmapping(struct ieee80211_hw *hw, bool  bwificfg,
 			       struct rtl_ep_map *ep_map)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -131,7 +131,7 @@ static void _ThreeOutEpMapping(struct ieee80211_hw *hw, bool  bwificfg,
 	}
 }
 
-static void _OneOutEpMapping(struct ieee80211_hw *hw, struct rtl_ep_map *ep_map)
+static void oneoutepmapping(struct ieee80211_hw *hw, struct rtl_ep_map *ep_map)
 {
 	ep_map->ep_mapping[RTL_TXQ_BE]	= 2;
 	ep_map->ep_mapping[RTL_TXQ_BK]	= 2;
@@ -144,27 +144,27 @@ static void _OneOutEpMapping(struct ieee80211_hw *hw, struct rtl_ep_map *ep_map)
 static int _out_ep_mapping(struct ieee80211_hw *hw)
 {
 	int err = 0;
-	bool bIsChipN, bwificfg = false;
+	bool ischipn, bwificfg = false;
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_usb_priv *usb_priv = rtl_usbpriv(hw);
 	struct rtl_usb *rtlusb = rtl_usbdev(usb_priv);
 	struct rtl_ep_map *ep_map = &(rtlusb->ep_map);
 
-	bIsChipN = IS_NORMAL_CHIP(rtlhal->version);
+	ischipn = IS_NORMAL_CHIP(rtlhal->version);
 	switch (rtlusb->out_ep_nums) {
 	case 2:
-		_TwoOutEpMapping(hw, bIsChipN, bwificfg, ep_map);
+		twooutepmapping(hw, ischipn, bwificfg, ep_map);
 		break;
 	case 3:
 		/* Test chip doesn't support three out EPs. */
-		if (!bIsChipN) {
+		if (!ischipn) {
 			err  =  -EINVAL;
 			goto err_out;
 		}
-		_ThreeOutEpMapping(hw, bIsChipN, ep_map);
+		threeoutepmapping(hw, ischipn, ep_map);
 		break;
 	case 1:
-		_OneOutEpMapping(hw, ep_map);
+		oneoutepmapping(hw, ep_map);
 		break;
 	default:
 		err  =  -EINVAL;
@@ -180,9 +180,9 @@ int  rtl8192cu_endpoint_mapping(struct ieee80211_hw *hw)
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	int error = 0;
 	if (likely(IS_NORMAL_CHIP(rtlhal->version)))
-		error = _ConfigVerNOutEP(hw);
+		error = configvernoutep(hw);
 	else
-		error = _ConfigVerTOutEP(hw);
+		error = configvertoutep(hw);
 	if (error)
 		goto err_out;
 	error = _out_ep_mapping(hw);
@@ -588,28 +588,28 @@ void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
 	RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE, "==>\n");
 }
 
-void rtl92cu_fill_fake_txdesc(struct ieee80211_hw *hw, u8 * pDesc,
-			      u32 buffer_len, bool bIsPsPoll)
+void rtl92cu_fill_fake_txdesc(struct ieee80211_hw *hw, u8 *pdesc,
+			      u32 buffer_len, bool is_pspoll)
 {
 	/* Clear all status */
-	memset(pDesc, 0, RTL_TX_HEADER_SIZE);
-	SET_TX_DESC_FIRST_SEG(pDesc, 1); /* bFirstSeg; */
-	SET_TX_DESC_LAST_SEG(pDesc, 1); /* bLastSeg; */
-	SET_TX_DESC_OFFSET(pDesc, RTL_TX_HEADER_SIZE); /* Offset = 32 */
-	SET_TX_DESC_PKT_SIZE(pDesc, buffer_len); /* Buffer size + command hdr */
-	SET_TX_DESC_QUEUE_SEL(pDesc, QSLT_MGNT); /* Fixed queue of Mgnt queue */
+	memset(pdesc, 0, RTL_TX_HEADER_SIZE);
+	SET_TX_DESC_FIRST_SEG(pdesc, 1); /* bFirstSeg; */
+	SET_TX_DESC_LAST_SEG(pdesc, 1); /* bLastSeg; */
+	SET_TX_DESC_OFFSET(pdesc, RTL_TX_HEADER_SIZE); /* Offset = 32 */
+	SET_TX_DESC_PKT_SIZE(pdesc, buffer_len); /* Buffer size + command hdr */
+	SET_TX_DESC_QUEUE_SEL(pdesc, QSLT_MGNT); /* Fixed queue of Mgnt queue */
 	/* Set NAVUSEHDR to prevent Ps-poll AId filed to be changed to error
 	 * vlaue by Hw. */
-	if (bIsPsPoll) {
-		SET_TX_DESC_NAV_USE_HDR(pDesc, 1);
+	if (is_pspoll) {
+		SET_TX_DESC_NAV_USE_HDR(pdesc, 1);
 	} else {
-		SET_TX_DESC_HWSEQ_EN(pDesc, 1); /* Hw set sequence number */
-		SET_TX_DESC_PKT_ID(pDesc, 0x100); /* set bit3 to 1. */
+		SET_TX_DESC_HWSEQ_EN(pdesc, 1); /* Hw set sequence number */
+		SET_TX_DESC_PKT_ID(pdesc, 0x100); /* set bit3 to 1. */
 	}
-	SET_TX_DESC_USE_RATE(pDesc, 1); /* use data rate which is set by Sw */
-	SET_TX_DESC_OWN(pDesc, 1);
-	SET_TX_DESC_TX_RATE(pDesc, DESC_RATE1M);
-	_rtl_tx_desc_checksum(pDesc);
+	SET_TX_DESC_USE_RATE(pdesc, 1); /* use data rate which is set by Sw */
+	SET_TX_DESC_OWN(pdesc, 1);
+	SET_TX_DESC_TX_RATE(pdesc, DESC_RATE1M);
+	_rtl_tx_desc_checksum(pdesc);
 }
 
 void rtl92cu_tx_fill_cmddesc(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h
index 21038540a5b2..cc9b26830cc7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h
@@ -375,8 +375,8 @@ void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
 			  struct sk_buff *skb,
 			  u8 queue_index,
 			  struct rtl_tcb_desc *tcb_desc);
-void rtl92cu_fill_fake_txdesc(struct ieee80211_hw *hw, u8 * pDesc,
-			      u32 buffer_len, bool bIsPsPoll);
+void rtl92cu_fill_fake_txdesc(struct ieee80211_hw *hw, u8 *pdesc,
+			       u32 buffer_len, bool ispspoll);
 void rtl92cu_tx_fill_cmddesc(struct ieee80211_hw *hw,
 			     u8 *pdesc, bool b_firstseg,
 			     bool b_lastseg, struct sk_buff *skb);
-- 
2.20.1

