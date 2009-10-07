Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35353 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758481AbZJGApL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 20:45:11 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/7] ath5k: use ath_hw_setbssidmask() for bssid mask setting upon assoc
Date: Tue,  6 Oct 2009 20:44:29 -0400
Message-Id: <1254876274-1145-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1254876274-1145-1-git-send-email-lrodriguez@atheros.com>
References: <1254876274-1145-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should avoid future typos.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/pcu.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 0385e80..32fd5f8 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -288,13 +288,8 @@ void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id)
 	/*
 	 * Set simple BSSID mask on 5212
 	 */
-	if (ah->ah_version == AR5K_AR5212) {
-		ath5k_hw_reg_write(ah, get_unaligned_le32(common->bssidmask),
-				   AR_BSSMSKL);
-		ath5k_hw_reg_write(ah,
-				   get_unaligned_le16(common->bssidmask + 4),
-				   AR_BSSMSKU);
-	}
+	if (ah->ah_version == AR5K_AR5212)
+		ath_hw_setbssidmask(common);
 
 	/*
 	 * Set BSSID which triggers the "SME Join" operation
-- 
1.6.0.4

