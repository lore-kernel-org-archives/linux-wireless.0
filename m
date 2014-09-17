Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:49499 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbaIQJP2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2014 05:15:28 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v3.18] ath9k: Cache BSS information
Date: Wed, 17 Sep 2014 14:45:56 +0530
Message-Id: <1410945356-24848-1-git-send-email-sujith@msujith.org> (sfid-20140917_111543_677457_3AD89002)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Using the BSS information stored in mac80211 directly
is racy in certain conditions. For example, in a MCC
setup, if the scheduler is switching channels when
a local deauth is issued, calculation of the opmode/bssid
etc. is incorrect. To avoid this, store the bss params
in the driver and use it.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  5 +++++
 drivers/net/wireless/ath/ath9k/channel.c |  6 +++---
 drivers/net/wireless/ath/ath9k/main.c    | 13 +++++++++----
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 8cd116e..d2a1ee1 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -585,6 +585,11 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 struct ath_vif {
 	struct list_head list;
 
+	/* BSS info */
+	u8 bssid[ETH_ALEN];
+	u16 aid;
+	bool assoc;
+
 	struct ieee80211_vif *vif;
 	struct ath_node mcast_node;
 	int av_bslot;
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 77c99eb5..b93f83c 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -211,7 +211,7 @@ void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx)
 		switch (vif->type) {
 		case NL80211_IFTYPE_P2P_CLIENT:
 		case NL80211_IFTYPE_STATION:
-			if (vif->bss_conf.assoc)
+			if (avp->assoc)
 				active = true;
 			break;
 		default:
@@ -917,7 +917,7 @@ ath_chanctx_send_vif_ps_frame(struct ath_softc *sc, struct ath_vif *avp,
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
-		if (!vif->bss_conf.assoc)
+		if (!avp->assoc)
 			return false;
 
 		skb = ieee80211_nullfunc_get(sc->hw, vif);
@@ -1339,7 +1339,7 @@ void ath9k_p2p_ps_timer(void *priv)
 	rcu_read_lock();
 
 	vif = avp->vif;
-	sta = ieee80211_find_sta(vif, vif->bss_conf.bssid);
+	sta = ieee80211_find_sta(vif, avp->bssid);
 	if (!sta)
 		goto out;
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3e485f7..78fc539 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -898,6 +898,7 @@ static bool ath9k_uses_beacons(int type)
 static void ath9k_vif_iter(struct ath9k_vif_iter_data *iter_data,
 			   u8 *mac, struct ieee80211_vif *vif)
 {
+	struct ath_vif *avp = (struct ath_vif *)vif->drv_priv;
 	int i;
 
 	if (iter_data->has_hw_macaddr) {
@@ -918,7 +919,7 @@ static void ath9k_vif_iter(struct ath9k_vif_iter_data *iter_data,
 		break;
 	case NL80211_IFTYPE_STATION:
 		iter_data->nstations++;
-		if (vif->bss_conf.assoc && !iter_data->primary_sta)
+		if (avp->assoc && !iter_data->primary_sta)
 			iter_data->primary_sta = vif;
 		break;
 	case NL80211_IFTYPE_ADHOC:
@@ -963,13 +964,13 @@ static void ath9k_set_assoc_state(struct ath_softc *sc,
 				  struct ieee80211_vif *vif, bool changed)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+	struct ath_vif *avp = (struct ath_vif *)vif->drv_priv;
 	unsigned long flags;
 
 	set_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags);
 
-	ether_addr_copy(common->curbssid, bss_conf->bssid);
-	common->curaid = bss_conf->aid;
+	ether_addr_copy(common->curbssid, avp->bssid);
+	common->curaid = avp->aid;
 	ath9k_hw_write_associd(sc->sc_ah);
 
 	if (changed) {
@@ -1698,6 +1699,10 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		ath_dbg(common, CONFIG, "BSSID %pM Changed ASSOC %d\n",
 			bss_conf->bssid, bss_conf->assoc);
 
+		ether_addr_copy(avp->bssid, bss_conf->bssid);
+		avp->aid = bss_conf->aid;
+		avp->assoc = bss_conf->assoc;
+
 		ath9k_calculate_summary_state(sc, avp->chanctx);
 
 		if (ath9k_is_chanctx_enabled()) {
-- 
2.1.0

