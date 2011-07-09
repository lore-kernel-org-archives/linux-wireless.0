Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35856 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab1GIENQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2011 00:13:16 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 8/9] ath9k_hw: fix synth delay for half/quarter channels
Date: Sat,  9 Jul 2011 11:12:53 +0700
Message-Id: <1310184774-32913-8-git-send-email-nbd@openwrt.org> (sfid-20110709_061328_617873_2DBB6EE5)
In-Reply-To: <1310184774-32913-7-git-send-email-nbd@openwrt.org>
References: <1310184774-32913-1-git-send-email-nbd@openwrt.org>
 <1310184774-32913-2-git-send-email-nbd@openwrt.org>
 <1310184774-32913-3-git-send-email-nbd@openwrt.org>
 <1310184774-32913-4-git-send-email-nbd@openwrt.org>
 <1310184774-32913-5-git-send-email-nbd@openwrt.org>
 <1310184774-32913-6-git-send-email-nbd@openwrt.org>
 <1310184774-32913-7-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The radio needs twice / four times as much time to stabilize for half/quarter
channels.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 441bb33..fac2c6d 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -627,6 +627,11 @@ static void ar5008_hw_init_bb(struct ath_hw *ah,
 	else
 		synthDelay /= 10;
 
+	if (IS_CHAN_HALF_RATE(chan))
+		synthDelay *= 2;
+	else if (IS_CHAN_QUARTER_RATE(chan))
+		synthDelay *= 4;
+
 	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
 
 	udelay(synthDelay + BASE_ACTIVATE_DELAY);
-- 
1.7.3.2

