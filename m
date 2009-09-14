Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52504 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbZINIhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 04:37:25 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 05/11] ath9k: remove ath9k 25 MHz HT40 spacing stuff
Date: Mon, 14 Sep 2009 04:37:22 -0400
Message-Id: <1252917448-10744-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252917448-10744-1-git-send-email-lrodriguez@atheros.com>
References: <1252917448-10744-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was for supporting 25 MHz spacing for HT40, this is not used
as we use 20 MHz spacing instead for HT40 as per 802.11n. The hardware
is capable of it though so we leave the phymode definition and EEPROM
parsing for it. If some experimenter wants to work on this stuff stuff
you can add an extension enabling bool on ath_common and perhaps some
debugfs knob to enable it. Keep in mind you'll also need to update the
phymode with the AR_PHY_FC_DYN2040_EXT_CH which has been left on the
driver.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/hw.c    |    8 ++------
 drivers/net/wireless/ath/ath9k/hw.h    |    1 -
 drivers/net/wireless/ath/ath9k/mac.h   |    5 -----
 drivers/net/wireless/ath/ath9k/phy.h   |    1 +
 5 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 46d19e8..e93ab63 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -592,7 +592,6 @@ struct ath_softc {
 	bool ps_enabled;
 	unsigned long ps_usecount;
 	enum ath9k_int imask;
-	enum ath9k_ht_extprotspacing ht_extprotspacing;
 	enum ath9k_ht_macmode tx_chan_width;
 
 	struct ath_config config;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4a5d398..e430be0 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -213,10 +213,9 @@ void ath9k_hw_get_channel_centers(struct ath_hw *ah,
 
 	centers->ctl_center =
 		centers->synth_center - (extoff * HT40_CHANNEL_CENTER_SHIFT);
+	/* 25 MHz spacing is supported by hw but not on upper layers */
 	centers->ext_center =
-		centers->synth_center + (extoff *
-			 ((ah->extprotspacing == ATH9K_HT_EXTPROTSPACING_20) ?
-			  HT40_CHANNEL_CENTER_SHIFT : 15));
+		centers->synth_center + (extoff * HT40_CHANNEL_CENTER_SHIFT);
 }
 
 /******************/
@@ -1750,8 +1749,6 @@ static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 		    (chan->chanmode == CHANNEL_G_HT40PLUS))
 			phymode |= AR_PHY_FC_DYN2040_PRI_CH;
 
-		if (ah->extprotspacing == ATH9K_HT_EXTPROTSPACING_25)
-			phymode |= AR_PHY_FC_DYN2040_EXT_CH;
 	}
 	REG_WRITE(ah, AR_PHY_TURBO, phymode);
 
@@ -2323,7 +2320,6 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	u32 macStaId1;
 	int i, rx_chainmask, r;
 
-	ah->extprotspacing = sc->ht_extprotspacing;
 	ah->txchainmask = common->tx_chainmask;
 	ah->rxchainmask = common->rx_chainmask;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 0fe814f..3b1cfda 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -563,7 +563,6 @@ struct ath_hw {
 	struct ath_btcoex_hw btcoex_hw;
 
 	u32 intr_txqs;
-	enum ath9k_ht_extprotspacing extprotspacing;
 	u8 txchainmask;
 	u8 rxchainmask;
 
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index f56e77d..767256d 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -619,11 +619,6 @@ enum ath9k_ht_macmode {
 	ATH9K_HT_MACMODE_2040 = 1,
 };
 
-enum ath9k_ht_extprotspacing {
-	ATH9K_HT_EXTPROTSPACING_20 = 0,
-	ATH9K_HT_EXTPROTSPACING_25 = 1,
-};
-
 struct ath_hw;
 struct ath9k_channel;
 struct ath_rate_table;
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index dfda6f4..140fef7 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -45,6 +45,7 @@ bool ath9k_hw_init_rf(struct ath_hw *ah,
 #define AR_PHY_FC_DYN2040_EN        0x00000004
 #define AR_PHY_FC_DYN2040_PRI_ONLY  0x00000008
 #define AR_PHY_FC_DYN2040_PRI_CH    0x00000010
+/* For 25 MHz channel spacing -- not used but supported by hw */
 #define AR_PHY_FC_DYN2040_EXT_CH    0x00000020
 #define AR_PHY_FC_HT_EN             0x00000040
 #define AR_PHY_FC_SHORT_GI_40       0x00000080
-- 
1.6.3.3

