Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:64350 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaJYTfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:35:25 -0400
Received: by mail-wg0-f47.google.com with SMTP id x13so3129907wgg.30
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:35:24 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 41/48] staging: vt6655: struct vnt_private remove dead members
Date: Sat, 25 Oct 2014 09:40:19 +0100
Message-Id: <1414226426-5811-42-git-send-email-tvboxspy@gmail.com> (sfid-20141025_213528_871338_B05BE3D4)
In-Reply-To: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
References: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h | 158 +---------------------------------------
 1 file changed, 1 insertion(+), 157 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 1d1b0fb..a26e904 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -322,8 +322,6 @@ struct vnt_private {
 	u16 current_aid;
 	int mc_list_count;
 	u8 mac_hw;
-// netdev
-	struct net_device *dev;
 
 //dma addr, rx/tx pool
 	dma_addr_t                  pool_dma;
@@ -383,10 +381,6 @@ struct vnt_private {
 	u8 rx_rate;
 	int                         multicast_limit;
 
-	pid_t			MLMEThr_pid;
-	struct completion	notify;
-	struct semaphore	mlme_semaphore;
-
 	u32                         rx_bytes;
 
 	// Version control
@@ -397,7 +391,7 @@ struct vnt_private {
 	unsigned char byZoneType;
 	bool bZoneRegExist;
 	unsigned char byOriginalZonetype;
-	unsigned char abyMacContext[MAC_MAX_CONTEXT_REG];
+
 	unsigned char abyCurrentNetAddr[ETH_ALEN];
 	bool bLinkPass;          // link status: OK or fail
 
@@ -455,14 +449,6 @@ struct vnt_private {
 	unsigned char byOpMode;
 	bool bBSSIDFilter;
 	unsigned short wMaxTransmitMSDULifetime;
-	unsigned char abyBSSID[ETH_ALEN];
-	unsigned char abyDesireBSSID[ETH_ALEN];
-	unsigned short wACKDuration;       // update while speed change
-	unsigned short wRTSTransmitLen;    // update while speed change
-	unsigned char byRTSServiceField;  // update while speed change
-	unsigned char byRTSSignalField;   // update while speed change
-
-	unsigned long dwMaxReceiveLifetime;       // dot11MaxReceiveLifetime
 
 	bool bEncryptionEnable;
 	bool bLongHeader;
@@ -471,9 +457,6 @@ struct vnt_private {
 	bool bNonERPPresent;
 	bool bBarkerPreambleMd;
 
-	unsigned char byERPFlag;
-	unsigned short wUseProtectCntDown;
-
 	bool bRadioControlOff;
 	bool bRadioOff;
 	bool bEnablePSMode;
@@ -496,64 +479,11 @@ struct vnt_private {
 	unsigned int	cbBeaconBufReadySetCnt;
 	bool bFixRate;
 	unsigned char byCurrentCh;
-	unsigned int	uScanTime;
-
-	bool bBeaconTx;
-
-	bool bStopBeacon;
-	bool bStopDataPkt;
-	bool bStopTx0Pkt;
-	unsigned int	uAutoReConnectTime;
-
-	// 802.11 counter
-
-	unsigned int	uCmdDequeueIdx;
-	unsigned int	uCmdEnqueueIdx;
-	unsigned int	cbFreeCmdQueue;
-	bool bCmdRunning;
-	bool bCmdClear;
-
-	bool bRoaming;
-	//WOW
-	unsigned char abyIPAddr[4];
-
-	unsigned long ulTxPower;
-	NDIS_802_11_WEP_STATUS  eEncryptionStatus;
-	bool bTransmitKey;
-//2007-0925-01<Add>by MikeLiu
-//mike add :save old Encryption
-	NDIS_802_11_WEP_STATUS  eOldEncryptionStatus;
-
-	unsigned long dwIVCounter;
-
-	u64 qwPacketNumber; /* For CCMP and TKIP as TSC(6 bytes) */
-	unsigned int	uCurrentWEPMode;
-
-	unsigned char abyPRNG[WLAN_WEPMAX_KEYLEN+3];
-	unsigned char byKeyIndex;
-	unsigned int	uKeyLength;
-	unsigned char abyKey[WLAN_WEP232_KEYLEN];
 
 	bool bAES;
-	unsigned char byCntMeasure;
-
-	// for AP mode
-	unsigned int	uAssocCount;
-	bool bMoreData;
-
-	// QoS
-	bool bGrpAckPolicy;
-
-	// for OID_802_11_ASSOCIATION_INFORMATION
-	bool bAssocInfoSet;
 
 	unsigned char byAutoFBCtrl;
 
-	bool bTxMICFail;
-	bool bRxMICFail;
-
-	unsigned int	uRATEIdx;
-
 	// For Update BaseBand VGA Gain Offset
 	bool bUpdateBBVGA;
 	unsigned int	uBBVGADiffCount;
@@ -565,23 +495,11 @@ struct vnt_private {
 	unsigned char byBBPreEDRSSI;
 	unsigned char byBBPreEDIndex;
 
-	bool bRadioCmd;
 	unsigned long dwDiagRefCount;
 
 	// For FOE Tuning
 	unsigned char byFOETuning;
 
-	// For Auto Power Tunning
-
-	unsigned char byAutoPwrTunning;
-	short                   sPSetPointCCK;
-	short                   sPSetPointOFDMG;
-	short                   sPSetPointOFDMA;
-	long                    lPFormulaOffset;
-	short                   sPThreshold;
-	char                    cAdjustStep;
-	char                    cMinTxAGC;
-
 	// For RF Power table
 	unsigned char byCCKPwr;
 	unsigned char byOFDMPwrG;
@@ -600,21 +518,6 @@ struct vnt_private {
 	unsigned char byBBCR88;
 	unsigned char byBBCR09;
 
-	// command timer
-	struct timer_list       sTimerCommand;
-	struct timer_list       sTimerTxData;
-	unsigned long nTxDataTimeCout;
-	bool fTxDataInSleep;
-	bool IsTxDataTrigger;
-
-#ifdef WPA_SM_Transtatus
-	bool fWPA_Authened;           //is WPA/WPA-PSK or WPA2/WPA2-PSK authen??
-#endif
-	unsigned char byReAssocCount;   //mike add:re-association retry times!
-	unsigned char byLinkWaitCount;
-
-	unsigned char abyNodeName[17];
-
 	bool bDiversityRegCtlON;
 	bool bDiversityEnable;
 	unsigned long ulDiversityNValue;
@@ -645,73 +548,14 @@ struct vnt_private {
 
 	// for 802.11h
 	bool b11hEnable;
-	unsigned char abyCountryCode[3];
-	// for 802.11h DFS
-	unsigned int	uNumOfMeasureEIDs;
-	bool bMeasureInProgress;
-	unsigned char byOrgChannel;
-	unsigned char byOrgRCR;
-	unsigned long dwOrgMAR0;
-	unsigned long dwOrgMAR4;
-	unsigned char byBasicMap;
-	unsigned char byCCAFraction;
-	unsigned char abyRPIs[8];
-	unsigned long dwRPIs[8];
-	bool bChannelSwitch;
-	unsigned char byNewChannel;
-	unsigned char byChannelSwitchCount;
-	bool bQuietEnable;
-	bool bEnableFirstQuiet;
-	unsigned char byQuietStartCount;
-	unsigned int	uQuietEnqueue;
-	unsigned long dwCurrentQuietEndTime;
-	SQuietControl           sQuiet[MAX_QUIET_COUNT];
-	// for 802.11h TPC
-	bool bCountryInfo5G;
-	bool bCountryInfo24G;
 
 	unsigned short wBeaconInterval;
 
-	//WPA supplicant deamon
-	struct net_device       *wpadev;
-	bool bWPADEVUp;
-	struct sk_buff          *skb;
-#ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-	unsigned int	bwextcount;
-	bool bWPASuppWextEnabled;
-#endif
-
-	//--
-#ifdef HOSTAP
-	// user space daemon: hostapd, is used for HOSTAP
-	bool bEnableHostapd;
-	bool bEnable8021x;
-	bool bEnableHostWEP;
-	struct net_device       *apdev;
-	int (*tx_80211)(struct sk_buff *skb, struct net_device *dev);
-#endif
 	unsigned int	uChannel;
-	bool bMACSuspend;
 
 	struct iw_statistics	wstats;		// wireless stats
-	bool bCommit;
 };
 
-static inline bool device_get_ip(struct vnt_private *pInfo)
-{
-	struct in_device *in_dev = (struct in_device *)pInfo->dev->ip_ptr;
-	struct in_ifaddr *ifa;
-
-	if (in_dev != NULL) {
-		ifa = (struct in_ifaddr *)in_dev->ifa_list;
-		if (ifa != NULL) {
-			memcpy(pInfo->abyIPAddr, &ifa->ifa_address, 4);
-			return true;
-		}
-	}
-	return false;
-}
-
 static inline PDEVICE_RD_INFO alloc_rd_info(void)
 {
 	return kzalloc(sizeof(DEVICE_RD_INFO), GFP_ATOMIC);
-- 
1.9.1

