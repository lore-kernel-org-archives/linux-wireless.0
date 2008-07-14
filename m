Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:62895 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759428AbYGNXeu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 19:34:50 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2933847waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jul 2008 16:34:50 -0700 (PDT)
To: ath5k-devel@lists.ath5k.org
Cc: linux-wireless@vger.kernel.org
Subject: [RFC] add Mesh Point support to ath5k
From: andrey@cozybit.com
Date: Mon, 14 Jul 2008 16:34:49 -0700 (PDT)
Message-ID: <487be299.22bd720a.70ba.29c5@mx.google.com> (sfid-20080715_013454_688792_D7BC8995)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables draft-802.11s Mesh Point operation.  For that we need mesh
beaconing.  This seems to work fine when tested against a Zydas interface but I
would appreciate it if someone who knows ath5k could check this over. My 
hardware is an AR5212/AR5213 PCI card.

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


