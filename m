Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:59698 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759146AbbA2Bxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2015 20:53:33 -0500
Received: from [117.199.141.188] (port=12173 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YGRcj-001zZ7-5v
	for linux-wireless@vger.kernel.org; Wed, 28 Jan 2015 07:21:33 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 3/6] ath9k: Add a macro to identify PCOEM chips
Date: Wed, 28 Jan 2015 17:54:23 +0530
Message-Id: <1422447866-19967-4-git-send-email-sujith@msujith.org> (sfid-20150129_025339_448666_9E56573B)
In-Reply-To: <1422447866-19967-1-git-send-email-sujith@msujith.org>
References: <1422447866-19967-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This can be used if we need to apply register settings
for all PCOEM solutions (in the AR9003 family).

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/reg.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index eb2bb0d..3c0b180 100644
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
+#define AR_SREV_9003_PCOEM(_ah) 0
 #endif
 
 #define AR_SREV_9485_11_OR_LATER(_ah) \
-- 
2.2.2

