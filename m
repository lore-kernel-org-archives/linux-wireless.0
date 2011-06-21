Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:41712 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab1FUJY5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 05:24:57 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 11/32] ath9k: don't enable LDPC for AR9330
Date: Tue, 21 Jun 2011 11:23:31 +0200
Message-Id: <1308648232-9906-12-git-send-email-juhosg@openwrt.org> (sfid-20110621_112608_401185_74B54C06)
In-Reply-To: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
References: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index b06fa6f..93c91f2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2030,7 +2030,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		pCap->hw_caps |= ATH9K_HW_CAP_EDMA | ATH9K_HW_CAP_FASTCLOCK;
-		if (!AR_SREV_9485(ah))
+		if (!AR_SREV_9330(ah) && !AR_SREV_9485(ah))
 			pCap->hw_caps |= ATH9K_HW_CAP_LDPC;
 
 		pCap->rx_hp_qdepth = ATH9K_HW_RX_HP_QDEPTH;
-- 
1.7.2.1

