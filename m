Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44673 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196Ab2DOKPw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2012 06:15:52 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3/9] ath9k_hw: set the PHY mode for half/quarter channels on AR9003
Date: Sun, 15 Apr 2012 12:15:35 +0200
Message-Id: <1334484941-27673-3-git-send-email-nbd@openwrt.org> (sfid-20120415_121611_208990_51615B4F)
In-Reply-To: <1334484941-27673-2-git-send-email-nbd@openwrt.org>
References: <1334484941-27673-1-git-send-email-nbd@openwrt.org>
 <1334484941-27673-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 4c9bc9f..b9f88a2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -721,6 +721,10 @@ static void ar9003_hw_set_rfmode(struct ath_hw *ah,
 
 	if (IS_CHAN_A_FAST_CLOCK(ah, chan))
 		rfMode |= (AR_PHY_MODE_DYNAMIC | AR_PHY_MODE_DYN_CCK_DISABLE);
+	if (IS_CHAN_QUARTER_RATE(chan))
+		rfMode |= AR_PHY_MODE_QUARTER;
+	if (IS_CHAN_HALF_RATE(chan))
+		rfMode |= AR_PHY_MODE_HALF;
 
 	REG_WRITE(ah, AR_PHY_MODE, rfMode);
 }
-- 
1.7.3.2

