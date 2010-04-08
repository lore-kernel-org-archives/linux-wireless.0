Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46777 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933226Ab0DHT1m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 029/102] ath9k_hw: Implement spur mitigation on AR9003
Date: Thu,  8 Apr 2010 15:26:25 -0400
Message-Id: <1270754858-26266-30-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   47 ++++++++++++++++++++++++++-
 1 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 94dcf79..a54a53f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -105,7 +105,52 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
  */
 static void ar9003_hw_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan)
 {
-	/* TODO */
+	u32 spur_freq[4] = { 2420, 2440, 2464, 2480 };
+	int cur_bb_spur, negative = 0, cck_spur_freq;
+	int i;
+
+	/*
+	 * Need to verify range +/- 10 MHz in control channel, otherwise spur
+	 * is out-of-band and can be ignored.
+	 */
+
+	for (i = 0; i < 4; i++) {
+		negative = 0;
+		cur_bb_spur = spur_freq[i] - chan->channel;
+
+		if(cur_bb_spur < 0) {
+			negative = 1;
+			cur_bb_spur = -cur_bb_spur;
+		}
+		if (cur_bb_spur < 10) {
+			cck_spur_freq = (int)((cur_bb_spur << 19) / 11);
+
+			if (negative == 1)
+				cck_spur_freq = -cck_spur_freq;
+
+			cck_spur_freq = cck_spur_freq & 0xfffff;
+
+			REG_RMW_FIELD(ah, AR_PHY_AGC_CONTROL,
+				      AR_PHY_AGC_CONTROL_YCOK_MAX, 0x7);
+			REG_RMW_FIELD(ah, AR_PHY_CCK_SPUR_MIT,
+				      AR_PHY_CCK_SPUR_MIT_SPUR_RSSI_THR, 0x7f);
+			REG_RMW_FIELD(ah, AR_PHY_CCK_SPUR_MIT,
+				      AR_PHY_CCK_SPUR_MIT_SPUR_FILTER_TYPE, 0x2);
+			REG_RMW_FIELD(ah, AR_PHY_CCK_SPUR_MIT,
+				      AR_PHY_CCK_SPUR_MIT_USE_CCK_SPUR_MIT, 0x1);
+			REG_RMW_FIELD(ah, AR_PHY_CCK_SPUR_MIT,
+				      AR_PHY_CCK_SPUR_MIT_CCK_SPUR_FREQ, cck_spur_freq);
+
+			return;
+		}
+	}
+
+	REG_RMW_FIELD(ah, AR_PHY_AGC_CONTROL,
+		      AR_PHY_AGC_CONTROL_YCOK_MAX, 0x5);
+	REG_RMW_FIELD(ah, AR_PHY_CCK_SPUR_MIT,
+		      AR_PHY_CCK_SPUR_MIT_USE_CCK_SPUR_MIT, 0x0);
+	REG_RMW_FIELD(ah, AR_PHY_CCK_SPUR_MIT,
+		      AR_PHY_CCK_SPUR_MIT_CCK_SPUR_FREQ, 0x0);
 }
 
 static u32 ar9003_hw_compute_pll_control(struct ath_hw *ah,
-- 
1.6.3.3

