Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:53739
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752988AbaJVQRl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 12:17:41 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH] ath9k_common: always update value in ath9k_cmn_update_txpow
Date: Wed, 22 Oct 2014 18:17:35 +0200
Message-Id: <1413994655-63046-1-git-send-email-nbd@openwrt.org> (sfid-20141022_181744_791626_DF2CCDDF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some cases the limit may be the same as reg->power_limit, but the
actual value that the hardware uses is not up to date. In that case, a
wrong value for current tx power is tracked internally.
Fix this by unconditionally updating it.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/common.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index c6dd7f1..33b0c7a 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -368,11 +368,11 @@ void ath9k_cmn_update_txpow(struct ath_hw *ah, u16 cur_txpow,
 {
 	struct ath_regulatory *reg = ath9k_hw_regulatory(ah);
 
-	if (reg->power_limit != new_txpow) {
+	if (reg->power_limit != new_txpow)
 		ath9k_hw_set_txpowerlimit(ah, new_txpow, false);
-		/* read back in case value is clamped */
-		*txpower = reg->max_power_level;
-	}
+
+	/* read back in case value is clamped */
+	*txpower = reg->max_power_level;
 }
 EXPORT_SYMBOL(ath9k_cmn_update_txpow);
 
-- 
2.0.4

