Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60501 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbZHSLBn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 07:01:43 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2009 04:01:45 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Fix bug in retrieving average beacon rssi
Date: Wed, 19 Aug 2009 16:23:39 +0530
Message-ID: <1250679220-30392-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ani.h |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index 1199245..6273fd0 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -18,15 +18,10 @@
 #define ANI_H
 
 #define HAL_PROCESS_ANI           0x00000001
-#define ATH9K_RSSI_EP_MULTIPLIER  (1<<7)
 
 #define DO_ANI(ah) (((ah)->proc_phyerr & HAL_PROCESS_ANI))
 
-#define HAL_EP_RND(x, mul)						\
-	((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))
-#define BEACON_RSSI(ahp)					\
-	HAL_EP_RND(ahp->stats.ast_nodestats.ns_avgbrssi,	\
-		   ATH9K_RSSI_EP_MULTIPLIER)
+#define BEACON_RSSI(ahp) (ahp->stats.ast_nodestats.ns_avgbrssi)
 
 #define ATH9K_ANI_OFDM_TRIG_HIGH          500
 #define ATH9K_ANI_OFDM_TRIG_LOW           200
-- 
1.5.5.1

