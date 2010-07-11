Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:46131 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735Ab0GKKs7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:48:59 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, linville@tuxdriver.com
Subject: [PATCH 5/7] ath9k_hw: report the TID in the tx status on AR5008-AR9002
Date: Sun, 11 Jul 2010 12:48:43 +0200
Message-Id: <1278845325-62000-5-git-send-email-nbd@openwrt.org>
In-Reply-To: <1278845325-62000-4-git-send-email-nbd@openwrt.org>
References: <1278845325-62000-1-git-send-email-nbd@openwrt.org>
 <1278845325-62000-2-git-send-email-nbd@openwrt.org>
 <1278845325-62000-3-git-send-email-nbd@openwrt.org>
 <1278845325-62000-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_mac.c |    1 +
 drivers/net/wireless/ath/ath9k/ar9003_mac.h |    3 ---
 drivers/net/wireless/ath/ath9k/mac.h        |    3 +++
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index 2be20d2..50dda39 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -287,6 +287,7 @@ static int ar9002_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 	ts->ts_shortretry = MS(ads->ds_txstatus1, AR_RTSFailCnt);
 	ts->ts_longretry = MS(ads->ds_txstatus1, AR_DataFailCnt);
 	ts->ts_virtcol = MS(ads->ds_txstatus1, AR_VirtRetryCnt);
+	ts->tid = MS(ads->ds_txstatus9, AR_TxTid);
 	ts->ts_antenna = 0;
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.h b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
index f76f27d..9f2cea7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
@@ -33,9 +33,6 @@
 #define AR_TxDescId_S	16
 #define AR_TxPtrChkSum	0x0000ffff
 
-#define AR_TxTid	0xf0000000
-#define AR_TxTid_S	28
-
 #define AR_LowRxChain	0x00004000
 
 #define AR_Not_Sounding	0x20000000
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 7559fb2..2633896 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -485,6 +485,9 @@ struct ar5416_desc {
 #define AR_TxRSSICombined   0xff000000
 #define AR_TxRSSICombined_S 24
 
+#define AR_TxTid	0xf0000000
+#define AR_TxTid_S	28
+
 #define AR_TxEVM0           ds_txstatus5
 #define AR_TxEVM1           ds_txstatus6
 #define AR_TxEVM2           ds_txstatus7
-- 
1.6.4.2

