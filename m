Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:57151 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756233Ab0ITLp4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 07:45:56 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 4/5] ath9k: move ath_tx_aggr_check() to the rate control module
Date: Mon, 20 Sep 2010 13:45:39 +0200
Message-Id: <1284983140-30099-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1284983140-30099-3-git-send-email-nbd@openwrt.org>
References: <1284983140-30099-1-git-send-email-nbd@openwrt.org>
 <1284983140-30099-2-git-send-email-nbd@openwrt.org>
 <1284983140-30099-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is not used anywhere else and can be made static

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/rc.c    |   16 ++++++++++++++++
 drivers/net/wireless/ath/ath9k/xmit.c  |   14 --------------
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index dfd368a..e02013c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -345,7 +345,6 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 void ath_tx_tasklet(struct ath_softc *sc);
 void ath_tx_edma_tasklet(struct ath_softc *sc);
 void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb);
-bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an, u8 tidno);
 int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 		      u16 tid, u16 *ssn);
 void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index e49be73..ce1cd6d 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1320,6 +1320,22 @@ static u8 ath_rc_build_ht_caps(struct ath_softc *sc, struct ieee80211_sta *sta,
 	return caps;
 }
 
+static bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an,
+			      u8 tidno)
+{
+	struct ath_atx_tid *txtid;
+
+	if (!(sc->sc_flags & SC_OP_TXAGGR))
+		return false;
+
+	txtid = ATH_AN_2_TID(an, tidno);
+
+	if (!(txtid->state & (AGGR_ADDBA_COMPLETE | AGGR_ADDBA_PROGRESS)))
+			return true;
+	return false;
+}
+
+
 /***********************************/
 /* mac80211 Rate Control callbacks */
 /***********************************/
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index e53433e..85a7323 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -855,20 +855,6 @@ void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid
 	}
 }
 
-bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an, u8 tidno)
-{
-	struct ath_atx_tid *txtid;
-
-	if (!(sc->sc_flags & SC_OP_TXAGGR))
-		return false;
-
-	txtid = ATH_AN_2_TID(an, tidno);
-
-	if (!(txtid->state & (AGGR_ADDBA_COMPLETE | AGGR_ADDBA_PROGRESS)))
-			return true;
-	return false;
-}
-
 /********************/
 /* Queue Management */
 /********************/
-- 
1.7.2.2

