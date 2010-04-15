Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60984 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293Ab0DOVjn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:43 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 28/97] ath9k_hw: Set the channel on AR9003
Date: Thu, 15 Apr 2010 17:38:33 -0400
Message-Id: <1271367582-992-29-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   47 ++++++++++++++++++++++++++-
 1 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 084b0f9..f1632ab 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -44,7 +44,52 @@
  */
 static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 {
-	/* TODO */
+	u16 bMode, fracMode = 0, aModeRefSel = 0;
+	u32 freq, channelSel = 0, reg32 = 0;
+	struct chan_centers centers;
+	int loadSynthChannel;
+
+	ath9k_hw_get_channel_centers(ah, chan, &centers);
+	freq = centers.synth_center;
+
+	if (freq < 4800) {     /* 2 GHz, fractional mode */
+		channelSel = CHANSEL_2G(freq);
+		/* Set to 2G mode */
+		bMode = 1;
+	} else {
+		channelSel = CHANSEL_5G(freq);
+		/* Doubler is ON, so, divide channelSel by 2. */
+		channelSel >>= 1;
+		/* Set to 5G mode */
+		bMode = 0;
+	}
+
+	/* Enable fractional mode for all channels */
+	fracMode = 1;
+	aModeRefSel = 0;
+	loadSynthChannel = 0;
+
+	reg32 = (bMode << 29);
+	REG_WRITE(ah, AR_PHY_SYNTH_CONTROL, reg32);
+
+	/* Enable Long shift Select for Synthesizer */
+	REG_RMW_FIELD(ah, AR_PHY_65NM_CH0_SYNTH4,
+		      AR_PHY_SYNTH4_LONG_SHIFT_SELECT, 1);
+
+	/* Program Synth. setting */
+	reg32 = (channelSel << 2) | (fracMode << 30) |
+		(aModeRefSel << 28) | (loadSynthChannel << 31);
+	REG_WRITE(ah, AR_PHY_65NM_CH0_SYNTH7, reg32);
+
+	/* Toggle Load Synth channel bit */
+	loadSynthChannel = 1;
+	reg32 = (channelSel << 2) | (fracMode << 30) |
+		(aModeRefSel << 28) | (loadSynthChannel << 31);
+	REG_WRITE(ah, AR_PHY_65NM_CH0_SYNTH7, reg32);
+
+	ah->curchan = chan;
+	ah->curchan_rad_index = -1;
+
 	return 0;
 }
 
-- 
1.6.3.3

