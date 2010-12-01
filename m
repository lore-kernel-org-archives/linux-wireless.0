Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13829 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833Ab0LAHdS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 02:33:18 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 23:33:04 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 03/26] ath9k_hw: Enable hw initialization for AR9485
Date: Tue, 30 Nov 2010 23:32:32 -0800
Message-ID: <1291188775-13707-4-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
References: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also make it a supported mac

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |    1 +
 drivers/net/wireless/ath/ath9k/hw.c        |    1 +
 drivers/net/wireless/ath/ath9k/hw.h        |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index c2a0571..0e3e259 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -24,6 +24,7 @@ static bool ar9003_hw_macversion_supported(u32 macversion)
 {
 	switch (macversion) {
 	case AR_SREV_VERSION_9300:
+	case AR_SREV_VERSION_9485:
 		return true;
 	default:
 		break;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9b1ee7f..f533aad 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -629,6 +629,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 	case AR9287_DEVID_PCIE:
 	case AR2427_DEVID_PCIE:
 	case AR9300_DEVID_PCIE:
+	case AR9300_DEVID_AR9485_PCIE:
 		break;
 	default:
 		if (common->bus_ops->ath_bus_type == ATH_USB)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 5fcfa48..bde1df3 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -44,6 +44,7 @@
 #define AR9287_DEVID_PCI	0x002d
 #define AR9287_DEVID_PCIE	0x002e
 #define AR9300_DEVID_PCIE	0x0030
+#define AR9300_DEVID_AR9485_PCIE 0x0032
 
 #define AR5416_AR9100_DEVID	0x000b
 
-- 
1.7.0.4

