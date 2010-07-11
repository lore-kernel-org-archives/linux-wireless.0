Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:46129 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559Ab0GKKs5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:48:57 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, linville@tuxdriver.com
Subject: [PATCH 3/7] ath9k_hw: fix an off-by-one error in the PDADC boundaries calculation
Date: Sun, 11 Jul 2010 12:48:41 +0200
Message-Id: <1278845325-62000-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1278845325-62000-2-git-send-email-nbd@openwrt.org>
References: <1278845325-62000-1-git-send-email-nbd@openwrt.org>
 <1278845325-62000-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PDADC values were only generated for values surrounding the target
index, however not for the target index itself, leading to a minor
error in the generated curve.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/eeprom_def.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 60480a1..02e6c2a 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -730,7 +730,7 @@ static void ath9k_hw_get_def_gain_boundaries_pdadcs(struct ath_hw *ah,
 				    vpdTableI[i][sizeCurrVpdTable - 2]);
 		vpdStep = (int16_t)((vpdStep < 1) ? 1 : vpdStep);
 
-		if (tgtIndex > maxIndex) {
+		if (tgtIndex >= maxIndex) {
 			while ((ss <= tgtIndex) &&
 			       (k < (AR5416_NUM_PDADC_VALUES - 1))) {
 				tmpVal = (int16_t)((vpdTableI[i][sizeCurrVpdTable - 1] +
-- 
1.6.4.2

