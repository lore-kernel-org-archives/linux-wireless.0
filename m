Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35344 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758477AbZJGApL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 20:45:11 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 5/7] ath5k: remove temporary low_id and high_id vars on ath5k_hw_set_associd()
Date: Tue,  6 Oct 2009 20:44:32 -0400
Message-Id: <1254876274-1145-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1254876274-1145-1-git-send-email-lrodriguez@atheros.com>
References: <1254876274-1145-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/pcu.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 23e5e7e..2ab9c0e 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -282,7 +282,6 @@ int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac)
 void ath5k_hw_set_associd(struct ath5k_hw *ah)
 {
 	struct ath_common *common = ath5k_hw_common(ah);
-	u32 low_id, high_id;
 	u16 tim_offset = 0;
 
 	/*
@@ -294,11 +293,13 @@ void ath5k_hw_set_associd(struct ath5k_hw *ah)
 	/*
 	 * Set BSSID which triggers the "SME Join" operation
 	 */
-	low_id = get_unaligned_le32(common->curbssid);
-	high_id = get_unaligned_le16(common->curbssid + 4);
-	ath5k_hw_reg_write(ah, low_id, AR_BSSMSKL);
-	ath5k_hw_reg_write(ah, high_id | ((common->curaid & 0x3fff) <<
-				AR5K_BSS_ID1_AID_S), AR_BSSMSKU);
+	ath5k_hw_reg_write(ah,
+			   get_unaligned_le32(common->curbssid),
+			   AR_BSSMSKL);
+	ath5k_hw_reg_write(ah,
+			   get_unaligned_le16(common->curbssid + 4) |
+			   ((common->curaid & 0x3fff) << AR5K_BSS_ID1_AID_S),
+			   AR_BSSMSKU);
 
 	if (common->curaid == 0) {
 		ath5k_hw_disable_pspoll(ah);
@@ -306,7 +307,7 @@ void ath5k_hw_set_associd(struct ath5k_hw *ah)
 	}
 
 	AR5K_REG_WRITE_BITS(ah, AR5K_BEACON, AR5K_BEACON_TIM,
-			tim_offset ? tim_offset + 4 : 0);
+			    tim_offset ? tim_offset + 4 : 0);
 
 	ath5k_hw_enable_pspoll(ah, NULL, 0);
 }
-- 
1.6.0.4

