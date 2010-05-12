Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:25336 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755178Ab0ELJko (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 05:40:44 -0400
Received: from vs3009.wh2.ocn.ne.jp (125.206.180.237)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0920157243
	for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 18:40:43 +0900 (JST)
Subject: [PATCH 12/12] ath5k: print error message if ANI levels are out of
	range
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 12 May 2010 18:40:44 +0900
Message-ID: <20100512094044.6575.80141.stgit@tt-desk>
In-Reply-To: <20100512093947.6575.99595.stgit@tt-desk>
References: <20100512093947.6575.99595.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we have sysfs to manually set the ANI levels, we should print errors to
the kernel log if the values are out of bounds.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ani.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ani.c b/drivers/net/wireless/ath/ath5k/ani.c
index 987e3d3..26dbe65 100644
--- a/drivers/net/wireless/ath/ath5k/ani.c
+++ b/drivers/net/wireless/ath/ath5k/ani.c
@@ -74,8 +74,8 @@ ath5k_ani_set_noise_immunity_level(struct ath5k_hw *ah, int level)
 	const s8 fr[] = { -78, -80 };
 #endif
 	if (level < 0 || level >= ARRAY_SIZE(sz)) {
-		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
-			"level out of range %d", level);
+		ATH5K_ERR(ah->ah_sc, "noise immuniy level %d out of range",
+			  level);
 		return;
 	}
 
@@ -106,8 +106,8 @@ ath5k_ani_set_spur_immunity_level(struct ath5k_hw *ah, int level)
 
 	if (level < 0 || level >= ARRAY_SIZE(val) ||
 	    level > ah->ah_sc->ani_state.max_spur_level) {
-		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
-			"level out of range %d", level);
+		ATH5K_ERR(ah->ah_sc, "spur immunity level %d out of range",
+			  level);
 		return;
 	}
 
@@ -130,8 +130,7 @@ ath5k_ani_set_firstep_level(struct ath5k_hw *ah, int level)
 	const int val[] = { 0, 4, 8 };
 
 	if (level < 0 || level >= ARRAY_SIZE(val)) {
-		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
-			"level out of range %d", level);
+		ATH5K_ERR(ah->ah_sc, "firstep level %d out of range", level);
 		return;
 	}
 

