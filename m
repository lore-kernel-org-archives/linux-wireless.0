Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25756 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbYHBXtK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 19:49:10 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 16:49:10 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<jouni.malinen@atheros.com>,
	Sujith Manoharan <smanoharan@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 02/12] ath9k: Update rate control after association
Date: Sat, 2 Aug 2008 16:48:54 -0700
Message-ID: <1217720944-23234-3-git-send-email-lrodriguez@atheros.com> (sfid-20080803_014915_465177_5AD7FA43)
In-Reply-To: <1217720944-23234-2-git-send-email-lrodriguez@atheros.com>
References: <1217720944-23234-1-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <smanoharan@atheros.com>

Rate control node has to be updated after setting the channel.
And remove an unused variable in ath_rate_newstate(). Be sure
to have a proper rate table for 11a mode before updating the
rate control based on the new mode.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/core.c |    2 +-
 drivers/net/wireless/ath9k/core.h |    1 +
 drivers/net/wireless/ath9k/main.c |   11 ++++++-----
 drivers/net/wireless/ath9k/rc.c   |    7 ++++---
 drivers/net/wireless/ath9k/rc.h   |    3 ++-
 5 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 587f307..6a61064 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -595,7 +595,7 @@ int ath_vap_listen(struct ath_softc *sc, int if_id)
 #endif
 
 	/* update ratectrl about the new state */
-	ath_rate_newstate(sc, avp, 0);
+	ath_rate_newstate(sc, avp);
 
 	rfilt = ath_calcrxfilter(sc);
 	ath9k_hw_setrxfilter(ah, rfilt);
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index fdd0f87..e2b42f2 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -792,6 +792,7 @@ struct ath_vap {
 						transmit queue */
 	struct ath_vap_config           av_config;  /* vap configuration
 					parameters from 802.11 protocol layer*/
+	struct ath_rate_node            *rc_node;
 };
 
 int ath_vap_attach(struct ath_softc *sc,
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 7ef0d58..c47ef50 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -447,7 +447,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 #endif
 
 	/* Update ratectrl */
-	ath_rate_newstate(sc, avp, 0);
+	ath_rate_newstate(sc, avp);
 
 	/* Reclaim beacon resources */
 	if (sc->sc_opmode == HAL_M_HOSTAP || sc->sc_opmode == HAL_M_IBSS) {
@@ -513,7 +513,7 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 		case IEEE80211_IF_TYPE_STA:
 		case IEEE80211_IF_TYPE_IBSS:
 			/* Update ratectrl about the new state */
-			ath_rate_newstate(sc, avp, 0);
+			ath_rate_newstate(sc, avp);
 
 			/* Set rx filter */
 			rfilt = ath_calcrxfilter(sc);
@@ -788,9 +788,6 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 			return;
 		}
 
-		/* Update ratectrl about the new state */
-		ath_rate_newstate(sc, avp, 1);
-
 		/* New association, store aid */
 		if (avp->av_opmode == HAL_M_STA) {
 			sc->sc_curaid = bss_conf->aid;
@@ -828,6 +825,10 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: Unable to set channel\n",
 				__func__);
+
+		ath_rate_newstate(sc, avp);
+		/* Update ratectrl about the new state */
+		ath_rc_node_update(hw, avp->rc_node);
 	} else {
 		DPRINTF(sc, ATH_DBG_CONFIG,
 		"%s: Bss Info DISSOC\n", __func__);
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 83b8f2d..ecab05f 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -797,6 +797,8 @@ static struct ath_rate_node *ath_rate_node_alloc(struct ath_vap *avp,
 
 	anode->avp = avp;
 	anode->asc = rsc;
+	avp->rc_node = anode;
+
 	return anode;
 }
 
@@ -838,7 +840,7 @@ u_int8_t ath_rate_findrateix(struct ath_softc *sc,
  * with an AP.  Otherwise this gets called, for example, when
  * the we transition to run state when operating as an AP.
  */
-void ath_rate_newstate(struct ath_softc *sc, struct ath_vap *avp, int up)
+void ath_rate_newstate(struct ath_softc *sc, struct ath_vap *avp)
 {
 	struct ath_rate_softc *asc = sc->sc_rc;
 
@@ -1833,8 +1835,7 @@ static void ath_setup_rates(struct ieee80211_local *local, struct sta_info *sta)
 	rc_priv->neg_rates.rs_nrates = j;
 }
 
-static void ath_rc_node_update(struct ieee80211_hw *hw,
-				struct ath_rate_node *rc_priv)
+void ath_rc_node_update(struct ieee80211_hw *hw, struct ath_rate_node *rc_priv)
 {
 	struct ath_softc *sc = hw->priv;
 	u_int32_t capflag = 0;
diff --git a/drivers/net/wireless/ath9k/rc.h b/drivers/net/wireless/ath9k/rc.h
index 3ed04b2..1c54924 100644
--- a/drivers/net/wireless/ath9k/rc.h
+++ b/drivers/net/wireless/ath9k/rc.h
@@ -294,7 +294,8 @@ void ath_rate_detach(struct ath_rate_softc *asc);
  * Important mostly as the analog to ath_rate_newassoc when operating
  * in station mode.
  */
-void ath_rate_newstate(struct ath_softc *sc, struct ath_vap *avp, int up);
+void ath_rc_node_update(struct ieee80211_hw *hw, struct ath_rate_node *rc_priv);
+void ath_rate_newstate(struct ath_softc *sc, struct ath_vap *avp);
 
 /*
  * Return the tx rate series.
-- 
1.5.6.rc2.15.g457bb.dirty

