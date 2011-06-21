Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:41650 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab1FUJYy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 05:24:54 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 01/32] ath9k: define mac version for AR9330
Date: Tue, 21 Jun 2011 11:23:21 +0200
Message-Id: <1308648232-9906-2-git-send-email-juhosg@openwrt.org> (sfid-20110621_112504_573738_1AA153AB)
In-Reply-To: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
References: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    5 ++++-
 drivers/net/wireless/ath/ath9k/reg.h |   16 ++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6de2655..a3881b6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -551,6 +551,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	case AR_SREV_VERSION_9287:
 	case AR_SREV_VERSION_9271:
 	case AR_SREV_VERSION_9300:
+	case AR_SREV_VERSION_9330:
 	case AR_SREV_VERSION_9485:
 	case AR_SREV_VERSION_9340:
 		break;
@@ -561,7 +562,8 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 		return -EOPNOTSUPP;
 	}
 
-	if (AR_SREV_9271(ah) || AR_SREV_9100(ah) || AR_SREV_9340(ah))
+	if (AR_SREV_9271(ah) || AR_SREV_9100(ah) || AR_SREV_9340(ah) ||
+	    AR_SREV_9330(ah))
 		ah->is_pciexpress = false;
 
 	ah->hw_version.phyRev = REG_READ(ah, AR_PHY_CHIP_ID);
@@ -2574,6 +2576,7 @@ static struct {
 	{ AR_SREV_VERSION_9287,         "9287" },
 	{ AR_SREV_VERSION_9271,         "9271" },
 	{ AR_SREV_VERSION_9300,         "9300" },
+	{ AR_SREV_VERSION_9330,         "9330" },
 	{ AR_SREV_VERSION_9485,         "9485" },
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index c18ee99..a483388 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -788,6 +788,10 @@
 #define AR_SREV_REVISION_9271_11	1
 #define AR_SREV_VERSION_9300		0x1c0
 #define AR_SREV_REVISION_9300_20	2 /* 2.0 and 2.1 */
+#define AR_SREV_VERSION_9330		0x200
+#define AR_SREV_REVISION_9330_10	0
+#define AR_SREV_REVISION_9330_11	1
+#define AR_SREV_REVISION_9330_12	2
 #define AR_SREV_VERSION_9485		0x240
 #define AR_SREV_REVISION_9485_10	0
 #define AR_SREV_REVISION_9485_11        1
@@ -862,6 +866,18 @@
 #define AR_SREV_9300_20_OR_LATER(_ah) \
 	((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9300)
 
+#define AR_SREV_9330(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9330))
+#define AR_SREV_9330_10(_ah) \
+	(AR_SREV_9330((_ah)) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9330_10))
+#define AR_SREV_9330_11(_ah) \
+	(AR_SREV_9330((_ah)) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9330_11))
+#define AR_SREV_9330_12(_ah) \
+	(AR_SREV_9330((_ah)) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9330_12))
+
 #define AR_SREV_9485(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9485))
 #define AR_SREV_9485_10(_ah) \
-- 
1.7.2.1

