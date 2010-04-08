Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46730 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933204Ab0DHT1k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:40 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 018/102] ath9k_hw: Add hw cap flag for EDMA for the AR9003 family
Date: Thu,  8 Apr 2010 15:26:14 -0400
Message-Id: <1270754858-26266-19-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

AR9003 supports extended DMA (EDMA), this comes with some
bells and whistles on top of the legacy DMA that we are used
to. Mark AR9003 and later chips EDMA capable.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    3 +++
 drivers/net/wireless/ath/ath9k/hw.h |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f161a98..9a63884 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2916,6 +2916,9 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		btcoex_hw->scheme = ATH_BTCOEX_CFG_NONE;
 	}
 
+	if (AR_SREV_9300_20_OR_LATER(ah))
+		pCap->hw_caps |= ATH9K_HW_CAP_EDMA;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index f04d64b..c4b2770 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -165,6 +165,7 @@ enum ath9k_hw_caps {
 	ATH9K_HW_CAP_ENHANCEDPM                 = BIT(14),
 	ATH9K_HW_CAP_AUTOSLEEP                  = BIT(15),
 	ATH9K_HW_CAP_4KB_SPLITTRANS             = BIT(16),
+	ATH9K_HW_CAP_EDMA			= BIT(17),
 };
 
 enum ath9k_capability_type {
-- 
1.6.3.3

