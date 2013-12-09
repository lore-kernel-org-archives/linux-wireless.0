Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41213 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab3LIWZz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Dec 2013 17:25:55 -0500
Received: by mail-wi0-f172.google.com with SMTP id en1so4552523wid.17
        for <linux-wireless@vger.kernel.org>; Mon, 09 Dec 2013 14:25:54 -0800 (PST)
Message-ID: <1386627948.14057.3.camel@canaries64-MCP7A> (sfid-20131209_232558_607098_E00FC71D)
Subject: [PATCH 2/4] staging: vt6656: Get wireless stats qual.qual directly
 from s_uCalculateLinkQual
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 09 Dec 2013 22:25:48 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Calculate the qual from the tx_packets and wstats.discard.retries and
apply to wstats.qual.qual

Discard pDevice->scStatistic.LinkQuality.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/bssdb.c | 59 +++++++++++++++++++++++-------------------
 drivers/staging/vt6656/iwctl.c |  3 ---
 2 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 1c3cbc5..4c32b12 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -1384,39 +1384,44 @@ static void s_vCheckSensitivity(struct vnt_private *pDevice)
 
 static void s_uCalculateLinkQual(struct vnt_private *pDevice)
 {
+	struct net_device_stats *stats = &pDevice->stats;
 	unsigned long TxOkRatio, TxCnt;
 	unsigned long RxOkRatio, RxCnt;
 	unsigned long RssiRatio;
+	unsigned long qual;
 	long ldBm;
 
-TxCnt = pDevice->scStatistic.TxNoRetryOkCount +
-	      pDevice->scStatistic.TxRetryOkCount +
-	      pDevice->scStatistic.TxFailCount;
-RxCnt = pDevice->scStatistic.RxFcsErrCnt +
+	TxCnt = stats->tx_packets + pDevice->wstats.discard.retries;
+
+	RxCnt = pDevice->scStatistic.RxFcsErrCnt +
 	      pDevice->scStatistic.RxOkCnt;
-TxOkRatio = (TxCnt < 6) ? 4000:((pDevice->scStatistic.TxNoRetryOkCount * 4000) / TxCnt);
-RxOkRatio = (RxCnt < 6) ? 2000:((pDevice->scStatistic.RxOkCnt * 2000) / RxCnt);
-//decide link quality
-if(pDevice->bLinkPass !=true)
-{
-   pDevice->scStatistic.LinkQuality = 0;
-   pDevice->scStatistic.SignalStren = 0;
-}
-else
-{
-   RFvRSSITodBm(pDevice, (u8)(pDevice->uCurrRSSI), &ldBm);
-   if(-ldBm < 50)  {
-   	RssiRatio = 4000;
-     }
-   else if(-ldBm > 90) {
-   	RssiRatio = 0;
-     }
-   else {
-   	RssiRatio = (40-(-ldBm-50))*4000/40;
-     }
-   pDevice->scStatistic.SignalStren = RssiRatio/40;
-   pDevice->scStatistic.LinkQuality = (RssiRatio+TxOkRatio+RxOkRatio)/100;
-}
+
+	TxOkRatio = (TxCnt < 6) ? 4000:((stats->tx_packets * 4000) / TxCnt);
+
+	RxOkRatio = (RxCnt < 6) ? 2000 :
+				((pDevice->scStatistic.RxOkCnt * 2000) / RxCnt);
+
+	/* decide link quality */
+	if (pDevice->bLinkPass != true) {
+		pDevice->wstats.qual.qual = 0;
+		pDevice->scStatistic.SignalStren = 0;
+	} else {
+		RFvRSSITodBm(pDevice, (u8)(pDevice->uCurrRSSI), &ldBm);
+		if (-ldBm < 50)
+			RssiRatio = 4000;
+		else if (-ldBm > 90)
+			RssiRatio = 0;
+		else
+			RssiRatio = (40-(-ldBm-50)) * 4000 / 40;
+
+		pDevice->scStatistic.SignalStren = RssiRatio / 40;
+		qual = (RssiRatio + TxOkRatio + RxOkRatio) / 100;
+		if (qual < 100)
+			pDevice->wstats.qual.qual = (u8)qual;
+		else
+			pDevice->wstats.qual.qual = 100;
+	}
+
    pDevice->scStatistic.RxFcsErrCnt = 0;
    pDevice->scStatistic.RxOkCnt = 0;
    pDevice->scStatistic.TxFailCount = 0;
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 183c5a2..058df65 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -58,9 +58,6 @@ struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 	long ldBm;
 
 	pDevice->wstats.status = pDevice->eOPMode;
-	if (pDevice->scStatistic.LinkQuality > 100)
-		pDevice->scStatistic.LinkQuality = 100;
-	pDevice->wstats.qual.qual = (u8)pDevice->scStatistic.LinkQuality;
 	RFvRSSITodBm(pDevice, (u8)(pDevice->uCurrRSSI), &ldBm);
 	pDevice->wstats.qual.level = ldBm;
 	pDevice->wstats.qual.noise = 0;
-- 
1.8.3.2


