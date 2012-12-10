Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36883 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2LJWWO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 17:22:14 -0500
Received: by mail-we0-f174.google.com with SMTP id x10so1401818wey.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 14:22:13 -0800 (PST)
Message-ID: <1355178128.4680.27.camel@canaries64> (sfid-20121210_232221_542578_D4D4B53F)
Subject: [PATCH 11/11] staging: vt6656: clean up struct vnt manager.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 10 Dec 2012 22:22:08 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Replacing types defined in "ttype.h" with linux/types.h.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wmgr.h | 253 ++++++++++++++++++++----------------------
 1 file changed, 122 insertions(+), 131 deletions(-)

diff --git a/drivers/staging/vt6656/wmgr.h b/drivers/staging/vt6656/wmgr.h
index 5112f53..83aed45 100644
--- a/drivers/staging/vt6656/wmgr.h
+++ b/drivers/staging/vt6656/wmgr.h
@@ -241,155 +241,146 @@ struct vnt_rx_mgmt {
 
 struct vnt_manager {
 	void *pAdapter;
-    // MAC address
-    BYTE                    abyMACAddr[WLAN_ADDR_LEN];
-
-    // Configuration Mode
-    WMAC_CONFIG_MODE        eConfigMode; // MAC pre-configed mode
-
-    CARD_PHY_TYPE           eCurrentPHYMode;
-
-
-    // Operation state variables
-    WMAC_CURRENT_MODE       eCurrMode;   // MAC current connection mode
-    WMAC_BSS_STATE          eCurrState;  // MAC current BSS state
-    WMAC_BSS_STATE          eLastState;  // MAC last BSS state
-
-    PKnownBSS               pCurrBSS;
-    BYTE                    byCSSGK;
-    BYTE                    byCSSPK;
-
-//    BYTE                    abyNewSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN];
-//    BYTE                    abyNewExtSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN];
-    BOOL                    bCurrBSSIDFilterOn;
-
-    // Current state vars
-    unsigned int                    uCurrChannel;
-    BYTE                    abyCurrSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
-    BYTE                    abyCurrExtSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
-    BYTE                    abyCurrSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
-    BYTE                    abyCurrBSSID[WLAN_BSSID_LEN];
-    WORD                    wCurrCapInfo;
-    WORD                    wCurrAID;
-    unsigned int                    uRSSITrigger;
-    WORD                    wCurrATIMWindow;
-    WORD                    wCurrBeaconPeriod;
-    BOOL                    bIsDS;
-    BYTE                    byERPContext;
-
-    CMD_STATE               eCommandState;
-    unsigned int                    uScanChannel;
-
-    // Desire joinning BSS vars
-    BYTE                    abyDesireSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
-    BYTE                    abyDesireBSSID[WLAN_BSSID_LEN];
-
-//restore BSS info for Ad-Hoc mode
-     BYTE                    abyAdHocSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
-
-    // Adhoc or AP configuration vars
-    WORD                    wIBSSBeaconPeriod;
-    WORD                    wIBSSATIMWindow;
-    unsigned int                    uIBSSChannel;
-    BYTE                    abyIBSSSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
-    BYTE                    byAPBBType;
-    BYTE                    abyWPAIE[MAX_WPA_IE_LEN];
-    WORD                    wWPAIELen;
-
-    unsigned int                    uAssocCount;
-    BOOL                    bMoreData;
-
-    // Scan state vars
-    WMAC_SCAN_STATE         eScanState;
-    WMAC_SCAN_TYPE          eScanType;
-    unsigned int                    uScanStartCh;
-    unsigned int                    uScanEndCh;
-    WORD                    wScanSteps;
-    unsigned int                    uScanBSSType;
-    // Desire scannig vars
-    BYTE                    abyScanSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
-    BYTE                    abyScanBSSID[WLAN_BSSID_LEN];
-
-    // Privacy
-    WMAC_AUTHENTICATION_MODE eAuthenMode;
-    BOOL                    bShareKeyAlgorithm;
-    BYTE                    abyChallenge[WLAN_CHALLENGE_LEN];
-    BOOL                    bPrivacyInvoked;
-
-    // Received beacon state vars
-    BOOL                    bInTIM;
-    BOOL                    bMulticastTIM;
-    BYTE                    byDTIMCount;
-    BYTE                    byDTIMPeriod;
-
-    // Power saving state vars
-    WMAC_POWER_MODE         ePSMode;
-    WORD                    wListenInterval;
-    WORD                    wCountToWakeUp;
-    BOOL                    bInTIMWake;
-    PBYTE                   pbyPSPacketPool;
+
+	/* MAC address */
+	u8  abyMACAddr[WLAN_ADDR_LEN];
+
+	/* Configuration Mode */
+	WMAC_CONFIG_MODE eConfigMode; /* MAC pre-configed mode */
+
+	CARD_PHY_TYPE eCurrentPHYMode;
+
+	/* Operation state variables */
+	WMAC_CURRENT_MODE eCurrMode; /* MAC current connection mode */
+	WMAC_BSS_STATE eCurrState; /* MAC current BSS state */
+	WMAC_BSS_STATE eLastState; /* MAC last BSS state */
+
+	PKnownBSS pCurrBSS;
+	u8 byCSSGK;
+	u8 byCSSPK;
+
+	int bCurrBSSIDFilterOn;
+
+	/* Current state vars */
+	u32 uCurrChannel;
+	u8 abyCurrSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
+	u8 abyCurrExtSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
+	u8 abyCurrSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
+	u8 abyCurrBSSID[WLAN_BSSID_LEN];
+	u16 wCurrCapInfo;
+	u16 wCurrAID;
+	u32 uRSSITrigger;
+	u16 wCurrATIMWindow;
+	u16 wCurrBeaconPeriod;
+	int bIsDS;
+	u8 byERPContext;
+
+	CMD_STATE eCommandState;
+	u32 uScanChannel;
+
+	/* Desire joinning BSS vars */
+	u8 abyDesireSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
+	u8 abyDesireBSSID[WLAN_BSSID_LEN];
+
+	/*restore BSS info for Ad-Hoc mode */
+	u8 abyAdHocSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
+
+	/* Adhoc or AP configuration vars */
+	u16 wIBSSBeaconPeriod;
+	u16 wIBSSATIMWindow;
+	u32 uIBSSChannel;
+	u8 abyIBSSSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
+	u8 byAPBBType;
+	u8 abyWPAIE[MAX_WPA_IE_LEN];
+	u16 wWPAIELen;
+
+	u32 uAssocCount;
+	int bMoreData;
+
+	/* Scan state vars */
+	WMAC_SCAN_STATE eScanState;
+	WMAC_SCAN_TYPE eScanType;
+	u32 uScanStartCh;
+	u32 uScanEndCh;
+	u16 wScanSteps;
+	u32 uScanBSSType;
+	/* Desire scannig vars */
+	u8 abyScanSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
+	u8 abyScanBSSID[WLAN_BSSID_LEN];
+
+	/* Privacy */
+	WMAC_AUTHENTICATION_MODE eAuthenMode;
+	int bShareKeyAlgorithm;
+	u8 abyChallenge[WLAN_CHALLENGE_LEN];
+	int bPrivacyInvoked;
+
+	/* Received beacon state vars */
+	int bInTIM;
+	int bMulticastTIM;
+	u8 byDTIMCount;
+	u8 byDTIMPeriod;
+
+	/* Power saving state vars */
+	WMAC_POWER_MODE ePSMode;
+	u16 wListenInterval;
+	u16 wCountToWakeUp;
+	int bInTIMWake;
+	u8 *pbyPSPacketPool;
 	u8 byPSPacketPool[sizeof(struct vnt_tx_mgmt)
 		+ WLAN_NULLDATA_FR_MAXLEN];
-    BOOL                    bRxBeaconInTBTTWake;
-    BYTE                    abyPSTxMap[MAX_NODE_NUM + 1];
+	int bRxBeaconInTBTTWake;
+	u8 abyPSTxMap[MAX_NODE_NUM + 1];
 
-    // management command related
-    unsigned int                    uCmdBusy;
-    unsigned int                    uCmdHostAPBusy;
+	/* management command related */
+	u32 uCmdBusy;
+	u32 uCmdHostAPBusy;
 
-    // management packet pool
-    PBYTE                   pbyMgmtPacketPool;
+	/* management packet pool */
+	u8 *pbyMgmtPacketPool;
 	u8 byMgmtPacketPool[sizeof(struct vnt_tx_mgmt)
 		+ WLAN_A3FR_MAXLEN];
 

-    // One second callback timer
-	struct timer_list	    sTimerSecondCallback;
+	/* One second callback timer */
+	struct timer_list sTimerSecondCallback;
 
 	/* Temporarily Rx Mgmt Packet Descriptor */
 	struct vnt_rx_mgmt sRxPacket;
 
-    // link list of known bss's (scan results)
-    KnownBSS                sBSSList[MAX_BSS_NUM];
+	/* link list of known bss's (scan results) */
+	KnownBSS sBSSList[MAX_BSS_NUM];
 	/* link list of same bss's */
-    KnownBSS				pSameBSS[6] ;
-    BOOL          Cisco_cckm ;
-    BYTE          Roam_dbm;
-
-    // table list of known node
-    // sNodeDBList[0] is reserved for AP under Infra mode
-    // sNodeDBList[0] is reserved for Multicast under adhoc/AP mode
-    KnownNodeDB             sNodeDBTable[MAX_NODE_NUM + 1];
-
-
-
-    // WPA2 PMKID Cache
-    SPMKIDCache             gsPMKIDCache;
-    BOOL                    bRoaming;
-
-    // rate fall back vars
-
-
-
-    // associate info
-    SAssocInfo              sAssocInfo;
-
-
-    // for 802.11h
-    BOOL                    b11hEnable;
-    BOOL                    bSwitchChannel;
-    BYTE                    byNewChannel;
-    PWLAN_IE_MEASURE_REP    pCurrMeasureEIDRep;
-    unsigned int                    uLengthOfRepEIDs;
+	KnownBSS pSameBSS[6];
+	int Cisco_cckm;
+	u8 Roam_dbm;
+
+	/* table list of known node */
+	/* sNodeDBList[0] is reserved for AP under Infra mode */
+	/* sNodeDBList[0] is reserved for Multicast under adhoc/AP mode */
+	KnownNodeDB sNodeDBTable[MAX_NODE_NUM + 1];
+
+	/* WPA2 PMKID Cache */
+	SPMKIDCache gsPMKIDCache;
+	int bRoaming;
+
+	/* associate info */
+	SAssocInfo sAssocInfo;
+
+	/* for 802.11h */
+	int b11hEnable;
+	int bSwitchChannel;
+	u8 byNewChannel;
+	PWLAN_IE_MEASURE_REP    pCurrMeasureEIDRep;
+	u32 uLengthOfRepEIDs;
 	u8 abyCurrentMSRReq[sizeof(struct vnt_tx_mgmt)
 		+ WLAN_A3FR_MAXLEN];
 	u8 abyCurrentMSRRep[sizeof(struct vnt_tx_mgmt)
 		+ WLAN_A3FR_MAXLEN];
-    BYTE                    abyIECountry[WLAN_A3FR_MAXLEN];
-    BYTE                    abyIBSSDFSOwner[6];
-    BYTE                    byIBSSDFSRecovery;
+	u8 abyIECountry[WLAN_A3FR_MAXLEN];
+	u8 abyIBSSDFSOwner[6];
+	u8 byIBSSDFSRecovery;
 
-    struct sk_buff  skb;
+	struct sk_buff skb;
 
 };
 
-- 
1.8.0




