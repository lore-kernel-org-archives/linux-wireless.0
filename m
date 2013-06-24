Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:52300 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3FXMvs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 08:51:48 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 1/4] ath9k: Add version macros for AR9462 2.1
Date: Mon, 24 Jun 2013 18:18:43 +0530
Message-Id: <1372078126-13602-1-git-send-email-sujith@msujith.org> (sfid-20130624_145151_330505_96C8DDA7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/reg.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index f7c90cc..5af9744 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -806,6 +806,7 @@
 #define AR_SREV_REVISION_9580_10	4 /* AR9580 1.0 */
 #define AR_SREV_VERSION_9462		0x280
 #define AR_SREV_REVISION_9462_20	2
+#define AR_SREV_REVISION_9462_21	3
 #define AR_SREV_VERSION_9565            0x2C0
 #define AR_SREV_REVISION_9565_10        0
 #define AR_SREV_VERSION_9550		0x400
@@ -911,10 +912,18 @@
 
 #define AR_SREV_9462(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462))
-
 #define AR_SREV_9462_20(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462) && \
-	((_ah)->hw_version.macRev == AR_SREV_REVISION_9462_20))
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9462_20))
+#define AR_SREV_9462_21(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9462_21))
+#define AR_SREV_9462_20_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462) && \
+	 ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9462_20))
+#define AR_SREV_9462_21_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462) && \
+	 ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9462_21))
 
 #define AR_SREV_9565(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9565))
-- 
1.8.3.1

