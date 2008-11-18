Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28507 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbYKRDnP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 22:43:15 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 19:43:15 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18722.14630.129243.189672@gargle.gargle.HOWL> (sfid-20081118_044319_230243_76183C0B)
Date: Tue, 18 Nov 2008 09:10:22 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 17/18] ath9k: Update TX trigger level on a FIFO underrun.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/mac.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/mac.c b/drivers/net/wireless/ath9k/mac.c
index c344a81..36955e0 100644
--- a/drivers/net/wireless/ath9k/mac.c
+++ b/drivers/net/wireless/ath9k/mac.c
@@ -293,8 +293,10 @@ int ath9k_hw_txprocdesc(struct ath_hal *ah, struct ath_desc *ds)
 		ds->ds_txstat.ts_status |= ATH9K_TXERR_XRETRY;
 	if (ads->ds_txstatus1 & AR_Filtered)
 		ds->ds_txstat.ts_status |= ATH9K_TXERR_FILT;
-	if (ads->ds_txstatus1 & AR_FIFOUnderrun)
+	if (ads->ds_txstatus1 & AR_FIFOUnderrun) {
 		ds->ds_txstat.ts_status |= ATH9K_TXERR_FIFO;
+		ath9k_hw_updatetxtriglevel(ah, true);
+	}
 	if (ads->ds_txstatus9 & AR_TxOpExceeded)
 		ds->ds_txstat.ts_status |= ATH9K_TXERR_XTXOP;
 	if (ads->ds_txstatus1 & AR_TxTimerExpired)
-- 
1.6.0.3

