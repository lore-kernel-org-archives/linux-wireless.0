Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:15371 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbZFCBNj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 21:13:39 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2009 18:13:42 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC] ath9k: add locking for rc private data
Date: Tue, 2 Jun 2009 18:13:44 -0700
Message-ID: <1243991624-12406-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |   62 +++++++++++++++++++++++++++++------
 drivers/net/wireless/ath/ath9k/rc.h |    2 +
 2 files changed, 54 insertions(+), 10 deletions(-)

Here's an attempt to lock the ath9k rc private data but I
get a lockdep complaint on this and not sure how to resolve it yet.

[   47.834736] =======================================================
[   47.834848] [ INFO: possible circular locking dependency detected ]
[   47.834912] 2.6.30-rc7-wl #31
[   47.834962] -------------------------------------------------------
[   47.835018] swapper/0 is trying to acquire lock:
[   47.835077]  (_xmit_IEEE80211#2){+.-...}, at: [<ffffffff804dcb51>] __qdisc_run+0x241/0x2b0
[   47.835320] 
[   47.835321] but task is already holding lock:
[   47.835419]  (&rate_priv->ath_rc_lock){+.-...}, at: [<ffffffffa0330eda>] ath_tx_status+0x3a/0x3e0 [ath9k]
[   47.835630] 
[   47.835631] which lock already depends on the new lock.
[   47.835632] 
[   47.835775] 
[   47.835780] the existing dependency chain (in reverse order) is:
[   47.835884] 
[   47.835885] -> #1 (&rate_priv->ath_rc_lock){+.-...}:
[   47.836114]        [<ffffffffffffffff>] 0xffffffffffffffff
[   47.836224] 
[   47.836225] -> #0 (_xmit_IEEE80211#2){+.-...}:
[   47.836538]        [<ffffffffffffffff>] 0xffffffffffffffff
[   47.836659] 
[   47.836660] other info that might help us debug this:
[   47.836662] 
[   47.836861] 1 lock held by swapper/0:
[   47.836933]  #0:  (&rate_priv->ath_rc_lock){+.-...}, at: [<ffffffffa0330eda>] ath_tx_status+0x3a/0x3e0 [ath9k]
[   47.837215] 
[   47.837216] stack backtrace:
[   47.837347] Pid: 0, comm: swapper Not tainted 2.6.30-rc7-wl #31
[   47.837423] Call Trace:
[   47.837493]  <IRQ>  [<ffffffff8026a9fe>] print_circular_bug_tail+0xae/0x100
[   47.837625]  [<ffffffff8026cdf0>] __lock_acquire+0xff0/0x1370
[   47.837702]  [<ffffffff802693c8>] ? add_lock_to_list+0x68/0xf0
[   47.837774]  [<ffffffff8026d279>] lock_acquire+0x109/0x150
[   47.837849]  [<ffffffff804dcb51>] ? __qdisc_run+0x241/0x2b0
[   47.837931]  [<ffffffff8055fe0c>] _spin_lock+0x3c/0x80
[   47.838000]  [<ffffffff804dcb51>] ? __qdisc_run+0x241/0x2b0
[   47.838074]  [<ffffffff805604c0>] ? _spin_unlock+0x30/0x60
[   47.838149]  [<ffffffff804dcb51>] __qdisc_run+0x241/0x2b0
[   47.838231]  [<ffffffff804cb6e8>] dev_queue_xmit+0x2c8/0x4a0
[   47.838329]  [<ffffffffa02e7fa7>] ieee80211_tx_skb+0x67/0x70 [mac80211]
[   47.838423]  [<ffffffffa02d4128>] ieee80211_start_tx_ba_session+0x498/0x5a0 [mac80211]
[   47.838521]  [<ffffffffa033125d>] ath_tx_status+0x3bd/0x3e0 [ath9k]
[   47.838617]  [<ffffffffa02ce329>] ieee80211_tx_status+0x479/0x4b0 [mac80211]
[   47.838703]  [<ffffffffa032b9dc>] ath_tx_complete_buf+0x20c/0x230 [ath9k]
[   47.838795]  [<ffffffffa032e3a8>] ath_tx_tasklet+0x198/0x4c0 [ath9k]
[   47.838882]  [<ffffffffa03295f8>] ath9k_tasklet+0xf8/0x1f0 [ath9k]
[   47.838960]  [<ffffffff80244fad>] tasklet_action+0x9d/0x130
[   47.839036]  [<ffffffff80245620>] __do_softirq+0xf0/0x220
[   47.839114]  [<ffffffff8020d17c>] call_softirq+0x1c/0x30
[   47.839190]  [<ffffffff8020e6c5>] do_softirq+0x75/0xb0
[   47.839259]  [<ffffffff8024530d>] irq_exit+0x9d/0xb0
[   47.839339]  [<ffffffff8020df4d>] do_IRQ+0x8d/0xf0
[   47.839414]  [<ffffffff8020c993>] ret_from_intr+0x0/0xf
[   47.839489]  <EOI>  [<ffffffff8021424f>] ? default_idle+0x7f/0x180
[   47.839608]  [<ffffffff8021424d>] ? default_idle+0x7d/0x180
[   47.839690]  [<ffffffff802646ed>] ? clockevents_notify+0x3d/0x90
[   47.839761]  [<ffffffff802143fd>] ? c1e_idle+0xad/0x120
[   47.839837]  [<ffffffff805638c1>] ? atomic_notifier_call_chain+0x11/0x20
[   47.839916]  [<ffffffff8020ab44>] ? cpu_idle+0x64/0xd0
[   47.839993]  [<ffffffff805594e9>] ? start_secondary+0x168/0x1bf


diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index ba06e78..b7fa0f2 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -741,12 +741,26 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 	if (rate > (ath_rc_priv->rate_table_size - 1))
 		rate = ath_rc_priv->rate_table_size - 1;
 
-	ASSERT((rate_table->info[rate].valid &&
-		(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG)) ||
-	       (rate_table->info[rate].valid_single_stream &&
-		!(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG)));
+	/* Rate is a valid and dual stream */
+	if (rate_table->info[rate].valid &&
+	    (ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG))
+		return rate;
 
-	return rate;
+	/* Rate is valid and single stream */
+	if (rate_table->info[rate].valid_single_stream &&
+	    !(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG))
+		return rate;
+
+	WARN_ON(!rate_table->info[rate].valid &&
+		!rate_table->info[rate].valid_single_stream);
+
+	/*
+	 * This is not expected, getting here would indicate no
+	 * valid dual stream or single stream rate.
+	 */
+	WARN_ON(1);
+
+	return minindex;
 }
 
 static void ath_rc_rate_set_series(const struct ath_rate_table *rate_table,
@@ -1389,6 +1403,7 @@ struct ath_rate_table *ath_choose_rate_table(struct ath_softc *sc,
 	return sc->hw_rate_table[mode];
 }
 
+/* Must hold rc priv lock */
 static void ath_rc_init(struct ath_softc *sc,
 			struct ath_rate_priv *ath_rc_priv,
 			struct ieee80211_supported_band *sband,
@@ -1506,6 +1521,9 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	int final_ts_idx, tx_status = 0, is_underrun = 0;
 	__le16 fc;
 
+	/* Could be called from the mac80211 tasklet */
+	spin_lock_bh(&ath_rc_priv->ath_rc_lock);
+
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = hdr->frame_control;
 	tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
@@ -1558,6 +1576,7 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	ath_debug_stat_rc(sc, skb);
 exit:
 	kfree(tx_info_priv);
+	spin_unlock_bh(&ath_rc_priv->ath_rc_lock);
 }
 
 static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
@@ -1582,7 +1601,9 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	}
 
 	/* Find tx rate for unicast frames */
+	spin_lock_bh(&ath_rc_priv->ath_rc_lock);
 	ath_rc_ratefind(sc, ath_rc_priv, txrc);
+	spin_unlock_bh(&ath_rc_priv->ath_rc_lock);
 }
 
 static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
@@ -1594,6 +1615,8 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	bool is_cw40, is_sgi40;
 	int i, j = 0;
 
+	spin_lock_bh(&ath_rc_priv->ath_rc_lock);
+
 	for (i = 0; i < sband->n_bitrates; i++) {
 		if (sta->supp_rates[sband->band] & BIT(i)) {
 			ath_rc_priv->neg_rates.rs_rates[j]
@@ -1631,6 +1654,9 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
 
 	ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta, is_cw40, is_sgi40);
 	ath_rc_init(sc, priv_sta, sband, sta, rate_table);
+
+	spin_unlock_bh(&ath_rc_priv->ath_rc_lock);
+
 }
 
 static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
@@ -1641,16 +1667,18 @@ static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
 	struct ath_rate_priv *ath_rc_priv = priv_sta;
 	const struct ath_rate_table *rate_table = NULL;
 	bool oper_cw40 = false, oper_sgi40;
-	bool local_cw40 = (ath_rc_priv->ht_cap & WLAN_RC_40_FLAG) ?
-		true : false;
-	bool local_sgi40 = (ath_rc_priv->ht_cap & WLAN_RC_SGI_FLAG) ?
-		true : false;
+	bool local_cw40, local_sgi40;
+	/* Test */
+	spin_lock_bh(&ath_rc_priv->ath_rc_lock);
+
+	local_cw40 = (ath_rc_priv->ht_cap & WLAN_RC_40_FLAG) ? true : false;
+	local_sgi40 = (ath_rc_priv->ht_cap & WLAN_RC_SGI_FLAG) ? true : false;
 
 	/* FIXME: Handle AP mode later when we support CWM */
 
 	if (changed & IEEE80211_RC_HT_CHANGED) {
 		if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
-			return;
+			goto out;
 
 		if (sc->hw->conf.channel_type == NL80211_CHAN_HT40MINUS ||
 		    sc->hw->conf.channel_type == NL80211_CHAN_HT40PLUS)
@@ -1672,6 +1700,9 @@ static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
 				sc->hw->conf.channel_type);
 		}
 	}
+
+out:
+	spin_unlock_bh(&ath_rc_priv->ath_rc_lock);
 }
 
 static void *ath_rate_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
@@ -1700,6 +1731,8 @@ static void *ath_rate_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp
 	rate_priv->rssi_down_time = jiffies_to_msecs(jiffies);
 	rate_priv->tx_triglevel_max = sc->sc_ah->caps.tx_triglevel_max;
 
+	spin_lock_init(&rate_priv->ath_rc_lock);
+
 	return rate_priv;
 }
 
@@ -1707,6 +1740,15 @@ static void ath_rate_free_sta(void *priv, struct ieee80211_sta *sta,
 			      void *priv_sta)
 {
 	struct ath_rate_priv *rate_priv = priv_sta;
+
+	/*
+	 * Let whoever is working on the sta priv to finish.
+	 * There is a _small_ race here between rate_control_free_sta()
+	 * which called us and the actual free of the sta.
+	 */
+	spin_lock_bh(&rate_priv->ath_rc_lock);
+	spin_unlock_bh(&rate_priv->ath_rc_lock);
+
 	kfree(rate_priv);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index e3abd76..1508184 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -137,6 +137,7 @@ struct ath_rateset {
 
 /**
  * struct ath_rate_priv - Rate Control priv data
+ * @ath_rc_lock: used to protect the private rate sta struct
  * @state: RC state
  * @rssi_last: last ACK rssi
  * @rssi_last_lookup: last ACK rssi used for lookup
@@ -161,6 +162,7 @@ struct ath_rateset {
  * @neg_ht_rates: Negotiated HT rates
  */
 struct ath_rate_priv {
+	spinlock_t ath_rc_lock;
 	int8_t rssi_last;
 	int8_t rssi_last_lookup;
 	int8_t rssi_last_prev;
-- 
1.5.6.4

