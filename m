Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26445 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947Ab1C1U5j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 16:57:39 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 13:57:15 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	<stable@kernel.org>, "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 5/9] ath9k_hw: fix potential spurious tx error bit interpretation
Date: Mon, 28 Mar 2011 13:57:11 -0700
Message-ID: <1301345835-11401-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301345835-11401-1-git-send-email-lrodriguez@atheros.com>
References: <1301345835-11401-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

commit ff32d9cd2c4107224a28f39d3c72eec66d566e09 upstream

According to documentation, AR_ExcessiveRetries, AR_Filtered and
AR_FIFOUnderrun are only valid if AR_FrmXmitOK is clear.

Not checking this might result in suboptimal FIFO settings, unnecessary
retransmissions, or other connectivity issues.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_mac.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index 50dda39..cebb97b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -227,18 +227,21 @@ static int ar9002_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 	ts->ts_status = 0;
 	ts->ts_flags = 0;
 
+	if (ads->ds_txstatus9 & AR_TxOpExceeded)
+		ts->ts_status |= ATH9K_TXERR_XTXOP;
+
 	if (ads->ds_txstatus1 & AR_FrmXmitOK)
 		ts->ts_status |= ATH9K_TX_ACKED;
-	if (ads->ds_txstatus1 & AR_ExcessiveRetries)
-		ts->ts_status |= ATH9K_TXERR_XRETRY;
-	if (ads->ds_txstatus1 & AR_Filtered)
-		ts->ts_status |= ATH9K_TXERR_FILT;
-	if (ads->ds_txstatus1 & AR_FIFOUnderrun) {
-		ts->ts_status |= ATH9K_TXERR_FIFO;
-		ath9k_hw_updatetxtriglevel(ah, true);
+	else {
+		if (ads->ds_txstatus1 & AR_ExcessiveRetries)
+			ts->ts_status |= ATH9K_TXERR_XRETRY;
+		if (ads->ds_txstatus1 & AR_Filtered)
+			ts->ts_status |= ATH9K_TXERR_FILT;
+		if (ads->ds_txstatus1 & AR_FIFOUnderrun) {
+			ts->ts_status |= ATH9K_TXERR_FIFO;
+			ath9k_hw_updatetxtriglevel(ah, true);
+		}
 	}
-	if (ads->ds_txstatus9 & AR_TxOpExceeded)
-		ts->ts_status |= ATH9K_TXERR_XTXOP;
 	if (ads->ds_txstatus1 & AR_TxTimerExpired)
 		ts->ts_status |= ATH9K_TXERR_TIMER_EXPIRED;
 
-- 
1.7.4.15.g7811d

