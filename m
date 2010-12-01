Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13826 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833Ab0LAHdF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 02:33:05 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 23:32:50 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 01/26] ath9k_hw: Define hw version macros for AR9485
Date: Tue, 30 Nov 2010 23:32:30 -0800
Message-ID: <1291188775-13707-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
References: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9485 is a single chain and single band (2.4 Ghz) chip.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/reg.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index c2472ed..0153ba1 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -787,6 +787,8 @@
 #define AR_SREV_REVISION_9271_11	1
 #define AR_SREV_VERSION_9300		0x1c0
 #define AR_SREV_REVISION_9300_20	2 /* 2.0 and 2.1 */
+#define AR_SREV_VERSION_9485		0x240
+#define AR_SREV_REVISION_9485_10	0
 
 #define AR_SREV_5416(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) || \
@@ -859,6 +861,12 @@
 	 (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9300) && \
 	  ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9300_20)))
 
+#define AR_SREV_9485(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9485))
+#define AR_SREV_9485_10(_ah) \
+	(AR_SREV_9485(_ah) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9485_10))
+
 #define AR_SREV_9285E_20(_ah) \
     (AR_SREV_9285_12_OR_LATER(_ah) && \
      ((REG_READ(_ah, AR_AN_SYNTH9) & 0x7) == 0x1))
-- 
1.7.0.4

