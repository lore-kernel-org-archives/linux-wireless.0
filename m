Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40561 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbZIPCzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 22:55:51 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: devel@linuxdriverproject.org, ath9k-devel@lists.ath9k.org,
	zhifeng.cai@atheros.com, Stephen.Chen@atheros.com,
	kevin@atheros.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 3/3] ath: add AR9271 srev and device ID to allow hw to support ar9271
Date: Tue, 15 Sep 2009 22:55:54 -0400
Message-Id: <1253069754-7470-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1253069754-7470-1-git-send-email-lrodriguez@atheros.com>
References: <1253069754-7470-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/hw.c |    4 ++--
 drivers/net/wireless/ath/hw.h |    5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/hw.c b/drivers/net/wireless/ath/hw.c
index a0a9647..f3777ee 100644
--- a/drivers/net/wireless/ath/hw.c
+++ b/drivers/net/wireless/ath/hw.c
@@ -592,6 +592,7 @@ static bool ath9k_hw_devid_supported(u16 devid)
 	case AR9285_DEVID_PCIE:
 	case AR5416_DEVID_AR9287_PCI:
 	case AR5416_DEVID_AR9287_PCIE:
+	case AR9271_USB:
 		return true;
 	default:
 		break;
@@ -609,9 +610,8 @@ static bool ath9k_hw_macversion_supported(u32 macversion)
 	case AR_SREV_VERSION_9280:
 	case AR_SREV_VERSION_9285:
 	case AR_SREV_VERSION_9287:
-		return true;
-	/* Not yet */
 	case AR_SREV_VERSION_9271:
+		return true;
 	default:
 		break;
 	}
diff --git a/drivers/net/wireless/ath/hw.h b/drivers/net/wireless/ath/hw.h
index 996ca85..b6c64e8 100644
--- a/drivers/net/wireless/ath/hw.h
+++ b/drivers/net/wireless/ath/hw.h
@@ -32,13 +32,18 @@
 #include "debug.h"
 
 #define ATHEROS_VENDOR_ID	0x168c
+
 #define AR5416_DEVID_PCI	0x0023
 #define AR5416_DEVID_PCIE	0x0024
 #define AR9160_DEVID_PCI	0x0027
 #define AR9280_DEVID_PCI	0x0029
 #define AR9280_DEVID_PCIE	0x002a
 #define AR9285_DEVID_PCIE	0x002b
+
 #define AR5416_AR9100_DEVID	0x000b
+
+#define AR9271_USB		0x9271
+
 #define	AR_SUBVENDOR_ID_NOG	0x0e11
 #define AR_SUBVENDOR_ID_NEW_A	0x7065
 #define AR5416_MAGIC		0x19641014
-- 
1.6.3.3

