Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33392 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab2AHCrM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jan 2012 21:47:12 -0500
Received: by mail-iy0-f174.google.com with SMTP id h11so4842716iae.19
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jan 2012 18:47:12 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2/8] rtl8192cu: Remove dead code never selected
Date: Sat,  7 Jan 2012 20:46:41 -0600
Message-Id: <1325990807-13575-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120108_034717_354366_35E28B00)
In-Reply-To: <1325990807-13575-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1325990807-13575-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The original driver contained some conditional code that was not selected,
but was not deleted in case it would be used later. That code can now be
removed.

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c |  170 ---------------------------
 1 files changed, 0 insertions(+), 170 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 516cf1b..51b7aa1 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -339,144 +339,8 @@ static void _rtl92cu_read_board_type(struct ieee80211_hw *hw, u8 *contents)
 	if (IS_HIGHT_PA(rtlefuse->board_type))
 		rtlefuse->external_pa = 1;
 	pr_info("Board Type %x\n", rtlefuse->board_type);
-
-#ifdef CONFIG_ANTENNA_DIVERSITY
-	/* Antenna Diversity setting. */
-	if (registry_par->antdiv_cfg == 2) /* 2: From Efuse */
-		rtl_efuse->antenna_cfg = (contents[EEPROM_RF_OPT1]&0x18)>>3;
-	else
-		rtl_efuse->antenna_cfg = registry_par->antdiv_cfg; /* 0:OFF, */
-
-	pr_info("Antenna Config %x\n", rtl_efuse->antenna_cfg);
-#endif
-}
-
-#ifdef CONFIG_BT_COEXIST
-static void _update_bt_param(_adapter *padapter)
-{
-	struct btcoexist_priv	 *pbtpriv = &(padapter->halpriv.bt_coexist);
-	struct registry_priv	*registry_par = &padapter->registrypriv;
-	if (2 != registry_par->bt_iso) {
-		/* 0:Low, 1:High, 2:From Efuse */
-		pbtpriv->BT_Ant_isolation = registry_par->bt_iso;
-	}
-	if (registry_par->bt_sco == 1) {
-		/* 0:Idle, 1:None-SCO, 2:SCO, 3:From Counter, 4.Busy,
-		 * 5.OtherBusy */
-		pbtpriv->BT_Service = BT_OtherAction;
-	} else if (registry_par->bt_sco == 2) {
-		pbtpriv->BT_Service = BT_SCO;
-	} else if (registry_par->bt_sco == 4) {
-		pbtpriv->BT_Service = BT_Busy;
-	} else if (registry_par->bt_sco == 5) {
-		pbtpriv->BT_Service = BT_OtherBusy;
-	} else {
-		pbtpriv->BT_Service = BT_Idle;
-	}
-	pbtpriv->BT_Ampdu = registry_par->bt_ampdu;
-	pbtpriv->bCOBT = _TRUE;
-	pbtpriv->BtEdcaUL = 0;
-	pbtpriv->BtEdcaDL = 0;
-	pbtpriv->BtRssiState = 0xff;
-	pbtpriv->bInitSet = _FALSE;
-	pbtpriv->bBTBusyTraffic = _FALSE;
-	pbtpriv->bBTTrafficModeSet = _FALSE;
-	pbtpriv->bBTNonTrafficModeSet = _FALSE;
-	pbtpriv->CurrentState = 0;
-	pbtpriv->PreviousState = 0;
-	pr_info("BT Coexistance = %s\n",
-		(pbtpriv->BT_Coexist == _TRUE) ? "enable" : "disable");
-	if (pbtpriv->BT_Coexist) {
-		if (pbtpriv->BT_Ant_Num == Ant_x2)
-			pr_info("BlueTooth BT_Ant_Num = Antx2\n");
-		else if (pbtpriv->BT_Ant_Num == Ant_x1)
-			pr_info("BlueTooth BT_Ant_Num = Antx1\n");
-		switch (pbtpriv->BT_CoexistType) {
-		case BT_2Wire:
-			pr_info("BlueTooth BT_CoexistType = BT_2Wire\n");
-			break;
-		case BT_ISSC_3Wire:
-			pr_info("BlueTooth BT_CoexistType = BT_ISSC_3Wire\n");
-			break;
-		case BT_Accel:
-			pr_info("BlueTooth BT_CoexistType = BT_Accel\n");
-			break;
-		case BT_CSR_BC4:
-			pr_info("BlueTooth BT_CoexistType = BT_CSR_BC4\n");
-			break;
-		case BT_CSR_BC8:
-			pr_info("BlueTooth BT_CoexistType = BT_CSR_BC8\n");
-			break;
-		case BT_RTL8756:
-			pr_info("BlueTooth BT_CoexistType = BT_RTL8756\n");
-			break;
-		default:
-			pr_info("BlueTooth BT_CoexistType = Unknown\n");
-			break;
-		}
-		pr_info("BlueTooth BT_Ant_isolation = %d\n",
-			pbtpriv->BT_Ant_isolation);
-		switch (pbtpriv->BT_Service) {
-		case BT_OtherAction:
-			pr_info("BlueTooth BT_Service = BT_OtherAction\n");
-			break;
-		case BT_SCO:
-			pr_info("BlueTooth BT_Service = BT_SCO\n");
-			break;
-		case BT_Busy:
-			pr_info("BlueTooth BT_Service = BT_Busy\n");
-			break;
-		case BT_OtherBusy:
-			pr_info("BlueTooth BT_Service = BT_OtherBusy\n");
-			break;
-		default:
-			pr_info("BlueTooth BT_Service = BT_Idle\n");
-			break;
-		}
-		pr_info("BT_RadioSharedType = 0x%x\n",
-			pbtpriv->BT_RadioSharedType);
-	}
 }
 
-#define GET_BT_COEXIST(priv) (&priv->bt_coexist)
-
-static void _rtl92cu_read_bluetooth_coexistInfo(struct ieee80211_hw *hw,
-						u8 *contents,
-						bool bautoloadfailed);
-{
-	HAL_DATA_TYPE	*pHalData = GET_HAL_DATA(Adapter);
-	bool isNormal = IS_NORMAL_CHIP(pHalData->VersionID);
-	struct btcoexist_priv	 *pbtpriv = &pHalData->bt_coexist;
-	u8	rf_opt4;
-
-	_rtw_memset(pbtpriv, 0, sizeof(struct btcoexist_priv));
-	if (AutoloadFail) {
-		pbtpriv->BT_Coexist = _FALSE;
-		pbtpriv->BT_CoexistType = BT_2Wire;
-		pbtpriv->BT_Ant_Num = Ant_x2;
-		pbtpriv->BT_Ant_isolation = 0;
-		pbtpriv->BT_RadioSharedType = BT_Radio_Shared;
-		return;
-	}
-	if (isNormal) {
-		if (pHalData->BoardType == BOARD_USB_COMBO)
-			pbtpriv->BT_Coexist = _TRUE;
-		else
-			pbtpriv->BT_Coexist = ((PROMContent[EEPROM_RF_OPT3] &
-					      0x20) >> 5); /* bit[5] */
-		rf_opt4 = PROMContent[EEPROM_RF_OPT4];
-		pbtpriv->BT_CoexistType = ((rf_opt4&0xe)>>1); /* bit [3:1] */
-		pbtpriv->BT_Ant_Num = (rf_opt4&0x1); /* bit [0] */
-		pbtpriv->BT_Ant_isolation = ((rf_opt4&0x10)>>4); /* bit [4] */
-		pbtpriv->BT_RadioSharedType = ((rf_opt4&0x20)>>5); /* bit [5] */
-	} else {
-		pbtpriv->BT_Coexist = (PROMContent[EEPROM_RF_OPT4] >> 4) ?
-				       _TRUE : _FALSE;
-	}
-	_update_bt_param(Adapter);
-}
-#endif
-
 static void _rtl92cu_read_adapter_info(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -552,10 +416,6 @@ static void _rtl92cu_read_adapter_info(struct ieee80211_hw *hw)
 		}
 	}
 	_rtl92cu_read_board_type(hw, hwinfo);
-#ifdef CONFIG_BT_COEXIST
-	_rtl92cu_read_bluetooth_coexistInfo(hw, hwinfo,
-					    rtlefuse->autoload_failflag);
-#endif
 }
 
 static void _rtl92cu_hal_customized_behavior(struct ieee80211_hw *hw)
@@ -1107,34 +967,6 @@ static void _InitPABias(struct ieee80211_hw *hw)
 	}
 }
 
-static void _InitAntenna_Selection(struct ieee80211_hw *hw)
-{
-#ifdef CONFIG_ANTENNA_DIVERSITY
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	struct rtl_phy *rtlphy = &(rtlpriv->phy);
-
-	if (pHalData->AntDivCfg == 0)
-		return;
-
-	if (rtlphy->rf_type == RF_1T1R) {
-		rtl_write_dword(rtlpriv, REG_LEDCFG0,
-				rtl_read_dword(rtlpriv,
-				REG_LEDCFG0)|BIT(23));
-		rtl_set_bbreg(hw, rFPGA0_XAB_RFPARAMETER, BIT(13), 0x01);
-		if (rtl_get_bbreg(hw, RFPGA0_XA_RFINTERFACEOE, 0x300) ==
-		    Antenna_A)
-			pHalData->CurAntenna = Antenna_A;
-		else
-			pHalData->CurAntenna = Antenna_B;
-	}
-#endif
-}
-
-static void _dump_registers(struct ieee80211_hw *hw)
-{
-}
-
 static void _update_mac_setting(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -1205,10 +1037,8 @@ int rtl92cu_hw_init(struct ieee80211_hw *hw)
 	}
 	_rtl92cu_hw_configure(hw);
 	_InitPABias(hw);
-	_InitAntenna_Selection(hw);
 	_update_mac_setting(hw);
 	rtl92c_dm_init(hw);
-	_dump_registers(hw);
 	return err;
 }
 
-- 
1.7.7

