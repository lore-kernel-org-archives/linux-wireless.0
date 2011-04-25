Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:61863 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758232Ab1DYK0f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 06:26:35 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 25 Apr 2011 03:26:08 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 3/5] ath9k: Fix warnings due to -Wunused-but-set-variable
Date: Mon, 25 Apr 2011 15:56:18 +0530
Message-ID: <1303727180-22212-3-git-send-email-rmanoharan@atheros.com> (sfid-20110425_122640_813585_52E41FFD)
In-Reply-To: <1303727180-22212-1-git-send-email-rmanoharan@atheros.com>
References: <1303727180-22212-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These warnings are exposed by gcc 4.6.
drivers/net/wireless/ath/ath9k/recv.c: In function 'ath_ant_comb_scan':
drivers/net/wireless/ath/ath9k/recv.c:1342:21: warning: variable
'curr_bias' set but not used [-Wunused-but-set-variable]
drivers/net/wireless/ath/ath9k/rc.c: In function 'ath_rc_update_ht':
drivers/net/wireless/ath/ath9k/rc.c:1020:7: warning: variable
'state_change' set but not used [-Wunused-but-set-variable]
drivers/net/wireless/ath/ath9k/ani.c: In function 'ath9k_hw_ani_init':
drivers/net/wireless/ath/ath9k/ani.c:903:37: warning: variable
'entry_cck' set but not used [-Wunused-but-set-variable]
drivers/net/wireless/ath/ath9k/ani.c:902:38: warning: variable
'entry_ofdm' set but not used [-Wunused-but-set-variable]

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ani.c  |    6 ------
 drivers/net/wireless/ath/ath9k/rc.c   |   12 +++++-------
 drivers/net/wireless/ath/ath9k/recv.c |    3 +--
 3 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 2e31c77..5a1f4f5 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -899,12 +899,6 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 	 * check here default level should not modify INI setting.
 	 */
 	if (use_new_ani(ah)) {
-		const struct ani_ofdm_level_entry *entry_ofdm;
-		const struct ani_cck_level_entry *entry_cck;
-
-		entry_ofdm = &ofdm_level_table[ATH9K_ANI_OFDM_DEF_LEVEL];
-		entry_cck = &cck_level_table[ATH9K_ANI_CCK_DEF_LEVEL];
-
 		ah->aniperiod = ATH9K_ANI_PERIOD_NEW;
 		ah->config.ani_poll_interval = ATH9K_ANI_POLLINTERVAL_NEW;
 	} else {
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 1809409..8a45906 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -854,14 +854,13 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	ath_rc_rate_set_rtscts(sc, rate_table, tx_info);
 }
 
-static bool ath_rc_update_per(struct ath_softc *sc,
+static void ath_rc_update_per(struct ath_softc *sc,
 			      const struct ath_rate_table *rate_table,
 			      struct ath_rate_priv *ath_rc_priv,
 				  struct ieee80211_tx_info *tx_info,
 			      int tx_rate, int xretries, int retries,
 			      u32 now_msec)
 {
-	bool state_change = false;
 	int count, n_bad_frames;
 	u8 last_per;
 	static const u32 nretry_to_per_lookup[10] = {
@@ -993,7 +992,7 @@ static bool ath_rc_update_per(struct ath_softc *sc,
 		}
 	}
 
-	return state_change;
+	return;
 }
 
 static void ath_debug_stat_retries(struct ath_rate_priv *rc, int rix,
@@ -1017,7 +1016,6 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	u32 now_msec = jiffies_to_msecs(jiffies);
 	int rate;
 	u8 last_per;
-	bool state_change = false;
 	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
 	int size = ath_rc_priv->rate_table_size;
 
@@ -1027,9 +1025,9 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	last_per = ath_rc_priv->per[tx_rate];
 
 	/* Update PER first */
-	state_change = ath_rc_update_per(sc, rate_table, ath_rc_priv,
-					 tx_info, tx_rate, xretries,
-					 retries, now_msec);
+	ath_rc_update_per(sc, rate_table, ath_rc_priv,
+			  tx_info, tx_rate, xretries,
+			  retries, now_msec);
 
 	/*
 	 * If this rate looks bad (high PER) then stop using it for
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index f69dcdf..abb9cd6 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1339,7 +1339,7 @@ static void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 	struct ath_hw_antcomb_conf div_ant_conf;
 	struct ath_ant_comb *antcomb = &sc->ant_comb;
 	int alt_ratio = 0, alt_rssi_avg = 0, main_rssi_avg = 0, curr_alt_set;
-	int curr_main_set, curr_bias;
+	int curr_main_set;
 	int main_rssi = rs->rs_rssi_ctl0;
 	int alt_rssi = rs->rs_rssi_ctl1;
 	int rx_ant_conf,  main_ant_conf;
@@ -1393,7 +1393,6 @@ static void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 	ath9k_hw_antdiv_comb_conf_get(sc->sc_ah, &div_ant_conf);
 	curr_alt_set = div_ant_conf.alt_lna_conf;
 	curr_main_set = div_ant_conf.main_lna_conf;
-	curr_bias = div_ant_conf.fast_div_bias;
 
 	antcomb->count++;
 
-- 
1.7.4.4

