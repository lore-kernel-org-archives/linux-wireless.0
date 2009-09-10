Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38475 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbZIJTaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 15:30:24 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 03/10] ath9k: use ath9k_hw_write_associd() on reset
Date: Thu, 10 Sep 2009 15:30:20 -0400
Message-Id: <1252611027-5285-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252611027-5285-1-git-send-email-lrodriguez@atheros.com>
References: <1252611027-5285-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the already provided helper instead of rewriting the code
required in place.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 957ecb8..e370c8f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2458,9 +2458,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	REG_WRITE(ah, AR_DEF_ANTENNA, saveDefAntenna);
 
-	REG_WRITE(ah, AR_BSS_ID0, get_unaligned_le32(sc->curbssid));
-	REG_WRITE(ah, AR_BSS_ID1, get_unaligned_le16(sc->curbssid + 4) |
-		  ((sc->curaid & 0x3fff) << AR_BSS_ID1_AID_S));
+	ath9k_hw_write_associd(ah);
 
 	REG_WRITE(ah, AR_ISR, ~0);
 
-- 
1.6.3.3

