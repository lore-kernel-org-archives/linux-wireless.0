Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48153 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab2DPVJe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 17:09:34 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v2 3/8] ath9k_hw: set the PHY mode for half/quarter channels on AR9003
Date: Mon, 16 Apr 2012 23:09:20 +0200
Message-Id: <1334610565-37399-3-git-send-email-nbd@openwrt.org> (sfid-20120416_230939_983642_73774C25)
In-Reply-To: <1334610565-37399-2-git-send-email-nbd@openwrt.org>
References: <1334610565-37399-1-git-send-email-nbd@openwrt.org>
 <1334610565-37399-2-git-send-email-nbd@openwrt.org>
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

