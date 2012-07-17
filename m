Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51274 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab2GQLrf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 07:47:35 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20485.20616.91106.641949@gargle.gargle.HOWL> (sfid-20120717_134738_697111_8DDDFA38)
Date: Tue, 17 Jul 2012 17:16:16 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/12] ath9k: Set the TSF adjust value properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |  1 +
 drivers/net/wireless/ath/ath9k/beacon.c | 17 +++++++++++++++++
 drivers/net/wireless/ath/ath9k/main.c   |  3 +++
 3 files changed, 21 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index ae3e940..7e4839a 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -418,6 +418,7 @@ void ath9k_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif,
 			 u32 changed);
 void ath9k_beacon_assign_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
 void ath9k_beacon_remove_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
+void ath9k_set_tsfadjust(struct ath_softc *sc, struct ieee80211_vif *vif);
 void ath9k_set_beacon(struct ath_softc *sc);
 void ath9k_set_beaconing_status(struct ath_softc *sc, bool status);
 
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 02fbd3e..f2a2131 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -268,6 +268,23 @@ void ath9k_beacon_remove_slot(struct ath_softc *sc, struct ieee80211_vif *vif)
 	tasklet_enable(&sc->bcon_tasklet);
 }
 
+void ath9k_set_tsfadjust(struct ath_softc *sc, struct ieee80211_vif *vif)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
+	struct ath_vif *avp = (void *)vif->drv_priv;
+	u64 tsfadjust;
+
+	if (avp->av_bslot == 0)
+		return;
+
+	tsfadjust = cur_conf->beacon_interval * avp->av_bslot / ATH_BCBUF;
+	avp->tsf_adjust = cpu_to_le64(TU_TO_USEC(tsfadjust));
+
+	ath_dbg(common, CONFIG, "tsfadjust is: %llu for bslot: %d\n",
+		(unsigned long long)tsfadjust, avp->av_bslot);
+}
+
 void ath_beacon_tasklet(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7760dc3..c23912c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1530,6 +1530,9 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 
 	if ((changed & BSS_CHANGED_BEACON_ENABLED) ||
 	    (changed & BSS_CHANGED_BEACON_INT)) {
+		if (ah->opmode == NL80211_IFTYPE_AP &&
+		    bss_conf->enable_beacon)
+			ath9k_set_tsfadjust(sc, vif);
 		if (ath9k_allow_beacon_config(sc, vif))
 			ath9k_beacon_config(sc, vif, changed);
 	}
-- 
1.7.11.2

