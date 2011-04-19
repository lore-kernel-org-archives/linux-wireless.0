Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:57291 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab1DSODO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 10:03:14 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 07:02:48 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: [PATCH V2 01/22] ath9k_hw: Define devid and mac version for AR9340
Date: Tue, 19 Apr 2011 19:33:19 +0530
Message-ID: <1303221803-25230-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    2 +-
 drivers/net/wireless/ath/ath9k/hw.h  |    1 +
 drivers/net/wireless/ath/ath9k/reg.h |    4 ++++
 3 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 045abd5..8c0364f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -552,7 +552,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 		return -EOPNOTSUPP;
 	}
 
-	if (AR_SREV_9271(ah) || AR_SREV_9100(ah))
+	if (AR_SREV_9271(ah) || AR_SREV_9100(ah) || AR_SREV_9340(ah))
 		ah->is_pciexpress = false;
 
 	ah->hw_version.phyRev = REG_READ(ah, AR_PHY_CHIP_ID);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 073bc9e..8da6619 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -43,6 +43,7 @@
 #define AR9287_DEVID_PCI	0x002d
 #define AR9287_DEVID_PCIE	0x002e
 #define AR9300_DEVID_PCIE	0x0030
+#define AR9300_DEVID_AR9340	0x0031
 #define AR9300_DEVID_AR9485_PCIE 0x0032
 
 #define AR5416_AR9100_DEVID	0x000b
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 6acbf0e..1bf5405 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -790,6 +790,7 @@
 #define AR_SREV_VERSION_9485		0x240
 #define AR_SREV_REVISION_9485_10	0
 #define AR_SREV_REVISION_9485_11        1
+#define AR_SREV_VERSION_9340		0x300
 
 #define AR_SREV_5416(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) || \
@@ -869,6 +870,9 @@
 	(AR_SREV_9485(_ah) && \
 	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9485_11))
 
+#define AR_SREV_9340(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9340))
+
 #define AR_SREV_9285E_20(_ah) \
     (AR_SREV_9285_12_OR_LATER(_ah) && \
      ((REG_READ(_ah, AR_AN_SYNTH9) & 0x7) == 0x1))
-- 
1.7.0.4

