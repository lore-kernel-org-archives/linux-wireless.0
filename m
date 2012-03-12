Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58173 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab2CLF5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 01:57:42 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC] ath9k_hw: Fix chip revision checks
Date: Mon, 12 Mar 2012 11:27:33 +0530
Message-ID: <1331531853-5043-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120312_065745_996257_9BD17688)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

not sure if these checks are previously avoided may be those revision of
chipsets are obselete ?

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/reg.h |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 80b1856..55e3513 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -821,20 +821,28 @@
 	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9160_11))
 #define AR_SREV_9280(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9280))
-#define AR_SREV_9280_20_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9280))
 #define AR_SREV_9280_20(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9280))
+#define AR_SREV_9280_10_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9280))
+#define AR_SREV_9280_20_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9280) || \
+	 (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9280) && \
+	  ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9280_20)))
 
 #define AR_SREV_9285(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9285))
 #define AR_SREV_9285_12_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9285))
+	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9285) || \
+	 (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9285) && \
+	  ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9285_12)))
 
 #define AR_SREV_9287(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287))
 #define AR_SREV_9287_11_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9287))
+	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9287) || \
+	 (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
+	  ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9285_11)))
 #define AR_SREV_9287_11(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
 	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9287_11))
@@ -862,7 +870,9 @@
 #define AR_SREV_9300(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9300))
 #define AR_SREV_9300_20_OR_LATER(_ah) \
-	((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9300)
+	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9300) || \
+	 (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9300) && \
+	  ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9300_20)))
 
 #define AR_SREV_9330(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9330))
-- 
1.7.0.4

