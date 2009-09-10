Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38477 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbZIJTaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 15:30:24 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 02/10] ath9k: Use ath9k_hw_setbssidmask() on reset
Date: Thu, 10 Sep 2009 15:30:19 -0400
Message-Id: <1252611027-5285-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252611027-5285-1-git-send-email-lrodriguez@atheros.com>
References: <1252611027-5285-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The same code was being implemented on reset for setting the bssidmask,
instead just use the already provided helper.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f7aaaa1..957ecb8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2454,8 +2454,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		  | ah->sta_id1_defaults);
 	ath9k_hw_set_operating_mode(ah, ah->opmode);
 
-	REG_WRITE(ah, AR_BSSMSKL, get_unaligned_le32(sc->bssidmask));
-	REG_WRITE(ah, AR_BSSMSKU, get_unaligned_le16(sc->bssidmask + 4));
+	ath9k_hw_setbssidmask(ah);
 
 	REG_WRITE(ah, AR_DEF_ANTENNA, saveDefAntenna);
 
-- 
1.6.3.3

