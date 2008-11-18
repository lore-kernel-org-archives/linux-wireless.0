Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26849 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbYKRDg3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 22:36:29 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 19:36:29 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18722.14224.545245.875365@gargle.gargle.HOWL> (sfid-20081118_043632_094739_91FAC1F7)
Date: Tue, 18 Nov 2008 09:03:36 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 02/18] ath9k: Simplify RC alloc/free functions
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/rc.c |   48 +++++---------------------------------
 1 files changed, 7 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 21116c5..09d622a 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -780,29 +780,6 @@ struct ath_rate_softc *ath_rate_attach(struct ath_hal *ah)
 	return asc;
 }
 
-static struct ath_rate_node *ath_rate_node_alloc(struct ath_vap *avp,
-						 struct ath_rate_softc *rsc,
-						 gfp_t gfp)
-{
-	struct ath_rate_node *anode;
-
-	anode = kzalloc(sizeof(struct ath_rate_node), gfp);
-	if (anode == NULL)
-		return NULL;
-
-	anode->avp = avp;
-	anode->asc = rsc;
-	avp->rc_node = anode;
-
-	return anode;
-}
-
-static void ath_rate_node_free(struct ath_rate_node *anode)
-{
-	if (anode != NULL)
-		kfree(anode);
-}
-
 void ath_rate_detach(struct ath_rate_softc *asc)
 {
 	if (asc != NULL)
@@ -1778,17 +1755,6 @@ static int ath_rate_newassoc(struct ath_softc *sc,
 	return 0;
 }
 
-/*
- *  This routine is called to initialize the rate control parameters
- *  in the SIB. It is called initially during system initialization
- *  or when a station is associated with the AP.
- */
-static void ath_rc_sib_init(struct ath_rate_node *ath_rc_priv)
-{
-	ath_rc_priv->rssi_down_time = jiffies_to_msecs(jiffies);
-}
-
-
 static void ath_setup_rates(struct ath_softc *sc,
 			    struct ieee80211_supported_band *sband,
 			    struct ieee80211_sta *sta,
@@ -1964,21 +1930,23 @@ static void *ath_rate_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp
 	struct ath_vap *avp;
 	struct ath_rate_node *rate_priv;
 
-	DPRINTF(sc, ATH_DBG_RATE, "%s\n", __func__);
-
 	vif = sc->sc_vaps[0];
 	ASSERT(vif);
 
 	avp = (void *)vif->drv_priv;
 
-	rate_priv = ath_rate_node_alloc(avp, sc->sc_rc, gfp);
+	rate_priv = kzalloc(sizeof(struct ath_rate_node), gfp);
 	if (!rate_priv) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: Unable to allocate private rc structure\n",
 			__func__);
 		return NULL;
 	}
-	ath_rc_sib_init(rate_priv);
+
+	rate_priv->avp = avp;
+	rate_priv->asc = sc->sc_rc;
+	avp->rc_node = rate_priv;
+	rate_priv->rssi_down_time = jiffies_to_msecs(jiffies);
 
 	return rate_priv;
 }
@@ -1987,10 +1955,8 @@ static void ath_rate_free_sta(void *priv, struct ieee80211_sta *sta,
 			      void *priv_sta)
 {
 	struct ath_rate_node *rate_priv = priv_sta;
-	struct ath_softc *sc = priv;
 
-	DPRINTF(sc, ATH_DBG_RATE, "%s", __func__);
-	ath_rate_node_free(rate_priv);
+	kfree(rate_priv);
 }
 
 static struct rate_control_ops ath_rate_ops = {
-- 
1.6.0.3

