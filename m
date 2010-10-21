Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:47287 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036Ab0JUArf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 20:47:35 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 1/3] ath9k_hw: fix potential spurious tx error bit interpretation
Date: Thu, 21 Oct 2010 02:47:23 +0200
Message-Id: <1287622045-21795-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to documentation, AR_ExcessiveRetries, AR_Filtered and
AR_FIFOUnderrun are only valid if AR_FrmXmitOK is clear.

Not checking this might result in suboptimal FIFO settings, unnecessary
retransmissions, or other connectivity issues.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/ar9002_mac.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index 3b4c52c..f0268e5 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -237,13 +237,15 @@ static int ar9002_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 	status = ACCESS_ONCE(ads->ds_txstatus1);
 	if (status & AR_FrmXmitOK)
 		ts->ts_status |= ATH9K_TX_ACKED;
-	if (status & AR_ExcessiveRetries)
-		ts->ts_status |= ATH9K_TXERR_XRETRY;
-	if (status & AR_Filtered)
-		ts->ts_status |= ATH9K_TXERR_FILT;
-	if (status & AR_FIFOUnderrun) {
-		ts->ts_status |= ATH9K_TXERR_FIFO;
-		ath9k_hw_updatetxtriglevel(ah, true);
+	else {
+		if (status & AR_ExcessiveRetries)
+			ts->ts_status |= ATH9K_TXERR_XRETRY;
+		if (status & AR_Filtered)
+			ts->ts_status |= ATH9K_TXERR_FILT;
+		if (status & AR_FIFOUnderrun) {
+			ts->ts_status |= ATH9K_TXERR_FIFO;
+			ath9k_hw_updatetxtriglevel(ah, true);
+		}
 	}
 	if (status & AR_TxTimerExpired)
 		ts->ts_status |= ATH9K_TXERR_TIMER_EXPIRED;
-- 
1.7.2.2

