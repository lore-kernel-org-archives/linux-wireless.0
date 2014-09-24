Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:56729 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaIXGRp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 02:17:45 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 2/5] ath9k: Fix p2p address management
Date: Wed, 24 Sep 2014 11:48:13 +0530
Message-Id: <1411539496-30595-3-git-send-email-sujith@msujith.org> (sfid-20140924_081754_615381_0487E71F)
In-Reply-To: <1411539496-30595-1-git-send-email-sujith@msujith.org>
References: <1411539496-30595-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When multiple channel contexts are enabled, a p2p interface
that is assigned to a context will have an address that
is different from the device mac address, which is used
by wpa_s as the p2p device ID.

Certain frames like provision requests use the device address
and these get dropped since ath9k_calculate_summary_state()
iterates over only the active interfaces in a context and the
device address is not used.

Fix this by adding the device mac address to the bssid mask.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
 drivers/net/wireless/ath/ath9k/main.c  | 36 ++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index d2a1ee1..37a5ccf 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -354,6 +354,7 @@ struct ath_chanctx {
 	bool switch_after_beacon;
 
 	short nvifs;
+	short nvifs_assigned;
 	unsigned int rxfilter;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6738c4d..ae7c6ee 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -940,6 +940,34 @@ static void ath9k_vif_iter(struct ath9k_vif_iter_data *iter_data,
 	}
 }
 
+static void ath9k_update_bssid_mask(struct ath_softc *sc,
+				    struct ath_chanctx *ctx,
+				    struct ath9k_vif_iter_data *iter_data)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_vif *avp;
+	int i;
+
+	if (!ath9k_is_chanctx_enabled())
+		return;
+
+	list_for_each_entry(avp, &ctx->vifs, list) {
+		if (ctx->nvifs_assigned != 1)
+			continue;
+
+		if (!avp->vif->p2p || !iter_data->has_hw_macaddr)
+			continue;
+
+		ether_addr_copy(common->curbssid, avp->bssid);
+
+		/* perm_addr will be used as the p2p device address. */
+		for (i = 0; i < ETH_ALEN; i++)
+			iter_data->mask[i] &=
+				~(iter_data->hw_macaddr[i] ^
+				  sc->hw->wiphy->perm_addr[i]);
+	}
+}
+
 /* Called with sc->mutex held. */
 void ath9k_calculate_iter_data(struct ath_softc *sc,
 			       struct ath_chanctx *ctx,
@@ -958,6 +986,8 @@ void ath9k_calculate_iter_data(struct ath_softc *sc,
 
 	list_for_each_entry(avp, &ctx->vifs, list)
 		ath9k_vif_iter(iter_data, avp->vif->addr, avp->vif);
+
+	ath9k_update_bssid_mask(sc, ctx, iter_data);
 }
 
 static void ath9k_set_assoc_state(struct ath_softc *sc,
@@ -1122,6 +1152,10 @@ void ath9k_calculate_summary_state(struct ath_softc *sc,
 	else
 		clear_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags);
 
+	ath_dbg(common, CONFIG,
+		"macaddr: %pM, bssid: %pM, bssidmask: %pM\n",
+		common->macaddr, common->curbssid, common->bssidmask);
+
 	ath9k_ps_restore(sc);
 }
 
@@ -2356,6 +2390,7 @@ static int ath9k_assign_vif_chanctx(struct ieee80211_hw *hw,
 		conf->def.chan->center_freq);
 
 	avp->chanctx = ctx;
+	ctx->nvifs_assigned++;
 	list_add_tail(&avp->list, &ctx->vifs);
 	ath9k_calculate_summary_state(sc, ctx);
 	for (i = 0; i < IEEE80211_NUM_ACS; i++)
@@ -2384,6 +2419,7 @@ static void ath9k_unassign_vif_chanctx(struct ieee80211_hw *hw,
 		conf->def.chan->center_freq);
 
 	avp->chanctx = NULL;
+	ctx->nvifs_assigned--;
 	list_del(&avp->list);
 	ath9k_calculate_summary_state(sc, ctx);
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
-- 
2.1.0

