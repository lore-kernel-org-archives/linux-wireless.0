Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27025 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbYKRDhO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 22:37:14 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 19:37:14 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18722.14269.74025.378686@gargle.gargle.HOWL> (sfid-20081118_043718_128918_EEB63187)
Date: Tue, 18 Nov 2008 09:04:21 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 04/18] ath9k: Remove ath_rate_newassoc()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/rc.c |   33 ++++++++-------------------------
 1 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 798dff6..1ec5861 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1732,29 +1732,6 @@ static void ath_rc_sib_update(struct ath_softc *sc,
 	ath_rc_priv->rate_max_phy = ath_rc_priv->valid_rate_index[k-4];
 }
 
-/*
- * Update rate-control state on station associate/reassociate.
- */
-static int ath_rate_newassoc(struct ath_softc *sc,
-			     struct ath_rate_node *ath_rc_priv,
-			     unsigned int capflag,
-			     struct ath_rateset *negotiated_rates,
-			     struct ath_rateset *negotiated_htrates)
-{
-
-
-	ath_rc_priv->ht_cap =
-		((capflag & ATH_RC_DS_FLAG) ? WLAN_RC_DS_FLAG : 0) |
-		((capflag & ATH_RC_SGI_FLAG) ? WLAN_RC_SGI_FLAG : 0) |
-		((capflag & ATH_RC_HT_FLAG)  ? WLAN_RC_HT_FLAG : 0) |
-		((capflag & ATH_RC_CW40_FLAG) ? WLAN_RC_40_FLAG : 0);
-
-	ath_rc_sib_update(sc, ath_rc_priv, ath_rc_priv->ht_cap, 0,
-			  negotiated_rates, negotiated_htrates);
-
-	return 0;
-}
-
 void ath_rc_node_update(struct ieee80211_hw *hw, struct ath_rate_node *rc_priv)
 {
 	struct ath_softc *sc = hw->priv;
@@ -1766,10 +1743,16 @@ void ath_rc_node_update(struct ieee80211_hw *hw, struct ath_rate_node *rc_priv)
 			capflag |= ATH_RC_CW40_FLAG;
 	}
 
-	ath_rate_newassoc(sc, rc_priv, capflag,
+	rc_priv->ht_cap =
+		((capflag & ATH_RC_DS_FLAG) ? WLAN_RC_DS_FLAG : 0) |
+		((capflag & ATH_RC_SGI_FLAG) ? WLAN_RC_SGI_FLAG : 0) |
+		((capflag & ATH_RC_HT_FLAG)  ? WLAN_RC_HT_FLAG : 0) |
+		((capflag & ATH_RC_CW40_FLAG) ? WLAN_RC_40_FLAG : 0);
+
+
+	ath_rc_sib_update(sc, rc_priv, rc_priv->ht_cap, 0,
 			  &rc_priv->neg_rates,
 			  &rc_priv->neg_ht_rates);
-
 }
 
 /* Rate Control callbacks */
-- 
1.6.0.3

