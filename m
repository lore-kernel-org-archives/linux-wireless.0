Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2870 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758775AbZBLSjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 13:39:09 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	ath9k-devel@lists.ath9k.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/6] ath9k: remove write-only current_rd_inuse
Date: Thu, 12 Feb 2009 13:38:53 -0500
Message-Id: <1234463938-1350-2-git-send-email-me@bobcopeland.com> (sfid-20090212_193916_912451_13107B1D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current_rd_inuse regulatory value is assigned but not used anywhere.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath9k/regd.c |    1 -
 drivers/net/wireless/ath9k/regd.h |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index 8c2b56a..0c632ff 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -433,7 +433,6 @@ int ath9k_regd_init(struct ath_hw *ah)
 			regdmn = country->regDmnEnum;
 	}
 
-	ah->regulatory.current_rd_inuse = regdmn;
 	ah->regulatory.regpair = ath9k_get_regpair(regdmn);
 
 	if (!ah->regulatory.regpair) {
diff --git a/drivers/net/wireless/ath9k/regd.h b/drivers/net/wireless/ath9k/regd.h
index 39420de..53a9f46 100644
--- a/drivers/net/wireless/ath9k/regd.h
+++ b/drivers/net/wireless/ath9k/regd.h
@@ -52,7 +52,6 @@ struct ath9k_regulatory {
 	u32 tp_scale;
 	u16 current_rd;
 	u16 current_rd_ext;
-	u16 current_rd_inuse;
 	int16_t power_limit;
 	struct reg_dmn_pair_mapping *regpair;
 };
-- 
1.6.0.6


