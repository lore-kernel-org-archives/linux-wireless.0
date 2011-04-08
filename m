Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35112 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab1DHStX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 14:49:23 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH] ath9k_hw: remove unnecessary parts of the AR9380 SREV check
Date: Fri,  8 Apr 2011 20:49:16 +0200
Message-Id: <1302288556-69156-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Older versions have not been sold and the driver does not explicitly
check for them anyway, so we can simply ignore the macRev here.
Reduces ath9k_hw size on mips by more than 2 KB.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/reg.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 693d543..2fbbe88 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -858,9 +858,7 @@
 #define AR_SREV_9300(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9300))
 #define AR_SREV_9300_20_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9300) || \
-	 (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9300) && \
-	  ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9300_20)))
+	((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9300)
 
 #define AR_SREV_9485(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9485))
-- 
1.7.3.2

