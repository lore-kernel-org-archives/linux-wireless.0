Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:40577 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933338Ab2GCRPA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 13:15:00 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	qca-developer-program@qualcomm.com, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 16/20] ath9k: skip internal regulator configuration for AR9550
Date: Tue,  3 Jul 2012 19:13:30 +0200
Message-Id: <1341335614-15419-17-git-send-email-juhosg@openwrt.org> (sfid-20120703_192129_499785_CA92FA15)
In-Reply-To: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
References: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 57002d1..25de6f9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3960,7 +3960,7 @@ static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 	ar9003_hw_drive_strength_apply(ah);
 	ar9003_hw_atten_apply(ah, chan);
 	ar9003_hw_quick_drop_apply(ah, chan->channel);
-	if (!AR_SREV_9330(ah) && !AR_SREV_9340(ah))
+	if (!AR_SREV_9330(ah) && !AR_SREV_9340(ah) && !AR_SREV_9550(ah))
 		ar9003_hw_internal_regulator_apply(ah);
 	if (AR_SREV_9485(ah) || AR_SREV_9330(ah) || AR_SREV_9340(ah))
 		ar9003_hw_apply_tuning_caps(ah);
-- 
1.7.2.1

