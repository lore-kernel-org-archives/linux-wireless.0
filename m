Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37047 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbZCFFzQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 00:55:16 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 21:55:15 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 4/4] ath9k: Incorrect AR9285 version check macro
Date: Fri, 6 Mar 2009 11:24:11 +0530
Message-ID: <1236318851-7500-5-git-send-email-senthilkumar@atheros.com> (sfid-20090306_065519_115425_182BD9AB)
In-Reply-To: <1236318851-7500-4-git-send-email-senthilkumar@atheros.com>
References: <1236318851-7500-1-git-send-email-senthilkumar@atheros.com>
 <1236318851-7500-2-git-send-email-senthilkumar@atheros.com>
 <1236318851-7500-3-git-send-email-senthilkumar@atheros.com>
 <1236318851-7500-4-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix AR9285 1.1 and 1.2 version check macro.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath9k/reg.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/reg.h b/drivers/net/wireless/ath9k/reg.h
index afca69f..d86e90e 100644
--- a/drivers/net/wireless/ath9k/reg.h
+++ b/drivers/net/wireless/ath9k/reg.h
@@ -780,14 +780,14 @@
 #define AR_SREV_9285_10_OR_LATER(_ah) \
 	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9285))
 #define AR_SREV_9285_11(_ah) \
-	(AR_SREV_9280(ah) && \
+	(AR_SREV_9285(ah) && \
 	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9285_11))
 #define AR_SREV_9285_11_OR_LATER(_ah) \
 	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9285) || \
 	 (AR_SREV_9285(ah) && ((_ah)->hw_version.macRev >= \
 			       AR_SREV_REVISION_9285_11)))
 #define AR_SREV_9285_12(_ah) \
-	(AR_SREV_9280(ah) && \
+	(AR_SREV_9285(ah) && \
 	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9285_12))
 #define AR_SREV_9285_12_OR_LATER(_ah) \
 	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9285) || \
-- 
1.6.0.4

