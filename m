Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60759 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab3LKVXl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 16:23:41 -0500
Received: by mail-wi0-f176.google.com with SMTP id hq4so7746676wib.15
        for <linux-wireless@vger.kernel.org>; Wed, 11 Dec 2013 13:23:40 -0800 (PST)
Message-ID: <1386797011.7790.9.camel@canaries64-MCP7A> (sfid-20131211_222345_829536_793B2DDF)
Subject: [PATCH 1/2] staging: vt6656: Remove unused scStatistic
 data/functions from driver.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 11 Dec 2013 21:23:31 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

None of these stats reach user. So delete them from driver

mib.c and mib.h becomes dead code as result of this patch.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/staging/vt6656/bssdb.c   |  8 --------
 drivers/staging/vt6656/device.h  |  5 -----
 drivers/staging/vt6656/dpc.c     | 43 ----------------------------------------
 drivers/staging/vt6656/int.c     | 10 ----------
 drivers/staging/vt6656/usbpipe.c | 10 ----------
 5 files changed, 76 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index c3fab7b..8d2c43d 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -1403,7 +1403,6 @@ static void s_uCalculateLinkQual(struct vnt_private *pDevice)
 	/* decide link quality */
 	if (pDevice->bLinkPass != true) {
 		pDevice->wstats.qual.qual = 0;
-		pDevice->scStatistic.SignalStren = 0;
 	} else {
 		RFvRSSITodBm(pDevice, (u8)(pDevice->uCurrRSSI), &ldBm);
 		if (-ldBm < 50)
@@ -1413,19 +1412,12 @@ static void s_uCalculateLinkQual(struct vnt_private *pDevice)
 		else
 			RssiRatio = (40-(-ldBm-50)) * 4000 / 40;
 
-		pDevice->scStatistic.SignalStren = RssiRatio / 40;
 		qual = (RssiRatio + TxOkRatio + RxOkRatio) / 100;
 		if (qual < 100)
 			pDevice->wstats.qual.qual = (u8)qual;
 		else
 			pDevice->wstats.qual.qual = 100;
 	}
-
-   pDevice->scStatistic.RxFcsErrCnt = 0;
-   pDevice->scStatistic.RxOkCnt = 0;
-   pDevice->scStatistic.TxFailCount = 0;
-   pDevice->scStatistic.TxNoRetryOkCount = 0;
-   pDevice->scStatistic.TxRetryOkCount = 0;
 }
 
 void BSSvClearAnyBSSJoinRecord(struct vnt_private *pDevice)
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index c58c69a..7dfe89d 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -481,11 +481,6 @@ struct vnt_private {
 
 	int bExistSWNetAddr;
 
-	/* Adapter statistics */
-	SStatCounter scStatistic;
-	/* 802.11 counter */
-	SDot11Counters s802_11Counter;
-
 	/* Maintain statistical debug info. */
 	unsigned long packetsReceived;
 	unsigned long packetsReceivedDropped;
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 84901c1..7b050e9 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -347,16 +347,6 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, struct vnt_rcb *pRCB,
     FrameSize = *pwPLCP_Length;
 
     pbyFrame = pbyDAddress + 8;
-    // update receive statistic counter
-
-    STAvUpdateRDStatCounter(&pDevice->scStatistic,
-                            *pbyRsr,
-                            *pbyNewRsr,
-                            *pbyRxSts,
-                            *pbyRxRate,
-                            pbyFrame,
-                            FrameSize
-                            );
 
     pMACHeader = (struct ieee80211_hdr *) pbyFrame;
 
@@ -373,7 +363,6 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, struct vnt_rcb *pRCB,
 
     if (!is_multicast_ether_addr(pMACHeader->addr1)) {
         if (WCTLbIsDuplicate(&(pDevice->sDupRxCache), (struct ieee80211_hdr *) pbyFrame)) {
-            pDevice->s802_11Counter.FrameDuplicateCount++;
             return false;
         }
 
@@ -453,14 +442,6 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, struct vnt_rcb *pRCB,
                     (pMgmt->eAuthenMode == WMAC_AUTH_WPANONE) ||
                     (pMgmt->eAuthenMode == WMAC_AUTH_WPA2) ||
                     (pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK)) {
-
-                    if ((pKey != NULL) && (pKey->byCipherSuite == KEY_CTL_TKIP)) {
-                        pDevice->s802_11Counter.TKIPICVErrors++;
-                    } else if ((pKey != NULL) && (pKey->byCipherSuite == KEY_CTL_CCMP)) {
-                        pDevice->s802_11Counter.CCMPDecryptErrors++;
-                    } else if ((pKey != NULL) && (pKey->byCipherSuite == KEY_CTL_WEP)) {
-//                      pDevice->s802_11Counter.WEPICVErrorCount.QuadPart++;
-                    }
                 }
                 return false;
             }
@@ -485,7 +466,6 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, struct vnt_rcb *pRCB,
         ) {
         // defragment
         bDeFragRx = WCTLbHandleFragment(pDevice, (struct ieee80211_hdr *) (pbyFrame), FrameSize, bIsWEP, bExtIV);
-        pDevice->s802_11Counter.ReceivedFragmentCount++;
         if (bDeFragRx) {
             // defrag complete
             // TODO skb, pbyFrame
@@ -763,8 +743,6 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, struct vnt_rcb *pRCB,
                 (pDevice->bRxMICFail == true)) {
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"MIC comparison is fail!\n");
                 pDevice->bRxMICFail = false;
-                //pDevice->s802_11Counter.TKIPLocalMICFailures.QuadPart++;
-                pDevice->s802_11Counter.TKIPLocalMICFailures++;
                 if (bDeFragRx) {
                     if (!device_alloc_frag_buf(pDevice, &pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx])) {
                         DBG_PRT(MSG_LEVEL_ERR,KERN_ERR "%s: can not alloc more frag bufs\n",
@@ -827,12 +805,6 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, struct vnt_rcb *pRCB,
                      (dwRxTSC47_16 <= dwLocalTSC47_16) &&
                      !((dwRxTSC47_16 == 0) && (dwLocalTSC47_16 == 0xFFFFFFFF))) {
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"TSC is illegal~~!\n ");
-                    if (pKey->byCipherSuite == KEY_CTL_TKIP)
-                        //pDevice->s802_11Counter.TKIPReplays.QuadPart++;
-                        pDevice->s802_11Counter.TKIPReplays++;
-                    else
-                        //pDevice->s802_11Counter.CCMPReplays.QuadPart++;
-                        pDevice->s802_11Counter.CCMPReplays++;
 
                     if (bDeFragRx) {
                         if (!device_alloc_frag_buf(pDevice, &pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx])) {
@@ -1064,19 +1036,9 @@ static int s_bHandleRxEncryption(struct vnt_private *pDevice, u8 *pbyFrame,
 
     if (pKey == NULL) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey == NULL\n");
-        if (byDecMode == KEY_CTL_WEP) {
-//            pDevice->s802_11Counter.WEPUndecryptableCount.QuadPart++;
-        } else if (pDevice->bLinkPass == true) {
-//            pDevice->s802_11Counter.DecryptFailureCount.QuadPart++;
-        }
         return false;
     }
     if (byDecMode != pKey->byCipherSuite) {
-        if (byDecMode == KEY_CTL_WEP) {
-//            pDevice->s802_11Counter.WEPUndecryptableCount.QuadPart++;
-        } else if (pDevice->bLinkPass == true) {
-//            pDevice->s802_11Counter.DecryptFailureCount.QuadPart++;
-        }
         *pKeyOut = NULL;
         return false;
     }
@@ -1167,11 +1129,6 @@ static int s_bHostWepRxEncryption(struct vnt_private *pDevice, u8 *pbyFrame,
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"AES:%d %d %d\n", pMgmt->byCSSPK, pMgmt->byCSSGK, byDecMode);
 
     if (byDecMode != pKey->byCipherSuite) {
-        if (byDecMode == KEY_CTL_WEP) {
-//            pDevice->s802_11Counter.WEPUndecryptableCount.QuadPart++;
-        } else if (pDevice->bLinkPass == true) {
-//            pDevice->s802_11Counter.DecryptFailureCount.QuadPart++;
-        }
         return false;
     }
 
diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 512bb5d..a2778a4 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -175,16 +175,6 @@ void INTnsProcessData(struct vnt_private *pDevice)
 		  pINTData->byISR0,
 		  pINTData->dwLoTSF,
 		  pINTData->dwHiTSF)); */
-
-		STAvUpdate802_11Counter(&pDevice->s802_11Counter,
-					&pDevice->scStatistic,
-					pINTData->byRTSSuccess,
-					pINTData->byRTSFail,
-					pINTData->byACKFail,
-					pINTData->byFCSErr);
-		STAvUpdateIsrStatCounter(&pDevice->scStatistic,
-					pINTData->byISR0,
-					pINTData->byISR1);
 	}
 	if (pINTData->byISR1 != 0)
 		if (pINTData->byISR1 & ISR_GPIO3)
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 5fc18ad..01cf099 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -390,8 +390,6 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
 	    INTnsProcessData(pDevice);
     }
 
-    STAvUpdateUSBCounter(&pDevice->scStatistic.USB_InterruptStat, ntStatus);
-
     if (pDevice->fKillEventPollingThread != true) {
        usb_fill_bulk_urb(pDevice->pInterruptURB,
 		      pDevice->usb,
@@ -499,8 +497,6 @@ static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
     if (status) {
         pDevice->ulBulkInError++;
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BULK In failed %d\n", status);
-
-           pDevice->scStatistic.RxFcsErrCnt ++;
 //todo...xxxxxx
 //        if (status == USBD_STATUS_CRC) {
 //            pDevice->ulBulkInContCRCError++;
@@ -514,12 +510,8 @@ static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
 		bIndicateReceive = true;
         pDevice->ulBulkInContCRCError = 0;
         pDevice->ulBulkInBytesRead += bytesRead;
-
-           pDevice->scStatistic.RxOkCnt ++;
     }
 
-    STAvUpdateUSBCounter(&pDevice->scStatistic.USB_BulkInStat, status);
-
     if (bIndicateReceive) {
         spin_lock(&pDevice->lock);
         if (RXbBulkInProcessData(pDevice, pRCB, bytesRead) == true)
@@ -655,8 +647,6 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
     //
 
     status = urb->status;
-    //we should have failed, succeeded, or cancelled, but NOT be pending
-    STAvUpdateUSBCounter(&pDevice->scStatistic.USB_BulkOutStat, status);
 
     if(status == STATUS_SUCCESS) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Write %d bytes\n",(int)ulBufLen);
-- 
1.8.3.2

