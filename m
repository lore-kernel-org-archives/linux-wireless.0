Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:14769 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419Ab0DOFbP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 01:31:15 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 14 Apr 2010 22:31:15 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19398.42100.427357.11751@gargle.gargle.HOWL>
Date: Thu, 15 Apr 2010 11:00:28 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/6] ath9k_hw: Add macros for multiple register writes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index ea82713..416924c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -69,6 +69,24 @@
 #define REG_READ(_ah, _reg) \
 	ath9k_hw_common(_ah)->ops->read((_ah), (_reg))
 
+#define ENABLE_REGWRITE_BUFFER(_ah)					\
+	do {								\
+		if (AR_SREV_9271(_ah))					\
+			ath9k_hw_common(_ah)->ops->enable_write_buffer((_ah)); \
+	} while (0)
+
+#define DISABLE_REGWRITE_BUFFER(_ah)					\
+	do {								\
+		if (AR_SREV_9271(_ah))					\
+			ath9k_hw_common(_ah)->ops->disable_write_buffer((_ah)); \
+	} while (0)
+
+#define REGWRITE_BUFFER_FLUSH(_ah)					\
+	do {								\
+		if (AR_SREV_9271(_ah))					\
+			ath9k_hw_common(_ah)->ops->write_flush((_ah));	\
+	} while (0)
+
 #define SM(_v, _f)  (((_v) << _f##_S) & _f)
 #define MS(_v, _f)  (((_v) & _f) >> _f##_S)
 #define REG_RMW(_a, _r, _set, _clr)    \
-- 
1.7.0.4

