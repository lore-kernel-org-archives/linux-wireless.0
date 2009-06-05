Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35512 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbZFEFlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 01:41:49 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 01/15] ath9k: fix oops by downgrading assert in rc.c
Date: Fri,  5 Jun 2009 01:41:28 -0400
Message-Id: <1244180502-4323-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com>
References: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unfortunately locking the driver rate control private area
doesn't resolve this issue and in fact causes some issues.
The root cause is yet undetermined. For now instead of crashing
lets just downgrades the ASSERT() and only show a trace when
we are debugging with ATH_DBG_CONFIG enabled. That attempt
and its results can be seen here:

http://marc.info/?l=linux-wireless&m=124399166108295&w=1

The ASSERT was happening because the rate control algorithm
figures it should find at least one valid dual stream or
single stream rate. *Something* is causing us to not find
such rate. This happens after association and only when HT
is enabled AFAICT. What we are doing by downgrading the assert
is informing the driver to use the lowest rate index. When
this happens lets disable multi rate retry and only try on
the lowest supported rate.

Traces of the ASSERT are available on this thread:

http://marc.info/?l=linux-wireless&m=124277331319024

At least one bug report (as side issue, mind you):

https://bugzilla.redhat.com/show_bug.cgi?id=503285

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/debug.h |    1 +
 drivers/net/wireless/ath/ath9k/rc.c    |   40 +++++++++++++++++++++++++++----
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index edda15b..9d72bc8 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -30,6 +30,7 @@ enum ATH_DEBUG {
 	ATH_DBG_CONFIG		= 0x00000200,
 	ATH_DBG_FATAL		= 0x00000400,
 	ATH_DBG_PS		= 0x00000800,
+	ATH_DBG_RATE		= 0x00001000,
 	ATH_DBG_ANY		= 0xffffffff
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index ba06e78..abad86b 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -741,10 +741,24 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 	if (rate > (ath_rc_priv->rate_table_size - 1))
 		rate = ath_rc_priv->rate_table_size - 1;
 
-	ASSERT((rate_table->info[rate].valid &&
-		(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG)) ||
-	       (rate_table->info[rate].valid_single_stream &&
-		!(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG)));
+	if (rate_table->info[rate].valid &&
+	    (ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG))
+		return rate;
+
+	if (rate_table->info[rate].valid_single_stream &&
+	    !(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG));
+		return rate;
+
+	/*
+	 * This should not happen, but we know it does for now... This
+	 * needs a proper fix but we're still not sure how this is caused.
+	 * Its not *critical* though so lets just warn when debug is enabled
+	 * for configuration changes.
+	 */
+	if (sc->debug.debug_mask & ATH_DBG_RATE)
+		WARN_ON(1);
+
+	rate = ath_rc_priv->valid_rate_index[0];
 
 	return rate;
 }
@@ -837,13 +851,15 @@ static u8 ath_rc_rate_getidx(struct ath_softc *sc,
 
 static void ath_rc_ratefind(struct ath_softc *sc,
 			    struct ath_rate_priv *ath_rc_priv,
-			    struct ieee80211_tx_rate_control *txrc)
+			    struct ieee80211_tx_rate_control *txrc,
+			    struct ieee80211_sta *sta)
 {
 	const struct ath_rate_table *rate_table;
 	struct sk_buff *skb = txrc->skb;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_rate *rates = tx_info->control.rates;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_supported_band *sband = txrc->sband;
 	__le16 fc = hdr->frame_control;
 	u8 try_per_rate = 0, i = 0, rix, nrix;
 	int is_probe = 0;
@@ -935,6 +951,18 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 
 	/* Setup RTS/CTS */
 	ath_rc_rate_set_rtscts(sc, rate_table, tx_info);
+
+	/*
+	 * Fine tuning for when no decent rate was found, the
+	 * lowest should *not* be used under normal circumstances.
+	 */
+	if (rix == ath_rc_priv->valid_rate_index[0]) {
+		DPRINTF(sc, ATH_DBG_RATE, "lowest rate being used, "
+			"disabling MRR\n");
+		rates[0].idx = rate_lowest_index(sband, sta);
+		/* Disable MRR when ath_rc_ratefind_ht() found rate 0 */
+		rates[1].idx = -1;
+	}
 }
 
 static bool ath_rc_update_per(struct ath_softc *sc,
@@ -1582,7 +1610,7 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	}
 
 	/* Find tx rate for unicast frames */
-	ath_rc_ratefind(sc, ath_rc_priv, txrc);
+	ath_rc_ratefind(sc, ath_rc_priv, txrc, sta);
 }
 
 static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
-- 
1.6.0.6

