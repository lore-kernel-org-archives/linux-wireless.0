Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:49789 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342AbaFYUWB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:22:01 -0400
Received: by mail-we0-f182.google.com with SMTP id q59so2624501wes.27
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:22:00 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 33/34] staging: vt6656: device.h remove dead strutures and variables
Date: Wed, 25 Jun 2014 21:20:10 +0100
Message-Id: <1403727611-6825-34-git-send-email-tvboxspy@gmail.com> (sfid-20140625_222240_286924_042AC659)
In-Reply-To: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
References: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 220 --------------------------------------
 drivers/staging/vt6656/main_usb.c |   6 --
 drivers/staging/vt6656/usbpipe.c  |   2 -
 3 files changed, 228 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index d9fc32c..9d4c5e7 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -188,14 +188,7 @@
 /* USB registers */
 #define USB_REG4			0x604
 
-#ifndef RUN_AT
-#define RUN_AT(x)                       (jiffies+(x))
-#endif
-
-#define PRIVATE_Message                 0
-
 #define DBG_PRT(l, p, args...) { if (l <= msglevel) printk(p, ##args); }
-#define PRINT_K(p, args...) { if (PRIVATE_Message) printk(p, ##args); }
 
 typedef enum __device_msg_level {
 	MSG_LEVEL_ERR = 0,            /* Errors causing abnormal operation */
@@ -266,16 +259,6 @@ struct vnt_tx_pkt_info {
 	u8 dest_addr[ETH_ALEN];
 };
 
-/* structure got from configuration file as user-desired default settings */
-typedef struct _DEFAULT_CONFIG {
-	signed int    ZoneType;
-	signed int    eConfigMode;
-	signed int    eAuthenMode;        /* open/wep/wpa */
-	signed int    bShareKeyAlgorithm; /* open-open/{open,wep}-sharekey */
-	signed int    keyidx;             /* wepkey index */
-	signed int    eEncryptionStatus;
-} DEFAULT_CONFIG, *PDEFAULT_CONFIG;
-
 /*
  * Structure to keep track of USB interrupt packets
  */
@@ -293,69 +276,6 @@ typedef enum __DEVICE_NDIS_STATUS {
     STATUS_PENDING,
 } DEVICE_NDIS_STATUS, *PDEVICE_NDIS_STATUS;
 
-#define MAX_BSSIDINFO_4_PMKID   16
-#define MAX_PMKIDLIST           5
-/* flags for PMKID Candidate list structure */
-#define NDIS_802_11_PMKID_CANDIDATE_PREAUTH_ENABLED	0x01
-
-/* PMKID Structures */
-typedef unsigned char   NDIS_802_11_PMKID_VALUE[16];
-
-typedef enum _NDIS_802_11_WEP_STATUS
-{
-    Ndis802_11WEPEnabled,
-    Ndis802_11Encryption1Enabled = Ndis802_11WEPEnabled,
-    Ndis802_11WEPDisabled,
-    Ndis802_11EncryptionDisabled = Ndis802_11WEPDisabled,
-    Ndis802_11WEPKeyAbsent,
-    Ndis802_11Encryption1KeyAbsent = Ndis802_11WEPKeyAbsent,
-    Ndis802_11WEPNotSupported,
-    Ndis802_11EncryptionNotSupported = Ndis802_11WEPNotSupported,
-    Ndis802_11Encryption2Enabled,
-    Ndis802_11Encryption2KeyAbsent,
-    Ndis802_11Encryption3Enabled,
-    Ndis802_11Encryption3KeyAbsent
-} NDIS_802_11_WEP_STATUS, *PNDIS_802_11_WEP_STATUS,
-  NDIS_802_11_ENCRYPTION_STATUS, *PNDIS_802_11_ENCRYPTION_STATUS;
-
-typedef enum _NDIS_802_11_STATUS_TYPE
-{
-	Ndis802_11StatusType_Authentication,
-	Ndis802_11StatusType_MediaStreamMode,
-	Ndis802_11StatusType_PMKID_CandidateList,
-	Ndis802_11StatusTypeMax, /* not a real type, defined as upper bound */
-} NDIS_802_11_STATUS_TYPE, *PNDIS_802_11_STATUS_TYPE;
-
-/* The receive duplicate detection cache entry */
-typedef struct tagSCacheEntry{
-	__le16 wFmSequence;
-	u8 abyAddr2[ETH_ALEN];
-	__le16 wFrameCtl;
-} SCacheEntry, *PSCacheEntry;
-
-typedef struct tagSCache{
-/* The receive cache is updated circularly.  The next entry to be written is
- * indexed by the "InPtr".
- */
-	unsigned int uInPtr; /* Place to use next */
-    SCacheEntry     asCacheEntry[DUPLICATE_RX_CACHE_LENGTH];
-} SCache, *PSCache;
-
-#define CB_MAX_RX_FRAG                 64
-/*
- * DeFragment Control Block, used for collecting fragments prior to reassembly
- */
-typedef struct tagSDeFragControlBlock
-{
-    u16            wSequence;
-    u16            wFragNum;
-    u8            abyAddr2[ETH_ALEN];
-	unsigned int            uLifetime;
-    struct sk_buff* skb;
-    u8 *           pbyRxBuffer;
-    unsigned int            cbFrameLength;
-    bool            bInUse;
-} SDeFragControlBlock, *PSDeFragControlBlock;
 
 /* flags for options */
 #define     DEVICE_FLAGS_UNPLUG          0x00000001UL
@@ -363,20 +283,6 @@ typedef struct tagSDeFragControlBlock
 /* flags for driver status */
 #define     DEVICE_FLAGS_OPENED          0x00010000UL
 
-typedef struct __device_opt {
-	int nRxDescs0;  /* number of RX descriptors 0 */
-	int nTxDescs0;  /* number of TX descriptors 0, 1, 2, 3 */
-	int rts_thresh; /* RTS threshold */
-    int         frag_thresh;
-    int         OpMode;
-    int         data_rate;
-    int         channel_num;
-    int         short_retry;
-    int         long_retry;
-    int         bbp_type;
-    u32         flags;
-} OPTIONS, *POPTIONS;
-
 struct vnt_private {
 	/* mac80211 */
 	struct ieee80211_hw *hw;
@@ -384,37 +290,22 @@ struct vnt_private {
 	u8 mac_hw;
 	/* netdev */
 	struct usb_device *usb;
-	struct net_device *dev;
 	struct net_device_stats stats;
 
-	OPTIONS sOpts;
-
 	struct work_struct read_work_item;
-	struct work_struct rx_mng_work_item;
 
 	u64 tsf_time;
 	u8 rx_rate;
 
 	u32 rx_buf_sz;
 	int mc_list_count;
-	int multicast_limit;
-	u8 byRxMode;
 
 	spinlock_t lock;
 	struct mutex usb_lock;
 
-	u32 rx_bytes;
-
 	u32 flags;
 	unsigned long Flags;
 
-	SCache sDupRxCache;
-
-	SDeFragControlBlock sRxDFCB[CB_MAX_RX_FRAG];
-	u32 cbDFCB;
-	u32 cbFreeDFCB;
-	u32 uCurrentDFCBIdx;
-
 	/* USB */
 	struct urb *pInterruptURB;
 	u32 int_interval;
@@ -428,8 +319,6 @@ struct vnt_private {
 	u32 NumRecvFreeList;
 
 	int bIsRxWorkItemQueued;
-	int bIsRxMngWorkItemQueued;
-	unsigned long ulRcvRefCount; /* packets that have not returned back */
 
 	/* Variables to track resources for the BULK Out Pipe */
 	struct vnt_usb_send_context *apTD[CB_MAX_TX_DESC];
@@ -439,9 +328,6 @@ struct vnt_private {
 	/* Variables to track resources for the Interrupt In Pipe */
 	struct vnt_interrupt_buffer int_buf;
 
-	/* default config from file by user setting */
-	DEFAULT_CONFIG config_file;
-
 	/* Version control */
 	u16 wFirmwareVersion;
 	u8 byLocalID;
@@ -450,7 +336,6 @@ struct vnt_private {
 
 	u8 byZoneType;
 
-	int bLinkPass; /* link status: OK or fail */
 	struct vnt_cmd_card_init init_command;
 	struct vnt_rsp_card_init init_response;
 	u8 abyCurrentNetAddr[ETH_ALEN];
@@ -458,17 +343,10 @@ struct vnt_private {
 
 	int bExistSWNetAddr;
 
-	/* Maintain statistical debug info. */
-	unsigned long SendContextsInUse;
-	unsigned long RcvBuffersInUse;
-
 	u64 qwCurrTSF;
-	u32 cbBulkInMax;
-	int bPSRxBeacon;
 
 	/* 802.11 MAC specific */
 	u32 uCurrRSSI;
-	u8 byCurrSQ;
 
 	/* Antenna Diversity */
 	int bTxRxAntInv;
@@ -488,13 +366,6 @@ struct vnt_private {
 	u32 uCwMin; /* Current CwMin */
 	u32 uCwMax; /* CwMax is fixed on 1023 */
 
-	/* PHY parameter */
-	u8  bySIFS;
-	u8  byDIFS;
-	u8  byEIFS;
-	u8  bySlot;
-	u8  byCWMaxMin;
-
 	/* Rate */
 	u8 byBBType; /* 0: 11A, 1:11B, 2:11G */
 	u8 byPacketType; /* 0:11a 1:11b 2:11gb 3:11ga */
@@ -504,14 +375,7 @@ struct vnt_private {
 
 	u8 abyEEPROM[EEP_MAX_CONTEXT_SIZE];  /*u32 alignment */
 
-	u8 byMinChannel;
-	u8 byMaxChannel;
-	u32 uConnectionRate;
-
 	u8 byPreambleType;
-	u8 byShortPreamble;
-	/* CARD_PHY_TYPE */
-	u8 eConfigPHYMode;
 
 	/* For RF Power table */
 	u8 byCCKPwr;
@@ -526,57 +390,28 @@ struct vnt_private {
 	u16 tx_rate_fb0;
 	u16 tx_rate_fb1;
 
-	u16 wRTSThreshold;
-	u16 wFragmentationThreshold;
 	u8 byShortRetryLimit;
 	u8 byLongRetryLimit;
 
 	enum nl80211_iftype op_mode;
 
-	int bBSSIDFilter;
-	u8 abyBSSID[ETH_ALEN];
-	u8 abyDesireBSSID[ETH_ALEN];
-
-	u32 dwMaxReceiveLifetime;  /* dot11MaxReceiveLifetime */
-
-	int bEncryptionEnable;
 	int bShortSlotTime;
-	int bProtectMode;
-	int bNonERPPresent;
 	int bBarkerPreambleMd;
 
-	u8 byERPFlag;
-	u16 wUseProtectCntDown;
-
 	int bRadioControlOff;
 	int bRadioOff;
 
 	/* Power save */
 	u16 current_aid;
-	u16 wListenInterval;
-	int bPWBitOn;
-
-	unsigned long ulPSModeWaitTx;
-	int bPSModeTxBurst;
 
 	/* Beacon releated */
 	u16 wSeqCounter;
-	int bBeaconBufReady;
-	int bBeaconSent;
-	int bFixRate;
-	u8 byCurrentCh;
 
 	CMD_STATE eCommandState;
 
 	CMD_CODE eCommand;
-	int bBeaconTx;
-	u8 byScanBBType;
 
-	int bStopBeacon;
 	int bStopDataPkt;
-	int bStopTx0Pkt;
-	u32 uAutoReConnectTime;
-	u32 uIsroamingTime;
 
 	/* 802.11 counter */
 
@@ -588,37 +423,10 @@ struct vnt_private {
 	int bCmdClear;
 	int bNeedRadioOFF;
 
-	int bEnableRoaming;
-	int bIsRoaming;
-	int bFastRoaming;
-	u8 bSameBSSMaxNum;
-	u8 bSameBSSCurNum;
-	int bRoaming;
-	int b11hEable;
-
-	/* Encryption */
-	NDIS_802_11_WEP_STATUS eEncryptionStatus;
-	int  bTransmitKey;
-	NDIS_802_11_WEP_STATUS eOldEncryptionStatus;
-	u32 dwIVCounter;
-
-	u8 byKeyIndex;
-
-	u32 uKeyLength;
 	unsigned long key_entry_inuse;
 
-	/* for AP mode */
-	u32 uAssocCount;
-	int bMoreData;
-
-	/* QoS */
-	int bGrpAckPolicy;
-
 	u8 byAutoFBCtrl;
 
-	int bTxMICFail;
-	int bRxMICFail;
-
 	/* For Update BaseBand VGA Gain Offset */
 	u32 uBBVGADiffCount;
 	u8 byBBVGANew;
@@ -633,42 +441,14 @@ struct vnt_private {
 
 	/* command timer */
 	struct delayed_work run_command_work;
-	/* One second callback */
-	struct delayed_work second_callback_work;
 
 	u8 tx_data_time_out;
-	bool tx_trigger;
-	int fWPA_Authened; /*is WPA/WPA-PSK or WPA2/WPA2-PSK authen?? */
-	u8 byReAssocCount;
-	u8 byLinkWaitCount;
-
-	struct ethhdr sTxEthHeader;
-	struct ethhdr sRxEthHeader;
-	u8 abyBroadcastAddr[ETH_ALEN];
-	u8 abySNAP_RFC1042[ETH_ALEN];
-	u8 abySNAP_Bridgetunnel[ETH_ALEN];
-
-	/* for 802.11h */
-	int b11hEnable;
 
 	int bChannelSwitch;
 	u8 byNewChannel;
 	u8 byChannelSwitchCount;
 
-	/* WPA supplicant daemon */
-	int bWPADEVUp;
-	int bwextstep0;
-	int bwextstep1;
-	int bwextstep2;
-	int bwextstep3;
-	int bWPASuppWextEnabled;
-
-	u32 uChannel;
-
 	struct iw_statistics wstats; /* wireless stats */
-
-	int bCommit;
-
 };
 
 #define EnqueueRCB(_Head, _Tail, _RCB)                  \
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index b49effa..86d9470 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -208,7 +208,6 @@ static void
 device_set_options(struct vnt_private *pDevice) {
     pDevice->cbTD = TX_DESC_DEF0;
     pDevice->cbRD = RX_DESC_DEF0;
-    pDevice->uChannel = CHANNEL_DEF;
     pDevice->byShortRetryLimit = SHORT_RETRY_DEF;
     pDevice->byLongRetryLimit = LONG_RETRY_DEF;
     pDevice->op_mode = NL80211_IFTYPE_UNSPECIFIED;
@@ -287,11 +286,6 @@ static int device_init_registers(struct vnt_private *pDevice)
 
 	/* do MACbSoftwareReset in MACvInitialize */
 
-	pDevice->bProtectMode = false;
-	/* only used in 11g type, sync with ERP IE */
-	pDevice->bNonERPPresent = false;
-	pDevice->bBarkerPreambleMd = false;
-
 	pDevice->byTopOFDMBasicRate = RATE_24M;
 	pDevice->byTopCCKBasicRate = RATE_1M;
 
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index fd8776c..6a7e692 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -338,8 +338,6 @@ int PIPEnsSendBulkOut(struct vnt_private *priv,
 	int status;
 	struct urb *urb;
 
-	priv->bPWBitOn = false;
-
 	if (!(MP_IS_READY(priv) && priv->Flags & fMP_POST_WRITES)) {
 		context->in_use = false;
 		return STATUS_RESOURCES;
-- 
1.9.1

