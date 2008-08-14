Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54832 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbYHNIJx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 04:09:53 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 14 Aug 2008 01:09:53 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18595.58780.447946.161047@localhost.localdomain> (sfid-20080814_100956_448628_4D88E35B)
Date: Thu, 14 Aug 2008 13:28:20 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 6/6] ath9k: Add IEEE80211_HW_RX_INCLUDES_FCS to hw flags
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't trim the FCS before passing the frame to mac80211,
move TSF_TO_TU to core.h and delete more unused macros.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h  |   13 -------------
 drivers/net/wireless/ath9k/beacon.c |    7 -------
 drivers/net/wireless/ath9k/core.h   |   11 +++++++----
 drivers/net/wireless/ath9k/main.c   |    8 +++-----
 drivers/net/wireless/ath9k/phy.h    |   12 ++++++------
 drivers/net/wireless/ath9k/recv.c   |    2 +-
 6 files changed, 17 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 682d3bb..18028a3 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -564,8 +564,6 @@ enum ath9k_cipher {
 #define CTL_5GHT40              8
 
 #define AR_EEPROM_MAC(i)        (0x1d+(i))
-#define EEP_SCALE       100
-#define EEP_DELTA       10
 
 #define AR_EEPROM_RFSILENT_GPIO_SEL     0x001c
 #define AR_EEPROM_RFSILENT_GPIO_SEL_S   2
@@ -606,9 +604,6 @@ struct ath9k_country_entry {
 #define REG_CLR_BIT(_a, _r, _f) \
 	REG_WRITE(_a, _r, REG_READ(_a, _r) & ~_f)
 
-#define ATH9K_COMP_BUF_MAX_SIZE   9216
-#define ATH9K_COMP_BUF_ALIGN_SIZE 512
-
 #define ATH9K_TXQ_USE_LOCKOUT_BKOFF_DIS   0x00000001
 
 #define INIT_AIFS       2
@@ -637,7 +632,6 @@ struct ath9k_country_entry {
 				  IEEE80211_WEP_KIDLEN +	\
 				  IEEE80211_WEP_CRCLEN))
 
-#define MAX_REG_ADD_COUNT   129
 #define MAX_RATE_POWER 63
 
 enum ath9k_power_mode {
@@ -707,13 +701,6 @@ enum phytype {
 };
 #define PHY_CCK PHY_DS
 
-enum start_adhoc_option {
-	START_ADHOC_NO_11A,
-	START_ADHOC_PER_11D,
-	START_ADHOC_IN_11A,
-	START_ADHOC_IN_11B,
-};
-
 enum ath9k_tp_scale {
 	ATH9K_TP_SCALE_MAX = 0,
 	ATH9K_TP_SCALE_50,
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 89e5c65..ee11856 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -551,9 +551,6 @@ void ath_beacon_free(struct ath_softc *sc)
 
 void ath9k_beacon_tasklet(unsigned long data)
 {
-#define TSF_TO_TU(_h,_l) \
-	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
-
 	struct ath_softc *sc = (struct ath_softc *)data;
 	struct ath_hal *ah = sc->sc_ah;
 	struct ath_buf *bf = NULL;
@@ -715,7 +712,6 @@ void ath9k_beacon_tasklet(unsigned long data)
 
 		sc->ast_be_xmit += bc;     /* XXX per-vap? */
 	}
-#undef TSF_TO_TU
 }
 
 /*
@@ -751,8 +747,6 @@ void ath_bstuck_process(struct ath_softc *sc)
 
 void ath_beacon_config(struct ath_softc *sc, int if_id)
 {
-#define TSF_TO_TU(_h,_l)					\
-	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
 	struct ath_hal *ah = sc->sc_ah;
 	u32 nexttbtt, intval;
 	struct ath_beacon_config conf;
@@ -975,7 +969,6 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		    (ah->ah_caps.hw_caps & ATH9K_HW_CAP_VEOL))
 			ath_beacon_start_adhoc(sc, 0);
 	}
-#undef TSF_TO_TU
 }
 
 /* Function to collect beacon rssi data and resync beacon if necessary */
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 406225b..ca7e613 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -79,6 +79,9 @@ struct ath_node;
 		}				\
 	} while (0)
 
+#define TSF_TO_TU(_h,_l) \
+	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
+
 /* XXX: remove */
 #define memzero(_buf, _len) memset(_buf, 0, _len)
 
@@ -382,10 +385,10 @@ int ath_rx_input(struct ath_softc *sc,
 		 struct sk_buff *skb,
 		 struct ath_recv_status *rx_status,
 		 enum ATH_RX_TYPE *status);
-int ath__rx_indicate(struct ath_softc *sc,
-		    struct sk_buff *skb,
-		    struct ath_recv_status *status,
-		    u16 keyix);
+int _ath_rx_indicate(struct ath_softc *sc,
+		     struct sk_buff *skb,
+		     struct ath_recv_status *status,
+		     u16 keyix);
 int ath_rx_subframe(struct ath_node *an, struct sk_buff *skb,
 		    struct ath_recv_status *status);
 
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 2b3b11b..55f4868 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1099,7 +1099,7 @@ void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 		ath_node_put(sc, an, ATH9K_BH_STATUS_CHANGE);
 }
 
-int ath__rx_indicate(struct ath_softc *sc,
+int _ath_rx_indicate(struct ath_softc *sc,
 		     struct sk_buff *skb,
 		     struct ath_recv_status *status,
 		     u16 keyix)
@@ -1119,9 +1119,6 @@ int ath__rx_indicate(struct ath_softc *sc,
 		skb_pull(skb, padsize);
 	}
 
-	/* remove FCS before passing up to protocol stack */
-	skb_trim(skb, (skb->len - FCS_LEN));
-
 	/* Prepare rx status */
 	ath9k_rx_prepare(sc, skb, status, &rx_status);
 
@@ -1364,7 +1361,8 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto bad2;
 	}
 
-	hw->flags = IEEE80211_HW_SIGNAL_DBM |
+	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
+		IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_NOISE_DBM;
 
 	SET_IEEE80211_DEV(hw, &pdev->dev);
diff --git a/drivers/net/wireless/ath9k/phy.h b/drivers/net/wireless/ath9k/phy.h
index 0cd399a..1470234 100644
--- a/drivers/net/wireless/ath9k/phy.h
+++ b/drivers/net/wireless/ath9k/phy.h
@@ -18,19 +18,19 @@
 #define PHY_H
 
 bool ath9k_hw_ar9280_set_channel(struct ath_hal *ah,
-					  struct ath9k_channel
-					  *chan);
+				 struct ath9k_channel
+				 *chan);
 bool ath9k_hw_set_channel(struct ath_hal *ah,
-				   struct ath9k_channel *chan);
+			  struct ath9k_channel *chan);
 void ath9k_hw_write_regs(struct ath_hal *ah, u32 modesIndex,
 			 u32 freqIndex, int regWrites);
 bool ath9k_hw_set_rf_regs(struct ath_hal *ah,
-				   struct ath9k_channel *chan,
-				   u16 modesIndex);
+			  struct ath9k_channel *chan,
+			  u16 modesIndex);
 void ath9k_hw_decrease_chain_power(struct ath_hal *ah,
 				   struct ath9k_channel *chan);
 bool ath9k_hw_init_rf(struct ath_hal *ah,
-			       int *status);
+		      int *status);
 
 #define AR_PHY_BASE     0x9800
 #define AR_PHY(_n)      (AR_PHY_BASE + ((_n)<<2))
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 91f6354..6e13c63 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -448,7 +448,7 @@ static int ath_rx_indicate(struct ath_softc *sc,
 	int type;
 
 	/* indicate frame to the stack, which will free the old skb. */
-	type = ath__rx_indicate(sc, skb, status, keyix);
+	type = _ath_rx_indicate(sc, skb, status, keyix);
 
 	/* allocate a new skb and queue it to for H/W processing */
 	nskb = ath_rxbuf_alloc(sc, sc->sc_rxbufsize);
-- 
1.5.6.5

