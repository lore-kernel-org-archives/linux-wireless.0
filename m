Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40337 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113AbZHDDOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 23:14:12 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zhifeng.cai@atheros.com,
	ath9k-devel@lists.ath9k.org, stephen.chen@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/3] ath9k: add ar9271 revision and subrevision ID helpers
Date: Mon,  3 Aug 2009 23:14:10 -0400
Message-Id: <1249355652-10031-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1249355652-10031-1-git-send-email-lrodriguez@atheros.com>
References: <1249355652-10031-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These will be used later to add support for ar9271.

Cc: Stephen Chen <stephen.chen@atheros.com>
Cc: Zhifeng Cai <zhifeng.cai@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/reg.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 8302aeb..37cbf03 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -744,6 +744,9 @@
 #define AR_SREV_VERSION_9287                  0x180
 #define AR_SREV_REVISION_9287_10              0
 #define AR_SREV_REVISION_9287_11              1
+#define AR_SREV_VERSION_9271			0x140
+#define AR_SREV_REVISION_9271_10		0
+#define AR_SREV_REVISION_9271_11		1
 
 #define AR_SREV_5416(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) || \
@@ -815,6 +818,15 @@
 	 (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
 	  ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9287_11)))
 
+#define AR_SREV_9271(_ah) \
+    (((_ah))->hw_version.macVersion == AR_SREV_VERSION_9271)
+#define AR_SREV_9271_10(_ah) \
+    (AR_SREV_9271(_ah) && \
+     ((_ah)->hw_version.macRev == AR_SREV_REVISION_9271_10))
+#define AR_SREV_9271_11(_ah) \
+    (AR_SREV_9271(_ah) && \
+     ((_ah)->hw_version.macRev == AR_SREV_REVISION_9271_11))
+
 #define AR_RADIO_SREV_MAJOR                   0xf0
 #define AR_RAD5133_SREV_MAJOR                 0xc0
 #define AR_RAD2133_SREV_MAJOR                 0xd0
-- 
1.6.3.3

