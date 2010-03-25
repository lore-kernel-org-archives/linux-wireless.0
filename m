Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:27084 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752623Ab0CYFtc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 01:49:32 -0400
Received: from vs3014.wh2.ocn.ne.jp (125.206.180.187)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0815026171
	for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 14:49:31 +0900 (JST)
Subject: [PATCH 05/10] ath5k: keep beacon RSSI average
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, bob@bobcopeland.com,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Date: Thu, 25 Mar 2010 14:49:25 +0900
Message-ID: <20100325054925.10697.20103.stgit@tt-desk>
In-Reply-To: <20100325054603.10697.48915.stgit@tt-desk>
References: <20100325054603.10697.48915.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Keep an exponentially weighted moving average of the beacon RSSI in our BSS.
It will be used by the ANI implementation.

The averaging algorithm is copied from rt2x00, Thanks :)

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |   35 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath5k/base.c  |   21 +++++++++++++++++++
 2 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 6334294..cefd28d 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -992,6 +992,15 @@ struct ath5k_nfcal_hist
 	s16 nfval[ATH5K_NF_CAL_HIST_MAX];	/* last few noise floors */
 };
 
+/**
+ * struct avg_val - Helper structure for average calculation
+ * @avg: contains the actual average value
+ * @avg_weight: is used internally during calculation to prevent rounding errors
+ */
+struct ath5k_avg_val {
+	int avg;
+	int avg_weight;
+};
 
 /***************************************\
   HARDWARE ABSTRACTION LAYER STRUCTURE
@@ -1096,6 +1105,9 @@ struct ath5k_hw {
 
 	struct ath5k_nfcal_hist ah_nfcal_hist;
 
+	/* average beacon RSSI in our BSS (used by ANI) */
+	struct ath5k_avg_val	ah_beacon_rssi_avg;
+
 	/* noise floor from last periodic calibration */
 	s32			ah_noise_floor;
 
@@ -1305,4 +1317,27 @@ static inline u32 ath5k_hw_bitswap(u32 val, unsigned int bits)
 	return retval;
 }
 
+#define AVG_SAMPLES	8
+#define AVG_FACTOR	1000
+
+/**
+ * ath5k_moving_average -  Exponentially weighted moving average
+ * @avg: average structure
+ * @val: current value
+ *
+ * This implementation make use of a struct ath5k_avg_val to prevent rounding
+ * errors.
+ */
+static inline struct ath5k_avg_val
+ath5k_moving_average(const struct ath5k_avg_val avg, const int val)
+{
+	struct ath5k_avg_val new;
+	new.avg_weight = avg.avg_weight  ?
+		(((avg.avg_weight * ((AVG_SAMPLES) - 1)) +
+			(val * (AVG_FACTOR))) / (AVG_SAMPLES)) :
+		(val * (AVG_FACTOR));
+	new.avg = new.avg_weight / (AVG_FACTOR);
+	return new;
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index f60d84f..ba2fad2 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1803,6 +1803,25 @@ ath5k_check_ibss_tsf(struct ath5k_softc *sc, struct sk_buff *skb,
 	}
 }
 
+static void
+ath5k_update_beacon_rssi(struct ath5k_softc *sc, struct sk_buff *skb, int rssi)
+{
+	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
+	struct ath5k_hw *ah = sc->ah;
+	struct ath_common *common = ath5k_hw_common(ah);
+
+	/* only beacons from our BSSID */
+	if (!ieee80211_is_beacon(mgmt->frame_control) ||
+	    memcmp(mgmt->bssid, common->curbssid, ETH_ALEN) != 0)
+		return;
+
+	ah->ah_beacon_rssi_avg = ath5k_moving_average(ah->ah_beacon_rssi_avg,
+						      rssi);
+
+	/* in IBSS mode we should keep RSSI statistics per neighbour */
+	/* le16_to_cpu(mgmt->u.beacon.capab_info) & WLAN_CAPABILITY_IBSS */
+}
+
 /*
  * Compute padding position. skb must contains an IEEE 802.11 frame
  */
@@ -2022,6 +2041,8 @@ accept:
 
 		ath5k_debug_dump_skb(sc, skb, "RX  ", 0);
 
+		ath5k_update_beacon_rssi(sc, skb, rs.rs_rssi);
+
 		/* check beacons in IBSS mode */
 		if (sc->opmode == NL80211_IFTYPE_ADHOC)
 			ath5k_check_ibss_tsf(sc, skb, rxs);

