Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:10074 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824AbYGQUM0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 16:12:26 -0400
Received: by yx-out-2324.google.com with SMTP id 8so14993yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2008 13:12:26 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: ath5k-devel@lists.ath5k.org
From: Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] ath5k: add Mesh Point support
Date: Thu, 17 Jul 2008 13:12:24 -0700 (PDT)
Message-ID: <487fa7a8.14da600a.1aae.48b1@mx.google.com> (sfid-20080717_221239_627791_55EAFBA7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This enables draft-802.11s Mesh Point operation.  For that we need mesh
beaconing.  Tested with AR5212/AR5213 PCI card against Zydas and b43 mesh 
nodes.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 217d506..6d9f4e1 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1425,7 +1425,8 @@ ath5k_beaconq_config(struct ath5k_softc *sc)
 	ret = ath5k_hw_get_tx_queueprops(ah, sc->bhalq, &qi);
 	if (ret)
 		return ret;
-	if (sc->opmode == IEEE80211_IF_TYPE_AP) {
+	if (sc->opmode == IEEE80211_IF_TYPE_AP ||
+		sc->opmode == IEEE80211_IF_TYPE_MESH_POINT) {
 		/*
 		 * Always burst out beacon and CAB traffic
 		 * (aifs = cwmin = cwmax = 0)
@@ -2911,6 +2912,7 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
 	if (sc->opmode != IEEE80211_IF_TYPE_STA)
 		rfilt |= AR5K_RX_FILTER_PROBEREQ;
 	if (sc->opmode != IEEE80211_IF_TYPE_AP &&
+		sc->opmode != IEEE80211_IF_TYPE_MESH_POINT &&
 		test_bit(ATH_STAT_PROMISC, sc->status))
 		rfilt |= AR5K_RX_FILTER_PROM;
 	if (sc->opmode == IEEE80211_IF_TYPE_STA ||
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index c6d12c5..8854820 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -2326,6 +2326,7 @@ int ath5k_hw_set_opmode(struct ath5k_hw *ah)
 		break;
 
 	case IEEE80211_IF_TYPE_AP:
+	case IEEE80211_IF_TYPE_MESH_POINT:
 		pcu_reg |= AR5K_STA_ID1_AP | AR5K_STA_ID1_RTS_DEF_ANTENNA |
 			(ah->ah_version == AR5K_AR5210 ?
 				AR5K_STA_ID1_NO_PSPOLL : 0);


