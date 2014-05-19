Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:64488 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbaESTeN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 15:34:13 -0400
Received: by mail-we0-f176.google.com with SMTP id q59so5861591wes.7
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 12:34:11 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/20] staging: vt6656: Remove hostapd functions.
Date: Mon, 19 May 2014 20:32:54 +0100
Message-Id: <1400527992-3061-2-git-send-email-tvboxspy@gmail.com> (sfid-20140519_213420_467849_BBE058F9)
In-Reply-To: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
References: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove throughout driver
bEnableHostapd
bEnable8021x
bEnableHostWEP
struct net_device *apdev
tx_80211

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/bssdb.c    |   4 +-
 drivers/staging/vt6656/device.h   |   7 -
 drivers/staging/vt6656/dpc.c      | 210 +-------------------
 drivers/staging/vt6656/iocmd.h    | 301 ----------------------------
 drivers/staging/vt6656/iwctl.c    |  16 --
 drivers/staging/vt6656/main_usb.c |  18 --
 drivers/staging/vt6656/rxtx.c     | 406 --------------------------------------
 drivers/staging/vt6656/wcmd.c     |   7 +-
 drivers/staging/vt6656/wmgr.c     |  45 +----
 9 files changed, 13 insertions(+), 1001 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index de60c99..5f631c8 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -771,8 +771,8 @@ void BSSvAddMulticastNode(struct vnt_private *pDevice)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 
-	if (!pDevice->bEnableHostWEP)
-		memset(&pMgmt->sNodeDBTable[0], 0, sizeof(KnownNodeDB));
+	memset(&pMgmt->sNodeDBTable[0], 0, sizeof(KnownNodeDB));
+
 	memset(pMgmt->sNodeDBTable[0].abyMACAddr, 0xff, WLAN_ADDR_LEN);
 	pMgmt->sNodeDBTable[0].bActive = true;
 	pMgmt->sNodeDBTable[0].bPSEnable = false;
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 606ca9f..d55f81c 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -707,13 +707,6 @@ struct vnt_private {
 	int bwextstep3;
 	int bWPASuppWextEnabled;
 
-	/* user space daemon: hostapd, is used for HOSTAP */
-	int bEnableHostapd;
-	int bEnable8021x;
-	int bEnableHostWEP;
-	struct net_device *apdev;
-	int (*tx_80211)(struct sk_buff *skb, struct net_device *dev);
-
 	u32 uChannel;
 
 	struct iw_statistics wstats; /* wireless stats */
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 2596fce..a1ae213 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -29,7 +29,6 @@
  *      s_bAPModeRxCtl- AP Rcv frame filer Ctl.
  *      s_bAPModeRxData- AP Rcv data frame handle
  *      s_bHandleRxEncryption- Rcv decrypted data via on-fly
- *      s_bHostWepRxEncryption- Rcv encrypted data via host
  *      s_byGetRateIdx- get rate index
  *      s_vGetDASA- get data offset
  *      s_vProcessRxMACHeader- Rcv 802.11 and translate to 802.3
@@ -86,10 +85,6 @@ static int s_bHandleRxEncryption(struct vnt_private *pDevice, u8 *pbyFrame,
 	u32 FrameSize, u8 *pbyRsr, u8 *pbyNewRsr, PSKeyItem *pKeyOut,
 	s32 *pbExtIV, u16 *pwRxTSC15_0, u32 *pdwRxTSC47_16);
 
-static int s_bHostWepRxEncryption(struct vnt_private *pDevice, u8 *pbyFrame,
-	u32 FrameSize, u8 *pbyRsr, int bOnFly, PSKeyItem pKey, u8 *pbyNewRsr,
-	s32 *pbExtIV, u16 *pwRxTSC15_0, u32 *pdwRxTSC47_16);
-
 /*+
  *
  * Description:
@@ -267,7 +262,6 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, struct vnt_rcb *pRCB,
 	PSKeyItem pKey = NULL;
 	u16 wRxTSC15_0 = 0;
 	u32 dwRxTSC47_16 = 0;
-	SKeyItem STempKey;
 	/* signed long ldBm = 0; */
 	int bIsWEP = false; int bExtIV = false;
 	u32 dwWbkStatus;
@@ -400,39 +394,9 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, struct vnt_rcb *pRCB,
 
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"rx WEP pkt\n");
         bIsWEP = true;
-        if ((pDevice->bEnableHostWEP) && (iSANodeIndex >= 0)) {
-            pKey = &STempKey;
-            pKey->byCipherSuite = pMgmt->sNodeDBTable[iSANodeIndex].byCipherSuite;
-            pKey->dwKeyIndex = pMgmt->sNodeDBTable[iSANodeIndex].dwKeyIndex;
-            pKey->uKeyLength = pMgmt->sNodeDBTable[iSANodeIndex].uWepKeyLength;
-            pKey->dwTSC47_16 = pMgmt->sNodeDBTable[iSANodeIndex].dwTSC47_16;
-            pKey->wTSC15_0 = pMgmt->sNodeDBTable[iSANodeIndex].wTSC15_0;
-            memcpy(pKey->abyKey,
-                &pMgmt->sNodeDBTable[iSANodeIndex].abyWepKey[0],
-                pKey->uKeyLength
-                );
-
-            bRxDecryOK = s_bHostWepRxEncryption(pDevice,
-                                                pbyFrame,
-                                                FrameSize,
-                                                pbyRsr,
-                                                pMgmt->sNodeDBTable[iSANodeIndex].bOnFly,
-                                                pKey,
-                                                pbyNewRsr,
-                                                &bExtIV,
-                                                &wRxTSC15_0,
-                                                &dwRxTSC47_16);
-        } else {
-            bRxDecryOK = s_bHandleRxEncryption(pDevice,
-                                                pbyFrame,
-                                                FrameSize,
-                                                pbyRsr,
-                                                pbyNewRsr,
-                                                &pKey,
-                                                &bExtIV,
-                                                &wRxTSC15_0,
-                                                &dwRxTSC47_16);
-        }
+
+	bRxDecryOK = s_bHandleRxEncryption(pDevice, pbyFrame, FrameSize,
+		pbyRsr, pbyNewRsr, &pKey, &bExtIV, &wRxTSC15_0, &dwRxTSC47_16);
 
         if (bRxDecryOK) {
             if ((*pbyNewRsr & NEWRSR_DECRYPTOK) == 0) {
@@ -516,22 +480,6 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, struct vnt_rcb *pRCB,
             }
             pRxPacket->byRxChannel = (*pbyRxSts) >> 2;
 
-            // hostap Deamon handle 802.11 management
-            if (pDevice->bEnableHostapd) {
-	            skb->dev = pDevice->apdev;
-	            //skb->data += 4;
-	            //skb->tail += 4;
-	            skb->data += 8;
-	            skb->tail += 8;
-                skb_put(skb, FrameSize);
-		skb_reset_mac_header(skb);
-	            skb->pkt_type = PACKET_OTHERHOST;
-    	        skb->protocol = htons(ETH_P_802_2);
-	            memset(skb->cb, 0, sizeof(skb->cb));
-	            netif_rx(skb);
-                return true;
-	        }
-
             //
             // Insert the RCB in the Recv Mng list
             //
@@ -653,45 +601,6 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, struct vnt_rcb *pRCB,
     }
 */
 
-    // -----------------------------------------------
-
-    if ((pMgmt->eCurrMode == WMAC_MODE_ESS_AP) && (pDevice->bEnable8021x == true)){
-        u8    abyMacHdr[24];
-
-        // Only 802.1x packet incoming allowed
-        if (bIsWEP)
-            cbIVOffset = 8;
-        else
-            cbIVOffset = 0;
-        wEtherType = (skb->data[cbIVOffset + 8 + 24 + 6] << 8) |
-                    skb->data[cbIVOffset + 8 + 24 + 6 + 1];
-
-	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"wEtherType = %04x \n", wEtherType);
-        if (wEtherType == ETH_P_PAE) {
-            skb->dev = pDevice->apdev;
-
-            if (bIsWEP == true) {
-                // strip IV header(8)
-                memcpy(&abyMacHdr[0], (skb->data + 8), 24);
-                memcpy((skb->data + 8 + cbIVOffset), &abyMacHdr[0], 24);
-            }
-
-            skb->data +=  (cbIVOffset + 8);
-            skb->tail +=  (cbIVOffset + 8);
-            skb_put(skb, FrameSize);
-	    skb_reset_mac_header(skb);
-            skb->pkt_type = PACKET_OTHERHOST;
-            skb->protocol = htons(ETH_P_802_2);
-            memset(skb->cb, 0, sizeof(skb->cb));
-            netif_rx(skb);
-            return true;
-
-        }
-        // check if 802.1x authorized
-        if (!(pMgmt->sNodeDBTable[iSANodeIndex].dwFlags & WLAN_STA_AUTHORIZED))
-            return false;
-    }
-
     if ((pKey != NULL) && (pKey->byCipherSuite == KEY_CTL_TKIP)) {
         if (bIsWEP) {
             FrameSize -= 8;  //MIC
@@ -1097,119 +1006,6 @@ static int s_bHandleRxEncryption(struct vnt_private *pDevice, u8 *pbyFrame,
     return true;
 }
 
-static int s_bHostWepRxEncryption(struct vnt_private *pDevice, u8 *pbyFrame,
-	u32 FrameSize, u8 *pbyRsr, int bOnFly, PSKeyItem pKey, u8 *pbyNewRsr,
-	s32 *pbExtIV, u16 *pwRxTSC15_0, u32 *pdwRxTSC47_16)
-{
-	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
-	struct ieee80211_hdr *pMACHeader;
-	u32 PayloadLen = FrameSize;
-	u8 *pbyIV;
-	u8 byKeyIdx;
-	u8 byDecMode = KEY_CTL_WEP;
-
-	*pwRxTSC15_0 = 0;
-	*pdwRxTSC47_16 = 0;
-
-    pbyIV = pbyFrame + WLAN_HDR_ADDR3_LEN;
-    if ( WLAN_GET_FC_TODS(*(u16 *)pbyFrame) &&
-         WLAN_GET_FC_FROMDS(*(u16 *)pbyFrame) ) {
-         pbyIV += 6;             // 6 is 802.11 address4
-         PayloadLen -= 6;
-    }
-    byKeyIdx = (*(pbyIV+3) & 0xc0);
-    byKeyIdx >>= 6;
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"\nKeyIdx: %d\n", byKeyIdx);
-
-    if (pMgmt->byCSSGK == KEY_CTL_TKIP)
-        byDecMode = KEY_CTL_TKIP;
-    else if (pMgmt->byCSSGK == KEY_CTL_CCMP)
-        byDecMode = KEY_CTL_CCMP;
-
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"AES:%d %d %d\n", pMgmt->byCSSPK, pMgmt->byCSSGK, byDecMode);
-
-    if (byDecMode != pKey->byCipherSuite) {
-        return false;
-    }
-
-    if (byDecMode == KEY_CTL_WEP) {
-        // handle WEP
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"byDecMode == KEY_CTL_WEP\n");
-        if ((pDevice->byLocalID <= REV_ID_VT3253_A1) ||
-		(((PSKeyTable)(pKey->pvKeyTable))->bSoftWEP == true) ||
-            (bOnFly == false)) {
-            // Software WEP
-            // 1. 3253A
-            // 2. WEP 256
-            // 3. NotOnFly
-
-            PayloadLen -= (WLAN_HDR_ADDR3_LEN + 4 + 4); // 24 is 802.11 header,4 is IV, 4 is crc
-            memcpy(pDevice->abyPRNG, pbyIV, 3);
-            memcpy(pDevice->abyPRNG + 3, pKey->abyKey, pKey->uKeyLength);
-            rc4_init(&pDevice->SBox, pDevice->abyPRNG, pKey->uKeyLength + 3);
-            rc4_encrypt(&pDevice->SBox, pbyIV+4, pbyIV+4, PayloadLen);
-
-            if (ETHbIsBufferCrc32Ok(pbyIV+4, PayloadLen)) {
-                *pbyNewRsr |= NEWRSR_DECRYPTOK;
-            }
-        }
-    } else if ((byDecMode == KEY_CTL_TKIP) ||
-               (byDecMode == KEY_CTL_CCMP)) {
-        // TKIP/AES
-
-        PayloadLen -= (WLAN_HDR_ADDR3_LEN + 8 + 4); // 24 is 802.11 header, 8 is IV&ExtIV, 4 is crc
-        *pdwRxTSC47_16 = cpu_to_le32(*(u32 *)(pbyIV + 4));
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ExtIV: %x\n", *pdwRxTSC47_16);
-
-        if (byDecMode == KEY_CTL_TKIP) {
-            *pwRxTSC15_0 = cpu_to_le16(MAKEWORD(*(pbyIV+2), *pbyIV));
-        } else {
-            *pwRxTSC15_0 = cpu_to_le16(*(u16 *)pbyIV);
-        }
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"TSC0_15: %x\n", *pwRxTSC15_0);
-
-        if (byDecMode == KEY_CTL_TKIP) {
-
-            if ((pDevice->byLocalID <= REV_ID_VT3253_A1) || (bOnFly == false)) {
-                // Software TKIP
-                // 1. 3253 A
-                // 2. NotOnFly
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"soft KEY_CTL_TKIP \n");
-                pMACHeader = (struct ieee80211_hdr *) (pbyFrame);
-                TKIPvMixKey(pKey->abyKey, pMACHeader->addr2, *pwRxTSC15_0, *pdwRxTSC47_16, pDevice->abyPRNG);
-                rc4_init(&pDevice->SBox, pDevice->abyPRNG, TKIP_KEY_LEN);
-                rc4_encrypt(&pDevice->SBox, pbyIV+8, pbyIV+8, PayloadLen);
-                if (ETHbIsBufferCrc32Ok(pbyIV+8, PayloadLen)) {
-                    *pbyNewRsr |= NEWRSR_DECRYPTOK;
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ICV OK!\n");
-                } else {
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ICV FAIL!!!\n");
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"PayloadLen = %d\n", PayloadLen);
-                }
-            }
-        }
-
-        if (byDecMode == KEY_CTL_CCMP) {
-            if (bOnFly == false) {
-                // Software CCMP
-                // NotOnFly
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"soft KEY_CTL_CCMP\n");
-                if (AESbGenCCMP(pKey->abyKey, pbyFrame, FrameSize)) {
-                    *pbyNewRsr |= NEWRSR_DECRYPTOK;
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"CCMP MIC compare OK!\n");
-                } else {
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"CCMP MIC fail!\n");
-                }
-            }
-        }
-
-    }// end of TKIP/AES
-
-    if ((*(pbyIV+3) & 0x20) != 0)
-        *pbExtIV = true;
-    return true;
-}
-
 static int s_bAPModeRxData(struct vnt_private *pDevice, struct sk_buff *skb,
 	u32 FrameSize, u32 cbHeaderOffset, s32 iSANodeIndex, s32 iDANodeIndex)
 {
diff --git a/drivers/staging/vt6656/iocmd.h b/drivers/staging/vt6656/iocmd.h
index f3406da..abf1f86 100644
--- a/drivers/staging/vt6656/iocmd.h
+++ b/drivers/staging/vt6656/iocmd.h
@@ -29,57 +29,12 @@
 #ifndef __IOCMD_H__
 #define __IOCMD_H__
 
-// ioctl Command code
-#define MAGIC_CODE	                 0x3142
-#define IOCTL_CMD_TEST	            (SIOCDEVPRIVATE + 0)
-#define IOCTL_CMD_SET			    (SIOCDEVPRIVATE + 1)
-#define IOCTL_CMD_HOSTAPD           (SIOCDEVPRIVATE + 2)
-#define IOCTL_CMD_WPA               (SIOCDEVPRIVATE + 3)
-
-typedef enum tagWMAC_CMD {
-
-    WLAN_CMD_BSS_SCAN,
-    WLAN_CMD_BSS_JOIN,
-    WLAN_CMD_DISASSOC,
-    WLAN_CMD_SET_WEP,
-    WLAN_CMD_GET_LINK,
-    WLAN_CMD_GET_LISTLEN,
-    WLAN_CMD_GET_LIST,
-    WLAN_CMD_GET_MIB,
-    WLAN_CMD_GET_STAT,
-    WLAN_CMD_STOP_MAC,
-    WLAN_CMD_START_MAC,
-    WLAN_CMD_AP_START,
-    WLAN_CMD_SET_HOSTAPD,
-    WLAN_CMD_SET_HOSTAPD_STA,
-    WLAN_CMD_SET_802_1X,
-    WLAN_CMD_SET_HOST_WEP,
-    WLAN_CMD_SET_WPA,
-    WLAN_CMD_GET_NODE_CNT,
-    WLAN_CMD_ZONETYPE_SET,
-    WLAN_CMD_GET_NODE_LIST
-
-} WMAC_CMD, *PWMAC_CMD;
-
 typedef enum tagWZONETYPE {
   ZoneType_USA = 0,
   ZoneType_Japan = 1,
   ZoneType_Europe = 2
 } WZONETYPE;
 
-#define ADHOC	0
-#define INFRA	1
-#define BOTH	2
-#define AP	    3
-
-#define ADHOC_STARTED	   1
-#define ADHOC_JOINTED	   2
-
-#define PHY80211a 0
-#define PHY80211b 1
-#define PHY80211g 2
-
-#define SSID_ID                0
 #define SSID_MAXLEN            32
 #define BSSID_LEN              6
 #define WEP_NKEYS              4
@@ -88,82 +43,6 @@ typedef enum tagWZONETYPE {
 #define WEP_104BIT_LEN         13
 #define WEP_232BIT_LEN         16
 
-// Ioctl interface structure
-// Command structure
-//
-typedef struct tagSCmdRequest {
-	u8 name[16];
-	void	*data;
-	u16	    wResult;
-	u16     wCmdCode;
-} __packed SCmdRequest, *PSCmdRequest;
-
-//
-// Scan
-//
-
-typedef struct tagSCmdScan {
-
-    u8	    ssid[SSID_MAXLEN + 2];
-
-} __packed SCmdScan, *PSCmdScan;
-
-//
-// BSS Join
-//
-
-typedef struct tagSCmdBSSJoin {
-
-    u16	    wBSSType;
-    u16     wBBPType;
-    u8	    ssid[SSID_MAXLEN + 2];
-    u32	    uChannel;
-    bool    bPSEnable;
-    bool    bShareKeyAuth;
-
-} __packed SCmdBSSJoin, *PSCmdBSSJoin;
-
-//
-// Zonetype Setting
-//
-
-typedef struct tagSCmdZoneTypeSet {
-
- bool       bWrite;
- WZONETYPE  ZoneType;
-
-} __packed SCmdZoneTypeSet, *PSCmdZoneTypeSet;
-
-typedef struct tagSWPAResult {
-         char	ifname[100];
-	u8 proto;
-	u8 key_mgmt;
-	u8 eap_type;
-         bool authenticated;
-} __packed SWPAResult, *PSWPAResult;
-
-typedef struct tagSCmdStartAP {
-
-    u16	    wBSSType;
-    u16     wBBPType;
-    u8	    ssid[SSID_MAXLEN + 2];
-	u32 uChannel;
-	u32 uBeaconInt;
-    bool    bShareKeyAuth;
-    u8      byBasicRate;
-
-} __packed SCmdStartAP, *PSCmdStartAP;
-
-typedef struct tagSCmdSetWEP {
-
-    bool    bEnableWep;
-    u8      byKeyIndex;
-    u8      abyWepKey[WEP_NKEYS][WEP_KEYMAXLEN];
-    bool    bWepKeyAvailable[WEP_NKEYS];
-    u32     auWepKeyLength[WEP_NKEYS];
-
-} __packed SCmdSetWEP, *PSCmdSetWEP;
-
 typedef struct tagSBSSIDItem {
 
 	u32	    uChannel;
@@ -177,12 +56,6 @@ typedef struct tagSBSSIDItem {
 
 } __packed SBSSIDItem;
 
-typedef struct tagSBSSIDList {
-
-	u32		    uItem;
-	SBSSIDItem	sBSSIDList[0];
-} __packed SBSSIDList, *PSBSSIDList;
-
 typedef struct tagSNodeItem {
     // STA info
     u16            wAID;
@@ -203,180 +76,6 @@ typedef struct tagSNodeItem {
 
 } __packed SNodeItem;
 
-typedef struct tagSNodeList {
-
-	u32		    uItem;
-	SNodeItem	sNodeList[0];
-
-} __packed SNodeList, *PSNodeList;
-
-typedef struct tagSCmdLinkStatus {
-
-    bool    bLink;
-	u16	    wBSSType;
-	u8      byState;
-    u8      abyBSSID[BSSID_LEN];
-    u8      abySSID[SSID_MAXLEN + 2];
-    u32     uChannel;
-    u32     uLinkRate;
-
-} __packed SCmdLinkStatus, *PSCmdLinkStatus;
-
-//
-// 802.11 counter
-//
-typedef struct tagSDot11MIBCount {
-    u32 TransmittedFragmentCount;
-    u32 MulticastTransmittedFrameCount;
-    u32 FailedCount;
-    u32 RetryCount;
-    u32 MultipleRetryCount;
-    u32 RTSSuccessCount;
-    u32 RTSFailureCount;
-    u32 ACKFailureCount;
-    u32 FrameDuplicateCount;
-    u32 ReceivedFragmentCount;
-    u32 MulticastReceivedFrameCount;
-    u32 FCSErrorCount;
-} __packed SDot11MIBCount, *PSDot11MIBCount;
-
-//
-// statistic counter
-//
-typedef struct tagSStatMIBCount {
-    //
-    // ISR status count
-    //
-    u32   dwIsrTx0OK;
-    u32   dwIsrTx1OK;
-    u32   dwIsrBeaconTxOK;
-    u32   dwIsrRxOK;
-    u32   dwIsrTBTTInt;
-    u32   dwIsrSTIMERInt;
-    u32   dwIsrUnrecoverableError;
-    u32   dwIsrSoftInterrupt;
-    u32   dwIsrRxNoBuf;
-    /////////////////////////////////////
-
-	u32 dwIsrUnknown; /* unknown interrupt count */
-
-    // RSR status count
-    //
-    u32   dwRsrFrmAlgnErr;
-    u32   dwRsrErr;
-    u32   dwRsrCRCErr;
-    u32   dwRsrCRCOk;
-    u32   dwRsrBSSIDOk;
-    u32   dwRsrADDROk;
-    u32   dwRsrICVOk;
-    u32   dwNewRsrShortPreamble;
-    u32   dwRsrLong;
-    u32   dwRsrRunt;
-
-    u32   dwRsrRxControl;
-    u32   dwRsrRxData;
-    u32   dwRsrRxManage;
-
-    u32   dwRsrRxPacket;
-    u32   dwRsrRxOctet;
-    u32   dwRsrBroadcast;
-    u32   dwRsrMulticast;
-    u32   dwRsrDirected;
-    // 64-bit OID
-    u32   ullRsrOK;
-
-    // for some optional OIDs (64 bits) and DMI support
-    u32   ullRxBroadcastBytes;
-    u32   ullRxMulticastBytes;
-    u32   ullRxDirectedBytes;
-    u32   ullRxBroadcastFrames;
-    u32   ullRxMulticastFrames;
-    u32   ullRxDirectedFrames;
-
-    u32   dwRsrRxFragment;
-    u32   dwRsrRxFrmLen64;
-    u32   dwRsrRxFrmLen65_127;
-    u32   dwRsrRxFrmLen128_255;
-    u32   dwRsrRxFrmLen256_511;
-    u32   dwRsrRxFrmLen512_1023;
-    u32   dwRsrRxFrmLen1024_1518;
-
-    // TSR0,1 status count
-    //
-	u32 dwTsrTotalRetry[2];        /* total collision retry count */
-	u32 dwTsrOnceRetry[2];         /* this packet had one collision */
-	u32 dwTsrMoreThanOnceRetry[2]; /* this packet had many collisions */
-	u32 dwTsrRetry[2];             /* this packet has ever occur collision,
-					* that is (dwTsrOnceCollision0 plus
-					* dwTsrMoreThanOnceCollision0) */
-    u32   dwTsrACKData[2];
-    u32   dwTsrErr[2];
-    u32   dwAllTsrOK[2];
-    u32   dwTsrRetryTimeout[2];
-    u32   dwTsrTransmitTimeout[2];
-
-    u32   dwTsrTxPacket[2];
-    u32   dwTsrTxOctet[2];
-    u32   dwTsrBroadcast[2];
-    u32   dwTsrMulticast[2];
-    u32   dwTsrDirected[2];
-
-    // RD/TD count
-    u32   dwCntRxFrmLength;
-    u32   dwCntTxBufLength;
-
-    u8    abyCntRxPattern[16];
-    u8    abyCntTxPattern[16];
-
-	/* Software check.... */
-	u32 dwCntRxDataErr;  /* rx buffer data CRC err count */
-	u32 dwCntDecryptErr; /* rx buffer data CRC err count */
-	u32 dwCntRxICVErr;   /* rx buffer data CRC err count */
-	u32 idxRxErrorDesc;  /* index for rx data error RD */
-
-	/* 64-bit OID */
-	u32   ullTsrOK[2];
-
-    // for some optional OIDs (64 bits) and DMI support
-    u32   ullTxBroadcastFrames[2];
-    u32   ullTxMulticastFrames[2];
-    u32   ullTxDirectedFrames[2];
-    u32   ullTxBroadcastBytes[2];
-    u32   ullTxMulticastBytes[2];
-    u32   ullTxDirectedBytes[2];
-} __packed SStatMIBCount, *PSStatMIBCount;
-
-typedef struct tagSCmdValue {
-
-    u32     dwValue;
-
-} __packed SCmdValue,  *PSCmdValue;
-
-//
-// hostapd & viawget ioctl related
-//
-
-// VIAGWET_IOCTL_HOSTAPD ioctl() cmd:
-enum {
-	VIAWGET_HOSTAPD_FLUSH = 1,
-	VIAWGET_HOSTAPD_ADD_STA = 2,
-	VIAWGET_HOSTAPD_REMOVE_STA = 3,
-	VIAWGET_HOSTAPD_GET_INFO_STA = 4,
-	VIAWGET_HOSTAPD_SET_ENCRYPTION = 5,
-	VIAWGET_HOSTAPD_GET_ENCRYPTION = 6,
-	VIAWGET_HOSTAPD_SET_FLAGS_STA = 7,
-	VIAWGET_HOSTAPD_SET_ASSOC_AP_ADDR = 8,
-	VIAWGET_HOSTAPD_SET_GENERIC_ELEMENT = 9,
-	VIAWGET_HOSTAPD_MLME = 10,
-	VIAWGET_HOSTAPD_SCAN_REQ = 11,
-	VIAWGET_HOSTAPD_STA_CLEAR_STATS = 12,
-};
-
-#define VIAWGET_HOSTAPD_GENERIC_ELEMENT_HDR_LEN \
-((int) (&((struct viawget_hostapd_param *) 0)->u.generic_elem.data))
-
-// Maximum length for algorithm names (-1 for nul termination) used in ioctl()
-
 struct viawget_hostapd_param {
 	u32 cmd;
 	u8 sta_addr[6];
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index a148ced..de2ae1d 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -382,12 +382,6 @@ int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
 	if (pMgmt == NULL)
 		return -EFAULT;
 
-	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP && pDevice->bEnableHostapd) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-			"Can't set operation mode, hostapd is running\n");
-		return rc;
-	}
-
 	switch (*wmode) {
 	case IW_MODE_ADHOC:
 		if (pMgmt->eConfigMode != WMAC_CONFIG_IBSS_STA) {
@@ -407,19 +401,9 @@ int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to infrastructure\n");
 		break;
 	case IW_MODE_MASTER:
-
-		pMgmt->eConfigMode = WMAC_CONFIG_ESS_STA;
 		rc = -EOPNOTSUPP;
 		break;
 
-		if (pMgmt->eConfigMode != WMAC_CONFIG_AP) {
-			pMgmt->eConfigMode = WMAC_CONFIG_AP;
-			if (pDevice->flags & DEVICE_FLAGS_OPENED)
-				pDevice->bCommit = true;
-		}
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to Access Point\n");
-		break;
-
 	case IW_MODE_REPEAT:
 		pMgmt->eConfigMode = WMAC_CONFIG_ESS_STA;
 		rc = -EOPNOTSUPP;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index b38be8d..9f888d5 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -216,7 +216,6 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 static int device_init_registers(struct vnt_private *pDevice);
 static bool device_init_defrag_cb(struct vnt_private *pDevice);
 static void device_init_diversity_timer(struct vnt_private *pDevice);
-static int  device_dma0_tx_80211(struct sk_buff *skb, struct net_device *dev);
 
 static int  ethtool_ioctl(struct net_device *dev, struct ifreq *);
 static void device_free_tx_bufs(struct vnt_private *pDevice);
@@ -683,7 +682,6 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	INIT_WORK(&pDevice->read_work_item, RXvWorkItem);
 	INIT_WORK(&pDevice->rx_mng_work_item, RXvMngWorkItem);
 
-	pDevice->tx_80211 = device_dma0_tx_80211;
 	pDevice->vnt_mgmt.pAdapter = (void *) pDevice;
 
 	netdev->netdev_ops = &device_netdev_ops;
@@ -1108,22 +1106,6 @@ static void vt6656_disconnect(struct usb_interface *intf)
 	}
 }
 
-static int device_dma0_tx_80211(struct sk_buff *skb, struct net_device *dev)
-{
-	struct vnt_private *pDevice = netdev_priv(dev);
-
-	spin_lock_irq(&pDevice->lock);
-
-	if (unlikely(pDevice->bStopTx0Pkt))
-		dev_kfree_skb_irq(skb);
-	else
-		vDMA0_tx_80211(pDevice, skb);
-
-	spin_unlock_irq(&pDevice->lock);
-
-	return NETDEV_TX_OK;
-}
-
 static int device_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct vnt_private *pDevice = netdev_priv(dev);
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 8e0045a..7713181 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -954,7 +954,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 	u32 *pcbHeaderLen, u32 *pcbTotalLen)
 {
 	struct vnt_tx_fifo_head *pTxBufHead = &tx_buffer->fifo_head;
-	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	u32 cbFrameSize, cbFrameBodySize;
 	u32 cb802_1_H_len;
 	u32 cbIVlen = 0, cbICVlen = 0, cbMIClen = 0, cbMACHdLen = 0;
@@ -1160,11 +1159,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
         //Fill TXKEY
 	s_vFillTxKey(pDevice, pTxBufHead, pbyIVHead, pTransmitKey,
 		pbyMacHdr, (u16)cbFrameBodySize, pMICHDR);
-
-        if (pDevice->bEnableHostWEP) {
-            pMgmt->sNodeDBTable[uNodeIndex].dwTSC47_16 = pTransmitKey->dwTSC47_16;
-            pMgmt->sNodeDBTable[uNodeIndex].wTSC15_0 = pTransmitKey->wTSC15_0;
-        }
     }
 
 	/* 802.1H */
@@ -1713,364 +1707,6 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 
 }
 
-void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
-{
-	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
-	struct vnt_tx_buffer *pTX_Buffer;
-	struct vnt_tx_fifo_head *pTxBufHead;
-	u8 byPktType;
-	u8 *pbyTxBufferAddr;
-	u32 uDuration, cbReqCount;
-	struct ieee80211_hdr *pMACHeader;
-	u32 cbHeaderSize, cbFrameBodySize;
-	int bNeedACK, bIsPSPOLL = false;
-	u32 cbFrameSize;
-	u32 cbIVlen = 0, cbICVlen = 0, cbMIClen = 0, cbFCSlen = 4;
-	u32 uPadding = 0;
-	u32 cbMICHDR = 0, uLength = 0;
-	u32 dwMICKey0, dwMICKey1;
-	u32 dwMIC_Priority;
-	u32 *pdwMIC_L, *pdwMIC_R;
-	u16 wTxBufSize;
-	u32 cbMacHdLen;
-	struct ethhdr sEthHeader;
-	struct vnt_mic_hdr *pMICHDR;
-	u32 wCurrentRate = RATE_1M;
-	PUWLAN_80211HDR  p80211Header;
-	u32 uNodeIndex = 0;
-	int bNodeExist = false;
-	SKeyItem STempKey;
-	PSKeyItem pTransmitKey = NULL;
-	u8 *pbyIVHead, *pbyPayloadHead, *pbyMacHdr;
-	u32 cbExtSuppRate = 0;
-	struct vnt_usb_send_context *pContext;
-
-	pMICHDR = NULL;
-
-    if(skb->len <= WLAN_HDR_ADDR3_LEN) {
-       cbFrameBodySize = 0;
-    }
-    else {
-       cbFrameBodySize = skb->len - WLAN_HDR_ADDR3_LEN;
-    }
-    p80211Header = (PUWLAN_80211HDR)skb->data;
-
-	pContext = s_vGetFreeContext(pDevice);
-
-    if (NULL == pContext) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"DMA0 TX...NO CONTEXT!\n");
-        dev_kfree_skb_irq(skb);
-        return ;
-    }
-
-	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->data[0];
-	pTxBufHead = &pTX_Buffer->fifo_head;
-	pbyTxBufferAddr = (u8 *)&pTxBufHead->adwTxKey[0];
-	wTxBufSize = sizeof(struct vnt_tx_fifo_head);
-
-    if (pDevice->byBBType == BB_TYPE_11A) {
-        wCurrentRate = RATE_6M;
-        byPktType = PK_TYPE_11A;
-    } else {
-        wCurrentRate = RATE_1M;
-        byPktType = PK_TYPE_11B;
-    }
-
-    // SetPower will cause error power TX state for OFDM Date packet in TX buffer.
-    // 2004.11.11 Kyle -- Using OFDM power to tx MngPkt will decrease the connection capability.
-    //                    And cmd timer will wait data pkt TX finish before scanning so it's OK
-    //                    to set power here.
-	if (wCurrentRate != pDevice->wCurrentRate) {
-		pDevice->wCurrentRate = wCurrentRate;
-
-		bScheduleCommand(pDevice, WLAN_CMD_SETPOWER, NULL);
-	}
-
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"vDMA0_tx_80211: p80211Header->sA3.wFrameCtl = %x \n", p80211Header->sA3.wFrameCtl);
-
-    //Set packet type
-    if (byPktType == PK_TYPE_11A) {//0000 0000 0000 0000
-        pTxBufHead->wFIFOCtl = 0;
-    }
-    else if (byPktType == PK_TYPE_11B) {//0000 0001 0000 0000
-        pTxBufHead->wFIFOCtl |= FIFOCTL_11B;
-    }
-    else if (byPktType == PK_TYPE_11GB) {//0000 0010 0000 0000
-        pTxBufHead->wFIFOCtl |= FIFOCTL_11GB;
-    }
-    else if (byPktType == PK_TYPE_11GA) {//0000 0011 0000 0000
-        pTxBufHead->wFIFOCtl |= FIFOCTL_11GA;
-    }
-
-    pTxBufHead->wFIFOCtl |= FIFOCTL_TMOEN;
-    pTxBufHead->time_stamp = cpu_to_le16(DEFAULT_MGN_LIFETIME_RES_64us);
-
-    if (is_multicast_ether_addr(p80211Header->sA3.abyAddr1)) {
-        bNeedACK = false;
-        if (pDevice->bEnableHostWEP) {
-            uNodeIndex = 0;
-            bNodeExist = true;
-        }
-    }
-    else {
-        if (pDevice->bEnableHostWEP) {
-            if (BSSbIsSTAInNodeDB(pDevice, (u8 *)(p80211Header->sA3.abyAddr1), &uNodeIndex))
-                bNodeExist = true;
-        }
-        bNeedACK = true;
-        pTxBufHead->wFIFOCtl |= FIFOCTL_NEEDACK;
-    };
-
-    if ((pMgmt->eCurrMode == WMAC_MODE_ESS_AP) ||
-        (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) ) {
-
-        pTxBufHead->wFIFOCtl |= FIFOCTL_LRETRY;
-        //Set Preamble type always long
-        //pDevice->byPreambleType = PREAMBLE_LONG;
-
-        // probe-response don't retry
-        //if ((p80211Header->sA4.wFrameCtl & TYPE_SUBTYPE_MASK) == TYPE_MGMT_PROBE_RSP) {
-        //     bNeedACK = false;
-        //     pTxBufHead->wFIFOCtl  &= (~FIFOCTL_NEEDACK);
-        //}
-    }
-
-    pTxBufHead->wFIFOCtl |= (FIFOCTL_GENINT | FIFOCTL_ISDMA0);
-
-    if ((p80211Header->sA4.wFrameCtl & TYPE_SUBTYPE_MASK) == TYPE_CTL_PSPOLL) {
-        bIsPSPOLL = true;
-        cbMacHdLen = WLAN_HDR_ADDR2_LEN;
-    } else {
-        cbMacHdLen = WLAN_HDR_ADDR3_LEN;
-    }
-
-    // hostapd daemon ext support rate patch
-    if (WLAN_GET_FC_FSTYPE(p80211Header->sA4.wFrameCtl) == WLAN_FSTYPE_ASSOCRESP) {
-
-        if (((PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates)->len != 0) {
-            cbExtSuppRate += ((PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates)->len + WLAN_IEHDR_LEN;
-         }
-
-        if (((PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates)->len != 0) {
-            cbExtSuppRate += ((PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates)->len + WLAN_IEHDR_LEN;
-         }
-
-         if (cbExtSuppRate >0) {
-            cbFrameBodySize = WLAN_ASSOCRESP_OFF_SUPP_RATES;
-         }
-    }
-
-    //Set FRAGCTL_MACHDCNT
-    pTxBufHead->wFragCtl |= cpu_to_le16((u16)cbMacHdLen << 10);
-
-    // Notes:
-    // Although spec says MMPDU can be fragmented; In most case,
-    // no one will send a MMPDU under fragmentation. With RTS may occur.
-
-    if (WLAN_GET_FC_ISWEP(p80211Header->sA4.wFrameCtl) != 0) {
-        if (pDevice->eEncryptionStatus == Ndis802_11Encryption1Enabled) {
-            cbIVlen = 4;
-            cbICVlen = 4;
-    	    pTxBufHead->wFragCtl |= FRAGCTL_LEGACY;
-        }
-        else if (pDevice->eEncryptionStatus == Ndis802_11Encryption2Enabled) {
-            cbIVlen = 8;//IV+ExtIV
-            cbMIClen = 8;
-            cbICVlen = 4;
-    	    pTxBufHead->wFragCtl |= FRAGCTL_TKIP;
-    	    //We need to get seed here for filling TxKey entry.
-            //TKIPvMixKey(pTransmitKey->abyKey, pDevice->abyCurrentNetAddr,
-            //            pTransmitKey->wTSC15_0, pTransmitKey->dwTSC47_16, pDevice->abyPRNG);
-        }
-        else if (pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled) {
-            cbIVlen = 8;//RSN Header
-            cbICVlen = 8;//MIC
-	    cbMICHDR = sizeof(struct vnt_mic_hdr);
-            pTxBufHead->wFragCtl |= FRAGCTL_AES;
-        }
-        //MAC Header should be padding 0 to DW alignment.
-        uPadding = 4 - (cbMacHdLen%4);
-        uPadding %= 4;
-    }
-
-    cbFrameSize = cbMacHdLen + cbFrameBodySize + cbIVlen + cbMIClen + cbICVlen + cbFCSlen + cbExtSuppRate;
-
-    //Set FIFOCTL_GrpAckPolicy
-    if (pDevice->bGrpAckPolicy == true) {//0000 0100 0000 0000
-        pTxBufHead->wFIFOCtl |=	FIFOCTL_GRPACK;
-    }
-    //the rest of pTxBufHead->wFragCtl:FragTyp will be set later in s_vFillFragParameter()
-
-    if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
-	cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR +
-		sizeof(struct vnt_cts);
-
-    }
-    else {//802.11a/b packet
-	cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR +
-					sizeof(struct vnt_tx_datahead_ab);
-    }
-    memcpy(&(sEthHeader.h_dest[0]),
-	   &(p80211Header->sA3.abyAddr1[0]),
-	   ETH_ALEN);
-    memcpy(&(sEthHeader.h_source[0]),
-	   &(p80211Header->sA3.abyAddr2[0]),
-	   ETH_ALEN);
-    //=========================
-    //    No Fragmentation
-    //=========================
-    pTxBufHead->wFragCtl |= (u16)FRAGCTL_NONFRAG;
-
-	/* Fill FIFO,RrvTime,RTS,and CTS */
-	uDuration = s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
-		pTX_Buffer, &pMICHDR, cbMICHDR,
-		cbFrameSize, bNeedACK, &sEthHeader, false);
-
-	pMACHeader = (struct ieee80211_hdr *) (pbyTxBufferAddr + cbHeaderSize);
-
-    cbReqCount = cbHeaderSize + cbMacHdLen + uPadding + cbIVlen + (cbFrameBodySize + cbMIClen) + cbExtSuppRate;
-
-    pbyMacHdr = (u8 *)(pbyTxBufferAddr + cbHeaderSize);
-    pbyPayloadHead = (u8 *)(pbyMacHdr + cbMacHdLen + uPadding + cbIVlen);
-    pbyIVHead = (u8 *)(pbyMacHdr + cbMacHdLen + uPadding);
-
-    // Copy the Packet into a tx Buffer
-    memcpy(pbyMacHdr, skb->data, cbMacHdLen);
-
-    // version set to 0, patch for hostapd deamon
-    pMACHeader->frame_control &= cpu_to_le16(0xfffc);
-    memcpy(pbyPayloadHead, (skb->data + cbMacHdLen), cbFrameBodySize);
-
-    // replace support rate, patch for hostapd daemon( only support 11M)
-    if (WLAN_GET_FC_FSTYPE(p80211Header->sA4.wFrameCtl) == WLAN_FSTYPE_ASSOCRESP) {
-        if (cbExtSuppRate != 0) {
-            if (((PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates)->len != 0)
-                memcpy((pbyPayloadHead + cbFrameBodySize),
-                        pMgmt->abyCurrSuppRates,
-                        ((PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates)->len + WLAN_IEHDR_LEN
-                       );
-             if (((PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates)->len != 0)
-                memcpy((pbyPayloadHead + cbFrameBodySize) + ((PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates)->len + WLAN_IEHDR_LEN,
-                        pMgmt->abyCurrExtSuppRates,
-                        ((PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates)->len + WLAN_IEHDR_LEN
-                       );
-         }
-    }
-
-    // Set wep
-    if (WLAN_GET_FC_ISWEP(p80211Header->sA4.wFrameCtl) != 0) {
-
-        if (pDevice->bEnableHostWEP) {
-            pTransmitKey = &STempKey;
-            pTransmitKey->byCipherSuite = pMgmt->sNodeDBTable[uNodeIndex].byCipherSuite;
-            pTransmitKey->dwKeyIndex = pMgmt->sNodeDBTable[uNodeIndex].dwKeyIndex;
-            pTransmitKey->uKeyLength = pMgmt->sNodeDBTable[uNodeIndex].uWepKeyLength;
-            pTransmitKey->dwTSC47_16 = pMgmt->sNodeDBTable[uNodeIndex].dwTSC47_16;
-            pTransmitKey->wTSC15_0 = pMgmt->sNodeDBTable[uNodeIndex].wTSC15_0;
-            memcpy(pTransmitKey->abyKey,
-                &pMgmt->sNodeDBTable[uNodeIndex].abyWepKey[0],
-                pTransmitKey->uKeyLength
-                );
-        }
-
-        if ((pTransmitKey != NULL) && (pTransmitKey->byCipherSuite == KEY_CTL_TKIP)) {
-
-            dwMICKey0 = *(u32 *)(&pTransmitKey->abyKey[16]);
-            dwMICKey1 = *(u32 *)(&pTransmitKey->abyKey[20]);
-
-            // DO Software Michael
-            MIC_vInit(dwMICKey0, dwMICKey1);
-            MIC_vAppend((u8 *)&(sEthHeader.h_dest[0]), 12);
-            dwMIC_Priority = 0;
-            MIC_vAppend((u8 *)&dwMIC_Priority, 4);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"DMA0_tx_8021:MIC KEY:"\
-			" %X, %X\n", dwMICKey0, dwMICKey1);
-
-            uLength = cbHeaderSize + cbMacHdLen + uPadding + cbIVlen;
-
-            MIC_vAppend((pbyTxBufferAddr + uLength), cbFrameBodySize);
-
-            pdwMIC_L = (u32 *)(pbyTxBufferAddr + uLength + cbFrameBodySize);
-            pdwMIC_R = (u32 *)(pbyTxBufferAddr + uLength + cbFrameBodySize + 4);
-
-            MIC_vGetMIC(pdwMIC_L, pdwMIC_R);
-            MIC_vUnInit();
-
-            if (pDevice->bTxMICFail == true) {
-                *pdwMIC_L = 0;
-                *pdwMIC_R = 0;
-                pDevice->bTxMICFail = false;
-            }
-
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"uLength: %d, %d\n", uLength, cbFrameBodySize);
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"cbReqCount:%d, %d, %d, %d\n", cbReqCount, cbHeaderSize, uPadding, cbIVlen);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"MIC:%x, %x\n",
-			*pdwMIC_L, *pdwMIC_R);
-
-        }
-
-	s_vFillTxKey(pDevice, pTxBufHead, pbyIVHead, pTransmitKey,
-		pbyMacHdr, (u16)cbFrameBodySize, pMICHDR);
-
-        if (pDevice->bEnableHostWEP) {
-            pMgmt->sNodeDBTable[uNodeIndex].dwTSC47_16 = pTransmitKey->dwTSC47_16;
-            pMgmt->sNodeDBTable[uNodeIndex].wTSC15_0 = pTransmitKey->wTSC15_0;
-        }
-
-        if ((pDevice->byLocalID <= REV_ID_VT3253_A1)) {
-            s_vSWencryption(pDevice, pTransmitKey, pbyPayloadHead, (u16)(cbFrameBodySize + cbMIClen));
-        }
-    }
-
-    pMACHeader->seq_ctrl = cpu_to_le16(pDevice->wSeqCounter << 4);
-    pDevice->wSeqCounter++ ;
-    if (pDevice->wSeqCounter > 0x0fff)
-        pDevice->wSeqCounter = 0;
-
-    if (bIsPSPOLL) {
-        // The MAC will automatically replace the Duration-field of MAC header by Duration-field
-        // of  FIFO control header.
-        // This will cause AID-field of PS-POLL packet be incorrect (Because PS-POLL's AID field is
-        // in the same place of other packet's Duration-field).
-        // And it will cause Cisco-AP to issue Disassociation-packet
-	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
-		struct vnt_tx_datahead_g *data_head = &pTX_Buffer->tx_head.
-						tx_cts.tx.head.cts_g.data_head;
-		data_head->duration_a =
-			cpu_to_le16(p80211Header->sA2.wDurationID);
-		data_head->duration_b =
-			cpu_to_le16(p80211Header->sA2.wDurationID);
-	} else {
-		struct vnt_tx_datahead_ab *data_head = &pTX_Buffer->tx_head.
-					tx_ab.tx.head.data_head_ab;
-		data_head->duration =
-			cpu_to_le16(p80211Header->sA2.wDurationID);
-	}
-    }
-
-    pTX_Buffer->tx_byte_count = cpu_to_le16((u16)(cbReqCount));
-    pTX_Buffer->byPKTNO = (u8) (((wCurrentRate<<4) &0x00F0) | ((pDevice->wSeqCounter - 1) & 0x000F));
-    pTX_Buffer->byType = 0x00;
-
-	pContext->skb = skb;
-	pContext->type = CONTEXT_MGMT_PACKET;
-	pContext->buf_len = (u16)cbReqCount + 4;  /* USB header */
-
-    if (WLAN_GET_FC_TODS(pMACHeader->frame_control) == 0) {
-	s_vSaveTxPktInfo(pDevice, (u8)(pTX_Buffer->byPKTNO & 0x0F),
-			&pMACHeader->addr1[0], (u16)cbFrameSize,
-			pTxBufHead->wFIFOCtl);
-    }
-    else {
-	s_vSaveTxPktInfo(pDevice, (u8)(pTX_Buffer->byPKTNO & 0x0F),
-			&pMACHeader->addr3[0], (u16)cbFrameSize,
-			pTxBufHead->wFIFOCtl);
-    }
-    PIPEnsSendBulkOut(pDevice,pContext);
-    return ;
-
-}
-
 //TYPE_AC0DMA data tx
 /*
  * Description:
@@ -2098,7 +1734,6 @@ int nsDMA_tx_packet(struct vnt_private *pDevice, struct sk_buff *skb)
 	u8 byPktType;
 	int bNeedEncryption = false;
 	PSKeyItem pTransmitKey = NULL;
-	SKeyItem STempKey;
 	int ii;
 	int bTKIP_UseGTK = false;
 	int bNeedDeAuth = false;
@@ -2262,22 +1897,6 @@ int nsDMA_tx_packet(struct vnt_private *pDevice, struct sk_buff *skb)
         } while(false);
     }
 
-    if (pDevice->bEnableHostWEP) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG"acdma0: STA index %d\n", uNodeIndex);
-        if (pDevice->bEncryptionEnable == true) {
-            pTransmitKey = &STempKey;
-            pTransmitKey->byCipherSuite = pMgmt->sNodeDBTable[uNodeIndex].byCipherSuite;
-            pTransmitKey->dwKeyIndex = pMgmt->sNodeDBTable[uNodeIndex].dwKeyIndex;
-            pTransmitKey->uKeyLength = pMgmt->sNodeDBTable[uNodeIndex].uWepKeyLength;
-            pTransmitKey->dwTSC47_16 = pMgmt->sNodeDBTable[uNodeIndex].dwTSC47_16;
-            pTransmitKey->wTSC15_0 = pMgmt->sNodeDBTable[uNodeIndex].wTSC15_0;
-            memcpy(pTransmitKey->abyKey,
-                &pMgmt->sNodeDBTable[uNodeIndex].abyWepKey[0],
-                pTransmitKey->uKeyLength
-                );
-         }
-    }
-
     byPktType = (u8)pDevice->byPacketType;
 
     if (pDevice->bFixRate) {
@@ -2381,15 +2000,6 @@ int nsDMA_tx_packet(struct vnt_private *pDevice, struct sk_buff *skb)
                     }
                 }
             }
-
-            if (pDevice->bEnableHostWEP) {
-                if ((uNodeIndex != 0) &&
-                    (pMgmt->sNodeDBTable[uNodeIndex].dwKeyIndex & PAIRWISE_KEY)) {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Find PTK [%X]\n",
-				pTransmitKey->dwKeyIndex);
-                    bNeedEncryption = true;
-                 }
-             }
         }
         else {
 
@@ -2487,7 +2097,6 @@ int bRelayPacketSend(struct vnt_private *pDevice, u8 *pbySkbData, u32 uDataLen,
 	u32 BytesToWrite = 0, uHeaderLen = 0;
 	u8 byPktType = PK_TYPE_11B;
 	int bNeedEncryption = false;
-	SKeyItem STempKey;
 	PSKeyItem pTransmitKey = NULL;
 	u8 *pbyBSSID;
 	struct vnt_usb_send_context *pContext;
@@ -2516,21 +2125,6 @@ int bRelayPacketSend(struct vnt_private *pDevice, u8 *pbySkbData, u32 uDataLen,
         }
     }
 
-    if (pDevice->bEnableHostWEP) {
-        if (uNodeIndex < MAX_NODE_NUM + 1) {
-            pTransmitKey = &STempKey;
-            pTransmitKey->byCipherSuite = pMgmt->sNodeDBTable[uNodeIndex].byCipherSuite;
-            pTransmitKey->dwKeyIndex = pMgmt->sNodeDBTable[uNodeIndex].dwKeyIndex;
-            pTransmitKey->uKeyLength = pMgmt->sNodeDBTable[uNodeIndex].uWepKeyLength;
-            pTransmitKey->dwTSC47_16 = pMgmt->sNodeDBTable[uNodeIndex].dwTSC47_16;
-            pTransmitKey->wTSC15_0 = pMgmt->sNodeDBTable[uNodeIndex].wTSC15_0;
-            memcpy(pTransmitKey->abyKey,
-                    &pMgmt->sNodeDBTable[uNodeIndex].abyWepKey[0],
-                    pTransmitKey->uKeyLength
-                  );
-        }
-    }
-
     if ( bNeedEncryption && (pTransmitKey == NULL) ) {
 	pContext->in_use = false;
         return false;
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index b742460..ff4e4ae 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -627,10 +627,9 @@ void vRunCommand(struct work_struct *work)
 			pMgmt->eCurrMode = WMAC_MODE_STANDBY;
 			pDevice->bLinkPass = false;
 			ControlvMaskByte(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PAPEDELAY, LEDSTS_STS, LEDSTS_SLOW);
-			if (pDevice->bEnableHostWEP == true)
-				BSSvClearNodeDBTable(pDevice, 1);
-			else
-				BSSvClearNodeDBTable(pDevice, 0);
+
+			BSSvClearNodeDBTable(pDevice, 0);
+
 			pDevice->uAssocCount = 0;
 			pMgmt->eCurrState = WMAC_STATE_IDLE;
 			pDevice->bFixRate = false;
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index e6eec7f..4f46aa6 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -540,10 +540,6 @@ static void s_vMgrRxAssocRequest(struct vnt_private *pDevice,
                   (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates
                 );
     if (pTxPacket != NULL ){
-
-        if (pDevice->bEnableHostapd) {
-            return;
-        }
         /* send the frame */
         Status = csMgmt_xmit(pDevice, pTxPacket);
         if (Status != CMD_STATUS_PENDING) {
@@ -689,9 +685,6 @@ static void s_vMgrRxReAssocRequest(struct vnt_private *pDevice,
 
     if (pTxPacket != NULL ){
         /* send the frame */
-        if (pDevice->bEnableHostapd) {
-            return;
-        }
         Status = csMgmt_xmit(pDevice, pTxPacket);
         if (Status != CMD_STATUS_PENDING) {
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:ReAssoc response tx failed\n");
@@ -1074,9 +1067,6 @@ static void s_vMgrRxAuthenSequence_1(struct vnt_private *pDevice,
     pTxPacket->cbMPDULen = sFrame.len;
     pTxPacket->cbPayloadLen = sFrame.len - WLAN_HDR_ADDR3_LEN;
     // send the frame
-    if (pDevice->bEnableHostapd) {
-        return;
-    }
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Authreq_reply sequence_1 tx.. \n");
     if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Authreq_reply sequence_1 tx failed.\n");
@@ -1256,9 +1246,6 @@ reply:
     pTxPacket->cbMPDULen = sFrame.len;
     pTxPacket->cbPayloadLen = sFrame.len - WLAN_HDR_ADDR3_LEN;
     // send the frame
-    if (pDevice->bEnableHostapd) {
-        return;
-    }
     if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Mgt:Authreq_reply sequence_4 tx failed.\n");
     }
@@ -2929,16 +2916,6 @@ static struct vnt_tx_mgmt *s_MgrMakeBeacon(struct vnt_private *pDevice,
              ((PWLAN_IE_SUPP_RATES)pCurrExtSuppRates)->len + WLAN_IEHDR_LEN
              );
     }
-    // hostapd wpa/wpa2 IE
-    if ((pMgmt->eCurrMode == WMAC_MODE_ESS_AP) && (pDevice->bEnableHostapd == true)) {
-         if (pMgmt->eAuthenMode == WMAC_AUTH_WPANONE) {
-             if (pMgmt->wWPAIELen != 0) {
-                 sFrame.pRSN = (PWLAN_IE_RSN)(sFrame.pBuf + sFrame.len);
-                 memcpy(sFrame.pRSN, pMgmt->abyWPAIE, pMgmt->wWPAIELen);
-                 sFrame.len += pMgmt->wWPAIELen;
-             }
-         }
-    }
 
     /* Adjust the length fields */
     pTxPacket->cbMPDULen = sFrame.len;
@@ -3049,17 +3026,6 @@ static struct vnt_tx_mgmt *s_MgrMakeProbeResponse(struct vnt_private *pDevice,
              );
     }
 
-    // hostapd wpa/wpa2 IE
-    if ((pMgmt->eCurrMode == WMAC_MODE_ESS_AP) && (pDevice->bEnableHostapd == true)) {
-         if (pMgmt->eAuthenMode == WMAC_AUTH_WPANONE) {
-             if (pMgmt->wWPAIELen != 0) {
-                 sFrame.pRSN = (PWLAN_IE_RSN)(sFrame.pBuf + sFrame.len);
-                 memcpy(sFrame.pRSN, pMgmt->abyWPAIE, pMgmt->wWPAIELen);
-                 sFrame.len += pMgmt->wWPAIELen;
-             }
-         }
-    }
-
     // Adjust the length fields
     pTxPacket->cbMPDULen = sFrame.len;
     pTxPacket->cbPayloadLen = sFrame.len - WLAN_HDR_ADDR3_LEN;
@@ -4058,12 +4024,11 @@ int bMgrPrepareBeaconToSend(struct vnt_private *pDevice,
 	unsigned long flags;
 
 //    pDevice->bBeaconBufReady = false;
-    if (pDevice->bEncryptionEnable || pDevice->bEnable8021x){
-        pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_PRIVACY(1);
-    }
-    else {
-        pMgmt->wCurrCapInfo &= ~WLAN_SET_CAP_INFO_PRIVACY(1);
-    }
+	if (pDevice->bEncryptionEnable)
+		pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_PRIVACY(1);
+	else
+		pMgmt->wCurrCapInfo &= ~WLAN_SET_CAP_INFO_PRIVACY(1);
+
     pTxPacket = s_MgrMakeBeacon
                 (
                   pDevice,
-- 
1.9.1

