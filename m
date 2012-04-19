Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39565 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756189Ab2DSTSg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 15:18:36 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v3 4/8] ath9k_hw: increase symbol overlap window for half/quarter channels
Date: Thu, 19 Apr 2012 21:18:25 +0200
Message-Id: <1334863109-95726-4-git-send-email-nbd@openwrt.org> (sfid-20120419_211851_341374_C653DE40)
In-Reply-To: <1334863109-95726-3-git-send-email-nbd@openwrt.org>
References: <1334863109-95726-1-git-send-email-nbd@openwrt.org>
 <1334863109-95726-2-git-send-email-nbd@openwrt.org>
 <1334863109-95726-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    4 ++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |    3 +++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index be6069b..4c8d0d7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -728,6 +728,10 @@ static void ar9003_hw_set_rfmode(struct ath_hw *ah,
 	if (IS_CHAN_HALF_RATE(chan))
 		rfMode |= AR_PHY_MODE_HALF;
 
+	if (rfMode & (AR_PHY_MODE_QUARTER | AR_PHY_MODE_HALF))
+		REG_RMW_FIELD(ah, AR_PHY_FRAME_CTL,
+			      AR_PHY_FRAME_CTL_CF_OVERLAP_WINDOW, 3);
+
 	REG_WRITE(ah, AR_PHY_MODE, rfMode);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index d834d97..7268a48 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -468,6 +468,9 @@
 #define AR_PHY_ADDAC_PARA_CTL    (AR_SM_BASE + 0x150)
 #define AR_PHY_XPA_CFG           (AR_SM_BASE + 0x158)
 
+#define AR_PHY_FRAME_CTL_CF_OVERLAP_WINDOW  3
+#define AR_PHY_FRAME_CTL_CF_OVERLAP_WINDOW_S    0
+
 #define AR_PHY_SPUR_MASK_A_CF_PUNC_MASK_IDX_A           0x0001FC00
 #define AR_PHY_SPUR_MASK_A_CF_PUNC_MASK_IDX_A_S         10
 #define AR_PHY_SPUR_MASK_A_CF_PUNC_MASK_A                       0x3FF
-- 
1.7.3.2

