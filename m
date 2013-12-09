Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:55061 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3LIW2g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Dec 2013 17:28:36 -0500
Received: by mail-wg0-f50.google.com with SMTP id a1so4078937wgh.17
        for <linux-wireless@vger.kernel.org>; Mon, 09 Dec 2013 14:28:35 -0800 (PST)
Message-ID: <1386628104.14057.5.camel@canaries64-MCP7A> (sfid-20131209_232840_219142_8315DC14)
Subject: [PATCH 3/4] staging: vt6656: s_uCalculateLinkQual use netstats rx
 values
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 09 Dec 2013 22:28:24 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use netstats rx_packets and rx_frame_errors.

Add frame errors to RXbBulkInProcessData

The current scStatistic.RxFcsErrCnt only records
USB errors not frame errors.

The scStatistic.RxOkCnt only recorded successful USB
transfers not actual successfully received packets.

So a more accurate reading is to use netstats rx_packets and
rx_frame_errors.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/bssdb.c | 5 ++---
 drivers/staging/vt6656/dpc.c   | 3 +++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 4c32b12..a0655a9 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -1393,13 +1393,12 @@ static void s_uCalculateLinkQual(struct vnt_private *pDevice)
 
 	TxCnt = stats->tx_packets + pDevice->wstats.discard.retries;
 
-	RxCnt = pDevice->scStatistic.RxFcsErrCnt +
-	      pDevice->scStatistic.RxOkCnt;
+	RxCnt = stats->rx_packets + stats->rx_frame_errors;
 
 	TxOkRatio = (TxCnt < 6) ? 4000:((stats->tx_packets * 4000) / TxCnt);
 
 	RxOkRatio = (RxCnt < 6) ? 2000 :
-				((pDevice->scStatistic.RxOkCnt * 2000) / RxCnt);
+				((stats->rx_packets * 2000) / RxCnt);
 
 	/* decide link quality */
 	if (pDevice->bLinkPass != true) {
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 2bed31b..84901c1 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -291,12 +291,14 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, struct vnt_rcb *pRCB,
 
 	if (BytesToIndicate != FrameSize) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"------- WRONG Length 1\n");
+		pStats->rx_frame_errors++;
 		return false;
 	}
 
     if ((BytesToIndicate > 2372) || (BytesToIndicate <= 40)) {
         // Frame Size error drop this packet.
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "---------- WRONG Length 2\n");
+	pStats->rx_frame_errors++;
         return false;
     }
 
@@ -314,6 +316,7 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, struct vnt_rcb *pRCB,
          (BytesToIndicate < (*pwPLCP_Length)) ) {
 
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Wrong PLCP Length %x\n", (int) *pwPLCP_Length);
+	pStats->rx_frame_errors++;
         return false;
     }
     for ( ii=RATE_1M;ii<MAX_RATE;ii++) {
-- 
1.8.3.2


