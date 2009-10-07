Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35352 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758443AbZJGApL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 20:45:11 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/7] ath5k: fix regression introduced upon the removal of AR5K_HIGH_ID()
Date: Tue,  6 Oct 2009 20:44:30 -0400
Message-Id: <1254876274-1145-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1254876274-1145-1-git-send-email-lrodriguez@atheros.com>
References: <1254876274-1145-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The trick was to add four bytes whenever this was used. There
are two places where this was missed.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/pcu.c   |    2 +-
 drivers/net/wireless/ath/ath5k/reset.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 32fd5f8..9e6e41b 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -295,7 +295,7 @@ void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id)
 	 * Set BSSID which triggers the "SME Join" operation
 	 */
 	low_id = get_unaligned_le32(bssid);
-	high_id = get_unaligned_le16(bssid);
+	high_id = get_unaligned_le16(bssid + 4);
 	ath5k_hw_reg_write(ah, low_id, AR_BSSMSKL);
 	ath5k_hw_reg_write(ah, high_id | ((assoc_id & 0x3fff) <<
 				AR5K_BSS_ID1_AID_S), AR_BSSMSKU);
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 51aff76..39346a2 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -1178,7 +1178,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 			   get_unaligned_le32(common->macaddr),
 			   AR5K_STA_ID0);
 	ath5k_hw_reg_write(ah,
-			   staid1_flags | get_unaligned_le16(common->macaddr),
+			   staid1_flags | get_unaligned_le16(common->macaddr + 4),
 			   AR5K_STA_ID1);
 
 
-- 
1.6.0.4

