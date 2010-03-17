Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41119 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147Ab0CQW2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 18:28:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 16/20] ath9k_hw: simplify reseting of the MIB control register
Date: Wed, 17 Mar 2010 18:28:09 -0400
Message-Id: <1268864893-11428-17-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
References: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This complex thing can more easily be expressed as 0.

Reported-by: Bruno Randolf <br1@einfach.org>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ani.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index a4e492d..efe0bb9 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -842,9 +842,7 @@ void ath9k_enable_mib_counters(struct ath_hw *ah)
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
 	ath9k_hw_clear_mib_counters(ah, false);
 
-	REG_WRITE(ah, AR_MIBC,
-		  ~(AR_MIBC_COW | AR_MIBC_FMC | AR_MIBC_CMC | AR_MIBC_MCS)
-		  & 0x0f);
+	REG_WRITE(ah, AR_MIBC, 0);
 	ath9k_hw_update_phy_err_masks(ah);
 }
 
-- 
1.6.3.3

