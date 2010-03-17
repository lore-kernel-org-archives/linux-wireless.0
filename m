Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41123 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab0CQW2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 18:28:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 18/20] ath9k_hw: move common defines for ANI into ath/reg.h
Date: Wed, 17 Mar 2010 18:28:11 -0400
Message-Id: <1268864893-11428-19-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
References: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will allow us to share a common ath9k_ani_restart()
and ath9k_hw_procmibevent() once we split the hardware
specific stuff.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/reg.h |    3 ---
 drivers/net/wireless/ath/reg.h       |    5 +++++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index ce94e99..fa37e30 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1530,9 +1530,6 @@ enum {
 #define AR_PHY_ERR_2_COUNT     0x00FFFFFF
 #define AR_PHY_ERR_MASK_2      0x8138
 
-#define AR_PHY_COUNTMAX        (3 << 22)
-#define AR_MIBCNT_INTRMASK     (3 << 22)
-
 #define AR_TSFOOR_THRESHOLD       0x813c
 #define AR_TSFOOR_THRESHOLD_VAL   0x0000FFFF
 
diff --git a/drivers/net/wireless/ath/reg.h b/drivers/net/wireless/ath/reg.h
index dfe1fbe..dc8de1b 100644
--- a/drivers/net/wireless/ath/reg.h
+++ b/drivers/net/wireless/ath/reg.h
@@ -24,4 +24,9 @@
 #define AR_BSSMSKL		0x80e0
 #define AR_BSSMSKU		0x80e4
 
+/* Max counted before intr */
+#define AR_PHY_COUNTMAX		(3 << 22)
+/* Mask top 2 bits of counters */
+#define AR_MIBCNT_INTRMASK	(3 << 22)
+
 #endif /* ATH_REGISTERS_H */
-- 
1.6.3.3

