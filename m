Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:44106 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbaE0UGR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 16:06:17 -0400
Received: by mail-wg0-f50.google.com with SMTP id x12so9969286wgg.33
        for <linux-wireless@vger.kernel.org>; Tue, 27 May 2014 13:06:16 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/10] staging: vt6656: rf.c/h rename RFvRSSITodBm to vnt_rf_rssi_to_dbm
Date: Tue, 27 May 2014 21:05:23 +0100
Message-Id: <1401221126-4219-7-git-send-email-tvboxspy@gmail.com> (sfid-20140527_220628_472730_F811DFF4)
In-Reply-To: <1401221126-4219-1-git-send-email-tvboxspy@gmail.com>
References: <1401221126-4219-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/bssdb.c | 9 +++++----
 drivers/staging/vt6656/iwctl.c | 6 +++---
 drivers/staging/vt6656/rf.c    | 2 +-
 drivers/staging/vt6656/rf.h    | 2 +-
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index f53d3bf..8e9ce96 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -457,8 +457,9 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 
 	/* Monitor if RSSI is too strong. */
 	pBSSList->byRSSIStatCnt = 0;
-	RFvRSSITodBm(pDevice, (u8) (pRxPacket->uRSSI),
-			     &pBSSList->ldBmMAX);
+
+	vnt_rf_rssi_to_dbm(pDevice, (u8)pRxPacket->uRSSI, &pBSSList->ldBmMAX);
+
 	pBSSList->ldBmAverage[0] = pBSSList->ldBmMAX;
 	pBSSList->ldBmAverRange = pBSSList->ldBmMAX;
 	for (ii = 1; ii < RSSI_STAT_COUNT; ii++)
@@ -578,7 +579,7 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 	}
 
 	if (pRxPacket->uRSSI != 0) {
-		RFvRSSITodBm(pDevice, (u8) (pRxPacket->uRSSI), &ldBm);
+		vnt_rf_rssi_to_dbm(pDevice, (u8)pRxPacket->uRSSI, &ldBm);
 		/* Monitor if RSSI is too strong. */
 		pBSSList->byRSSIStatCnt++;
 		pBSSList->byRSSIStatCnt %= RSSI_STAT_COUNT;
@@ -1417,7 +1418,7 @@ static void s_uCalculateLinkQual(struct vnt_private *pDevice)
 	if (pDevice->bLinkPass != true) {
 		pDevice->wstats.qual.qual = 0;
 	} else {
-		RFvRSSITodBm(pDevice, (u8) (pDevice->uCurrRSSI), &ldBm);
+		vnt_rf_rssi_to_dbm(pDevice, (u8) (pDevice->uCurrRSSI), &ldBm);
 		if (-ldBm < 50)
 			RssiRatio = 4000;
 		else if (-ldBm > 90)
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 94b7fe8..c43718d 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -57,7 +57,7 @@ struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 	long ldBm;
 
 	pDevice->wstats.status = pDevice->op_mode;
-	RFvRSSITodBm(pDevice, (u8)(pDevice->uCurrRSSI), &ldBm);
+	vnt_rf_rssi_to_dbm(pDevice, (u8)(pDevice->uCurrRSSI), &ldBm);
 	pDevice->wstats.qual.level = ldBm;
 	pDevice->wstats.qual.noise = 0;
 	pDevice->wstats.qual.updated = 1;
@@ -235,7 +235,7 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 			// ADD quality
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = IWEVQUAL;
-			RFvRSSITodBm(pDevice, (u8)(pBSS->uRSSI), &ldBm);
+			vnt_rf_rssi_to_dbm(pDevice, (u8)(pBSS->uRSSI), &ldBm);
 			iwe.u.qual.level = ldBm;
 			iwe.u.qual.noise = 0;
 
@@ -1399,7 +1399,7 @@ int iwctl_giwsens(struct net_device *dev, struct iw_request_info *info,
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSENS\n");
 	if (pDevice->bLinkPass == true) {
-		RFvRSSITodBm(pDevice, (u8)(pDevice->uCurrRSSI), &ldBm);
+		vnt_rf_rssi_to_dbm(pDevice, (u8)(pDevice->uCurrRSSI), &ldBm);
 		wrq->value = ldBm;
 	} else {
 		wrq->value = 0;
diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index fd69960..4e1a28d 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -969,7 +969,7 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
  * Return Value: none
  *
 -*/
-void RFvRSSITodBm(struct vnt_private *priv, u8 rssi, long *dbm)
+void vnt_rf_rssi_to_dbm(struct vnt_private *priv, u8 rssi, long *dbm)
 {
 	u8 idx = (((rssi & 0xc0) >> 6) & 0x03);
 	long b = (rssi & 0x3f);
diff --git a/drivers/staging/vt6656/rf.h b/drivers/staging/vt6656/rf.h
index 2040d50..bc0e923 100644
--- a/drivers/staging/vt6656/rf.h
+++ b/drivers/staging/vt6656/rf.h
@@ -60,7 +60,7 @@ extern const u8 RFaby11aChannelIndex[200];
 int vnt_rf_write_embedded(struct vnt_private *, u32);
 int vnt_rf_setpower(struct vnt_private *, u32, u32);
 int vnt_rf_set_txpower(struct vnt_private *, u8, u32);
-void RFvRSSITodBm(struct vnt_private *, u8 byCurrRSSI, long *pldBm);
+void vnt_rf_rssi_to_dbm(struct vnt_private *, u8, long *);
 void RFbRFTableDownload(struct vnt_private *pDevice);
 
 #endif /* __RF_H__ */
-- 
1.9.1

