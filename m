Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35348 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757856AbZJGApL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 20:45:11 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/7] ath5k: fix regression on setting bssid mask on association
Date: Tue,  6 Oct 2009 20:44:28 -0400
Message-Id: <1254876274-1145-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1254876274-1145-1-git-send-email-lrodriguez@atheros.com>
References: <1254876274-1145-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was a typo on the second bssid mask register.
This was caused by the patch titled:

"ath5k: use common curbssid, bssidmask and macaddr"

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/pcu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 9ac7638..0385e80 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -292,7 +292,7 @@ void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id)
 		ath5k_hw_reg_write(ah, get_unaligned_le32(common->bssidmask),
 				   AR_BSSMSKL);
 		ath5k_hw_reg_write(ah,
-				   get_unaligned_le16(common->curbssid + 4),
+				   get_unaligned_le16(common->bssidmask + 4),
 				   AR_BSSMSKU);
 	}
 
-- 
1.6.0.4

