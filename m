Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:39702 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbZCETyE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 14:54:04 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Imre Kaloz <kaloz@openwrt.org>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/3] ath9k: move ar9100 version checking macros into a more appropriate place
Date: Thu,  5 Mar 2009 20:53:56 +0100
Message-Id: <1236282837-6612-3-git-send-email-juhosg@openwrt.org> (sfid-20090305_205410_663436_7CAECEC2)
In-Reply-To: <1236282837-6612-1-git-send-email-juhosg@openwrt.org>
References: <1236282837-6612-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All other version checking macros are in a common location within the
reg.h file. The AR_SREV_9100_OR_LATER macro is wrong currently, but will
be fixed with the next patch.

Changes-licensed-under: ISC

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
---
 drivers/net/wireless/ath9k/reg.h |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath9k/reg.h b/drivers/net/wireless/ath9k/reg.h
index fcddef5..2512e9b 100644
--- a/drivers/net/wireless/ath9k/reg.h
+++ b/drivers/net/wireless/ath9k/reg.h
@@ -158,10 +158,6 @@
 #define AR_CST_TIMEOUT_LIMIT      0xFFFF0000
 #define AR_CST_TIMEOUT_LIMIT_S    16
 
-#define AR_SREV_VERSION_9100                  0x014
-
-#define AR_SREV_9100(ah) ((ah->hw_version.macVersion) == AR_SREV_VERSION_9100)
-
 #define AR_ISR               0x0080
 #define AR_ISR_RXOK          0x00000001
 #define AR_ISR_RXDESC        0x00000002
@@ -730,6 +726,7 @@
 #define AR_SREV_REVISION_5416_10               0
 #define AR_SREV_REVISION_5416_20               1
 #define AR_SREV_REVISION_5416_22               2
+#define AR_SREV_VERSION_9100                  0x14
 #define AR_SREV_VERSION_9160        	      0x40
 #define AR_SREV_REVISION_9160_10    	      0
 #define AR_SREV_REVISION_9160_11    	      1
@@ -742,9 +739,6 @@
 #define AR_SREV_REVISION_9285_11              1
 #define AR_SREV_REVISION_9285_12              2
 
-#define AR_SREV_9100_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_5416_PCIE))
-
 #define AR_SREV_5416(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) || \
 	 ((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCIE))
@@ -757,6 +751,11 @@
 	 ((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_22)) || \
 	 ((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9100))
 
+#define AR_SREV_9100(ah) \
+	((ah->hw_version.macVersion) == AR_SREV_VERSION_9100)
+#define AR_SREV_9100_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_5416_PCIE))
+
 #define AR_SREV_9160(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9160))
 #define AR_SREV_9160_10_OR_LATER(_ah) \
-- 
1.5.3.2

