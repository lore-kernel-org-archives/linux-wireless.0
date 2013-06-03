Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:61567 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab3FCVty (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 17:49:54 -0400
Received: by mail-wg0-f52.google.com with SMTP id z11so3721508wgg.7
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jun 2013 14:49:53 -0700 (PDT)
Message-ID: <1370296188.9091.31.camel@canaries64> (sfid-20130603_234957_697022_2736DF14)
Subject: [PATCH 5/8] staging: vt6656: rf.c/h rename RFvRSSITodBm
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Jun 2013 22:49:48 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove camel case rename RFvRSSITodBm to vnt_rf_rssi_to_dbm

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/bssdb.c | 6 +++---
 drivers/staging/vt6656/iwctl.c | 6 +++---
 drivers/staging/vt6656/rf.c    | 2 +-
 drivers/staging/vt6656/rf.h    | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index ee79bbd..078d751 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -451,7 +451,7 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
     if (pDevice->bUpdateBBVGA) {
         // Monitor if RSSI is too strong.
         pBSSList->byRSSIStatCnt = 0;
-        RFvRSSITodBm(pDevice, (u8)(pRxPacket->uRSSI), &pBSSList->ldBmMAX);
+	vnt_rf_rssi_to_dbm(pDevice, (u8)(pRxPacket->uRSSI), &pBSSList->ldBmMAX);
         pBSSList->ldBmAverage[0] = pBSSList->ldBmMAX;
         pBSSList->ldBmAverRange = pBSSList->ldBmMAX;
         for (ii = 1; ii < RSSI_STAT_COUNT; ii++)
@@ -578,7 +578,7 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
     }
 
     if (pRxPacket->uRSSI != 0) {
-        RFvRSSITodBm(pDevice, (u8)(pRxPacket->uRSSI), &ldBm);
+	vnt_rf_rssi_to_dbm(pDevice, (u8)(pRxPacket->uRSSI), &ldBm);
         // Monitor if RSSI is too strong.
         pBSSList->byRSSIStatCnt++;
         pBSSList->byRSSIStatCnt %= RSSI_STAT_COUNT;
@@ -1387,7 +1387,7 @@ if(pDevice->bLinkPass !=true)
 }
 else
 {
-   RFvRSSITodBm(pDevice, (u8)(pDevice->uCurrRSSI), &ldBm);
+	vnt_rf_rssi_to_dbm(pDevice, (u8)(pDevice->uCurrRSSI), &ldBm);
    if(-ldBm < 50)  {
    	RssiRatio = 4000;
      }
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index d0cf7d8..af355d2 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -61,7 +61,7 @@ struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 	if (pDevice->scStatistic.LinkQuality > 100)
 		pDevice->scStatistic.LinkQuality = 100;
 	pDevice->wstats.qual.qual =(u8)pDevice->scStatistic.LinkQuality;
-	RFvRSSITodBm(pDevice, (u8)(pDevice->uCurrRSSI), &ldBm);
+	vnt_rf_rssi_to_dbm(pDevice, (u8)(pDevice->uCurrRSSI), &ldBm);
 	pDevice->wstats.qual.level = ldBm;
 	pDevice->wstats.qual.noise = 0;
 	pDevice->wstats.qual.updated = 1;
@@ -237,7 +237,7 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 			// ADD quality
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = IWEVQUAL;
-			RFvRSSITodBm(pDevice, (u8)(pBSS->uRSSI), &ldBm);
+			vnt_rf_rssi_to_dbm(pDevice, (u8)(pBSS->uRSSI), &ldBm);
 			iwe.u.qual.level = ldBm;
 			iwe.u.qual.noise = 0;
 
@@ -1427,7 +1427,7 @@ int iwctl_giwsens(struct net_device *dev, struct iw_request_info *info,
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSENS\n");
 	if (pDevice->bLinkPass == true) {
-		RFvRSSITodBm(pDevice, (u8)(pDevice->uCurrRSSI), &ldBm);
+		vnt_rf_rssi_to_dbm(pDevice, (u8)(pDevice->uCurrRSSI), &ldBm);
 		wrq->value = ldBm;
 	} else {
 		wrq->value = 0;
diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 1706d8d..bcc9632 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -943,7 +943,7 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
  * Return Value: none
  *
 -*/
-void RFvRSSITodBm(struct vnt_private *priv, u8 rssi, long *dbm)
+void vnt_rf_rssi_to_dbm(struct vnt_private *priv, u8 rssi, long *dbm)
 {
 	u8 idx = (((rssi & 0xc0) >> 6) & 0x03);
 	long b = (rssi & 0x3f);
diff --git a/drivers/staging/vt6656/rf.h b/drivers/staging/vt6656/rf.h
index 1c0dd25..73abc5a 100644
--- a/drivers/staging/vt6656/rf.h
+++ b/drivers/staging/vt6656/rf.h
@@ -58,7 +58,7 @@ extern const u8 RFaby11aChannelIndex[200];
 int vnt_rf_write_embedded(struct vnt_private *, u32);
 int vnt_rf_setpower(struct vnt_private *, u32, u32);
 int vnt_rf_set_txpower(struct vnt_private *, u8, u32);
-void RFvRSSITodBm(struct vnt_private *, u8 byCurrRSSI, long *pldBm);
+void vnt_rf_rssi_to_dbm(struct vnt_private *, u8, long *);
 void RFbRFTableDownload(struct vnt_private *pDevice);
 
 #endif /* __RF_H__ */
-- 
1.8.1.2

