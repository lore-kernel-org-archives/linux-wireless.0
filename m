Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:46461 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbbASCKw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2015 21:10:52 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@qca.qualcomm.com
Subject: [PATCH 3/6] ath9k: Add a macro to identify PCOEM chips
Date: Mon, 19 Jan 2015 07:43:15 +0530
Message-Id: <1421633598-4488-4-git-send-email-sujith@msujith.org> (sfid-20150119_031102_509049_C858CCE7)
In-Reply-To: <1421633598-4488-1-git-send-email-sujith@msujith.org>
References: <1421633598-4488-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This can be use if we need to apply register settings
for all PCOEM solutions (in the AR9003 family).

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/reg.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index eb2bb0d..441145e 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -900,10 +900,13 @@
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9485))
 #define AR_SREV_9565(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9565))
+#define AR_SREV_9003_PCOEM(_ah) \
+	(AR_SREV_9462(_ah) || AR_SREV_9485(_ah) || AR_SREV_9565(_ah))
 #else
 #define AR_SREV_9462(_ah) 0
 #define AR_SREV_9485(_ah) 0
 #define AR_SREV_9565(_ah) 0
+#define AR_SREV_9003_PCOEM(_ah) )
 #endif
 
 #define AR_SREV_9485_11_OR_LATER(_ah) \
-- 
2.2.2

