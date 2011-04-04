Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63907 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab1DDR0S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 13:26:18 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2011 10:25:53 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 2/5] ath9k: Cleanup ath_vif struct
Date: Mon, 4 Apr 2011 22:56:17 +0530
Message-ID: <1301937979-14770-2-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1301937979-14770-1-git-send-email-rmanoharan@atheros.com>
References: <1301937979-14770-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unused bssid from ath_vif and set av_bslot on beacon
alloc/return.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    2 --
 drivers/net/wireless/ath/ath9k/beacon.c |    1 +
 drivers/net/wireless/ath/ath9k/main.c   |    6 ------
 3 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 7c91ba4..d637345 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -348,9 +348,7 @@ struct ath_vif {
 	int av_bslot;
 	bool is_bslot_active;
 	__le64 tsf_adjust; /* TSF adjustment for staggered beacons */
-	enum nl80211_iftype av_opmode;
 	struct ath_buf *av_bcbuf;
-	u8 bssid[ETH_ALEN]; /* current BSSID from config_interface */
 };
 
 /*******************/
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 74f33bc..fec9255 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -323,6 +323,7 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp)
 		if (avp->av_bslot != -1) {
 			sc->beacon.bslot[avp->av_bslot] = NULL;
 			sc->nbcnvifs--;
+			avp->av_bslot = -1;
 		}
 
 		bf = avp->av_bcbuf;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 67b0eea..729f3db 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1454,7 +1454,6 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath_vif *avp = (void *)vif->drv_priv;
 	int ret = 0;
 
 	mutex_lock(&sc->mutex);
@@ -1495,10 +1494,6 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	ath_dbg(common, ATH_DBG_CONFIG,
 		"Attach a VIF of type: %d\n", vif->type);
 
-	/* Set the VIF opmode */
-	avp->av_opmode = vif->type;
-	avp->av_bslot = -1;
-
 	sc->nvifs++;
 
 	ath9k_do_vif_add_setup(hw, vif);
@@ -1914,7 +1909,6 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_BSSID) {
 		/* Set BSSID */
 		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
-		memcpy(avp->bssid, bss_conf->bssid, ETH_ALEN);
 		common->curaid = 0;
 		ath9k_hw_write_associd(ah);
 
-- 
1.7.4.2

