Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:50377 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab2LJWTm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 17:19:42 -0500
Received: by mail-wg0-f46.google.com with SMTP id dr13so2054416wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 14:19:41 -0800 (PST)
Message-ID: <1355177973.4680.26.camel@canaries64> (sfid-20121210_231959_374429_B8966D18)
Subject: [PATCH 10/11] staging: vt6656: clean up struct vnt_private.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 10 Dec 2012 22:19:33 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Replacing types defined in "ttype.h" with linux/types.h.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 721 +++++++++++++++++++---------------------
 1 file changed, 349 insertions(+), 372 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 1d2e234..e153beb 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -393,426 +393,403 @@ typedef struct __device_opt {
 

 struct vnt_private {
+	/* netdev */
+	struct usb_device *usb;
+	struct net_device *dev;
+	struct net_device_stats stats;
 
-// netdev
-	struct usb_device*          usb;
-    struct net_device*          dev;
-    struct net_device_stats     stats;
+	OPTIONS sOpts;
 
+	struct tasklet_struct CmdWorkItem;
+	struct tasklet_struct EventWorkItem;
+	struct tasklet_struct ReadWorkItem;
+	struct tasklet_struct RxMngWorkItem;
 
-    OPTIONS                     sOpts;
+	u32 rx_buf_sz;
+	int multicast_limit;
+	u8 byRxMode;
 
-	struct tasklet_struct       CmdWorkItem;
-	struct tasklet_struct       EventWorkItem;
-	struct tasklet_struct       ReadWorkItem;
-	struct tasklet_struct       RxMngWorkItem;
+	spinlock_t lock;
 
-    u32                         rx_buf_sz;
-    int                         multicast_limit;
-    BYTE                        byRxMode;
+	u32 rx_bytes;
 
-    spinlock_t                  lock;
+	u8 byRevId;
 
-    u32                         rx_bytes;
+	u32 flags;
+	unsigned long Flags;
 
-    BYTE                        byRevId;
+	SCache sDupRxCache;
 
-    u32                         flags;
-    unsigned long                       Flags;
+	SDeFragControlBlock sRxDFCB[CB_MAX_RX_FRAG];
+	u32 cbDFCB;
+	u32 cbFreeDFCB;
+	u32 uCurrentDFCBIdx;
 
-    SCache                      sDupRxCache;
 
-    SDeFragControlBlock         sRxDFCB[CB_MAX_RX_FRAG];
-    unsigned int                        cbDFCB;
-    unsigned int                        cbFreeDFCB;
-    unsigned int                        uCurrentDFCBIdx;
+	/* USB */
+	struct urb *pControlURB;
+	struct urb *pInterruptURB;
+	struct usb_ctrlrequest sUsbCtlRequest;
+	u32 int_interval;
 
-    // +++USB
-
-    struct urb                  *pControlURB;
-    struct urb                  *pInterruptURB;
-	struct usb_ctrlrequest      sUsbCtlRequest;
-
-    unsigned int                        int_interval;
-    //
-    // Variables to track resources for the BULK In Pipe
-    //
-    PRCB                        pRCBMem;
-    PRCB                        apRCB[CB_MAX_RX_DESC];
-    unsigned int                        cbRD;
-    PRCB                        FirstRecvFreeList;
-    PRCB                        LastRecvFreeList;
-    unsigned int                        NumRecvFreeList;
-    PRCB                        FirstRecvMngList;
-    PRCB                        LastRecvMngList;
-    unsigned int                        NumRecvMngList;
-    BOOL                        bIsRxWorkItemQueued;
-    BOOL                        bIsRxMngWorkItemQueued;
+	/* Variables to track resources for the BULK In Pipe */
+	PRCB pRCBMem;
+	PRCB apRCB[CB_MAX_RX_DESC];
+	u32 cbRD;
+	PRCB FirstRecvFreeList;
+	PRCB LastRecvFreeList;
+	u32 NumRecvFreeList;
+	PRCB FirstRecvMngList;
+	PRCB LastRecvMngList;
+	u32 NumRecvMngList;
+	int bIsRxWorkItemQueued;
+	int bIsRxMngWorkItemQueued;
 	unsigned long ulRcvRefCount; /* packets that have not returned back */
 
-    //
-    //  Variables to track resources for the BULK Out Pipe
-    //
-
-    PUSB_SEND_CONTEXT           apTD[CB_MAX_TX_DESC];
-    unsigned int                        cbTD;
-
-    //
-    //  Variables to track resources for the Interrupt In Pipe
-    //
-    INT_BUFFER                  intBuf;
-    BOOL                        fKillEventPollingThread;
-    BOOL                        bEventAvailable;
+	/* Variables to track resources for the BULK Out Pipe */
+	PUSB_SEND_CONTEXT apTD[CB_MAX_TX_DESC];
+	u32 cbTD;
 
+	/* Variables to track resources for the Interrupt In Pipe */
+	INT_BUFFER intBuf;
+	int fKillEventPollingThread;
+	int bEventAvailable;
 
-  //default config from file by user setting
-    DEFAULT_CONFIG    config_file;
+	/* default config from file by user setting */
+	DEFAULT_CONFIG config_file;
 

-    //
-    // Statistic for USB
-    // protect with spinlock
-    unsigned long                       ulBulkInPosted;
-    unsigned long                       ulBulkInError;
-    unsigned long                       ulBulkInContCRCError;
-    unsigned long                       ulBulkInBytesRead;
+	/* Statistic for USB */
+	unsigned long ulBulkInPosted;
+	unsigned long ulBulkInError;
+	unsigned long ulBulkInContCRCError;
+	unsigned long ulBulkInBytesRead;
 
-    unsigned long                       ulBulkOutPosted;
-    unsigned long                       ulBulkOutError;
-    unsigned long                       ulBulkOutContCRCError;
-    unsigned long                       ulBulkOutBytesWrite;
+	unsigned long ulBulkOutPosted;
+	unsigned long ulBulkOutError;
+	unsigned long ulBulkOutContCRCError;
+	unsigned long ulBulkOutBytesWrite;
 
-    unsigned long                       ulIntInPosted;
-    unsigned long                       ulIntInError;
-    unsigned long                       ulIntInContCRCError;
-    unsigned long                       ulIntInBytesRead;
+	unsigned long ulIntInPosted;
+	unsigned long ulIntInError;
+	unsigned long ulIntInContCRCError;
+	unsigned long ulIntInBytesRead;
 

-    // Version control
-    WORD                        wFirmwareVersion;
-    BYTE                        byLocalID;
-    BYTE                        byRFType;
-    BYTE                        byBBRxConf;
+	/* Version control */
+	u16 wFirmwareVersion;
+	u8 byLocalID;
+	u8 byRFType;
+	u8 byBBRxConf;
 

-    BYTE                        byZoneType;
-    BOOL                        bZoneRegExist;
+	u8 byZoneType;
+	int bZoneRegExist;
 
-    BYTE                        byOriginalZonetype;
+	u8 byOriginalZonetype;
 
-    BOOL                        bLinkPass;          // link status: OK or fail
-    BYTE                        abyCurrentNetAddr[ETH_ALEN];
-    BYTE                        abyPermanentNetAddr[ETH_ALEN];
-    // SW network address
-	/* u8 abySoftwareNetAddr[ETH_ALEN]; */
-    BOOL                        bExistSWNetAddr;
+	int bLinkPass; /* link status: OK or fail */
+	u8 abyCurrentNetAddr[ETH_ALEN];
+	u8 abyPermanentNetAddr[ETH_ALEN];
 
-    // Adapter statistics
-    SStatCounter                scStatistic;
-    // 802.11 counter
-    SDot11Counters              s802_11Counter;
+	int bExistSWNetAddr;
 
-    //
-    // Maintain statistical debug info.
-    //
-    unsigned long                       packetsReceived;
-    unsigned long                       packetsReceivedDropped;
-    unsigned long                       packetsReceivedOverflow;
-    unsigned long                       packetsSent;
-    unsigned long                       packetsSentDropped;
-    unsigned long                       SendContextsInUse;
-    unsigned long                       RcvBuffersInUse;
+	/* Adapter statistics */
+	SStatCounter scStatistic;
+	/* 802.11 counter */
+	SDot11Counters s802_11Counter;
 
+	/* Maintain statistical debug info. */
+	unsigned long packetsReceived;
+	unsigned long packetsReceivedDropped;
+	unsigned long packetsReceivedOverflow;
+	unsigned long packetsSent;
+	unsigned long packetsSentDropped;
+	unsigned long SendContextsInUse;
+	unsigned long RcvBuffersInUse;
 
 	/* 802.11 management */
 	struct vnt_manager vnt_mgmt;
 
 	u64 qwCurrTSF;
-    unsigned int                        cbBulkInMax;
-    BOOL                        bPSRxBeacon;
-
-    // 802.11 MAC specific
-    unsigned int                        uCurrRSSI;
-    BYTE                        byCurrSQ;
-
-
-    //Antenna Diversity
-    BOOL                        bTxRxAntInv;
-    DWORD                       dwRxAntennaSel;
-    DWORD                       dwTxAntennaSel;
-    BYTE                        byAntennaCount;
-    BYTE                        byRxAntennaMode;
-    BYTE                        byTxAntennaMode;
-    BYTE                        byRadioCtl;
-    BYTE                        bHWRadioOff;
-
-    //SQ3 functions for antenna diversity
-    struct timer_list           TimerSQ3Tmax1;
-    struct timer_list           TimerSQ3Tmax2;
-    struct timer_list           TimerSQ3Tmax3;
-
-    BOOL                        bDiversityRegCtlON;
-    BOOL                        bDiversityEnable;
-    unsigned long                       ulDiversityNValue;
-    unsigned long                       ulDiversityMValue;
-    BYTE                        byTMax;
-    BYTE                        byTMax2;
-    BYTE                        byTMax3;
-    unsigned long                       ulSQ3TH;
-
-    unsigned long                       uDiversityCnt;
-    BYTE                        byAntennaState;
-    unsigned long                       ulRatio_State0;
-    unsigned long                       ulRatio_State1;
-    unsigned long                       ulSQ3_State0;
-    unsigned long                       ulSQ3_State1;
-
-    unsigned long                       aulSQ3Val[MAX_RATE];
-    unsigned long                       aulPktNum[MAX_RATE];
+	u32 cbBulkInMax;
+	int bPSRxBeacon;
+
+	/* 802.11 MAC specific */
+	u32 uCurrRSSI;
+	u8 byCurrSQ;
+
+	/* Antenna Diversity */
+	int bTxRxAntInv;
+	u32 dwRxAntennaSel;
+	u32 dwTxAntennaSel;
+	u8 byAntennaCount;
+	u8 byRxAntennaMode;
+	u8 byTxAntennaMode;
+	u8 byRadioCtl;
+	u8 bHWRadioOff;
+
+	/* SQ3 functions for antenna diversity */
+	struct timer_list TimerSQ3Tmax1;
+	struct timer_list TimerSQ3Tmax2;
+	struct timer_list TimerSQ3Tmax3;
+
+	int bDiversityRegCtlON;
+	int bDiversityEnable;
+	unsigned long ulDiversityNValue;
+	unsigned long ulDiversityMValue;
+	u8 byTMax;
+	u8 byTMax2;
+	u8 byTMax3;
+	unsigned long ulSQ3TH;
+
+	unsigned long uDiversityCnt;
+	u8 byAntennaState;
+	unsigned long ulRatio_State0;
+	unsigned long ulRatio_State1;
+	unsigned long ulSQ3_State0;
+	unsigned long ulSQ3_State1;
+
+	unsigned long aulSQ3Val[MAX_RATE];
+	unsigned long aulPktNum[MAX_RATE];
 
 	/* IFS & Cw */
-	unsigned int uSIFS;  /* Current SIFS */
-	unsigned int uDIFS;  /* Current DIFS */
-	unsigned int uEIFS;  /* Current EIFS */
-	unsigned int uSlot;  /* Current SlotTime */
-	unsigned int uCwMin; /* Current CwMin */
-	unsigned int uCwMax; /* CwMax is fixed on 1023 */
-
-    // PHY parameter
-    BYTE                        bySIFS;
-    BYTE                        byDIFS;
-    BYTE                        byEIFS;
-    BYTE                        bySlot;
-    BYTE                        byCWMaxMin;
-
-    // Rate
-    VIA_BB_TYPE                 byBBType; //0: 11A, 1:11B, 2:11G
-    VIA_PKT_TYPE                byPacketType; //0:11a,1:11b,2:11gb(only CCK in BasicRate),3:11ga(OFDM in Basic Rate)
-    WORD                        wBasicRate;
-    BYTE                        byACKRate;
-    BYTE                        byTopOFDMBasicRate;
-    BYTE                        byTopCCKBasicRate;
-
-
-    DWORD                       dwAotoRateTxOkCnt;
-    DWORD                       dwAotoRateTxFailCnt;
-    DWORD                       dwErrorRateThreshold[13];
-    DWORD                       dwTPTable[MAX_RATE];
-    BYTE                        abyEEPROM[EEP_MAX_CONTEXT_SIZE];  //DWORD alignment
-
-    BYTE                        byMinChannel;
-    BYTE                        byMaxChannel;
-    unsigned int                        uConnectionRate;
-
-    BYTE                        byPreambleType;
-    BYTE                        byShortPreamble;
-    // CARD_PHY_TYPE
-    BYTE                        eConfigPHYMode;
-
-    // For RF Power table
-    BYTE                        byCCKPwr;
-    BYTE                        byOFDMPwrG;
-    BYTE                        byOFDMPwrA;
-    BYTE                        byCurPwr;
-    BYTE                        abyCCKPwrTbl[14];
-    BYTE                        abyOFDMPwrTbl[14];
-    BYTE                        abyOFDMAPwrTbl[42];
-
-    WORD                        wCurrentRate;
-    WORD                        wRTSThreshold;
-    WORD                        wFragmentationThreshold;
-    BYTE                        byShortRetryLimit;
-    BYTE                        byLongRetryLimit;
-    CARD_OP_MODE                eOPMode;
-    BOOL                        bBSSIDFilter;
-    WORD                        wMaxTransmitMSDULifetime;
-    BYTE                        abyBSSID[ETH_ALEN];
-    BYTE                        abyDesireBSSID[ETH_ALEN];
-    WORD                        wCTSDuration;       // update while speed change
-    WORD                        wACKDuration;       // update while speed change
-    WORD                        wRTSTransmitLen;    // update while speed change
-    BYTE                        byRTSServiceField;  // update while speed change
-    BYTE                        byRTSSignalField;   // update while speed change
-
-    DWORD                       dwMaxReceiveLifetime;       // dot11MaxReceiveLifetime
-
-    BOOL                        bCCK;
-    BOOL                        bEncryptionEnable;
-    BOOL                        bLongHeader;
-    BOOL                        bSoftwareGenCrcErr;
-    BOOL                        bShortSlotTime;
-    BOOL                        bProtectMode;
-    BOOL                        bNonERPPresent;
-    BOOL                        bBarkerPreambleMd;
-
-    BYTE                        byERPFlag;
-    WORD                        wUseProtectCntDown;
-
-    BOOL                        bRadioControlOff;
-    BOOL                        bRadioOff;
-
-    // Power save
-    BOOL                        bEnablePSMode;
-    WORD                        wListenInterval;
-    BOOL                        bPWBitOn;
-    WMAC_POWER_MODE             ePSMode;
-    unsigned long                       ulPSModeWaitTx;
-    BOOL                        bPSModeTxBurst;
-
-    // Beacon releated
-    WORD                    wSeqCounter;
-    BOOL                    bBeaconBufReady;
-    BOOL                    bBeaconSent;
-    BOOL                    bFixRate;
-    BYTE                    byCurrentCh;
-    unsigned int                    uScanTime;
-
-    CMD_STATE               eCommandState;
-
-    CMD_CODE                eCommand;
-    BOOL                    bBeaconTx;
-    BYTE                    byScanBBType;
-
-    BOOL                    bStopBeacon;
-    BOOL                    bStopDataPkt;
-    BOOL                    bStopTx0Pkt;
-    unsigned int                    uAutoReConnectTime;
-    unsigned int                    uIsroamingTime;
-
-    // 802.11 counter
-
-    CMD_ITEM                eCmdQueue[CMD_Q_SIZE];
-    unsigned int                    uCmdDequeueIdx;
-    unsigned int                    uCmdEnqueueIdx;
-    unsigned int                    cbFreeCmdQueue;
-    BOOL                    bCmdRunning;
-    BOOL                    bCmdClear;
-    BOOL                    bNeedRadioOFF;
-
-    BOOL                    bEnableRoaming;
-    BOOL                    bIsRoaming;
-    BOOL                    bFastRoaming;
-    BYTE                    bSameBSSMaxNum;
-    BYTE                    bSameBSSCurNum;
-    BOOL                    bRoaming;
-    BOOL                    b11hEable;
-    unsigned long                   ulTxPower;
-
-    // Encryption
-    NDIS_802_11_WEP_STATUS  eEncryptionStatus;
-    BOOL                    bTransmitKey;
-
-//mike add :save old Encryption
-    NDIS_802_11_WEP_STATUS  eOldEncryptionStatus;
-
-    SKeyManagement          sKey;
-    DWORD                   dwIVCounter;
-
-
-    RC4Ext                  SBox;
-    BYTE                    abyPRNG[WLAN_WEPMAX_KEYLEN+3];
-    BYTE                    byKeyIndex;
-
-    BOOL                    bAES;
-
-    unsigned int                    uKeyLength;
-    BYTE                    abyKey[WLAN_WEP232_KEYLEN];
-
-    // for AP mode
-    unsigned int                    uAssocCount;
-    BOOL                    bMoreData;
-
-    // QoS
-    BOOL                    bGrpAckPolicy;
-
-
-    BYTE                    byAutoFBCtrl;
-
-    BOOL                    bTxMICFail;
-    BOOL                    bRxMICFail;
-
-
-    // For Update BaseBand VGA Gain Offset
-    BOOL                    bUpdateBBVGA;
-    unsigned int                    uBBVGADiffCount;
-    BYTE                    byBBVGANew;
-    BYTE                    byBBVGACurrent;
-    BYTE                    abyBBVGA[BB_VGA_LEVEL];
-    signed long                    ldBmThreshold[BB_VGA_LEVEL];
-
-    BYTE                    byBBPreEDRSSI;
-    BYTE                    byBBPreEDIndex;
-
+	u32 uSIFS;  /* Current SIFS */
+	u32 uDIFS;  /* Current DIFS */
+	u32 uEIFS;  /* Current EIFS */
+	u32 uSlot;  /* Current SlotTime */
+	u32 uCwMin; /* Current CwMin */
+	u32 uCwMax; /* CwMax is fixed on 1023 */
+
+	/* PHY parameter */
+	u8  bySIFS;
+	u8  byDIFS;
+	u8  byEIFS;
+	u8  bySlot;
+	u8  byCWMaxMin;
+
+	/* Rate */
+	VIA_BB_TYPE byBBType; /* 0: 11A, 1:11B, 2:11G */
+	VIA_PKT_TYPE byPacketType; /* 0:11a 1:11b 2:11gb 3:11ga */
+	u16 wBasicRate;
+	u8 byACKRate;
+	u8 byTopOFDMBasicRate;
+	u8 byTopCCKBasicRate;
+
+
+	u32 dwAotoRateTxOkCnt;
+	u32 dwAotoRateTxFailCnt;
+	u32 dwErrorRateThreshold[13];
+	u32 dwTPTable[MAX_RATE];
+	u8 abyEEPROM[EEP_MAX_CONTEXT_SIZE];  /*u32 alignment */
+
+	u8 byMinChannel;
+	u8 byMaxChannel;
+	u32 uConnectionRate;
+
+	u8 byPreambleType;
+	u8 byShortPreamble;
+	/* CARD_PHY_TYPE */
+	u8 eConfigPHYMode;
+
+	/* For RF Power table */
+	u8 byCCKPwr;
+	u8 byOFDMPwrG;
+	u8 byOFDMPwrA;
+	u8 byCurPwr;
+	u8 abyCCKPwrTbl[14];
+	u8 abyOFDMPwrTbl[14];
+	u8 abyOFDMAPwrTbl[42];
+
+	u16 wCurrentRate;
+	u16 wRTSThreshold;
+	u16 wFragmentationThreshold;
+	u8 byShortRetryLimit;
+	u8 byLongRetryLimit;
+	CARD_OP_MODE eOPMode;
+	int bBSSIDFilter;
+	u16 wMaxTransmitMSDULifetime;
+	u8 abyBSSID[ETH_ALEN];
+	u8 abyDesireBSSID[ETH_ALEN];
+
+	u16 wCTSDuration;       /* update while speed change */
+	u16 wACKDuration;
+	u16 wRTSTransmitLen;
+	u8 byRTSServiceField;
+	u8 byRTSSignalField;
+
+	u32 dwMaxReceiveLifetime;  /* dot11MaxReceiveLifetime */
+
+	int bCCK;
+	int bEncryptionEnable;
+	int bLongHeader;
+	int bSoftwareGenCrcErr;
+	int bShortSlotTime;
+	int bProtectMode;
+	int bNonERPPresent;
+	int bBarkerPreambleMd;
+
+	u8 byERPFlag;
+	u16 wUseProtectCntDown;
+
+	int bRadioControlOff;
+	int bRadioOff;
+
+	/* Power save */
+	int bEnablePSMode;
+	u16 wListenInterval;
+	int bPWBitOn;
+	WMAC_POWER_MODE ePSMode;
+	unsigned long ulPSModeWaitTx;
+	int bPSModeTxBurst;
+
+	/* Beacon releated */
+	u16 wSeqCounter;
+	int bBeaconBufReady;
+	int bBeaconSent;
+	int bFixRate;
+	u8 byCurrentCh;
+	u32 uScanTime;
+
+	CMD_STATE eCommandState;
+
+	CMD_CODE eCommand;
+	int bBeaconTx;
+	u8 byScanBBType;
+
+	int bStopBeacon;
+	int bStopDataPkt;
+	int bStopTx0Pkt;
+	u32 uAutoReConnectTime;
+	u32 uIsroamingTime;
+
+	/* 802.11 counter */
+
+	CMD_ITEM eCmdQueue[CMD_Q_SIZE];
+	u32 uCmdDequeueIdx;
+	u32 uCmdEnqueueIdx;
+	u32 cbFreeCmdQueue;
+	int bCmdRunning;
+	int bCmdClear;
+	int bNeedRadioOFF;
+
+	int bEnableRoaming;
+	int bIsRoaming;
+	int bFastRoaming;
+	u8 bSameBSSMaxNum;
+	u8 bSameBSSCurNum;
+	int bRoaming;
+	int b11hEable;
+	unsigned long ulTxPower;
+
+	/* Encryption */
+	NDIS_802_11_WEP_STATUS eEncryptionStatus;
+	int  bTransmitKey;
+	NDIS_802_11_WEP_STATUS eOldEncryptionStatus;
+	SKeyManagement sKey;
+	u32 dwIVCounter;
+
+
+	RC4Ext SBox;
+	u8 abyPRNG[WLAN_WEPMAX_KEYLEN+3];
+	u8 byKeyIndex;
+
+	int bAES;
+
+	u32 uKeyLength;
+	u8 abyKey[WLAN_WEP232_KEYLEN];
+
+	/* for AP mode */
+	u32 uAssocCount;
+	int bMoreData;
+
+	/* QoS */
+	int bGrpAckPolicy;
+
+
+	u8 byAutoFBCtrl;
+
+	int bTxMICFail;
+	int bRxMICFail;
+
+
+	/* For Update BaseBand VGA Gain Offset */
+	int bUpdateBBVGA;
+	u32 uBBVGADiffCount;
+	u8 byBBVGANew;
+	u8 byBBVGACurrent;
+	u8 abyBBVGA[BB_VGA_LEVEL];
+	signed long ldBmThreshold[BB_VGA_LEVEL];
+
+	u8 byBBPreEDRSSI;
+	u8 byBBPreEDIndex;
+
+
+	int bRadioCmd;
+	u32 dwDiagRefCount;
+
+	/* For FOE Tuning */
+	u8  byFOETuning;
+
+	/* For Auto Power Tunning */
+	u8  byAutoPwrTunning;
+
+	/* BaseBand Loopback Use */
+	u8 byBBCR4d;
+	u8 byBBCRc9;
+	u8 byBBCR88;
+	u8 byBBCR09;
+
+	/* command timer */
+	struct timer_list sTimerCommand;
 
-    BOOL                    bRadioCmd;
-    DWORD                   dwDiagRefCount;
+	struct timer_list sTimerTxData;
+	unsigned long nTxDataTimeCout;
+	int fTxDataInSleep;
+	int IsTxDataTrigger;
 
-    // For FOE Tuning
-    BYTE                    byFOETuning;
+	int fWPA_Authened; /*is WPA/WPA-PSK or WPA2/WPA2-PSK authen?? */
+	u8 byReAssocCount;
+	u8 byLinkWaitCount;
 
-    // For Auto Power Tunning
+	SEthernetHeader sTxEthHeader;
+	SEthernetHeader sRxEthHeader;
+	u8 abyBroadcastAddr[ETH_ALEN];
+	u8 abySNAP_RFC1042[ETH_ALEN];
+	u8 abySNAP_Bridgetunnel[ETH_ALEN];
 
-    BYTE                    byAutoPwrTunning;
+	/* Pre-Authentication & PMK cache */
+	SPMKID gsPMKID;
+	SPMKIDCandidateEvent gsPMKIDCandidate;
 
-    // BaseBand Loopback Use
-    BYTE                    byBBCR4d;
-    BYTE                    byBBCRc9;
-    BYTE                    byBBCR88;
-    BYTE                    byBBCR09;
 
-    // command timer
-    struct timer_list       sTimerCommand;
+	/* for 802.11h */
+	int b11hEnable;
 
-     struct timer_list       sTimerTxData;
-     unsigned long                       nTxDataTimeCout;
-     BOOL  fTxDataInSleep;
-     BOOL  IsTxDataTrigger;
+	int bChannelSwitch;
+	u8 byNewChannel;
+	u8 byChannelSwitchCount;
 
-    BOOL  fWPA_Authened;           //is WPA/WPA-PSK or WPA2/WPA2-PSK authen??
-    BYTE            byReAssocCount;   //mike add:re-association retry times!
-    BYTE            byLinkWaitCount;
+	/* WPA supplicant daemon */
+	int bWPADEVUp;
+	int bwextstep0;
+	int bwextstep1;
+	int bwextstep2;
+	int bwextstep3;
+	int bWPASuppWextEnabled;
 
-    SEthernetHeader         sTxEthHeader;
-    SEthernetHeader         sRxEthHeader;
-    BYTE                    abyBroadcastAddr[ETH_ALEN];
-    BYTE                    abySNAP_RFC1042[ETH_ALEN];
-    BYTE                    abySNAP_Bridgetunnel[ETH_ALEN];
-
-    // Pre-Authentication & PMK cache
-    SPMKID                  gsPMKID;
-    SPMKIDCandidateEvent    gsPMKIDCandidate;
-
-
-    // for 802.11h
-    BOOL                    b11hEnable;
-
-    BOOL                    bChannelSwitch;
-    BYTE                    byNewChannel;
-    BYTE                    byChannelSwitchCount;
-
-    //WPA supplicant daemon
-	struct net_device       *wpadev;
-	BOOL                    bWPADEVUp;
-    //--
+	/* user space daemon: hostapd, is used for HOSTAP */
+	int bEnableHostapd;
+	int bEnable8021x;
+	int bEnableHostWEP;
+	struct net_device *apdev;
+	int (*tx_80211)(struct sk_buff *skb, struct net_device *dev);
 
-        BOOL                 bwextstep0;
-        BOOL                 bwextstep1;
-        BOOL                 bwextstep2;
-        BOOL                 bwextstep3;
-        BOOL                 bWPASuppWextEnabled;
+	u32 uChannel;
 
-#ifdef HOSTAP
-    // user space daemon: hostapd, is used for HOSTAP
-	BOOL                    bEnableHostapd;
-	BOOL                    bEnable8021x;
-	BOOL                    bEnableHostWEP;
-	struct net_device       *apdev;
-	int (*tx_80211)(struct sk_buff *skb, struct net_device *dev);
-#endif
-    unsigned int                    uChannel;
+	struct iw_statistics wstats; /* wireless stats */
 
-	struct iw_statistics	wstats;		// wireless stats
-    BOOL                    bCommit;
+	int bCommit;
 
 };
 
-- 
1.8.0




