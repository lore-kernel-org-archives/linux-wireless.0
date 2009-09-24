Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43114 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbZIXDHB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 23:07:01 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 4/4] ath9k_hw: add AR9271 srev and device ID to allow hw to support ar9271
Date: Wed, 23 Sep 2009 23:07:02 -0400
Message-Id: <1253761622-9530-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1253761622-9530-1-git-send-email-lrodriguez@atheros.com>
References: <1253761622-9530-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows for hw support to be enabled for ar9271.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    4 ++--
 drivers/net/wireless/ath/ath9k/hw.h |    5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7bf0f8c..692fd1d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -609,6 +609,7 @@ static bool ath9k_hw_devid_supported(u16 devid)
 	case AR9285_DEVID_PCIE:
 	case AR5416_DEVID_AR9287_PCI:
 	case AR5416_DEVID_AR9287_PCIE:
+	case AR9271_USB:
 		return true;
 	default:
 		break;
@@ -626,9 +627,8 @@ static bool ath9k_hw_macversion_supported(u32 macversion)
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
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 773f5c4..f782c1a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -33,13 +33,18 @@
 #include "../debug.h"
 
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
+#define AR9271_USB             0x9271
+
 #define	AR_SUBVENDOR_ID_NOG	0x0e11
 #define AR_SUBVENDOR_ID_NEW_A	0x7065
 #define AR5416_MAGIC		0x19641014
-- 
1.6.3.3

