Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:60894 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab3KSHEQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 02:04:16 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] ath9k: Add version macros for AR9565 1.1
Date: Tue, 19 Nov 2013 12:29:34 +0530
Message-Id: <1384844375-6347-3-git-send-email-sujith@msujith.org> (sfid-20131119_080421_165661_71725892)
In-Reply-To: <1384844375-6347-1-git-send-email-sujith@msujith.org>
References: <1384844375-6347-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/reg.h | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index a13b2d1..259a4b3 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -809,6 +809,8 @@
 #define AR_SREV_REVISION_9462_21	3
 #define AR_SREV_VERSION_9565            0x2C0
 #define AR_SREV_REVISION_9565_10        0
+#define AR_SREV_REVISION_9565_101       1
+#define AR_SREV_REVISION_9565_11        2
 #define AR_SREV_VERSION_9550		0x400
 
 #define AR_SREV_5416(_ah) \
@@ -927,10 +929,18 @@
 
 #define AR_SREV_9565(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9565))
-
 #define AR_SREV_9565_10(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9565) && \
 	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9565_10))
+#define AR_SREV_9565_101(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9565) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9565_101))
+#define AR_SREV_9565_11(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9565) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9565_11))
+#define AR_SREV_9565_11_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9565) && \
+	 ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9565_11))
 
 #define AR_SREV_9550(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9550))
-- 
1.8.4.2

