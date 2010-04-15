Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54725 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab0DODaw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:52 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v2 02/97] ath9k_hw: add silicon revision macros for AR9300
Date: Wed, 14 Apr 2010 23:29:16 -0400
Message-Id: <1271302251-9075-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

AR9300 will be the first device supported of the AR9003
family. AR9300 1.0 hardware exists but it is not going to
be sold anywhere so we completely skip its support.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/reg.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 7e36ad7..5ab6d6e 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -759,6 +759,8 @@
 #define AR_SREV_VERSION_9271			0x140
 #define AR_SREV_REVISION_9271_10		0
 #define AR_SREV_REVISION_9271_11		1
+#define AR_SREV_VERSION_9300                  0x1c0
+#define AR_SREV_REVISION_9300_20              2 /* 2.0 and 2.1 */
 
 #define AR_SREV_5416(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) || \
@@ -844,6 +846,15 @@
 #define AR_SREV_9271_11(_ah) \
     (AR_SREV_9271(_ah) && \
      ((_ah)->hw_version.macRev == AR_SREV_REVISION_9271_11))
+#define AR_SREV_9300(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9300))
+#define AR_SREV_9300_20(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9300) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9300_20))
+#define AR_SREV_9300_20_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9300) || \
+	 (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9300) && \
+	  ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9300_20)))
 
 #define AR_SREV_9285E_20(_ah) \
     (AR_SREV_9285_12_OR_LATER(_ah) && \
-- 
1.6.3.3

