Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLACK,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51BF8C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 22:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B68821B18
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 22:37:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XYC4pgOi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503423AbfBNWhK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 17:37:10 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:41368 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729710AbfBNWg4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 17:36:56 -0500
Received: by mail-ot1-f68.google.com with SMTP id u16so13364610otk.8
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 14:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SyqZ0f4EN7iAlBP6jrwVKTuBcb0DG+iN+UoL1HFouH4=;
        b=XYC4pgOinUnhusosyEK2fFfP9JOdkFWt1EL2cpsssPXUg+imztPL2nNtU7WaYnZd/h
         WFXOFYDwgXmW35DxxZVUXBO5oxYJq2WMha5ognTG7Dn4vNXKU23lVB/hjdb6D+fqebAf
         GfJx3Z/5/fGF9r6A5JjfViCJNo4Xv/pR2LKvSEfh1tWN2DInB9Rk7XJsLFljkIDXa7a8
         lny+1YG3KYYs5Yf8xDjrCooJYkqRdaW1rdm2PO4EN8zrFsI2VQQpGlWDECkb0IgFIr3S
         YCiEUBVbARenYHBKya3pPp82HBDznQ86PXEzDsEL+N9DVggxEgDDrYJrpXHMI4oePvMO
         dy3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=SyqZ0f4EN7iAlBP6jrwVKTuBcb0DG+iN+UoL1HFouH4=;
        b=DlivkM/xZfaURQalnAQcAIMy4w4CpQC+oDDcSly3fldHxKSAbBI0pSJV7O/LWpZg1V
         zJhwFTU3hjeDCFYCViRdvFeG3XTqiMAhbJPbr3nWW0hrvkQC+/FbokWuql0V/Qvli3fr
         ibty3pqkj4k9ZrL+iBPw9tLEZy70R1SJfES3w6b6vqKpq5I8k9+dEShOL/2GMQkUtssP
         nyigS4eCN7tFjTQWAopuyIgshGr+F2NeXVqwn0vutjxXiyeQGcFm+vXPasHoqMvG3vcG
         G7oWINcnq5IYl3FkrpSTA5h9XSZ7zPNeUfzzvEmS0m1qo3TJy3aND6KO1j5OMXzWbXOL
         1J1A==
X-Gm-Message-State: AHQUAuYuWgVqRwJh0k8omALRrzLS20iW5A3iv8vB3MUgLINrrJzvTbgJ
        EQgW4bdA99P5JpJwsiMMnr8=
X-Google-Smtp-Source: AHgI3IYQgl2PM2x49Sd6bdeqWCO0Y1SpMFfT0axPXz/GDivOLutPpvkyVuMyi0hiZIRen1yfA/2Hag==
X-Received: by 2002:aca:54d5:: with SMTP id i204mr4026332oib.143.1550183815213;
        Thu, 14 Feb 2019 14:36:55 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id h1sm1463938otm.0.2019.02.14.14.36.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 14:36:54 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 6/8] rtlwifi: rtl8192se: Remove CamelCase variables
Date:   Thu, 14 Feb 2019 16:36:42 -0600
Message-Id: <20190214223644.8035-7-Larry.Finger@lwfinger.net>
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
 .../wireless/realtek/rtlwifi/rtl8192se/dm.h   |  2 +-
 .../wireless/realtek/rtlwifi/rtl8192se/fw.c   |  4 +-
 .../wireless/realtek/rtlwifi/rtl8192se/fw.h   |  6 +--
 .../wireless/realtek/rtlwifi/rtl8192se/hw.c   | 22 ++++-----
 .../wireless/realtek/rtlwifi/rtl8192se/phy.c  | 44 ++++++++---------
 .../wireless/realtek/rtlwifi/rtl8192se/reg.h  | 48 +++++++++----------
 6 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.h
index 11acc1d98527..cde793e6062e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.h
@@ -58,7 +58,7 @@ enum dm_ratr_sta {
 
 #define	DM_DIG_HIGH_PWR_THRESH_HIGH	75
 #define	DM_DIG_HIGH_PWR_THRESH_LOW	70
-#define	DM_DIG_MIN_Netcore		0x12
+#define	DM_DIG_MIN_NETCORE		0x12
 
 void rtl92s_dm_watchdog(struct ieee80211_hw *hw);
 void rtl92s_dm_init(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c
index a87a97cd0a62..43b94a1d09f2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c
@@ -547,14 +547,14 @@ static bool _rtl92s_firmware_set_h2c_cmd(struct ieee80211_hw *hw, u8 h2c_cmd,
 	return true;
 }
 
-void rtl92s_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 Mode)
+void rtl92s_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode)
 {
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct h2c_set_pwrmode_parm	pwrmode;
 	u16 max_wakeup_period = 0;
 
-	pwrmode.mode = Mode;
+	pwrmode.mode = mode;
 	pwrmode.flag_low_traffic_en = 0;
 	pwrmode.flag_lpnav_en = 0;
 	pwrmode.flag_rf_low_snr_en = 0;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.h
index 300f52560a8c..2f9a3aff2fc0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.h
@@ -276,7 +276,7 @@ enum fw_h2c_cmd {
 	H2C_JOINBSS_CMD,
 	H2C_DISCONNECT_CMD,				/*15*/
 	H2C_CREATEBSS_CMD,
-	H2C_SETOPMode_CMD,
+	H2C_SETOPMODE_CMD,
 	H2C_SITESURVEY_CMD,
 	H2C_SETAUTH_CMD,
 	H2C_SETKEY_CMD,					/*20*/
@@ -315,10 +315,10 @@ enum fw_h2c_cmd {
 
 /* The following macros are used for FW
  * CMD map and parameter updated. */
-#define FW_CMD_IO_CLR(rtlpriv, _Bit)				\
+#define FW_CMD_IO_CLR(rtlpriv, _bit)				\
 	do {							\
 		udelay(1000);					\
-		rtlpriv->rtlhal.fwcmd_iomap &= (~_Bit);		\
+		rtlpriv->rtlhal.fwcmd_iomap &= (~_bit);		\
 	} while (0)
 
 #define FW_CMD_IO_UPDATE(rtlpriv, _val)				\
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
index 6ff0a46b05f1..4d550c2add91 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
@@ -236,7 +236,7 @@ void rtl92se_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 			union aci_aifsn *p_aci_aifsn = (union aci_aifsn *)(&(
 							mac->ac[0].aifs));
 			u8 acm = p_aci_aifsn->f.acm;
-			u8 acm_ctrl = rtl_read_byte(rtlpriv, AcmHwCtrl);
+			u8 acm_ctrl = rtl_read_byte(rtlpriv, ACMHWCTRL);
 
 			acm_ctrl = acm_ctrl | ((rtlpci->acm_method == 2) ?
 				   0x0 : 0x1);
@@ -244,13 +244,13 @@ void rtl92se_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
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
@@ -261,13 +261,13 @@ void rtl92se_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
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
@@ -278,7 +278,7 @@ void rtl92se_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 
 			RT_TRACE(rtlpriv, COMP_QOS, DBG_TRACE,
 				 "HW_VAR_ACM_CTRL Write 0x%X\n", acm_ctrl);
-			rtl_write_byte(rtlpriv, AcmHwCtrl, acm_ctrl);
+			rtl_write_byte(rtlpriv, ACMHWCTRL, acm_ctrl);
 			break;
 		}
 	case HW_VAR_RCR:{
@@ -847,7 +847,7 @@ static void _rtl92se_macconfig_after_fwdownload(struct ieee80211_hw *hw)
 	/* 10. Power Save Control Register (Offset: 0x0260 - 0x02DF) */
 	/* 11. General Purpose Register (Offset: 0x02E0 - 0x02FF) */
 	/* 12. Host Interrupt Status Register (Offset: 0x0300 - 0x030F) */
-	/* 13. Test Mode and Debug Control Register (Offset: 0x0310 - 0x034F) */
+	/* 13. Test mode and Debug Control Register (Offset: 0x0310 - 0x034F) */
 
 	/* 14. Set driver info, we only accept PHY status now. */
 	rtl_write_byte(rtlpriv, RXDRVINFO_SZ, 4);
@@ -1619,7 +1619,7 @@ void rtl92se_update_interrupt_mask(struct ieee80211_hw *hw,
 	rtl92se_enable_interrupt(hw);
 }
 
-static void _rtl8192se_get_IC_Inferiority(struct ieee80211_hw *hw)
+static void _rtl8192se_get_ic_inferiority(struct ieee80211_hw *hw)
 {
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -1682,7 +1682,7 @@ static void _rtl92se_read_adapter_info(struct ieee80211_hw *hw)
 	if (rtlefuse->autoload_failflag)
 		return;
 
-	_rtl8192se_get_IC_Inferiority(hw);
+	_rtl8192se_get_ic_inferiority(hw);
 
 	/* Read IC Version && Channel Plan */
 	/* VID, DID	 SE	0xA-D */
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
index 232d0cf83991..5bc4ba1cd94c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
@@ -527,13 +527,13 @@ bool rtl92s_phy_set_rf_power_state(struct ieee80211_hw *hw,
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
@@ -913,7 +913,7 @@ static bool _rtl92s_phy_bb_config_parafile(struct ieee80211_hw *hw)
 
 	if (!rtstatus) {
 		pr_err("Write BB Reg Fail!!\n");
-		goto phy_BB8190_Config_ParaFile_Fail;
+		goto phy_bb8190_config_parafile_fail;
 	}
 
 	/* 2. If EEPROM or EFUSE autoload OK, We must config by
@@ -926,7 +926,7 @@ static bool _rtl92s_phy_bb_config_parafile(struct ieee80211_hw *hw)
 	}
 	if (!rtstatus) {
 		pr_err("_rtl92s_phy_bb_config_parafile(): BB_PG Reg Fail!!\n");
-		goto phy_BB8190_Config_ParaFile_Fail;
+		goto phy_bb8190_config_parafile_fail;
 	}
 
 	/* 3. BB AGC table Initialization */
@@ -934,7 +934,7 @@ static bool _rtl92s_phy_bb_config_parafile(struct ieee80211_hw *hw)
 
 	if (!rtstatus) {
 		pr_err("%s(): AGC Table Fail\n", __func__);
-		goto phy_BB8190_Config_ParaFile_Fail;
+		goto phy_bb8190_config_parafile_fail;
 	}
 
 	/* Check if the CCK HighPower is turned ON. */
@@ -942,7 +942,7 @@ static bool _rtl92s_phy_bb_config_parafile(struct ieee80211_hw *hw)
 	rtlphy->cck_high_power = (bool)(rtl92s_phy_query_bb_reg(hw,
 			RFPGA0_XA_HSSIPARAMETER2, 0x200));
 
-phy_BB8190_Config_ParaFile_Fail:
+phy_bb8190_config_parafile_fail:
 	return rtstatus;
 }
 
@@ -1007,13 +1007,13 @@ bool rtl92s_phy_mac_config(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u32 i;
 	u32 arraylength;
-	u32 *ptraArray;
+	u32 *ptrarray;
 
 	arraylength = MAC_2T_ARRAYLENGTH;
-	ptraArray = rtl8192semac_2t_array;
+	ptrarray = rtl8192semac_2t_array;
 
 	for (i = 0; i < arraylength; i = i + 2)
-		rtl_write_byte(rtlpriv, ptraArray[i], (u8)ptraArray[i + 1]);
+		rtl_write_byte(rtlpriv, ptrarray[i], (u8)ptrarray[i + 1]);
 
 	return true;
 }
@@ -1106,7 +1106,7 @@ void rtl92s_phy_get_hw_reg_originalvalue(struct ieee80211_hw *hw)
 }
 
 static void _rtl92s_phy_get_txpower_index(struct ieee80211_hw *hw, u8 channel,
-					  u8 *cckpowerlevel, u8 *ofdmpowerLevel)
+					  u8 *cckpowerlevel, u8 *ofdmpowerlevel)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -1122,15 +1122,15 @@ static void _rtl92s_phy_get_txpower_index(struct ieee80211_hw *hw, u8 channel,
 	/* 2. OFDM for 1T or 2T */
 	if (rtlphy->rf_type == RF_1T2R || rtlphy->rf_type == RF_1T1R) {
 		/* Read HT 40 OFDM TX power */
-		ofdmpowerLevel[0] = rtlefuse->txpwrlevel_ht40_1s[0][index];
-		ofdmpowerLevel[1] = rtlefuse->txpwrlevel_ht40_1s[1][index];
+		ofdmpowerlevel[0] = rtlefuse->txpwrlevel_ht40_1s[0][index];
+		ofdmpowerlevel[1] = rtlefuse->txpwrlevel_ht40_1s[1][index];
 	} else if (rtlphy->rf_type == RF_2T2R) {
 		/* Read HT 40 OFDM TX power */
-		ofdmpowerLevel[0] = rtlefuse->txpwrlevel_ht40_2s[0][index];
-		ofdmpowerLevel[1] = rtlefuse->txpwrlevel_ht40_2s[1][index];
+		ofdmpowerlevel[0] = rtlefuse->txpwrlevel_ht40_2s[0][index];
+		ofdmpowerlevel[1] = rtlefuse->txpwrlevel_ht40_2s[1][index];
 	} else {
-		ofdmpowerLevel[0] = 0;
-		ofdmpowerLevel[1] = 0;
+		ofdmpowerlevel[0] = 0;
+		ofdmpowerlevel[1] = 0;
 	}
 }
 
@@ -1149,7 +1149,7 @@ void rtl92s_phy_set_txpower(struct ieee80211_hw *hw, u8	channel)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	/* [0]:RF-A, [1]:RF-B */
-	u8 cckpowerlevel[2], ofdmpowerLevel[2];
+	u8 cckpowerlevel[2], ofdmpowerlevel[2];
 
 	if (!rtlefuse->txpwr_fromeprom)
 		return;
@@ -1161,18 +1161,18 @@ void rtl92s_phy_set_txpower(struct ieee80211_hw *hw, u8	channel)
 	 * 1. For CCK.
 	 * 2. For OFDM 1T or 2T */
 	_rtl92s_phy_get_txpower_index(hw, channel, &cckpowerlevel[0],
-			&ofdmpowerLevel[0]);
+			&ofdmpowerlevel[0]);
 
 	RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
 		 "Channel-%d, cckPowerLevel (A / B) = 0x%x / 0x%x, ofdmPowerLevel (A / B) = 0x%x / 0x%x\n",
 		 channel, cckpowerlevel[0], cckpowerlevel[1],
-		 ofdmpowerLevel[0], ofdmpowerLevel[1]);
+		 ofdmpowerlevel[0], ofdmpowerlevel[1]);
 
 	_rtl92s_phy_ccxpower_indexcheck(hw, channel, &cckpowerlevel[0],
-			&ofdmpowerLevel[0]);
+			&ofdmpowerlevel[0]);
 
 	rtl92s_phy_rf6052_set_ccktxpower(hw, cckpowerlevel[0]);
-	rtl92s_phy_rf6052_set_ofdmtxpower(hw, &ofdmpowerLevel[0], channel);
+	rtl92s_phy_rf6052_set_ofdmtxpower(hw, &ofdmpowerlevel[0], channel);
 
 }
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/reg.h
index 0e45f373dc49..cc70afa3169d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/reg.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/reg.h
@@ -169,7 +169,7 @@
 #define	BCNTCFG					0x01E0
 #define	CWRR					0x01E2
 #define	ACMAVG					0x01E4
-#define	AcmHwCtrl				0x01E7
+#define	ACMHWCTRL				0x01E7
 #define	VO_ADMTM				0x01E8
 #define	VI_ADMTM				0x01EC
 #define	BE_ADMTM				0x01F0
@@ -235,7 +235,7 @@
 #define	INTA_MASK				0x0300
 #define	ISR					0x0308
 
-/* 13. Test Mode and Debug Control Registers */
+/* 13. Test mode and Debug Control Registers */
 #define	DBG_PORT_SWITCH				0x003A
 #define	BIST					0x0310
 #define	DBS					0x0314
@@ -325,9 +325,9 @@
 #define	SYS_SWHW_SEL				BIT(14)
 #define	SYS_FWHW_SEL				BIT(15)
 
-#define	CmdEEPROM_En				BIT(5)
-#define	CmdEERPOMSEL				BIT(4)
-#define	Cmd9346CR_9356SEL			BIT(4)
+#define	CMDEEPROM_EN				BIT(5)
+#define	CMDEERPOMSEL				BIT(4)
+#define	CMD9346CR_9356SEL			BIT(4)
 
 #define	AFE_MBEN				BIT(1)
 #define	AFE_BGEN				BIT(0)
@@ -348,9 +348,9 @@
 
 #define	APLL_EN					BIT(0)
 
-#define	AFR_CardBEn				BIT(0)
+#define	AFR_CARDBEN				BIT(0)
 #define	AFR_CLKRUN_SEL				BIT(1)
-#define	AFR_FuncRegEn				BIT(2)
+#define	AFR_FUNCREGEN				BIT(2)
 
 #define	APSDOFF_STATUS				BIT(15)
 #define	APSDOFF					BIT(14)
@@ -366,13 +366,13 @@
 #define	HCI_RXDMA_EN				BIT(3)
 #define	HCI_TXDMA_EN				BIT(2)
 
-#define	StopHCCA				BIT(6)
-#define	StopHigh				BIT(5)
-#define	StopMgt					BIT(4)
-#define	StopVO					BIT(3)
-#define	StopVI					BIT(2)
-#define	StopBE					BIT(1)
-#define	StopBK					BIT(0)
+#define	STOPHCCA				BIT(6)
+#define	STOPHIGH				BIT(5)
+#define	STOPMGT					BIT(4)
+#define	STOPVO					BIT(3)
+#define	STOPVI					BIT(2)
+#define	STOPBE					BIT(1)
+#define	STOPBK					BIT(0)
 
 #define	LBK_NORMAL				0x00
 #define	LBK_MAC_LB				(BIT(0) | BIT(1) | BIT(3))
@@ -384,7 +384,7 @@
 #define	TXDMAPRE2FULL				BIT(23)
 #define	DISCW					BIT(20)
 #define	TCRICV					BIT(19)
-#define	CfendForm				BIT(17)
+#define	cfendform				BIT(17)
 #define	TCRCRC					BIT(16)
 #define	FAKE_IMEM_EN				BIT(15)
 #define	TSFRST					BIT(9)
@@ -509,7 +509,7 @@
 #define	RRSR_MCS5				BIT(17)
 #define	RRSR_MCS6				BIT(18)
 #define	RRSR_MCS7				BIT(19)
-#define	BRSR_AckShortPmb			BIT(23)
+#define	BRSR_ACKSHORTPMB			BIT(23)
 
 #define	RATR_1M					0x00000001
 #define	RATR_2M					0x00000002
@@ -560,13 +560,13 @@
 #define	AC_PARAM_ECW_MIN_OFFSET			8
 #define	AC_PARAM_AIFS_OFFSET			0
 
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
 
 #define	RETRY_LIMIT_SHORT_SHIFT			8
 #define	RETRY_LIMIT_LONG_SHIFT			0
@@ -824,7 +824,7 @@
 #define TCR_SAT					BIT(24)
 #define RCR_MXDMA_OFFSET			8
 #define RCR_FIFO_OFFSET				13
-#define RCR_OnlyErlPkt				BIT(31)
+#define RCR_ONLYERLPKT				BIT(31)
 #define CWR					0xDC
 #define RETRYCTR				0xDE
 
-- 
2.20.1

