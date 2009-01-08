Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:43621 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081AbZAHLe1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 06:34:27 -0500
Message-Id: <20090108113417.844266189@atheros.com> (sfid-20090108_123902_769545_0D2D9F03)
References: <20090108113158.681894124@atheros.com>
Date: Thu, 08 Jan 2009 13:32:13 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCHv2 15/16] ath9k: Setup MFP options for CCMP
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure hardware CCMP for management frame protection and use
software crypto when needed.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


---
 drivers/net/wireless/ath9k/ath9k.h |    2 ++
 drivers/net/wireless/ath9k/hw.c    |   17 +++++++++++++++++
 drivers/net/wireless/ath9k/main.c  |    5 +++++
 drivers/net/wireless/ath9k/recv.c  |    6 ++++++
 drivers/net/wireless/ath9k/reg.h   |    6 ++++++
 5 files changed, 36 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/ath9k/hw.c	2009-01-08 13:03:42.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/hw.c	2009-01-08 13:08:54.000000000 +0200
@@ -2266,6 +2266,23 @@ int ath9k_hw_reset(struct ath_hal *ah, s
 	if (r)
 		return r;
 
+	/* Setup MFP options for CCMP */
+	if (AR_SREV_9280_20_OR_LATER(ah)) {
+		/* Mask Retry(b11), PwrMgt(b12), MoreData(b13) to 0 in mgmt
+		 * frames when constructing CCMP AAD. */
+		REG_RMW_FIELD(ah, AR_AES_MUTE_MASK1, AR_AES_MUTE_MASK1_FC_MGMT,
+			      0xc7ff);
+		ah->sw_mgmt_crypto = false;
+	} else if (AR_SREV_9160_10_OR_LATER(ah)) {
+		/* Disable hardware crypto for management frames */
+		REG_CLR_BIT(ah, AR_PCU_MISC_MODE2,
+			    AR_PCU_MISC_MODE2_MGMT_CRYPTO_ENABLE);
+		REG_SET_BIT(ah, AR_PCU_MISC_MODE2,
+			    AR_PCU_MISC_MODE2_NO_CRYPTO_FOR_NON_DATA_PKT);
+		ah->sw_mgmt_crypto = true;
+	} else
+		ah->sw_mgmt_crypto = true;
+
 	if (IS_CHAN_OFDM(chan) || IS_CHAN_HT(chan))
 		ath9k_hw_set_delta_slope(ah, chan);
 
--- wireless-testing.orig/drivers/net/wireless/ath9k/reg.h	2009-01-08 13:03:42.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/reg.h	2009-01-08 13:08:54.000000000 +0200
@@ -1243,6 +1243,8 @@ enum {
 
 #define AR_AES_MUTE_MASK1       0x8060
 #define AR_AES_MUTE_MASK1_SEQ   0x0000FFFF
+#define AR_AES_MUTE_MASK1_FC_MGMT 0xFFFF0000
+#define AR_AES_MUTE_MASK1_FC_MGMT_S 16
 
 #define AR_GATED_CLKS       0x8064
 #define AR_GATED_CLKS_TX    0x00000002
@@ -1467,6 +1469,10 @@ enum {
 #define AR_PCU_TXBUF_CTRL_USABLE_SIZE   0x700
 #define AR_9285_PCU_TXBUF_CTRL_USABLE_SIZE   0x380
 
+#define AR_PCU_MISC_MODE2               0x8344
+#define AR_PCU_MISC_MODE2_MGMT_CRYPTO_ENABLE           0x00000002
+#define AR_PCU_MISC_MODE2_NO_CRYPTO_FOR_NON_DATA_PKT   0x00000004
+
 #define AR_KEYTABLE_0           0x8800
 #define AR_KEYTABLE(_n)         (AR_KEYTABLE_0 + ((_n)*32))
 #define AR_KEY_CACHE_SIZE       128
--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-01-08 13:08:51.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-01-08 13:08:54.000000000 +0200
@@ -1554,6 +1554,9 @@ static int ath_attach(u16 devid, struct 
 		IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_AMPDU_AGGREGATION;
 
+	if (AR_SREV_9160_10_OR_LATER(sc->sc_ah))
+		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
+
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_STATION) |
@@ -2348,6 +2351,8 @@ static int ath9k_set_key(struct ieee8021
 			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 			if (key->alg == ALG_TKIP)
 				key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+			if (sc->sc_ah->sw_mgmt_crypto && key->alg == ALG_CCMP)
+				key->flags |= IEEE80211_KEY_FLAG_SW_MGMT;
 			ret = 0;
 		}
 		break;
--- wireless-testing.orig/drivers/net/wireless/ath9k/recv.c	2009-01-08 13:03:42.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/recv.c	2009-01-08 13:08:54.000000000 +0200
@@ -593,6 +593,12 @@ int ath_rx_tasklet(struct ath_softc *sc,
 			if (test_bit(keyix, sc->sc_keymap))
 				rx_status.flag |= RX_FLAG_DECRYPTED;
 		}
+		if (ah->sw_mgmt_crypto &&
+		    (rx_status.flag & RX_FLAG_DECRYPTED) &&
+		    ieee80211_is_mgmt(hdr->frame_control)) {
+			/* Use software decrypt for management frames. */
+			rx_status.flag &= ~RX_FLAG_DECRYPTED;
+		}
 
 		/* Send the frame to mac80211 */
 		__ieee80211_rx(sc->hw, skb, &rx_status);
--- wireless-testing.orig/drivers/net/wireless/ath9k/ath9k.h	2009-01-08 13:03:42.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/ath9k.h	2009-01-08 13:08:54.000000000 +0200
@@ -805,6 +805,8 @@ struct ath_hal {
 #ifndef ATH_NF_PER_CHAN
 	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
 #endif
+
+	bool sw_mgmt_crypto;
 };
 
 struct chan_centers {

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
