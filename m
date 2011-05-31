Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:53491 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758090Ab1EaTrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 15:47:49 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [RFC 11/32] ath9k: don't enable LDPC for AR9330
Date: Tue, 31 May 2011 21:37:02 +0200
Message-Id: <1306870643-7935-12-git-send-email-juhosg@openwrt.org> (sfid-20110531_214913_401244_D7992640)
In-Reply-To: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
References: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f53a3bf..6315e7d 100644
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

