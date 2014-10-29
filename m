Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:42205 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571AbaJ2R6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:58:00 -0400
Received: by mail-wg0-f45.google.com with SMTP id x12so3921812wgg.4
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:57:59 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 32/48] staging: vt6655: wmgr.h remove management structures
Date: Wed, 29 Oct 2014 17:55:50 +0000
Message-Id: <1414605366-9335-33-git-send-email-tvboxspy@gmail.com> (sfid-20141029_185927_667690_0C1C4CFC)
In-Reply-To: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
References: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h |   5 --
 drivers/staging/vt6655/wmgr.h   | 194 ----------------------------------------
 2 files changed, 199 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 5e48608..d2779a3 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -426,11 +426,6 @@ struct vnt_private {
 	/* 802.11 counter */
 	SDot11Counters              s802_11Counter;
 
-	/* 802.11 management */
-	PSMgmtObject                pMgmt;
-	SMgmtObject                 sMgmtObj;
-
-	/* 802.11 MAC specific */
 	unsigned int	uCurrRSSI;
 	unsigned char byCurrSQ;
 
diff --git a/drivers/staging/vt6655/wmgr.h b/drivers/staging/vt6655/wmgr.h
index ecbb8d4..1deedd8 100644
--- a/drivers/staging/vt6655/wmgr.h
+++ b/drivers/staging/vt6655/wmgr.h
@@ -112,199 +112,5 @@ typedef struct tagSAssocInfo {
 	unsigned long RequestIELength;
 	unsigned char abyReqIEs[WLAN_BEACON_FR_MAXLEN];
 } SAssocInfo, *PSAssocInfo;
-//---
-
-typedef enum tagWMAC_SCAN_TYPE {
-	WMAC_SCAN_ACTIVE,
-	WMAC_SCAN_PASSIVE,
-	WMAC_SCAN_HYBRID
-} WMAC_SCAN_TYPE, *PWMAC_SCAN_TYPE;
-
-typedef enum tagWMAC_SCAN_STATE {
-	WMAC_NO_SCANNING,
-	WMAC_IS_SCANNING,
-	WMAC_IS_PROBEPENDING
-} WMAC_SCAN_STATE, *PWMAC_SCAN_STATE;
-
-// Notes:
-// Basic Service Set state explained as following:
-// WMAC_STATE_IDLE          : no BSS is selected (Adhoc or Infra)
-// WMAC_STATE_STARTED       : no BSS is selected, start own IBSS (Adhoc only)
-// WMAC_STATE_JOINTED       : BSS is selected and synchronized (Adhoc or Infra)
-// WMAC_STATE_AUTHPENDING   : Authentication pending (Infra)
-// WMAC_STATE_AUTH          : Authenticated (Infra)
-// WMAC_STATE_ASSOCPENDING  : Association pending (Infra)
-// WMAC_STATE_ASSOC         : Associated (Infra)
-
-typedef enum tagWMAC_BSS_STATE {
-	WMAC_STATE_IDLE,
-	WMAC_STATE_STARTED,
-	WMAC_STATE_JOINTED,
-	WMAC_STATE_AUTHPENDING,
-	WMAC_STATE_AUTH,
-	WMAC_STATE_ASSOCPENDING,
-	WMAC_STATE_ASSOC
-} WMAC_BSS_STATE, *PWMAC_BSS_STATE;
-
-// WMAC selected running mode
-typedef enum tagWMAC_CURRENT_MODE {
-	WMAC_MODE_STANDBY,
-	WMAC_MODE_ESS_STA,
-	WMAC_MODE_IBSS_STA,
-	WMAC_MODE_ESS_AP
-} WMAC_CURRENT_MODE, *PWMAC_CURRENT_MODE;
-
-/*
-  typedef enum tagWMAC_POWER_MODE {
-  WMAC_POWER_CAM,
-  WMAC_POWER_FAST,
-  WMAC_POWER_MAX
-
-  } WMAC_POWER_MODE, *PWMAC_POWER_MODE;
-*/
-
-// Tx Management Packet descriptor
-typedef struct tagSTxMgmtPacket {
-	PUWLAN_80211HDR     p80211Header;
-	unsigned int cbMPDULen;
-	unsigned int cbPayloadLen;
-} STxMgmtPacket, *PSTxMgmtPacket;
-
-// Rx Management Packet descriptor
-typedef struct tagSRxMgmtPacket {
-	PUWLAN_80211HDR     p80211Header;
-	u64 qwLocalTSF;
-	unsigned int cbMPDULen;
-	unsigned int cbPayloadLen;
-	unsigned int uRSSI;
-	unsigned char bySQ;
-	unsigned char byRxRate;
-	unsigned char byRxChannel;
-} SRxMgmtPacket, *PSRxMgmtPacket;
-
-typedef struct tagSMgmtObject {
-	void *pAdapter;
-	// MAC address
-	unsigned char abyMACAddr[WLAN_ADDR_LEN];
-
-	// Configuration Mode
-	CARD_PHY_TYPE           eCurrentPHYMode;
-	CARD_PHY_TYPE           eConfigPHYMode;
-
-	// Operation state variables
-	WMAC_CURRENT_MODE       eCurrMode;   // MAC current connection mode
-	WMAC_BSS_STATE          eCurrState;  // MAC current BSS state
-
-	PKnownBSS               pCurrBSS;
-	unsigned char byCSSGK;
-	unsigned char byCSSPK;
-
-	// Current state vars
-	unsigned int	uCurrChannel;
-	unsigned char abyCurrBSSID[WLAN_BSSID_LEN];
-	unsigned char abyCurrSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
-	unsigned char abyCurrExtSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
-	unsigned char abyCurrSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
-	unsigned short wCurrCapInfo;
-	unsigned short wCurrAID;
-	unsigned short wCurrATIMWindow;
-	unsigned short wCurrBeaconPeriod;
-	bool bIsDS;
-	unsigned char byERPContext;
-
-	CMD_STATE               eCommandState;
-	unsigned int	uScanChannel;
-
-	// Desire joining BSS vars
-	unsigned char abyDesireSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
-	unsigned char abyDesireBSSID[WLAN_BSSID_LEN];
-
-	// Adhoc or AP configuration vars
-	unsigned short wIBSSBeaconPeriod;
-	unsigned short wIBSSATIMWindow;
-	unsigned int	uIBSSChannel;
-	unsigned char abyIBSSSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
-	unsigned char byAPBBType;
-	unsigned char abyWPAIE[MAX_WPA_IE_LEN];
-	unsigned short wWPAIELen;
-
-	unsigned int	uAssocCount;
-	bool bMoreData;
-
-	// Scan state vars
-	WMAC_SCAN_STATE         eScanState;
-	WMAC_SCAN_TYPE          eScanType;
-	unsigned int	uScanStartCh;
-	unsigned int	uScanEndCh;
-	unsigned short wScanSteps;
-	unsigned int	uScanBSSType;
-	// Desire scanning vars
-	unsigned char abyScanSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
-	unsigned char abyScanBSSID[WLAN_BSSID_LEN];
-
-	// Privacy
-	bool bShareKeyAlgorithm;
-	unsigned char abyChallenge[WLAN_CHALLENGE_LEN];
-	bool bPrivacyInvoked;
-
-	// Received beacon state vars
-	bool bInTIM;
-	bool bMulticastTIM;
-	unsigned char byDTIMCount;
-	unsigned char byDTIMPeriod;
-
-	// Power saving state vars
-	unsigned short wListenInterval;
-	unsigned short wCountToWakeUp;
-	bool bInTIMWake;
-	unsigned char *pbyPSPacketPool;
-	unsigned char byPSPacketPool[sizeof(STxMgmtPacket) + WLAN_NULLDATA_FR_MAXLEN];
-	bool bRxBeaconInTBTTWake;
-	unsigned char abyPSTxMap[MAX_NODE_NUM + 1];
-
-	// management command related
-	unsigned int	uCmdBusy;
-	unsigned int	uCmdHostAPBusy;
-
-	// management packet pool
-	unsigned char *pbyMgmtPacketPool;
-	unsigned char byMgmtPacketPool[sizeof(STxMgmtPacket) + WLAN_A3FR_MAXLEN];
-
-	// One second callback timer
-	struct timer_list	    sTimerSecondCallback;
-
-	// Temporarily Rx Mgmt Packet Descriptor
-	SRxMgmtPacket           sRxPacket;
-
-	// link list of known bss's (scan results)
-	KnownBSS                sBSSList[MAX_BSS_NUM];
-
-	// table list of known node
-	// sNodeDBList[0] is reserved for AP under Infra mode
-	// sNodeDBList[0] is reserved for Multicast under adhoc/AP mode
-	KnownNodeDB             sNodeDBTable[MAX_NODE_NUM + 1];
-
-	// WPA2 PMKID Cache
-	bool bRoaming;
-
-	// rate fall back vars
-
-	// associate info
-	SAssocInfo              sAssocInfo;
-
-	// for 802.11h
-	bool b11hEnable;
-	bool bSwitchChannel;
-	unsigned char byNewChannel;
-	PWLAN_IE_MEASURE_REP    pCurrMeasureEIDRep;
-	unsigned int	uLengthOfRepEIDs;
-	unsigned char abyCurrentMSRReq[sizeof(STxMgmtPacket) + WLAN_A3FR_MAXLEN];
-	unsigned char abyCurrentMSRRep[sizeof(STxMgmtPacket) + WLAN_A3FR_MAXLEN];
-	unsigned char abyIECountry[WLAN_A3FR_MAXLEN];
-	unsigned char abyIBSSDFSOwner[6];
-	unsigned char byIBSSDFSRecovery;
-
-	struct sk_buff  skb;
-} SMgmtObject, *PSMgmtObject;
 
 #endif // __WMGR_H__
-- 
2.1.0

