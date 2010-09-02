Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:21542 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab0IBIfA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 04:35:00 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Sep 2010 01:34:55 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] ath9k: Implement an algorithm for Antenna diversity and combining
Date: Thu, 2 Sep 2010 01:34:43 -0700
Message-ID: <1283416483-5674-3-git-send-email-vasanth@atheros.com>
In-Reply-To: <1283416483-5674-1-git-send-email-vasanth@atheros.com>
References: <1283416483-5674-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This algorithm chooses the best main and alt lna out of
LNA1, LNA2, LNA1+LNA2 and LNA1-LNA2 to improve rx for single
chain chips(AR9285). This would greatly improve rx when there
is only one antenna is connected with AR9285.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |   56 ++++
 drivers/net/wireless/ath/ath9k/init.c  |    3 +
 drivers/net/wireless/ath/ath9k/recv.c  |  545 ++++++++++++++++++++++++++++++++
 3 files changed, 604 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index f0197a6..5fe570b 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -481,6 +481,60 @@ struct ath_led {
 void ath_init_leds(struct ath_softc *sc);
 void ath_deinit_leds(struct ath_softc *sc);
 
+/* Antenna diversity/combining */
+#define ATH_ANT_RX_CURRENT_SHIFT 4
+#define ATH_ANT_RX_MAIN_SHIFT 2
+#define ATH_ANT_RX_MASK 0x3
+
+#define ATH_ANT_DIV_COMB_SHORT_SCAN_INTR 50
+#define ATH_ANT_DIV_COMB_SHORT_SCAN_PKTCOUNT 0x100
+#define ATH_ANT_DIV_COMB_MAX_PKTCOUNT 0x200
+#define ATH_ANT_DIV_COMB_INIT_COUNT 95
+#define ATH_ANT_DIV_COMB_MAX_COUNT 100
+#define ATH_ANT_DIV_COMB_ALT_ANT_RATIO 30
+#define ATH_ANT_DIV_COMB_ALT_ANT_RATIO2 20
+
+#define ATH_ANT_DIV_COMB_LNA1_LNA2_DELTA -3
+#define ATH_ANT_DIV_COMB_LNA1_LNA2_SWITCH_DELTA -1
+#define ATH_ANT_DIV_COMB_LNA1_DELTA_HI -4
+#define ATH_ANT_DIV_COMB_LNA1_DELTA_MID -2
+#define ATH_ANT_DIV_COMB_LNA1_DELTA_LOW 2
+
+enum ath9k_ant_div_comb_lna_conf {
+	ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2,
+	ATH_ANT_DIV_COMB_LNA2,
+	ATH_ANT_DIV_COMB_LNA1,
+	ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2,
+};
+
+struct ath_ant_comb {
+	u16 count;
+	u16 total_pkt_count;
+	bool scan;
+	bool scan_not_start;
+	int main_total_rssi;
+	int alt_total_rssi;
+	int alt_recv_cnt;
+	int main_recv_cnt;
+	int rssi_lna1;
+	int rssi_lna2;
+	int rssi_add;
+	int rssi_sub;
+	int rssi_first;
+	int rssi_second;
+	int rssi_third;
+	bool alt_good;
+	int quick_scan_cnt;
+	int main_conf;
+	enum ath9k_ant_div_comb_lna_conf first_quick_scan_conf;
+	enum ath9k_ant_div_comb_lna_conf second_quick_scan_conf;
+	int first_bias;
+	int second_bias;
+	bool first_ratio;
+	bool second_ratio;
+	unsigned long scan_start_time;
+};
+
 /********************/
 /* Main driver core */
 /********************/
@@ -597,6 +651,8 @@ struct ath_softc {
 	struct ath_btcoex btcoex;
 
 	struct ath_descdma txsdma;
+
+	struct ath_ant_comb ant_comb;
 };
 
 struct ath_wiphy {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 3dbff8d..e7c07b3 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -531,6 +531,9 @@ static void ath9k_init_misc(struct ath_softc *sc)
 		sc->beacon.bslot[i] = NULL;
 		sc->beacon.bslot_aphy[i] = NULL;
 	}
+
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB)
+		sc->ant_comb.count = ATH_ANT_DIV_COMB_INIT_COUNT;
 }
 
 static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 534a91b..b32c8f0 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -19,6 +19,15 @@
 
 #define SKB_CB_ATHBUF(__skb)	(*((struct ath_buf **)__skb->cb))
 
+static inline bool ath_is_alt_ant_ratio_better(int alt_ratio, int maxdelta,
+					       int mindelta, int main_rssi_avg,
+					       int alt_rssi_avg, int pkt_count)
+{
+	return (((alt_ratio >= ATH_ANT_DIV_COMB_ALT_ANT_RATIO2) &&
+		(alt_rssi_avg > main_rssi_avg + maxdelta)) ||
+		(alt_rssi_avg > main_rssi_avg + mindelta)) && (pkt_count > 50);
+}
+
 static inline bool ath9k_check_auto_sleep(struct ath_softc *sc)
 {
 	return sc->ps_enabled &&
@@ -1076,6 +1085,539 @@ static void ath9k_rx_skb_postprocess(struct ath_common *common,
 		rxs->flag &= ~RX_FLAG_DECRYPTED;
 }
 
+static void ath_lnaconf_alt_good_scan(struct ath_ant_comb *antcomb,
+				      struct ath_hw_antcomb_conf ant_conf,
+				      int main_rssi_avg)
+{
+	antcomb->quick_scan_cnt = 0;
+
+	if (ant_conf.main_lna_conf == ATH_ANT_DIV_COMB_LNA2)
+		antcomb->rssi_lna2 = main_rssi_avg;
+	else if (ant_conf.main_lna_conf == ATH_ANT_DIV_COMB_LNA1)
+		antcomb->rssi_lna1 = main_rssi_avg;
+
+	switch ((ant_conf.main_lna_conf << 4) | ant_conf.alt_lna_conf) {
+	case (0x10): /* LNA2 A-B */
+		antcomb->main_conf = ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2;
+		antcomb->first_quick_scan_conf =
+			ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2;
+		antcomb->second_quick_scan_conf = ATH_ANT_DIV_COMB_LNA1;
+		break;
+	case (0x20): /* LNA1 A-B */
+		antcomb->main_conf = ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2;
+		antcomb->first_quick_scan_conf =
+			ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2;
+		antcomb->second_quick_scan_conf = ATH_ANT_DIV_COMB_LNA2;
+		break;
+	case (0x21): /* LNA1 LNA2 */
+		antcomb->main_conf = ATH_ANT_DIV_COMB_LNA2;
+		antcomb->first_quick_scan_conf =
+			ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2;
+		antcomb->second_quick_scan_conf =
+			ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2;
+		break;
+	case (0x12): /* LNA2 LNA1 */
+		antcomb->main_conf = ATH_ANT_DIV_COMB_LNA1;
+		antcomb->first_quick_scan_conf =
+			ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2;
+		antcomb->second_quick_scan_conf =
+			ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2;
+		break;
+	case (0x13): /* LNA2 A+B */
+		antcomb->main_conf = ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2;
+		antcomb->first_quick_scan_conf =
+			ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2;
+		antcomb->second_quick_scan_conf = ATH_ANT_DIV_COMB_LNA1;
+		break;
+	case (0x23): /* LNA1 A+B */
+		antcomb->main_conf = ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2;
+		antcomb->first_quick_scan_conf =
+			ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2;
+		antcomb->second_quick_scan_conf = ATH_ANT_DIV_COMB_LNA2;
+		break;
+	default:
+		break;
+	}
+}
+
+static void ath_select_ant_div_from_quick_scan(struct ath_ant_comb *antcomb,
+				struct ath_hw_antcomb_conf *div_ant_conf,
+				int main_rssi_avg, int alt_rssi_avg,
+				int alt_ratio)
+{
+	/* alt_good */
+	switch (antcomb->quick_scan_cnt) {
+	case 0:
+		/* set alt to main, and alt to first conf */
+		div_ant_conf->main_lna_conf = antcomb->main_conf;
+		div_ant_conf->alt_lna_conf = antcomb->first_quick_scan_conf;
+		break;
+	case 1:
+		/* set alt to main, and alt to first conf */
+		div_ant_conf->main_lna_conf = antcomb->main_conf;
+		div_ant_conf->alt_lna_conf = antcomb->second_quick_scan_conf;
+		antcomb->rssi_first = main_rssi_avg;
+		antcomb->rssi_second = alt_rssi_avg;
+
+		if (antcomb->main_conf == ATH_ANT_DIV_COMB_LNA1) {
+			/* main is LNA1 */
+			if (ath_is_alt_ant_ratio_better(alt_ratio,
+						ATH_ANT_DIV_COMB_LNA1_DELTA_HI,
+						ATH_ANT_DIV_COMB_LNA1_DELTA_LOW,
+						main_rssi_avg, alt_rssi_avg,
+						antcomb->total_pkt_count))
+				antcomb->first_ratio = true;
+			else
+				antcomb->first_ratio = false;
+		} else if (antcomb->main_conf == ATH_ANT_DIV_COMB_LNA2) {
+			if (ath_is_alt_ant_ratio_better(alt_ratio,
+						ATH_ANT_DIV_COMB_LNA1_DELTA_MID,
+						ATH_ANT_DIV_COMB_LNA1_DELTA_LOW,
+						main_rssi_avg, alt_rssi_avg,
+						antcomb->total_pkt_count))
+				antcomb->first_ratio = true;
+			else
+				antcomb->first_ratio = false;
+		} else {
+			if ((((alt_ratio >= ATH_ANT_DIV_COMB_ALT_ANT_RATIO2) &&
+			    (alt_rssi_avg > main_rssi_avg +
+			    ATH_ANT_DIV_COMB_LNA1_DELTA_HI)) ||
+			    (alt_rssi_avg > main_rssi_avg)) &&
+			    (antcomb->total_pkt_count > 50))
+				antcomb->first_ratio = true;
+			else
+				antcomb->first_ratio = false;
+		}
+		break;
+	case 2:
+		antcomb->alt_good = false;
+		antcomb->scan_not_start = false;
+		antcomb->scan = false;
+		antcomb->rssi_first = main_rssi_avg;
+		antcomb->rssi_third = alt_rssi_avg;
+
+		if (antcomb->second_quick_scan_conf == ATH_ANT_DIV_COMB_LNA1)
+			antcomb->rssi_lna1 = alt_rssi_avg;
+		else if (antcomb->second_quick_scan_conf ==
+			 ATH_ANT_DIV_COMB_LNA2)
+			antcomb->rssi_lna2 = alt_rssi_avg;
+		else if (antcomb->second_quick_scan_conf ==
+			 ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2) {
+			if (antcomb->main_conf == ATH_ANT_DIV_COMB_LNA2)
+				antcomb->rssi_lna2 = main_rssi_avg;
+			else if (antcomb->main_conf == ATH_ANT_DIV_COMB_LNA1)
+				antcomb->rssi_lna1 = main_rssi_avg;
+		}
+
+		if (antcomb->rssi_lna2 > antcomb->rssi_lna1 +
+		    ATH_ANT_DIV_COMB_LNA1_LNA2_SWITCH_DELTA)
+			div_ant_conf->main_lna_conf = ATH_ANT_DIV_COMB_LNA2;
+		else
+			div_ant_conf->main_lna_conf = ATH_ANT_DIV_COMB_LNA1;
+
+		if (antcomb->main_conf == ATH_ANT_DIV_COMB_LNA1) {
+			if (ath_is_alt_ant_ratio_better(alt_ratio,
+						ATH_ANT_DIV_COMB_LNA1_DELTA_HI,
+						ATH_ANT_DIV_COMB_LNA1_DELTA_LOW,
+						main_rssi_avg, alt_rssi_avg,
+						antcomb->total_pkt_count))
+				antcomb->second_ratio = true;
+			else
+				antcomb->second_ratio = false;
+		} else if (antcomb->main_conf == ATH_ANT_DIV_COMB_LNA2) {
+			if (ath_is_alt_ant_ratio_better(alt_ratio,
+						ATH_ANT_DIV_COMB_LNA1_DELTA_MID,
+						ATH_ANT_DIV_COMB_LNA1_DELTA_LOW,
+						main_rssi_avg, alt_rssi_avg,
+						antcomb->total_pkt_count))
+				antcomb->second_ratio = true;
+			else
+				antcomb->second_ratio = false;
+		} else {
+			if ((((alt_ratio >= ATH_ANT_DIV_COMB_ALT_ANT_RATIO2) &&
+			    (alt_rssi_avg > main_rssi_avg +
+			    ATH_ANT_DIV_COMB_LNA1_DELTA_HI)) ||
+			    (alt_rssi_avg > main_rssi_avg)) &&
+			    (antcomb->total_pkt_count > 50))
+				antcomb->second_ratio = true;
+			else
+				antcomb->second_ratio = false;
+		}
+
+		/* set alt to the conf with maximun ratio */
+		if (antcomb->first_ratio && antcomb->second_ratio) {
+			if (antcomb->rssi_second > antcomb->rssi_third) {
+				/* first alt*/
+				if ((antcomb->first_quick_scan_conf ==
+				    ATH_ANT_DIV_COMB_LNA1) ||
+				    (antcomb->first_quick_scan_conf ==
+				    ATH_ANT_DIV_COMB_LNA2))
+					/* Set alt LNA1 or LNA2*/
+					if (div_ant_conf->main_lna_conf ==
+					    ATH_ANT_DIV_COMB_LNA2)
+						div_ant_conf->alt_lna_conf =
+							ATH_ANT_DIV_COMB_LNA1;
+					else
+						div_ant_conf->alt_lna_conf =
+							ATH_ANT_DIV_COMB_LNA2;
+				else
+					/* Set alt to A+B or A-B */
+					div_ant_conf->alt_lna_conf =
+						antcomb->first_quick_scan_conf;
+			} else if ((antcomb->second_quick_scan_conf ==
+				   ATH_ANT_DIV_COMB_LNA1) ||
+				   (antcomb->second_quick_scan_conf ==
+				   ATH_ANT_DIV_COMB_LNA2)) {
+				/* Set alt LNA1 or LNA2 */
+				if (div_ant_conf->main_lna_conf ==
+				    ATH_ANT_DIV_COMB_LNA2)
+					div_ant_conf->alt_lna_conf =
+						ATH_ANT_DIV_COMB_LNA1;
+				else
+					div_ant_conf->alt_lna_conf =
+						ATH_ANT_DIV_COMB_LNA2;
+			} else {
+				/* Set alt to A+B or A-B */
+				div_ant_conf->alt_lna_conf =
+					antcomb->second_quick_scan_conf;
+			}
+		} else if (antcomb->first_ratio) {
+			/* first alt */
+			if ((antcomb->first_quick_scan_conf ==
+			    ATH_ANT_DIV_COMB_LNA1) ||
+			    (antcomb->first_quick_scan_conf ==
+			    ATH_ANT_DIV_COMB_LNA2))
+					/* Set alt LNA1 or LNA2 */
+				if (div_ant_conf->main_lna_conf ==
+				    ATH_ANT_DIV_COMB_LNA2)
+					div_ant_conf->alt_lna_conf =
+							ATH_ANT_DIV_COMB_LNA1;
+				else
+					div_ant_conf->alt_lna_conf =
+							ATH_ANT_DIV_COMB_LNA2;
+			else
+				/* Set alt to A+B or A-B */
+				div_ant_conf->alt_lna_conf =
+						antcomb->first_quick_scan_conf;
+		} else if (antcomb->second_ratio) {
+				/* second alt */
+			if ((antcomb->second_quick_scan_conf ==
+			    ATH_ANT_DIV_COMB_LNA1) ||
+			    (antcomb->second_quick_scan_conf ==
+			    ATH_ANT_DIV_COMB_LNA2))
+				/* Set alt LNA1 or LNA2 */
+				if (div_ant_conf->main_lna_conf ==
+				    ATH_ANT_DIV_COMB_LNA2)
+					div_ant_conf->alt_lna_conf =
+						ATH_ANT_DIV_COMB_LNA1;
+				else
+					div_ant_conf->alt_lna_conf =
+						ATH_ANT_DIV_COMB_LNA2;
+			else
+				/* Set alt to A+B or A-B */
+				div_ant_conf->alt_lna_conf =
+						antcomb->second_quick_scan_conf;
+		} else {
+			/* main is largest */
+			if ((antcomb->main_conf == ATH_ANT_DIV_COMB_LNA1) ||
+			    (antcomb->main_conf == ATH_ANT_DIV_COMB_LNA2))
+				/* Set alt LNA1 or LNA2 */
+				if (div_ant_conf->main_lna_conf ==
+				    ATH_ANT_DIV_COMB_LNA2)
+					div_ant_conf->alt_lna_conf =
+							ATH_ANT_DIV_COMB_LNA1;
+				else
+					div_ant_conf->alt_lna_conf =
+							ATH_ANT_DIV_COMB_LNA2;
+			else
+				/* Set alt to A+B or A-B */
+				div_ant_conf->alt_lna_conf = antcomb->main_conf;
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf)
+{
+	/* Adjust the fast_div_bias based on main and alt lna conf */
+	switch ((ant_conf->main_lna_conf << 4) | ant_conf->alt_lna_conf) {
+	case (0x01): /* A-B LNA2 */
+		ant_conf->fast_div_bias = 0x3b;
+		break;
+	case (0x02): /* A-B LNA1 */
+		ant_conf->fast_div_bias = 0x3d;
+		break;
+	case (0x03): /* A-B A+B */
+		ant_conf->fast_div_bias = 0x1;
+		break;
+	case (0x10): /* LNA2 A-B */
+		ant_conf->fast_div_bias = 0x7;
+		break;
+	case (0x12): /* LNA2 LNA1 */
+		ant_conf->fast_div_bias = 0x2;
+		break;
+	case (0x13): /* LNA2 A+B */
+		ant_conf->fast_div_bias = 0x7;
+		break;
+	case (0x20): /* LNA1 A-B */
+		ant_conf->fast_div_bias = 0x6;
+		break;
+	case (0x21): /* LNA1 LNA2 */
+		ant_conf->fast_div_bias = 0x0;
+		break;
+	case (0x23): /* LNA1 A+B */
+		ant_conf->fast_div_bias = 0x6;
+		break;
+	case (0x30): /* A+B A-B */
+		ant_conf->fast_div_bias = 0x1;
+		break;
+	case (0x31): /* A+B LNA2 */
+		ant_conf->fast_div_bias = 0x3b;
+		break;
+	case (0x32): /* A+B LNA1 */
+		ant_conf->fast_div_bias = 0x3d;
+		break;
+	default:
+		break;
+	}
+}
+
+/* Antenna diversity and combining */
+static void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
+{
+	struct ath_hw_antcomb_conf div_ant_conf;
+	struct ath_ant_comb *antcomb = &sc->ant_comb;
+	int alt_ratio = 0, alt_rssi_avg = 0, main_rssi_avg = 0, curr_alt_set;
+	int curr_main_set, curr_bias;
+	int main_rssi = rs->rs_rssi_ctl0;
+	int alt_rssi = rs->rs_rssi_ctl1;
+	int rx_ant_conf,  main_ant_conf;
+	bool short_scan = false;
+
+	rx_ant_conf = (rs->rs_rssi_ctl2 >> ATH_ANT_RX_CURRENT_SHIFT) &
+		       ATH_ANT_RX_MASK;
+	main_ant_conf = (rs->rs_rssi_ctl2 >> ATH_ANT_RX_MAIN_SHIFT) &
+			 ATH_ANT_RX_MASK;
+
+	/* Record packet only when alt_rssi is positive */
+	if (alt_rssi > 0) {
+		antcomb->total_pkt_count++;
+		antcomb->main_total_rssi += main_rssi;
+		antcomb->alt_total_rssi  += alt_rssi;
+		if (main_ant_conf == rx_ant_conf)
+			antcomb->main_recv_cnt++;
+		else
+			antcomb->alt_recv_cnt++;
+	}
+
+	/* Short scan check */
+	if (antcomb->scan && antcomb->alt_good) {
+		if (time_after(jiffies, antcomb->scan_start_time +
+		    msecs_to_jiffies(ATH_ANT_DIV_COMB_SHORT_SCAN_INTR)))
+			short_scan = true;
+		else
+			if (antcomb->total_pkt_count ==
+			    ATH_ANT_DIV_COMB_SHORT_SCAN_PKTCOUNT) {
+				alt_ratio = ((antcomb->alt_recv_cnt * 100) /
+					    antcomb->total_pkt_count);
+				if (alt_ratio < ATH_ANT_DIV_COMB_ALT_ANT_RATIO)
+					short_scan = true;
+			}
+	}
+
+	if (((antcomb->total_pkt_count < ATH_ANT_DIV_COMB_MAX_PKTCOUNT) ||
+	    rs->rs_moreaggr) && !short_scan)
+		return;
+
+	if (antcomb->total_pkt_count) {
+		alt_ratio = ((antcomb->alt_recv_cnt * 100) /
+			     antcomb->total_pkt_count);
+		main_rssi_avg = (antcomb->main_total_rssi /
+				 antcomb->total_pkt_count);
+		alt_rssi_avg = (antcomb->alt_total_rssi /
+				 antcomb->total_pkt_count);
+	}
+
+
+	ath9k_hw_antdiv_comb_conf_get(sc->sc_ah, &div_ant_conf);
+	curr_alt_set = div_ant_conf.alt_lna_conf;
+	curr_main_set = div_ant_conf.main_lna_conf;
+	curr_bias = div_ant_conf.fast_div_bias;
+
+	antcomb->count++;
+
+	if (antcomb->count == ATH_ANT_DIV_COMB_MAX_COUNT) {
+		if (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO) {
+			ath_lnaconf_alt_good_scan(antcomb, div_ant_conf,
+						  main_rssi_avg);
+			antcomb->alt_good = true;
+		} else {
+			antcomb->alt_good = false;
+		}
+
+		antcomb->count = 0;
+		antcomb->scan = true;
+		antcomb->scan_not_start = true;
+	}
+
+	if (!antcomb->scan) {
+		if (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO) {
+			if (curr_alt_set == ATH_ANT_DIV_COMB_LNA2) {
+				/* Switch main and alt LNA */
+				div_ant_conf.main_lna_conf =
+						ATH_ANT_DIV_COMB_LNA2;
+				div_ant_conf.alt_lna_conf  =
+						ATH_ANT_DIV_COMB_LNA1;
+			} else if (curr_alt_set == ATH_ANT_DIV_COMB_LNA1) {
+				div_ant_conf.main_lna_conf =
+						ATH_ANT_DIV_COMB_LNA1;
+				div_ant_conf.alt_lna_conf  =
+						ATH_ANT_DIV_COMB_LNA2;
+			}
+
+			goto div_comb_done;
+		} else if ((curr_alt_set != ATH_ANT_DIV_COMB_LNA1) &&
+			   (curr_alt_set != ATH_ANT_DIV_COMB_LNA2)) {
+			/* Set alt to another LNA */
+			if (curr_main_set == ATH_ANT_DIV_COMB_LNA2)
+				div_ant_conf.alt_lna_conf =
+						ATH_ANT_DIV_COMB_LNA1;
+			else if (curr_main_set == ATH_ANT_DIV_COMB_LNA1)
+				div_ant_conf.alt_lna_conf =
+						ATH_ANT_DIV_COMB_LNA2;
+
+			goto div_comb_done;
+		}
+
+		if ((alt_rssi_avg < (main_rssi_avg +
+		    ATH_ANT_DIV_COMB_LNA1_LNA2_DELTA)))
+			goto div_comb_done;
+	}
+
+	if (!antcomb->scan_not_start) {
+		switch (curr_alt_set) {
+		case ATH_ANT_DIV_COMB_LNA2:
+			antcomb->rssi_lna2 = alt_rssi_avg;
+			antcomb->rssi_lna1 = main_rssi_avg;
+			antcomb->scan = true;
+			/* set to A+B */
+			div_ant_conf.main_lna_conf =
+				ATH_ANT_DIV_COMB_LNA1;
+			div_ant_conf.alt_lna_conf  =
+				ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2;
+			break;
+		case ATH_ANT_DIV_COMB_LNA1:
+			antcomb->rssi_lna1 = alt_rssi_avg;
+			antcomb->rssi_lna2 = main_rssi_avg;
+			antcomb->scan = true;
+			/* set to A+B */
+			div_ant_conf.main_lna_conf = ATH_ANT_DIV_COMB_LNA2;
+			div_ant_conf.alt_lna_conf  =
+				ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2;
+			break;
+		case ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2:
+			antcomb->rssi_add = alt_rssi_avg;
+			antcomb->scan = true;
+			/* set to A-B */
+			div_ant_conf.alt_lna_conf =
+				ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2;
+			break;
+		case ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2:
+			antcomb->rssi_sub = alt_rssi_avg;
+			antcomb->scan = false;
+			if (antcomb->rssi_lna2 >
+			    (antcomb->rssi_lna1 +
+			    ATH_ANT_DIV_COMB_LNA1_LNA2_SWITCH_DELTA)) {
+				/* use LNA2 as main LNA */
+				if ((antcomb->rssi_add > antcomb->rssi_lna1) &&
+				    (antcomb->rssi_add > antcomb->rssi_sub)) {
+					/* set to A+B */
+					div_ant_conf.main_lna_conf =
+						ATH_ANT_DIV_COMB_LNA2;
+					div_ant_conf.alt_lna_conf  =
+						ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2;
+				} else if (antcomb->rssi_sub >
+					   antcomb->rssi_lna1) {
+					/* set to A-B */
+					div_ant_conf.main_lna_conf =
+						ATH_ANT_DIV_COMB_LNA2;
+					div_ant_conf.alt_lna_conf =
+						ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2;
+				} else {
+					/* set to LNA1 */
+					div_ant_conf.main_lna_conf =
+						ATH_ANT_DIV_COMB_LNA2;
+					div_ant_conf.alt_lna_conf =
+						ATH_ANT_DIV_COMB_LNA1;
+				}
+			} else {
+				/* use LNA1 as main LNA */
+				if ((antcomb->rssi_add > antcomb->rssi_lna2) &&
+				    (antcomb->rssi_add > antcomb->rssi_sub)) {
+					/* set to A+B */
+					div_ant_conf.main_lna_conf =
+						ATH_ANT_DIV_COMB_LNA1;
+					div_ant_conf.alt_lna_conf  =
+						ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2;
+				} else if (antcomb->rssi_sub >
+					   antcomb->rssi_lna1) {
+					/* set to A-B */
+					div_ant_conf.main_lna_conf =
+						ATH_ANT_DIV_COMB_LNA1;
+					div_ant_conf.alt_lna_conf =
+						ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2;
+				} else {
+					/* set to LNA2 */
+					div_ant_conf.main_lna_conf =
+						ATH_ANT_DIV_COMB_LNA1;
+					div_ant_conf.alt_lna_conf =
+						ATH_ANT_DIV_COMB_LNA2;
+				}
+			}
+			break;
+		default:
+			break;
+		}
+	} else {
+		if (!antcomb->alt_good) {
+			antcomb->scan_not_start = false;
+			/* Set alt to another LNA */
+			if (curr_main_set == ATH_ANT_DIV_COMB_LNA2) {
+				div_ant_conf.main_lna_conf =
+						ATH_ANT_DIV_COMB_LNA2;
+				div_ant_conf.alt_lna_conf =
+						ATH_ANT_DIV_COMB_LNA1;
+			} else if (curr_main_set == ATH_ANT_DIV_COMB_LNA1) {
+				div_ant_conf.main_lna_conf =
+						ATH_ANT_DIV_COMB_LNA1;
+				div_ant_conf.alt_lna_conf =
+						ATH_ANT_DIV_COMB_LNA2;
+			}
+			goto div_comb_done;
+		}
+	}
+
+	ath_select_ant_div_from_quick_scan(antcomb, &div_ant_conf,
+					   main_rssi_avg, alt_rssi_avg,
+					   alt_ratio);
+
+	antcomb->quick_scan_cnt++;
+
+div_comb_done:
+	ath_ant_div_conf_fast_divbias(&div_ant_conf);
+
+	ath9k_hw_antdiv_comb_conf_set(sc->sc_ah, &div_ant_conf);
+
+	antcomb->scan_start_time = jiffies;
+	antcomb->total_pkt_count = 0;
+	antcomb->main_total_rssi = 0;
+	antcomb->alt_total_rssi = 0;
+	antcomb->main_recv_cnt = 0;
+	antcomb->alt_recv_cnt = 0;
+}
+
 int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 {
 	struct ath_buf *bf;
@@ -1213,6 +1755,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 					      PS_WAIT_FOR_PSPOLL_DATA))))
 			ath_rx_ps(sc, skb);
 
+		if (ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB)
+			ath_ant_comb_scan(sc, &rs);
+
 		ath_rx_send_to_mac80211(hw, sc, skb, rxs);
 
 requeue:
-- 
1.7.0.4

