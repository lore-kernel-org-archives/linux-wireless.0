Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35350 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758405AbZJGApL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 20:45:11 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 6/7] ath5k: fix regression which triggers an SME join upon assoc
Date: Tue,  6 Oct 2009 20:44:33 -0400
Message-Id: <1254876274-1145-7-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1254876274-1145-1-git-send-email-lrodriguez@atheros.com>
References: <1254876274-1145-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a regression introduced by patch titled:

"atheros: define shared bssidmask setting"

The register for the BSSID was exchanged for the bssid mask register.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/pcu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 2ab9c0e..64fc1eb 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -295,11 +295,11 @@ void ath5k_hw_set_associd(struct ath5k_hw *ah)
 	 */
 	ath5k_hw_reg_write(ah,
 			   get_unaligned_le32(common->curbssid),
-			   AR_BSSMSKL);
+			   AR5K_BSS_ID0);
 	ath5k_hw_reg_write(ah,
 			   get_unaligned_le16(common->curbssid + 4) |
 			   ((common->curaid & 0x3fff) << AR5K_BSS_ID1_AID_S),
-			   AR_BSSMSKU);
+			   AR5K_BSS_ID1);
 
 	if (common->curaid == 0) {
 		ath5k_hw_disable_pspoll(ah);
-- 
1.6.0.4

