Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:57384 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab3L1EWW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Dec 2013 23:22:22 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/7] ath9k: Handle unsupported MAC versions early
Date: Sat, 28 Dec 2013 09:47:11 +0530
Message-Id: <1388204235-14682-3-git-send-email-sujith@msujith.org> (sfid-20131228_052247_408688_9DB91537)
In-Reply-To: <1388204235-14682-1-git-send-email-sujith@msujith.org>
References: <1388204235-14682-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

There is no point in trying to bring up the chip when
the MAC version is not present in the supported list.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 48 ++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a0e62cc..536b9ec 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -474,6 +474,30 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 
 	ath9k_hw_read_revisions(ah);
 
+	switch (ah->hw_version.macVersion) {
+	case AR_SREV_VERSION_5416_PCI:
+	case AR_SREV_VERSION_5416_PCIE:
+	case AR_SREV_VERSION_9160:
+	case AR_SREV_VERSION_9100:
+	case AR_SREV_VERSION_9280:
+	case AR_SREV_VERSION_9285:
+	case AR_SREV_VERSION_9287:
+	case AR_SREV_VERSION_9271:
+	case AR_SREV_VERSION_9300:
+	case AR_SREV_VERSION_9330:
+	case AR_SREV_VERSION_9485:
+	case AR_SREV_VERSION_9340:
+	case AR_SREV_VERSION_9462:
+	case AR_SREV_VERSION_9550:
+	case AR_SREV_VERSION_9565:
+		break;
+	default:
+		ath_err(common,
+			"Mac Chip Rev 0x%02x.%x is not supported by this driver\n",
+			ah->hw_version.macVersion, ah->hw_version.macRev);
+		return -EOPNOTSUPP;
+	}
+
 	/*
 	 * Read back AR_WA into a permanent copy and set bits 14 and 17.
 	 * We need to do this to avoid RMW of this register. We cannot
@@ -527,30 +551,6 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	else
 		ah->config.max_txtrig_level = MAX_TX_FIFO_THRESHOLD;
 
-	switch (ah->hw_version.macVersion) {
-	case AR_SREV_VERSION_5416_PCI:
-	case AR_SREV_VERSION_5416_PCIE:
-	case AR_SREV_VERSION_9160:
-	case AR_SREV_VERSION_9100:
-	case AR_SREV_VERSION_9280:
-	case AR_SREV_VERSION_9285:
-	case AR_SREV_VERSION_9287:
-	case AR_SREV_VERSION_9271:
-	case AR_SREV_VERSION_9300:
-	case AR_SREV_VERSION_9330:
-	case AR_SREV_VERSION_9485:
-	case AR_SREV_VERSION_9340:
-	case AR_SREV_VERSION_9462:
-	case AR_SREV_VERSION_9550:
-	case AR_SREV_VERSION_9565:
-		break;
-	default:
-		ath_err(common,
-			"Mac Chip Rev 0x%02x.%x is not supported by this driver\n",
-			ah->hw_version.macVersion, ah->hw_version.macRev);
-		return -EOPNOTSUPP;
-	}
-
 	if (AR_SREV_9271(ah) || AR_SREV_9100(ah) || AR_SREV_9340(ah) ||
 	    AR_SREV_9330(ah) || AR_SREV_9550(ah))
 		ah->is_pciexpress = false;
-- 
1.8.5.2

