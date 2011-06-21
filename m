Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:41712 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab1FUJZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 05:25:00 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 28/32] ath9k: fix few register offsets for AR9330
Date: Tue, 21 Jun 2011 11:23:48 +0200
Message-Id: <1308648232-9906-29-git-send-email-juhosg@openwrt.org> (sfid-20110621_112542_039091_FD986449)
In-Reply-To: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
References: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index d259278..9eb3aa2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -625,11 +625,11 @@
 #define AR_PHY_65NM_CH2_RXTX1       0x16900
 #define AR_PHY_65NM_CH2_RXTX2       0x16904
 
-#define AR_CH0_TOP2 (AR_SREV_9485(ah) ? 0x00016284 : 0x0001628c)
+#define AR_CH0_TOP2		(AR_SREV_9300(ah) ? 0x1628c : 0x16284)
 #define AR_CH0_TOP2_XPABIASLVL		0xf000
 #define AR_CH0_TOP2_XPABIASLVL_S	12
 
-#define AR_CH0_XTAL		(AR_SREV_9485(ah) ? 0x16290 : 0x16294)
+#define AR_CH0_XTAL		(AR_SREV_9300(ah) ? 0x16294 : 0x16290)
 #define AR_CH0_XTAL_CAPINDAC	0x7f000000
 #define AR_CH0_XTAL_CAPINDAC_S	24
 #define AR_CH0_XTAL_CAPOUTDAC	0x00fe0000
-- 
1.7.2.1

