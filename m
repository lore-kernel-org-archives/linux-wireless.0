Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39346 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab0DZTEm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 15:04:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 13/13] ath9k_hw: Fix TX interrupt mitigation settings
Date: Mon, 26 Apr 2010 15:04:41 -0400
Message-Id: <1272308681-32396-14-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1272308681-32396-1-git-send-email-lrodriguez@atheros.com>
References: <1272308681-32396-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TX interrupt mitigation reduces the number of interrupts
by addressing several interrupt actions (AR_IMR_TXOK,
AR_IMR_TXDESC) all in one interrupt so when enabling
it discard setting the other interrupts.

Without this TX interrupt mitigation would actually
increase the number of interrupts two-fold. We still
leave TX interrupt mitigation disabled as it is still
being tested.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/mac.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 7bbf502..0e425cb 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -878,10 +878,12 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah,
 	if (ints & ATH9K_INT_TX) {
 		if (ah->config.tx_intr_mitigation)
 			mask |= AR_IMR_TXMINTR | AR_IMR_TXINTM;
-		if (ah->txok_interrupt_mask)
-			mask |= AR_IMR_TXOK;
-		if (ah->txdesc_interrupt_mask)
-			mask |= AR_IMR_TXDESC;
+		else {
+			if (ah->txok_interrupt_mask)
+				mask |= AR_IMR_TXOK;
+			if (ah->txdesc_interrupt_mask)
+				mask |= AR_IMR_TXDESC;
+		}
 		if (ah->txerr_interrupt_mask)
 			mask |= AR_IMR_TXERR;
 		if (ah->txeol_interrupt_mask)
-- 
1.6.3.3

