Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-11162.dedibox.fr ([88.191.70.230]:33734 "EHLO
	sd-11162.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab0BQIUM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 03:20:12 -0500
Date: Wed, 17 Feb 2010 09:19:20 +0100
From: Frederic Leroy <fredo@starox.org>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@suse.de>
Subject: [RFC PATCH] staging: rtl8192su: remove dead code
Message-ID: <20100217091920.083a3dd3@houba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

This patch removes some dead code in rtl8192su driver in staging against linux-2.6-stable tree.
Should I split it into smaller chunk ? 
As it is in staging, should I post it to linux-kernel@vger.kernel.org ?

-- 
Frédéric Leroy

commit a7d4098964566955d1ffde9921f6c9b7f276cc73
Author: Frédéric Leroy <fredo@starox.org>
Date:   Wed Feb 17 00:49:35 2010 +0100

    staging: rtl8292su: remove dead code
    
    this patch removes dead code enclosed by undefined vars RTL8190P/RTL8192E/TO_DO_LIST

diff --git a/drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c
index 4d54e1e..378ed9e 100644
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c
@@ -316,14 +316,6 @@ void ieee80211_tx_query_agg_cap(struct ieee80211_device* ieee, struct sk_buff* s
 
 	if (is_multicast_ether_addr(hdr->addr1) || is_broadcast_ether_addr(hdr->addr1))
 		return;
-	//check packet and mode later
-#ifdef TO_DO_LIST
-	if(pTcb->PacketLength >= 4096)
-		return;
-	// For RTL819X, if pairwisekey = wep/tkip, we don't aggrregation.
-	if(!Adapter->HalFunc.GetNmodeSupportBySecCfgHandler(Adapter))
-		return;
-#endif
 
 	if(pHTInfo->IOTAction & HT_IOT_ACT_TX_NO_AGGREGATION)
 		return;
@@ -561,22 +553,6 @@ NO_PROTECTION:
 
 void ieee80211_txrate_selectmode(struct ieee80211_device* ieee, cb_desc* tcb_desc)
 {
-#ifdef TO_DO_LIST
-	if(!IsDataFrame(pFrame))
-	{
-		pTcb->bTxDisableRateFallBack = TRUE;
-		pTcb->bTxUseDriverAssingedRate = TRUE;
-		pTcb->RATRIndex = 7;
-		return;
-	}
-
-	if(pMgntInfo->ForcedDataRate!= 0)
-	{
-		pTcb->bTxDisableRateFallBack = TRUE;
-		pTcb->bTxUseDriverAssingedRate = TRUE;
-		return;
-	}
-#endif
 	if(ieee->bTxDisableRateFallBack)
 		tcb_desc->bTxDisableRateFallBack = true;
 
diff --git a/drivers/staging/rtl8192su/ieee80211/rtl819x_HTProc.c b/drivers/staging/rtl8192su/ieee80211/rtl819x_HTProc.c
index 33c7fa7..378f8b1 100644
--- a/drivers/staging/rtl8192su/ieee80211/rtl819x_HTProc.c
+++ b/drivers/staging/rtl8192su/ieee80211/rtl819x_HTProc.c
@@ -89,10 +89,6 @@ void HTUpdateDefaultSetting(struct ieee80211_device* ieee)
 	ieee->bTxDisableRateFallBack = 0;
 	ieee->bTxUseDriverAssingedRate = 0;
 
-#ifdef 	TO_DO_LIST
-	// 8190 only. Assign duration operation mode to firmware
-	pMgntInfo->bTxEnableFwCalcDur = (BOOLEAN)pNdisCommon->bRegTxEnableFwCalcDur;
-#endif
 	// 8190 only, Realtek proprietary aggregation mode
 	// Set MPDUDensity=2,   1: Set MPDUDensity=2(32k)  for Realtek AP and set MPDUDensity=0(8k) for others
 	pHTInfo->bRegRT2RTAggregation = 1;//0: Set MPDUDensity=2,   1: Set MPDUDensity=2(32k)  for Realtek AP and set MPDUDensity=0(8k) for others
diff --git a/drivers/staging/rtl8192su/r8192S_Efuse.c b/drivers/staging/rtl8192su/r8192S_Efuse.c
index f0ce656..f844887 100644
--- a/drivers/staging/rtl8192su/r8192S_Efuse.c
+++ b/drivers/staging/rtl8192su/r8192S_Efuse.c
@@ -165,12 +165,6 @@ efuse_OneByteWrite(struct net_device* dev,u16 addr, u8 data);
 //
 static	void
 efuse_ReadAllMap(struct net_device* dev,u8 *Efuse);
-#ifdef TO_DO_LIST
-static	void
-efuse_WriteAllMap(struct net_device* dev,u8 *eeprom,u32 eeprom_size);
-static	bool
-efuse_ParsingMap(char* szStr,u32* pu4bVal,u32* pu4bMove);
-#endif
 //
 // Reald Efuse R/W or other operation API.
 //
@@ -191,9 +185,6 @@ efuse_CalculateWordCnts(u8 word_en);
 //
 // API for power on power off!!!
 //
-#ifdef TO_DO_LIST
-static void efuse_reg_ctrl(struct net_device* dev, u8 bPowerOn);
-#endif
 /*--------------------Define function prototype-----------------------*/
 
 
@@ -1019,66 +1010,6 @@ efuse_ReadAllMap(struct net_device*	dev, u8	*Efuse)
 }	// efuse_ReadAllMap
 
 
-/*-----------------------------------------------------------------------------
- * Function:	efuse_WriteAllMap
- *
- * Overview:	Write All Efuse content
- *
- * Input:       NONE
- *
- * Output:      NONE
- *
- * Return:      NONE
- *
- * Revised History:
- * When			Who		Remark
- * 11/11/2008 	MHC		Create Version 0.
- *
- *---------------------------------------------------------------------------*/
-#ifdef TO_DO_LIST
-static	void
-efuse_WriteAllMap(struct net_device* dev,u8 *eeprom, u32 eeprom_size)
-{
-	unsigned char word_en = 0x00;
-
-	unsigned char tmpdata[8];
-	unsigned char offset;
-
-	// For Efuse write action, we must enable LDO2.5V and 40MHZ clk.
-	efuse_PowerSwitch(dev, TRUE);
-
-	//sdio contents
-	for(offset=0 ; offset< eeprom_size/PGPKT_DATA_SIZE ; offset++)
-	{
-		// 92S will only reserv 0x18-1F 8 bytes now. The 3rd efuse write area!
-		if (IS_HARDWARE_TYPE_8192SE(dev))
-		{
-			// Refer to
-			// 0x18-1f Reserve >0x50 Reserve for tx power
-			if (offset == 3/* || offset > 9*/)
-				continue;//word_en = 0x0F;
-			//else if (offset == 9)	// 0x4c-4f Reserve
-				//word_en = 0x0C;
-			else
-				word_en = 0x00;
-		}
-		//RT_TRACE(COMP_EFUSE, ("Addr=%d size=%d Word_En=%02x\n", offset, eeprom_size, word_en));
-
-		//memcpy(tmpdata,eeprom+(offset*PGPKT_DATA_SIZE),8);
-		memcpy(tmpdata, (eeprom+(offset*PGPKT_DATA_SIZE)), 8);
-
-		//RT_PRINT_DATA(COMP_INIT, DBG_LOUD, ("EFUSE\t"), tmpdata, 8);
-
-		efuse_PgPacketWrite(dev,offset,word_en,tmpdata);
-
-
-	}
-
-	// For warm reboot, we must resume Efuse clock to 500K.
-	efuse_PowerSwitch(dev, FALSE);
-
-}	// efuse_WriteAllMap
-#endif
 
 /*-----------------------------------------------------------------------------
  * Function:	efuse_PgPacketRead
@@ -1725,108 +1656,6 @@ efuse_CalculateWordCnts(u8	word_en)
 	return word_cnts;
 }	// efuse_CalculateWordCnts
 
-/*-----------------------------------------------------------------------------
- * Function:	EFUSE_ProgramMap
- *
- * Overview:	Read EFUSE map file and execute PG.
- *
- * Input:       NONE
- *
- * Output:      NONE
- *
- * Return:      NONE
- *
- * Revised History:
- * When			Who		Remark
- * 11/10/2008 	MHC		Create Version 0.
- *
- *---------------------------------------------------------------------------*/
- #ifdef TO_DO_LIST
-extern	bool	// 0=Shadow 1=Real Efuse
-EFUSE_ProgramMap(struct net_device* dev, char* pFileName,u8	TableType)
-{
-	struct r8192_priv 	*priv = ieee80211_priv(dev);
-	s4Byte			nLinesRead, ithLine;
-	RT_STATUS		rtStatus = RT_STATUS_SUCCESS;
-	char* 			szLine;
-	u32			u4bRegValue, u4RegMask;
-	u32			u4bMove;
-	u16			index = 0;
-	u16			i;
-	u8			eeprom[HWSET_MAX_SIZE_92S];
-
-	rtStatus = PlatformReadFile(
-					dev,
-					pFileName,
-					(u8*)(priv->BufOfLines),
-					MAX_LINES_HWCONFIG_TXT,
-					MAX_BYTES_LINE_HWCONFIG_TXT,
-					&nLinesRead
-					);
-
-	if(rtStatus == RT_STATUS_SUCCESS)
-	{
-		memcp(pHalData->BufOfLines3, pHalData->BufOfLines,
-			nLinesRead*MAX_BYTES_LINE_HWCONFIG_TXT);
-		pHalData->nLinesRead3 = nLinesRead;
-	}
-
-	if(rtStatus == RT_STATUS_SUCCESS)
-	{
-		printk("szEepromFile(): read %s ok\n", pFileName);
-		for(ithLine = 0; ithLine < nLinesRead; ithLine++)
-		{
-			szLine = pHalData->BufOfLines[ithLine];
-			printk("Line-%d String =%s\n", ithLine, szLine);
-
-			if(!IsCommentString(szLine))
-			{
-				// EEPROM map one line has 8 words content.
-				for (i = 0; i < 8; i++)
-				{
-					u32	j;
-
-					//GetHexValueFromString(szLine, &u4bRegValue, &u4bMove);
-					efuse_ParsingMap(szLine, &u4bRegValue, &u4bMove);
-
-					// Get next hex value as EEPROM value.
-					szLine += u4bMove;
-					//WriteEEprom(dev, (u16)(ithLine*8+i), (u16)u4bRegValue);
-					eeprom[index++] = (u8)(u4bRegValue&0xff);
-					eeprom[index++] = (u8)((u4bRegValue>>8)&0xff);
-
-					printk("Addr-%d = %x\n", (ithLine*8+i), u4bRegValue);
-				}
-			}
-
-		}
-
-	}
-	else
-	{
-		printk("szEepromFile(): Fail read%s\n", pFileName);
-		return	RT_STATUS_FAILURE;
-	}
-
-
-	//RT_PRINT_DATA(COMP_EFUSE, DBG_LOUD, ("EFUSE "), eeprom, HWSET_MAX_SIZE_92S);
-
-	// Use map file to update real Efuse or shadow modify table.
-	if (TableType == 1)
-	{
-		efuse_WriteAllMap(dev, eeprom, HWSET_MAX_SIZE_92S);
-	}
-	else
-	{
-		// Modify shadow table.
-		for (i = 0; i < HWSET_MAX_SIZE_92S; i++)
-			EFUSE_ShadowWrite(dev, 1, i, (u32)eeprom[i]);
-	}
-
-	return	rtStatus;
-}	/* EFUSE_ProgramMap */
-
-#endif
 
 //
 //	Description:
@@ -1864,71 +1693,6 @@ u32 MapCharToHexDigit(char chTmp)
 		return 0;
 }
 
-/*-----------------------------------------------------------------------------
- * Function:	efuse_ParsingMap
- *
- * Overview:
- *
- * Input:       NONE
- *
- * Output:      NONE
- *
- * Return:      NONE
- *
- * Revised History:
- * When			Who		Remark
- * 11/08/2008 	MHC		Create Version 0.
- *
- *---------------------------------------------------------------------------*/
-#ifdef TO_DO_LIST
-static	bool
-efuse_ParsingMap(char* szStr,u32* pu4bVal,u32* pu4bMove)
-{
-	char* 		szScan = szStr;
-
-	// Check input parameter.
-	if(szStr == NULL || pu4bVal == NULL || pu4bMove == NULL)
-	{
-		//RT_TRACE(COMP_EFUSE,
-		//"eeprom_ParsingMap(): Invalid IN args! szStr: %p, pu4bVal: %p, pu4bMove: %p\n",
-		//szStr, pu4bVal, pu4bMove);
-		return FALSE;
-	}
-
-	// Initialize output.
-	*pu4bMove = 0;
-	*pu4bVal = 0;
-
-	// Skip leading space.
-	while(	*szScan != '\0' &&
-			(*szScan == ' ' || *szScan == '\t') )
-	{
-		szScan++;
-		(*pu4bMove)++;
-	}
-
-	// Check if szScan is now pointer to a character for hex digit,
-	// if not, it means this is not a valid hex number.
-	if(!IsHexDigit(*szScan))
-	{
-		return FALSE;
-	}
-
-	// Parse each digit.
-	do
-	{
-		(*pu4bVal) <<= 4;
-		*pu4bVal += MapCharToHexDigit(*szScan);
-
-		szScan++;
-		(*pu4bMove)++;
-	} while(IsHexDigit(*szScan));
-
-	return TRUE;
-
-}	/* efuse_ParsingMap */
-#endif
-
 //
 // Useless Section Code Now!!!!!!
 //
@@ -2034,40 +1798,6 @@ void efuse_access(struct net_device* dev, u8 bRead,u16 start_addr, u8 cnts, u8 *
 //------------------------------------------------------------------------------
 //------------------------------------------------------------------------------
 
-#ifdef TO_DO_LIST
-static	void efuse_reg_ctrl(struct net_device* dev, u8 bPowerOn)
-{
-	if(TRUE==bPowerOn){
-		// -----------------SYS_FUNC_EN Digital Core Vdd enable ---------------------------------
-		write_nic_byte(dev, SYS_FUNC_EN+1,  read_nic_byte(dev,SYS_FUNC_EN+1)|0x20);
-#ifdef _POWERON_DELAY_
-		mdelay(10);
-#endif
-		// -----------------e-fuse pwr & clk reg ctrl ---------------------------------
-		write_nic_byte(dev, EFUSE_TEST+4, (read_nic_byte(dev, EFUSE_TEST+4)|0x80));
-		write_nic_byte(dev, EFUSE_CLK_CTRL, (read_nic_byte(dev, EFUSE_CLK_CTRL)|0x03));
-#ifdef _PRE_EXECUTE_READ_CMD_
-		{
-			unsigned char tmpdata;
-			efuse_OneByteRead(dev, 0,&tmpdata);
-		}
-
-#endif
-	}
-	else{
-		// -----------------e-fuse pwr & clk reg ctrl ---------------------------------
-		write_nic_byte(dev, EFUSE_TEST+4, read_nic_byte(dev, EFUSE_TEST+4)&0x7f);
-		write_nic_byte(dev, EFUSE_CLK_CTRL, read_nic_byte(dev, EFUSE_CLK_CTRL)&0xfd);
-		// -----------------SYS_FUNC_EN Digital Core Vdd disable ---------------------------------
-
-		//write_nic_byte(pAdapter, SYS_FUNC_EN+1,  read_nic_byte(pAdapter,SYS_FUNC_EN+1)&0xDF);
-	}
-
-
-}
-#endif
-//------------------------------------------------------------------------------
-
 //------------------------------------------------------------------------------
 void efuse_read_data(struct net_device* dev,u8 efuse_read_item,u8 *data,u32 data_size)
 {
diff --git a/drivers/staging/rtl8192su/r8192S_phy.c b/drivers/staging/rtl8192su/r8192S_phy.c
index 77ab026..42d1f1a 100644
--- a/drivers/staging/rtl8192su/r8192S_phy.c
+++ b/drivers/staging/rtl8192su/r8192S_phy.c
@@ -774,19 +774,6 @@ PHY_RFConfig8192S(struct net_device* dev)
 }
 
 
-// Joseph test: new initialize order!!
-// Test only!! This part need to be re-organized.
-// Now it is just for 8256.
-//use in phy only
-#ifdef TO_DO_LIST
-static RT_STATUS
-phy_BB8190_Config_HardCode(struct net_device* dev)
-{
-	//RT_ASSERT(FALSE, ("This function is not implement yet!! \n"));
-	return RT_STATUS_SUCCESS;
-}
-#endif
-
 /*-----------------------------------------------------------------------------
  * Function:    phy_SetBBtoDiffRFWithHeaderFile()
  *
@@ -1348,84 +1335,6 @@ PHY_CheckBBAndRFOK(
 	return rtStatus;
 }
 
-//no use temp in windows driver
-#ifdef TO_DO_LIST
-void
-PHY_SetRFPowerState8192SUsb(
-	struct net_device* dev,
-	RF_POWER_STATE	RFPowerState
-	)
-{
-	struct r8192_priv *priv = ieee80211_priv(dev);
-	bool			WaitShutDown = FALSE;
-	u32			DWordContent;
-	//RF90_RADIO_PATH_E	eRFPath;
-	u8				eRFPath;
-	BB_REGISTER_DEFINITION_T	*pPhyReg;
-
-	if(priv->SetRFPowerStateInProgress == TRUE)
-		return;
-
-	priv->SetRFPowerStateInProgress = TRUE;
-
-	// TODO: Emily, 2006.11.21, we should rewrite this function
-
-	if(RFPowerState==RF_SHUT_DOWN)
-	{
-		RFPowerState=RF_OFF;
-		WaitShutDown=TRUE;
-	}
-
-
-	priv->RFPowerState = RFPowerState;
-	switch( priv->rf_chip )
-	{
-	case RF_8225:
-	case RF_6052:
-		switch( RFPowerState )
-		{
-		case RF_ON:
-			break;
-
-		case RF_SLEEP:
-			break;
-
-		case RF_OFF:
-			break;
-		}
-		break;
-
-	case RF_8256:
-		switch( RFPowerState )
-		{
-		case RF_ON:
-			break;
-
-		case RF_SLEEP:
-			break;
-
-		case RF_OFF:
-			for(eRFPath=(RF90_RADIO_PATH_E)RF90_PATH_A; eRFPath < RF90_PATH_MAX; eRFPath++)
-			{
-				if (!rtl8192_phy_CheckIsLegalRFPath(dev, eRFPath))
-					continue;
-
-				pPhyReg = &priv->PHYRegDef[eRFPath];
-				rtl8192_setBBreg(dev, pPhyReg->rfintfs, bRFSI_RFENV, bRFSI_RFENV);
-				rtl8192_setBBreg(dev, pPhyReg->rfintfo, bRFSI_RFENV, 0);
-			}
-			break;
-		}
-		break;
-
-	case RF_8258:
-		break;
-	}// switch( priv->rf_chip )
-
-	priv->SetRFPowerStateInProgress = FALSE;
-}
-#endif
-
 #ifdef RTL8192U
 //no use temp in windows driver
 void
@@ -1735,59 +1644,6 @@ static bool phy_SetRFPowerState8192SU(struct net_device* dev,RT_RF_POWER_STATE e
 
 	}
 	priv->ieee80211->eRFPowerState = eRFPowerState;
-#ifdef TO_DO_LIST
-	if(bResult)
-	{
-		// Update current RF state variable.
-		priv->ieee80211->eRFPowerState = eRFPowerState;
-
-		switch(priv->rf_chip )
-		{
-			case RF_8256:
-			switch(priv->ieee80211->eRFPowerState)
-			{
-				case eRfOff:
-					//
-					//If Rf off reason is from IPS, Led should blink with no link, by Maddest 071015
-					//
-					if(pMgntInfo->RfOffReason==RF_CHANGE_BY_IPS )
-					{
-						dev->HalFunc.LedControlHandler(dev,LED_CTL_NO_LINK);
-					}
-					else
-					{
-						// Turn off LED if RF is not ON.
-						dev->HalFunc.LedControlHandler(dev, LED_CTL_POWER_OFF);
-					}
-					break;
-
-				case eRfOn:
-					// Turn on RF we are still linked, which might happen when
-					// we quickly turn off and on HW RF. 2006.05.12, by rcnjko.
-					if( pMgntInfo->bMediaConnect == TRUE )
-					{
-						dev->HalFunc.LedControlHandler(dev, LED_CTL_LINK);
-					}
-					else
-					{
-						// Turn off LED if RF is not ON.
-						dev->HalFunc.LedControlHandler(dev, LED_CTL_NO_LINK);
-					}
-					break;
-
-				default:
-					// do nothing.
-					break;
-			}// Switch RF state
-
-				break;
-
-			default:
-				RT_TRACE(COMP_RF, "phy_SetRFPowerState8192SU(): Unknown RF type\n");
-				break;
-		}// Switch rf_chip
-	}
-#endif
 	priv->SetRFPowerStateInProgress = FALSE;
 
 	return bResult;
@@ -2277,53 +2133,6 @@ static long phy_TxPwrIdxToDbm(
 	return PwrOutDbm;
 }
 
-#ifdef TO_DO_LIST
-extern	VOID
-PHY_ScanOperationBackup8192S(
-	IN	PADAPTER	Adapter,
-	IN	u1Byte		Operation
-	)
-{
-
-	HAL_DATA_TYPE			*pHalData = GET_HAL_DATA(Adapter);
-	PMGNT_INFO			pMgntInfo = &(Adapter->MgntInfo);
-	u4Byte				BitMask;
-	u1Byte				initial_gain;
-
-
-
-
-
-	if(!Adapter->bDriverStopped)
-	{
-		switch(Operation)
-		{
-			case SCAN_OPT_BACKUP:
-				//
-				// <Roger_Notes> We halt FW DIG and disable high ppower both two DMs here
-				// and resume both two DMs while scan complete.
-				// 2008.11.27.
-				//
-				Adapter->HalFunc.SetFwCmdHandler(Adapter, FW_CMD_PAUSE_DM_BY_SCAN);
-				break;
-
-			case SCAN_OPT_RESTORE:
-				//
-				// <Roger_Notes> We resume DIG and enable high power both two DMs here and
-				// recover earlier DIG settings.
-				// 2008.11.27.
-				//
-				Adapter->HalFunc.SetFwCmdHandler(Adapter, FW_CMD_RESUME_DM_BY_SCAN);
-				break;
-
-			default:
-				RT_TRACE(COMP_SCAN, DBG_LOUD, ("Unknown Scan Backup Operation. \n"));
-				break;
-		}
-	}
-}
-#endif
-
 //nouse temp
 void PHY_InitialGain8192S(struct net_device* dev,u8 Operation	)
 {
@@ -2679,18 +2488,6 @@ u8 rtl8192_phy_SwChnl(struct net_device* dev, u8 channel)
 	if((priv->up))// && !(RT_CANNOT_IO(Adapter) && Adapter->bInSetPower))
 	{
 	SwChnlCallback8192SUsbWorkItem(dev);
-#ifdef TO_DO_LIST
-	if(bResult)
-		{
-			RT_TRACE(COMP_SCAN, "PHY_SwChnl8192S SwChnlInProgress TRUE schdule workitem done\n");
-		}
-		else
-		{
-			RT_TRACE(COMP_SCAN, "PHY_SwChnl8192S SwChnlInProgress FALSE schdule workitem error\n");
-			priv->SwChnlInProgress = false;
-			priv->CurrentChannel = tmpchannel;
-		}
-#endif
 	}
 	else
 	{
@@ -2721,12 +2518,6 @@ void PHY_SwChnlPhy8192S(	// Only called during initialize
 
 	RT_TRACE(COMP_SCAN, "==>PHY_SwChnlPhy8192S(), switch to channel %d.\n", priv->chan);
 
-#ifdef TO_DO_LIST
-	// Cannot IO.
-	if(RT_CANNOT_IO(dev))
-		return;
-#endif
-
 	// Channel Switching is in progress.
 	if(priv->SwChnlInProgress)
 		return;
@@ -3443,15 +3234,6 @@ void SwChnlCallback8192SUsbWorkItem(struct net_device *dev )
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
 	RT_TRACE(COMP_TRACE, "==> SwChnlCallback8192SUsbWorkItem()\n");
-#ifdef TO_DO_LIST
-	if(pAdapter->bInSetPower && RT_USB_CANNOT_IO(pAdapter))
-	{
-		RT_TRACE(COMP_SCAN, DBG_LOUD, ("<== SwChnlCallback8192SUsbWorkItem() SwChnlInProgress FALSE driver sleep or unload\n"));
-
-		pHalData->SwChnlInProgress = FALSE;
-		return;
-	}
-#endif
 	phy_FinishSwChnlNow(dev, priv->chan);
 	priv->SwChnlInProgress = FALSE;
 
@@ -3734,9 +3516,6 @@ void SetBWModeCallback8192SUsbWorkItem(struct net_device *dev)
 //--------------------------Move to oter DIR later-------------------------------*/
 void InitialGain8192S(struct net_device *dev,	u8 Operation)
 {
-#ifdef TO_DO_LIST
-	struct r8192_priv *priv = ieee80211_priv(dev);
-#endif
 
 }
 
@@ -3892,13 +3671,6 @@ void ChkFwCmdIoDone(struct net_device* dev)
 
 	do
 	{// Make sure that CMD IO has be accepted by FW.
-#ifdef TO_DO_LIST
-		if(RT_USB_CANNOT_IO(Adapter))
-		{
-			RT_TRACE(COMP_CMD, "ChkFwCmdIoDone(): USB can NOT IO!!\n");
-			return;
-		}
-#endif
 		udelay(10); // sleep 20us
 		tmpValue = read_nic_dword(dev, WFM5);
 		if(tmpValue == 0)
diff --git a/drivers/staging/rtl8192su/r8192S_rtl8225.h b/drivers/staging/rtl8192su/r8192S_rtl8225.h
index 8a64728..7a16a3b 100644
--- a/drivers/staging/rtl8192su/r8192S_rtl8225.h
+++ b/drivers/staging/rtl8192su/r8192S_rtl8225.h
@@ -13,11 +13,7 @@
 #ifndef RTL8225H
 #define RTL8225H
 
-#ifdef RTL8190P
-#define RTL819X_TOTAL_RF_PATH 4 //for 90P
-#else
 #define RTL819X_TOTAL_RF_PATH 2 //for 8192U
-#endif
 extern void PHY_SetRF0222DBandwidth(struct net_device* dev , HT_CHANNEL_WIDTH Bandwidth);	//20M or 40M;
 extern void PHY_SetRF8225Bandwidth(	struct net_device* dev ,	HT_CHANNEL_WIDTH Bandwidth);
 extern bool PHY_RF8225_Config(struct net_device* dev );
diff --git a/drivers/staging/rtl8192su/r8192U_core.c b/drivers/staging/rtl8192su/r8192U_core.c
index ccb9d5b..9f16c5c 100644
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -2952,9 +2952,6 @@ void rtl8192_SetWirelessMode(struct net_device* dev, u8 wireless_mode)
 			wireless_mode = WIRELESS_MODE_B;
 		}
 	}
-#ifdef TO_DO_LIST //// TODO: this function doesn't work well at this time, we shoud wait for FPGA
-	ActUpdateChannelAccessSetting( pAdapter, pHalData->CurrentWirelessMode, &pAdapter->MgntInfo.Info8185.ChannelAccessSetting );
-#endif
 	//LZM 090306 usb crash here, mark it temp
 	//write_nic_word(dev, SIFS_OFDM, 0x0e0e);
 	priv->ieee80211->mode = wireless_mode;
@@ -3687,71 +3684,6 @@ rtl8192SU_ReadAdapterInfo8192SUsb(struct net_device* dev)
 	RT_TRACE(COMP_INIT, "USB Option = %#x\n", priv->EEPROMUsbOption);
 	RT_TRACE(COMP_INIT, "EndPoint Number = %#x\n", priv->EEPROMUsbEndPointNumber);
 
-#ifdef TO_DO_LIST
-	//
-	//  Decide CustomerID according to VID/DID or EEPROM
-	//
-	switch(pHalData->EEPROMCustomerID)
-	{
-		case EEPROM_CID_ALPHA:
-			pMgntInfo->CustomerID = RT_CID_819x_ALPHA;
-			break;
-
-		case EEPROM_CID_CAMEO:
-			pMgntInfo->CustomerID = RT_CID_819x_CAMEO;
-			break;
-
-		case EEPROM_CID_SITECOM:
-			pMgntInfo->CustomerID = RT_CID_819x_Sitecom;
-			RT_TRACE(COMP_INIT, DBG_LOUD, ("CustomerID = 0x%4x\n", pMgntInfo->CustomerID));
-
-			break;
-
-		case EEPROM_CID_WHQL:
-			Adapter->bInHctTest = TRUE;
-
-			pMgntInfo->bSupportTurboMode = FALSE;
-			pMgntInfo->bAutoTurboBy8186 = FALSE;
-
-			pMgntInfo->PowerSaveControl.bInactivePs = FALSE;
-			pMgntInfo->PowerSaveControl.bIPSModeBackup = FALSE;
-			pMgntInfo->PowerSaveControl.bLeisurePs = FALSE;
-			pMgntInfo->keepAliveLevel = 0;
-			break;
-
-		default:
-			pMgntInfo->CustomerID = RT_CID_DEFAULT;
-			break;
-
-	}
-
-	//
-	// Led mode
-	//
-	switch(pMgntInfo->CustomerID)
-	{
-		case RT_CID_DEFAULT:
-		case RT_CID_819x_ALPHA:
-			pHalData->LedStrategy = SW_LED_MODE1;
-			pHalData->bRegUseLed = TRUE;
-			pHalData->SwLed1.bLedOn = TRUE;
-			break;
-		case RT_CID_819x_CAMEO:
-			pHalData->LedStrategy = SW_LED_MODE1;
-			pHalData->bRegUseLed = TRUE;
-			break;
-
-		case RT_CID_819x_Sitecom:
-			pHalData->LedStrategy = SW_LED_MODE2;
-			pHalData->bRegUseLed = TRUE;
-			break;
-
-		default:
-			pHalData->LedStrategy = SW_LED_MODE0;
-			break;
-	}
-#endif
-
 	// Read USB PHY parameters.
 	for(i=0; i<5; i++)
 		priv->EEPROMUsbPhyParam[i] = *(u8 *)&hwinfo[EEPROM_USB_PHY_PARA1+i];
@@ -4112,34 +4044,6 @@ static void rtl8192SU_read_eeprom_info(struct net_device *dev)
 			EFUSE_ShadowMapUpdate(dev);
 		}
 	}
-#ifdef TO_DO_LIST
-	if((priv->RegChannelPlan >= RT_CHANNEL_DOMAIN_MAX) || (pHalData->EEPROMChannelPlan & EEPROM_CHANNEL_PLAN_BY_HW_MASK))
-	{
-		pMgntInfo->ChannelPlan = HalMapChannelPlan8192S(Adapter, (pHalData->EEPROMChannelPlan & (~(EEPROM_CHANNEL_PLAN_BY_HW_MASK))));
-		pMgntInfo->bChnlPlanFromHW = (pHalData->EEPROMChannelPlan & EEPROM_CHANNEL_PLAN_BY_HW_MASK) ? TRUE : FALSE; // User cannot change  channel plan.
-	}
-	else
-	{
-		pMgntInfo->ChannelPlan = (RT_CHANNEL_DOMAIN)pMgntInfo->RegChannelPlan;
-	}
-
-	switch(pMgntInfo->ChannelPlan)
-	{
-		case RT_CHANNEL_DOMAIN_GLOBAL_DOAMIN:
-		{
-			PRT_DOT11D_INFO	pDot11dInfo = GET_DOT11D_INFO(pMgntInfo);
-
-			pDot11dInfo->bEnabled = TRUE;
-		}
-		RT_TRACE(COMP_INIT, DBG_LOUD, ("ReadAdapterInfo8187(): Enable dot11d when RT_CHANNEL_DOMAIN_GLOBAL_DOAMIN!\n"));
-		break;
-	}
-
-	RT_TRACE(COMP_INIT, DBG_LOUD, ("RegChannelPlan(%d) EEPROMChannelPlan(%d)", pMgntInfo->RegChannelPlan, pHalData->EEPROMChannelPlan));
-	RT_TRACE(COMP_INIT, DBG_LOUD, ("ChannelPlan = %d\n" , pMgntInfo->ChannelPlan));
-
-	RT_TRACE(COMP_INIT, DBG_LOUD, ("<==== ReadAdapterInfo8192S\n"));
-#endif
 
 	RT_TRACE(COMP_INIT, "<==== ReadAdapterInfo8192SUsb\n");
 
@@ -4216,15 +4120,6 @@ void rtl8192_hwconfig(struct net_device* dev)
 		regRRSR = RATE_ALL_CCK | RATE_ALL_OFDM_AG;
 		break;
 	case WIRELESS_MODE_AUTO:
-#ifdef TO_DO_LIST
-		if (Adapter->bInHctTest)
-		{
-		    regBwOpMode = BW_OPMODE_20MHZ;
-		    regRATR = RATE_ALL_CCK | RATE_ALL_OFDM_AG;
-		    regRRSR = RATE_ALL_CCK | RATE_ALL_OFDM_AG;
-		}
-		else
-#endif
 		{
 		    regBwOpMode = BW_OPMODE_20MHZ;
 		    regRATR = RATE_ALL_CCK | RATE_ALL_OFDM_AG | RATE_ALL_OFDM_1SS | RATE_ALL_OFDM_2SS;
@@ -4876,77 +4771,9 @@ start:
 		write_nic_byte(dev, SECR, SECR_value);
 	}
 
-#ifdef TO_DO_LIST
-
-	//PHY_UpdateInitialGain(dev);
-
-	if(priv->RegRfOff == true)
-	{ // User disable RF via registry.
-		u8 eRFPath = 0;
-
-		RT_TRACE((COMP_INIT|COMP_RF), "InitializeAdapter8192SUsb(): Turn off RF for RegRfOff ----------\n");
-		MgntActSet_RF_State(dev, eRfOff, RF_CHANGE_BY_SW);
-		// Those action will be discard in MgntActSet_RF_State because off the same state
-		for(eRFPath = 0; eRFPath <priv->NumTotalRFPath; eRFPath++)
-			rtl8192_setBBreg(dev, (RF90_RADIO_PATH_E)eRFPath, 0x4, 0xC00, 0x0);
-	}
-	else if(priv->RfOffReason > RF_CHANGE_BY_PS)
-	{ // H/W or S/W RF OFF before sleep.
-		RT_TRACE((COMP_INIT|COMP_RF), "InitializeAdapter8192SUsb(): Turn off RF for RfOffReason(%d) ----------\n", priv->RfOffReason);
-		MgntActSet_RF_State(dev, eRfOff, priv->RfOffReason);
-	}
-	else
-	{
-		priv->eRFPowerState = eRfOn;
-		priv->RfOffReason = 0;
-		RT_TRACE((COMP_INIT|COMP_RF), "InitializeAdapter8192SUsb(): RF is on ----------\n");
-	}
-
-#endif
-
-
 //
 // f. Start to BulkIn transfer.
 //
-#ifdef TO_DO_LIST
-
-#ifndef UNDER_VISTA
-	{
-		u8	i;
-		PlatformAcquireSpinLock(Adapter, RT_RX_SPINLOCK);
-
-		for(PipeIndex=0; PipeIndex < MAX_RX_QUEUE; PipeIndex++)
-		{
-			if (PipeIndex == 0)
-			{
-				for(i=0; i<32; i++)
-				HalUsbInMpdu(Adapter, PipeIndex);
-			}
-			else
-			{
-				//HalUsbInMpdu(Adapter, PipeIndex);
-				//HalUsbInMpdu(Adapter, PipeIndex);
-				//HalUsbInMpdu(Adapter, PipeIndex);
-			}
-		}
-		PlatformReleaseSpinLock(Adapter, RT_RX_SPINLOCK);
-	}
-#else
-		// Joseph add to 819X code base for Vista USB platform.
-		// This part may need to be add to Hal819xU code base. too.
-	        PlatformUsbEnableInPipes(Adapter);
-#endif
-
-	RT_TRACE(COMP_INIT, "HighestOperaRate = %x\n", Adapter->MgntInfo.HighestOperaRate);
-
-	PlatformStartWorkItem( &(pHalData->RtUsbCheckForHangWorkItem) );
-
-	//
-	// <Roger_EXP> The following  configurations are for ASIC verification temporally.
-	// 2008.07.10.
-	//
-
-#endif
 
 	//
 	// Read EEPROM TX power index and PHY_REG_PG.txt to capture correct
diff --git a/drivers/staging/rtl8192su/r8192U_dm.c b/drivers/staging/rtl8192su/r8192U_dm.c
index 7891e96..b03a817 100644
--- a/drivers/staging/rtl8192su/r8192U_dm.c
+++ b/drivers/staging/rtl8192su/r8192U_dm.c
@@ -56,9 +56,6 @@ DRxPathSel	DM_RxPathSelTable;
 
 
 /*--------------------Define export function prototype-----------------------*/
-#ifdef TO_DO_LIST
-static	void dm_CheckProtection(struct net_device *dev);
-#endif
 extern	void	init_hal_dm(struct net_device *dev);
 extern	void deinit_hal_dm(struct net_device *dev);
 
@@ -133,9 +130,6 @@ static	void	dm_check_edca_turbo(struct net_device *dev);
 // DM --> HW RF control
 static	void	dm_check_rfctrl_gpio(struct net_device *dev);
 
-#ifndef RTL8190P
-//static	void	dm_gpio_change_rf(struct net_device *dev);
-#endif
 // DM --> Check PBC
 static	void dm_check_pbc_gpio(struct net_device *dev);
 
@@ -210,20 +204,6 @@ static void dm_CheckAggrPolicy(struct net_device *dev)
 	}
 	else if(!bAmsduEnable && pHTInfo->bCurrent_AMSDU_Support)
 	{
-#ifdef TO_DO_LIST
-		//PlatformAcquireSpinLock(Adapter, RT_TX_SPINLOCK);
-		for(QueueId = 0; QueueId < MAX_TX_QUEUE; QueueId++)
-		{
-			while(!RTIsListEmpty(&dev->TcbAggrQueue[QueueId]))
-			{
-				pTcb = (PRT_TCB)RTRemoveHeadList(&dev->TcbAggrQueue[QueueId]);
-				dev->TcbCountInAggrQueue[QueueId]--;
-				PreTransmitTCB(dev, pTcb);
-			}
-		}
-		//PlatformReleaseSpinLock(Adapter, RT_TX_SPINLOCK);
-		pHTInfo->bCurrent_AMSDU_Support = false;
-#endif
 	}
 
 	// Determine A-MPDU policy
@@ -294,24 +274,12 @@ extern  void    hal_dm_watchdog(struct net_device *dev)
 
 	dm_CheckAggrPolicy(dev);
 
-#ifdef TO_DO_LIST
-	dm_CheckProtection(dev);
-#endif
-
 	// ====================================================
 	// If any dynamic mechanism is ready, put it above this return;
 	// ====================================================
 	//if (IS_HARDWARE_TYPE_8192S(dev))
 	return;
 
-#ifdef TO_DO_LIST
-	if(Adapter->MgntInfo.mActingAsAp)
-	{
-		AP_dm_CheckRateAdaptive(dev);
-		//return;
-	}
-	else
-#endif
 	{
 		dm_check_rate_adaptive(dev);
 	}
@@ -693,11 +661,7 @@ static void dm_TXPowerTrackingCallback_TSSI(struct net_device * dev)
 			mdelay(1);
 			continue;
 		}
-#ifdef RTL8190P
-		Avg_TSSI_Meas = read_nic_word(dev, 0x1bc);
-#else
 		Avg_TSSI_Meas = read_nic_word(dev, 0x13c);
-#endif
 		if(Avg_TSSI_Meas == 0)
 		{
 			write_nic_byte(dev, 0x1ba, 0);
@@ -706,14 +670,10 @@ static void dm_TXPowerTrackingCallback_TSSI(struct net_device * dev)
 
 		for(k = 0;k < 5; k++)
 		{
-#ifdef RTL8190P
-			tmp_report[k] = read_nic_byte(dev, 0x1d8+k);
-#else
 			if(k !=4)
 				tmp_report[k] = read_nic_byte(dev, 0x134+k);
 			else
 				tmp_report[k] = read_nic_byte(dev, 0x13e);
-#endif
 			RT_TRACE(COMP_POWER_TRACKING, "TSSI_report_value = %d\n", tmp_report[k]);
 		}
 
@@ -760,10 +720,6 @@ static void dm_TXPowerTrackingCallback_TSSI(struct net_device * dev)
 			RT_TRACE(COMP_POWER_TRACKING, "tx power track is done\n");
 			RT_TRACE(COMP_POWER_TRACKING, "priv->rfa_txpowertrackingindex = %d\n", priv->rfa_txpowertrackingindex);
 			RT_TRACE(COMP_POWER_TRACKING, "priv->rfa_txpowertrackingindex_real = %d\n", priv->rfa_txpowertrackingindex_real);
-#ifdef RTL8190P
-			RT_TRACE(COMP_POWER_TRACKING, "priv->rfc_txpowertrackingindex = %d\n", priv->rfc_txpowertrackingindex);
-			RT_TRACE(COMP_POWER_TRACKING, "priv->rfc_txpowertrackingindex_real = %d\n", priv->rfc_txpowertrackingindex_real);
-#endif
 			RT_TRACE(COMP_POWER_TRACKING, "priv->cck_present_attentuation_difference = %d\n", priv->cck_present_attentuation_difference);
 			RT_TRACE(COMP_POWER_TRACKING, "priv->cck_present_attentuation = %d\n", priv->cck_present_attentuation);
 			return;
@@ -773,9 +729,6 @@ static void dm_TXPowerTrackingCallback_TSSI(struct net_device * dev)
 			if(Avg_TSSI_Meas_from_driver < TSSI_13dBm - E_FOR_TX_POWER_TRACK)
 			{
 				if((priv->rfa_txpowertrackingindex > 0)
-#ifdef RTL8190P
-					&&(priv->rfc_txpowertrackingindex > 0)
-#endif
 				)
 				{
 					priv->rfa_txpowertrackingindex--;
@@ -784,33 +737,17 @@ static void dm_TXPowerTrackingCallback_TSSI(struct net_device * dev)
 						priv->rfa_txpowertrackingindex_real--;
 						rtl8192_setBBreg(dev, rOFDM0_XATxIQImbalance, bMaskDWord, priv->txbbgain_table[priv->rfa_txpowertrackingindex_real].txbbgain_value);
 					}
-#ifdef RTL8190P
-					priv->rfc_txpowertrackingindex--;
-					if(priv->rfc_txpowertrackingindex_real > 4)
-					{
-						priv->rfc_txpowertrackingindex_real--;
-						rtl8192_setBBreg(dev, rOFDM0_XCTxIQImbalance, bMaskDWord, priv->txbbgain_table[priv->rfc_txpowertrackingindex_real].txbbgain_value);
-					}
-#endif
 				}
 			}
 			else
 			{
 				if((priv->rfa_txpowertrackingindex < 36)
-#ifdef RTL8190P
-					&&(priv->rfc_txpowertrackingindex < 36)
-#endif
 					)
 				{
 					priv->rfa_txpowertrackingindex++;
 					priv->rfa_txpowertrackingindex_real++;
 					rtl8192_setBBreg(dev, rOFDM0_XATxIQImbalance, bMaskDWord, priv->txbbgain_table[priv->rfa_txpowertrackingindex_real].txbbgain_value);
 
-#ifdef RTL8190P
-					priv->rfc_txpowertrackingindex++;
-					priv->rfc_txpowertrackingindex_real++;
-					rtl8192_setBBreg(dev, rOFDM0_XCTxIQImbalance, bMaskDWord, priv->txbbgain_table[priv->rfc_txpowertrackingindex_real].txbbgain_value);
-#endif
 				}
 			}
 			priv->cck_present_attentuation_difference
@@ -840,10 +777,6 @@ static void dm_TXPowerTrackingCallback_TSSI(struct net_device * dev)
 			}
 		RT_TRACE(COMP_POWER_TRACKING, "priv->rfa_txpowertrackingindex = %d\n", priv->rfa_txpowertrackingindex);
 		RT_TRACE(COMP_POWER_TRACKING, "priv->rfa_txpowertrackingindex_real = %d\n", priv->rfa_txpowertrackingindex_real);
-#ifdef RTL8190P
-		RT_TRACE(COMP_POWER_TRACKING, "priv->rfc_txpowertrackingindex = %d\n", priv->rfc_txpowertrackingindex);
-		RT_TRACE(COMP_POWER_TRACKING, "priv->rfc_txpowertrackingindex_real = %d\n", priv->rfc_txpowertrackingindex_real);
-#endif
 		RT_TRACE(COMP_POWER_TRACKING, "priv->cck_present_attentuation_difference = %d\n", priv->cck_present_attentuation_difference);
 		RT_TRACE(COMP_POWER_TRACKING, "priv->cck_present_attentuation = %d\n", priv->cck_present_attentuation);
 
@@ -985,14 +918,10 @@ extern	void	dm_txpower_trackingcallback(struct work_struct *work)
        struct r8192_priv *priv = container_of(dwork,struct r8192_priv,txpower_tracking_wq);
        struct net_device *dev = priv->ieee80211->dev;
 
-#ifdef RTL8190P
-	dm_TXPowerTrackingCallback_TSSI(dev);
-#else
 	if(priv->bDcut == TRUE)
 		dm_TXPowerTrackingCallback_TSSI(dev);
 	else
 		dm_TXPowerTrackingCallback_ThermalMeter(dev);
-#endif
 }
 
 
@@ -1504,13 +1433,9 @@ static void dm_InitializeTXPowerTracking_TSSI(struct net_device *dev)
 
 void dm_initialize_txpower_tracking(struct net_device *dev)
 {
-#if (defined RTL8190P)
-	dm_InitializeTXPowerTracking_TSSI(dev);
-#else
 	// 2009/01/12 MH Enable for 92S series channel 1-14 CCK tx pwer setting for MP.
 	//
 	dm_InitializeTXPowerTracking_TSSI(dev);
-#endif
 }// dm_InitializeTXPowerTracking
 
 
@@ -1576,14 +1501,10 @@ static void dm_check_txpower_tracking(struct net_device *dev)
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	//static u32 tx_power_track_counter = 0;
 
-#ifdef  RTL8190P
-	dm_CheckTXPowerTracking_TSSI(dev);
-#else
 	if(priv->bDcut == TRUE)
 		dm_CheckTXPowerTracking_TSSI(dev);
 	else
 		dm_CheckTXPowerTracking_ThermalMeter(dev);
-#endif
 
 }	// dm_CheckTXPowerTracking
 
@@ -1709,14 +1630,10 @@ extern void dm_cck_txpower_adjust(
 {	// dm_CCKTxPowerAdjust
 
 	struct r8192_priv *priv = ieee80211_priv(dev);
-#ifdef RTL8190P
-	dm_CCKTxPowerAdjust_TSSI(dev, binch14);
-#else
 	if(priv->bDcut == TRUE)
 		dm_CCKTxPowerAdjust_TSSI(dev, binch14);
 	else
 		dm_CCKTxPowerAdjust_ThermalMeter(dev, binch14);
-#endif
 }
 
 
@@ -2298,11 +2215,7 @@ static void dm_ctrl_initgain_byrssi_by_fwfalse_alarm(
 		{
 			/* 2008/01/11 MH 40MHZ 90/92 register are not the same. */
 			// 2008/02/05 MH SD3-Jerry 92U/92E PD_TH are the same.
-			#ifdef RTL8190P
-				write_nic_byte(dev, rOFDM0_RxDetector1, 0x42);
-			#else
 				write_nic_byte(dev, (rOFDM0_XATxAFE+3), 0x20);
-			#endif
 			/*
 			else if (priv->card_8192 == HARDWARE_TYPE_RTL8190P)
 				write_nic_byte(dev, rOFDM0_RxDetector1, 0x42);
@@ -2398,11 +2311,7 @@ static void dm_ctrl_initgain_byrssi_highpwr(
 			// 3.2 Recover PD_TH for OFDM for normal power region.
 			if (priv->CurrentChannelBW != HT_CHANNEL_WIDTH_20)
 			{
-				#ifdef RTL8190P
-					write_nic_byte(dev, rOFDM0_RxDetector1, 0x42);
-				#else
 					write_nic_byte(dev, (rOFDM0_XATxAFE+3), 0x20);
-				#endif
 				/*else if (priv->card_8192 == HARDWARE_TYPE_RTL8190P)
 					write_nic_byte(dev, rOFDM0_RxDetector1, 0x42);
 				*/
@@ -2557,11 +2466,7 @@ static void dm_pd_th(
 				{
 					/* 2008/01/11 MH 40MHZ 90/92 register are not the same. */
 					// 2008/02/05 MH SD3-Jerry 92U/92E PD_TH are the same.
-					#ifdef RTL8190P
-						write_nic_byte(dev, rOFDM0_RxDetector1, 0x42);
-					#else
 						write_nic_byte(dev, (rOFDM0_XATxAFE+3), 0x20);
-					#endif
 					/*else if (priv->card_8192 == HARDWARE_TYPE_RTL8190P)
 						write_nic_byte(dev, rOFDM0_RxDetector1, 0x42);
 					*/
@@ -2574,11 +2479,7 @@ static void dm_pd_th(
 				// Higher PD_TH for OFDM for high power state.
 				if (priv->CurrentChannelBW != HT_CHANNEL_WIDTH_20)
 				{
-					#ifdef RTL8190P
-						write_nic_byte(dev, rOFDM0_RxDetector1, 0x41);
-					#else
 						write_nic_byte(dev, (rOFDM0_XATxAFE+3), 0x10);
-					#endif
 					/*else if (priv->card_8192 == HARDWARE_TYPE_RTL8190P)
 						write_nic_byte(dev, rOFDM0_RxDetector1, 0x41);
 					*/
@@ -2913,16 +2814,7 @@ static void dm_check_rfctrl_gpio(struct net_device * dev)
 	// from S4. 20080218, Emily
 
 	// Stop to execute workitem to prevent S3/S4 bug.
-#ifdef RTL8190P
-	return;
-#endif
-#ifdef RTL8192U
-	return;
-#endif
 	return;
-#ifdef RTL8192E
-		queue_delayed_work(priv->priv_wq,&priv->gpio_change_rf_wq,0);
-#endif
 
 }	/* dm_CheckRfCtrlGPIO */
 
@@ -2991,79 +2883,6 @@ static	void	dm_check_pbc_gpio(struct net_device *dev)
 
 }
 
-#ifdef RTL8192E
-
-/*-----------------------------------------------------------------------------
- * Function:	dm_GPIOChangeRF
- * Overview:	PCI will not support workitem call back HW radio on-off control.
- *
- * Input:		NONE
- *
- * Output:		NONE
- *
- * Return:		NONE
- *
- * Revised History:
- *	When		Who		Remark
- *	02/21/2008	MHC		Create Version 0.
- *
- *---------------------------------------------------------------------------*/
-extern	void	dm_gpio_change_rf_callback(struct work_struct *work)
-{
-	struct delayed_work *dwork = container_of(work,struct delayed_work,work);
-       struct r8192_priv *priv = container_of(dwork,struct r8192_priv,gpio_change_rf_wq);
-       struct net_device *dev = priv->ieee80211->dev;
-	u8 tmp1byte;
-	RT_RF_POWER_STATE	eRfPowerStateToSet;
-	bool bActuallySet = false;
-
-	do{
-		bActuallySet=false;
-
-		if(!priv->up)
-		{
-			RT_TRACE((COMP_INIT | COMP_POWER | COMP_RF),"dm_gpio_change_rf_callback(): Callback function breaks out!!\n");
-		}
-		else
-		{
-			// 0x108 GPIO input register is read only
-			//set 0x108 B1= 1: RF-ON; 0: RF-OFF.
-			tmp1byte = read_nic_byte(dev,GPI);
-
-			eRfPowerStateToSet = (tmp1byte&BIT1) ?  eRfOn : eRfOff;
-
-			if( (priv->bHwRadioOff == true) && (eRfPowerStateToSet == eRfOn))
-			{
-				RT_TRACE(COMP_RF, "gpiochangeRF  - HW Radio ON\n");
-
-				priv->bHwRadioOff = false;
-				bActuallySet = true;
-			}
-			else if ( (priv->bHwRadioOff == false) && (eRfPowerStateToSet == eRfOff))
-			{
-				RT_TRACE(COMP_RF, "gpiochangeRF  - HW Radio OFF\n");
-				priv->bHwRadioOff = true;
-				bActuallySet = true;
-			}
-
-			if(bActuallySet)
-			{
-				#ifdef TO_DO
-				MgntActSet_RF_State(dev, eRfPowerStateToSet, RF_CHANGE_BY_HW);
-				//DrvIFIndicateCurrentPhyStatus(pAdapter);
-				#endif
-			}
-			else
-			{
-				msleep(2000);
-			}
-
-		}
-	}while(TRUE)
-
-}	/* dm_GPIOChangeRF */
-
-#endif
 /*-----------------------------------------------------------------------------
  * Function:	DM_RFPathCheckWorkItemCallBack()
  *
@@ -3421,11 +3240,7 @@ static void dm_init_fsync (struct net_device *dev)
 	priv->ieee80211->fsync_time_interval = 500;
 	priv->ieee80211->fsync_rate_bitmap = 0x0f000800;
 	priv->ieee80211->fsync_rssi_threshold = 30;
-#ifdef RTL8190P
-	priv->ieee80211->bfsync_enable = true;
-#else
 	priv->ieee80211->bfsync_enable = false;
-#endif
 	priv->ieee80211->fsync_multiple_timeinterval = 3;
 	priv->ieee80211->fsync_firstdiff_ratethreshold= 100;
 	priv->ieee80211->fsync_seconddiff_ratethreshold= 200;
@@ -3508,20 +3323,12 @@ extern void dm_fsync_timer_callback(unsigned long data)
 			priv->bswitch_fsync = !priv->bswitch_fsync;
 			if(priv->bswitch_fsync)
 			{
-			#ifdef RTL8190P
-				write_nic_byte(dev, 0xC36, 0x00);
-			#else
 				write_nic_byte(dev,0xC36, 0x1c);
-			#endif
 				write_nic_byte(dev, 0xC3e, 0x90);
 			}
 			else
 			{
-			#ifdef RTL8190P
-				write_nic_byte(dev, 0xC36, 0x40);
-			#else
 				write_nic_byte(dev, 0xC36, 0x5c);
-			#endif
 				write_nic_byte(dev, 0xC3e, 0x96);
 			}
 		}
@@ -3530,11 +3337,7 @@ extern void dm_fsync_timer_callback(unsigned long data)
 			if(priv->bswitch_fsync)
 			{
 				priv->bswitch_fsync  = false;
-			#ifdef RTL8190P
-				write_nic_byte(dev, 0xC36, 0x40);
-			#else
 				write_nic_byte(dev, 0xC36, 0x5c);
-			#endif
 				write_nic_byte(dev, 0xC3e, 0x96);
 			}
 		}
@@ -3557,11 +3360,7 @@ extern void dm_fsync_timer_callback(unsigned long data)
 		if(priv->bswitch_fsync)
 		{
 			priv->bswitch_fsync  = false;
-		#ifdef RTL8190P
-			write_nic_byte(dev, 0xC36, 0x40);
-		#else
 			write_nic_byte(dev, 0xC36, 0x5c);
-		#endif
 			write_nic_byte(dev, 0xC3e, 0x96);
 		}
 		priv->ContiuneDiffCount = 0;
@@ -3590,19 +3389,12 @@ static void dm_EndSWFsync(struct net_device *dev)
 	{
 		priv->bswitch_fsync  = false;
 
-		#ifdef RTL8190P
-			write_nic_byte(dev, 0xC36, 0x40);
-		#else
 			write_nic_byte(dev, 0xC36, 0x5c);
-		#endif
 
 		write_nic_byte(dev, 0xC3e, 0x96);
 	}
 
 	priv->ContiuneDiffCount = 0;
-#ifndef RTL8190P
-	write_nic_dword(dev, rOFDM0_RxDetector2, 0x465c52cd);
-#endif
 
 }
 
@@ -3641,10 +3433,6 @@ static void dm_StartSWFsync(struct net_device *dev)
 	priv->fsync_timer.expires = jiffies + MSECS(priv->ieee80211->fsync_time_interval);
 	add_timer(&priv->fsync_timer);
 
-#ifndef RTL8190P
-	write_nic_dword(dev, rOFDM0_RxDetector2, 0x465c12cd);
-#endif
-
 }
 
 static void dm_EndHWFsync(struct net_device *dev)
@@ -3712,11 +3500,7 @@ void dm_check_fsync(struct net_device *dev)
 		{
 			if(reg_c38_State != RegC38_Fsync_AP_BCM)
 			{	//For broadcom AP we write different default value
-				#ifdef RTL8190P
-					write_nic_byte(dev, rOFDM0_RxDetector3, 0x15);
-				#else
 					write_nic_byte(dev, rOFDM0_RxDetector3, 0x95);
-				#endif
 
 				reg_c38_State = RegC38_Fsync_AP_BCM;
 			}
@@ -3747,11 +3531,7 @@ void dm_check_fsync(struct net_device *dev)
 				{
 					if(reg_c38_State != RegC38_NonFsync_Other_AP)
 					{
-						#ifdef RTL8190P
-							write_nic_byte(dev, rOFDM0_RxDetector3, 0x10);
-						#else
 							write_nic_byte(dev, rOFDM0_RxDetector3, 0x90);
-						#endif
 
 						reg_c38_State = RegC38_NonFsync_Other_AP;
 					}
@@ -3954,24 +3734,5 @@ static void dm_send_rssi_tofw(struct net_device *dev)
 {
 }
 
-#ifdef TO_DO_LIST
-static	void
-dm_CheckProtection(struct net_device *dev)
-{
-	struct r8192_priv *priv = ieee80211_priv(dev);
-	//PMGNT_INFO		pMgntInfo = &(Adapter->MgntInfo);
-	u8			CurRate;
-
-	if(priv->ieee80211->pHTInfo->IOTAction & (HT_IOT_ACT_FORCED_RTS|HT_IOT_ACT_FORCED_CTS2SELF))
-	{
-		CurRate = read_nic_byte(dev, INIMCS_SEL);
-		if(CurRate <= DESC92S_RATE11M)
-			priv->bDmDisableProtect = true;
-		else
-			priv->bDmDisableProtect = fasle;
-	}
-}
-#endif
-
 /*---------------------------Define function prototype------------------------*/
 
