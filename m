Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:31010 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab1GWN26 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 09:28:58 -0400
Subject: [PATCH 2 1/3] ath5k: remove unused and write-only structures and
 fields
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Sat, 23 Jul 2011 09:28:56 -0400
Message-ID: <20110723132856.10739.42301.stgit@mj.roinet.com> (sfid-20110723_152902_807976_859B9C58)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct ath5k_avg_val is unused.

In struct ath5k_hw, lladdr, ah_radar and ah_mac_revision are write-only,
rxbufsize is unused, ah_phy is write-only and referenced by unused
macros.

In struct ath5k_vif, lladdr is write-only.

Remove AR5K_TUNE_RADAR_ALERT, which has no effect.

Signed-off-by: Pavel Roskin <proski@gnu.org>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h        |   28 -------------------------
 drivers/net/wireless/ath/ath5k/attach.c       |    5 +---
 drivers/net/wireless/ath/ath5k/base.c         |    1 -
 drivers/net/wireless/ath/ath5k/base.h         |    1 -
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    3 ---
 5 files changed, 1 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 277d5cb..be7b8c0 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -131,13 +131,6 @@
 #define AR5K_REG_DISABLE_BITS(ah, _reg, _flags)			\
 	ath5k_hw_reg_write(ah, ath5k_hw_reg_read(ah, _reg) & ~(_flags), _reg)
 
-/* Access to PHY registers */
-#define AR5K_PHY_READ(ah, _reg)					\
-	ath5k_hw_reg_read(ah, (ah)->ah_phy + ((_reg) << 2))
-
-#define AR5K_PHY_WRITE(ah, _reg, _val)					\
-	ath5k_hw_reg_write(ah, _val, (ah)->ah_phy + ((_reg) << 2))
-
 /* Access QCU registers per queue */
 #define AR5K_REG_READ_Q(ah, _reg, _queue)				\
 	(ath5k_hw_reg_read(ah, _reg) & (1 << _queue))			\
@@ -166,7 +159,6 @@
 #define AR5K_TUNE_DMA_BEACON_RESP		2
 #define AR5K_TUNE_SW_BEACON_RESP		10
 #define AR5K_TUNE_ADDITIONAL_SWBA_BACKOFF	0
-#define AR5K_TUNE_RADAR_ALERT			false
 #define AR5K_TUNE_MIN_TX_FIFO_THRES		1
 #define AR5K_TUNE_MAX_TX_FIFO_THRES	((IEEE80211_MAX_FRAME_LEN / 64) + 1)
 #define AR5K_TUNE_REGISTER_TIMEOUT		20000
@@ -1013,16 +1005,6 @@ struct ath5k_nfcal_hist {
 	s16 nfval[ATH5K_NF_CAL_HIST_MAX];	/* last few noise floors */
 };
 
-/**
- * struct avg_val - Helper structure for average calculation
- * @avg: contains the actual average value
- * @avg_weight: is used internally during calculation to prevent rounding errors
- */
-struct ath5k_avg_val {
-	int avg;
-	int avg_weight;
-};
-
 #define ATH5K_LED_MAX_NAME_LEN 31
 
 /*
@@ -1148,7 +1130,6 @@ struct ath5k_hw {
 	bool			rx_pending;	/* rx tasklet pending */
 	bool			tx_pending;	/* tx tasklet pending */
 
-	u8			lladdr[ETH_ALEN];
 	u8			bssidmask[ETH_ALEN];
 
 	unsigned int		led_pin,	/* GPIO pin for driving LED */
@@ -1156,7 +1137,6 @@ struct ath5k_hw {
 
 	struct work_struct	reset_work;	/* deferred chip reset */
 
-	unsigned int		rxbufsize;	/* rx size based on mtu */
 	struct list_head	rxbuf;		/* receive buffer */
 	spinlock_t		rxbuflock;
 	u32			*rxlink;	/* link ptr in last RX desc */
@@ -1208,10 +1188,8 @@ struct ath5k_hw {
 
 	enum ath5k_version	ah_version;
 	enum ath5k_radio	ah_radio;
-	u32			ah_phy;
 	u32			ah_mac_srev;
 	u16			ah_mac_version;
-	u16			ah_mac_revision;
 	u16			ah_phy_revision;
 	u16			ah_radio_5ghz_revision;
 	u16			ah_radio_2ghz_revision;
@@ -1279,12 +1257,6 @@ struct ath5k_hw {
 		bool		txp_setup;
 	} ah_txpower;
 
-	struct {
-		bool		r_enabled;
-		int		r_last_alert;
-		struct ieee80211_channel r_last_channel;
-	} ah_radar;
-
 	struct ath5k_nfcal_hist ah_nfcal_hist;
 
 	/* average beacon RSSI in our BSS (used by ANI) */
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index f8a6b38..b0df2f6 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -114,7 +114,6 @@ int ath5k_hw_init(struct ath5k_hw *ah)
 	/*
 	 * HW information
 	 */
-	ah->ah_radar.r_enabled = AR5K_TUNE_RADAR_ALERT;
 	ah->ah_bwmode = AR5K_BWMODE_DEFAULT;
 	ah->ah_txpower.txp_tpc = AR5K_TUNE_TPC_TXPOWER;
 	ah->ah_imr = 0;
@@ -137,9 +136,8 @@ int ath5k_hw_init(struct ath5k_hw *ah)
 	else
 		ah->ah_version = AR5K_AR5212;
 
-	/* Get the MAC revision */
+	/* Get the MAC version */
 	ah->ah_mac_version = AR5K_REG_MS(srev, AR5K_SREV_VER);
-	ah->ah_mac_revision = AR5K_REG_MS(srev, AR5K_SREV_REV);
 
 	/* Fill the ath5k_hw struct with the needed functions */
 	ret = ath5k_hw_init_desc_functions(ah);
@@ -156,7 +154,6 @@ int ath5k_hw_init(struct ath5k_hw *ah)
 			0xffffffff;
 	ah->ah_radio_5ghz_revision = ath5k_hw_radio_revision(ah,
 			CHANNEL_5GHZ);
-	ah->ah_phy = AR5K_PHY(0);
 
 	/* Try to identify radio chip based on its srev */
 	switch (ah->ah_radio_5ghz_revision & 0xf0) {
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a74d286..ee06e34 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2861,7 +2861,6 @@ ath5k_init(struct ieee80211_hw *hw)
 	}
 
 	SET_IEEE80211_PERM_ADDR(hw, mac);
-	memcpy(&ah->lladdr, mac, ETH_ALEN);
 	/* All MAC address bits matter for ACKs */
 	ath5k_update_bssid_mask_and_opmode(ah, NULL);
 
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index a81f28d..5501bcb 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -65,7 +65,6 @@ struct ath5k_vif {
 	enum nl80211_iftype	opmode;
 	int			bslot;
 	struct ath5k_buf	*bbuf; /* beacon buffer */
-	u8			lladdr[ETH_ALEN];
 };
 
 struct ath5k_vif_iter_data {
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 2a715ca..53d3af9 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -137,11 +137,8 @@ ath5k_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	/* Any MAC address is fine, all others are included through the
 	 * filter.
 	 */
-	memcpy(&ah->lladdr, vif->addr, ETH_ALEN);
 	ath5k_hw_set_lladdr(ah, vif->addr);
 
-	memcpy(&avf->lladdr, vif->addr, ETH_ALEN);
-
 	ath5k_update_bssid_mask_and_opmode(ah, vif);
 	ret = 0;
 end:
