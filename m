Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:56253
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753249AbaI2Sps (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 14:45:48 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 2/3] ath9k_hw: reduce ANI spur immunity setting on HT40 extension channel
Date: Mon, 29 Sep 2014 20:45:41 +0200
Message-Id: <1412016342-21227-2-git-send-email-nbd@openwrt.org> (sfid-20140929_204553_005920_8B7D24A6)
In-Reply-To: <1412016342-21227-1-git-send-email-nbd@openwrt.org>
References: <1412016342-21227-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The cycpwr_thr1 value needs to be lower on the extension channel than on
the control channel, similar to how the register settings are programmed
in the initvals.

Also drop the unnecessary check for HT40 - this register can always be
written. This patch has been reported to improve HT40 stability and
throughput in some environments.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 3b3e910..b72d0be 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1042,9 +1042,8 @@ static bool ar5008_hw_ani_control_new(struct ath_hw *ah,
 		REG_RMW_FIELD(ah, AR_PHY_TIMING5,
 			      AR_PHY_TIMING5_CYCPWR_THR1, value);
 
-		if (IS_CHAN_HT40(ah->curchan))
-			REG_RMW_FIELD(ah, AR_PHY_EXT_CCA,
-				      AR_PHY_EXT_TIMING5_CYCPWR_THR1, value);
+		REG_RMW_FIELD(ah, AR_PHY_EXT_CCA,
+				  AR_PHY_EXT_TIMING5_CYCPWR_THR1, value - 1);
 
 		if (level != aniState->spurImmunityLevel) {
 			ath_dbg(common, ANI,
-- 
2.0.4

