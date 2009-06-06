Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47287 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbZFFAEC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 20:04:02 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, j@w1.fi
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Subject: [PATCH v2 15/15] ath9k: remove rate control wraper
Date: Fri,  5 Jun 2009 20:03:49 -0400
Message-Id: <1244246629-28179-16-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1244246629-28179-1-git-send-email-lrodriguez@atheros.com>
References: <1244246629-28179-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the cleanup we just use get_rate as a wrapper, skip
the wrapper.

Cc: Derek Smithies <derek@indranet.co.nz>
Cc: Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |   24 +++++++-----------------
 1 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 9199ce9..a921d75 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -792,11 +792,11 @@ static void ath_rc_rate_set_rtscts(struct ath_softc *sc,
 	tx_info->control.rts_cts_rate_idx = cix;
 }
 
-static void ath_rc_ratefind(struct ath_softc *sc,
-			    struct ath_rate_priv *ath_rc_priv,
-			    struct ieee80211_tx_rate_control *txrc,
-			    struct ieee80211_sta *sta)
+static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
+			 struct ieee80211_tx_rate_control *txrc)
 {
+	struct ath_softc *sc = priv;
+	struct ath_rate_priv *ath_rc_priv = priv_sta;
 	const struct ath_rate_table *rate_table;
 	struct sk_buff *skb = txrc->skb;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
@@ -807,6 +807,9 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 	u8 try_per_rate, i = 0, rix, nrix;
 	int is_probe = 0;
 
+	if (rate_control_send_low(sta, priv_sta, txrc))
+		return;
+
 	/*
 	 * For Multi Rate Retry we use a different number of
 	 * retry attempt counts. This ends up looking like this:
@@ -1536,19 +1539,6 @@ exit:
 	kfree(tx_info_priv);
 }
 
-static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
-			 struct ieee80211_tx_rate_control *txrc)
-{
-	struct ath_softc *sc = priv;
-	struct ath_rate_priv *ath_rc_priv = priv_sta;
-
-	if (rate_control_send_low(sta, priv_sta, txrc))
-		return;
-
-	/* Find tx rate for unicast frames */
-	ath_rc_ratefind(sc, ath_rc_priv, txrc, sta);
-}
-
 static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
                           struct ieee80211_sta *sta, void *priv_sta)
 {
-- 
1.6.0.6

