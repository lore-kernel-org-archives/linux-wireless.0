Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:45845 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbaICDJQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 23:09:16 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 3/6] ath9k: Fix panic when adding an AP interface
Date: Wed,  3 Sep 2014 08:39:22 +0530
Message-Id: <1409713765-9358-4-git-send-email-sujith@msujith.org> (sfid-20140903_050937_696839_845A12C2)
In-Reply-To: <1409713765-9358-1-git-send-email-sujith@msujith.org>
References: <1409713765-9358-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

If a station interface is already assigned to a context
and is active and a second interface of type AP is added,
then beaconing on the new interface has to be begin only
after the BSS_CHANGED_BEACON_ENABLED flag is sent by mac80211
to the driver.

But, since we issue ATH_CHANCTX_EVENT_ENABLE_MULTICHANNEL as soon
as a new channel context is added, a switch occurs almost immediately
before BSS_CHANGED_BEACON_ENABLED is received. When a HW reset
is done for the new context, beacons are enabled for the
interface since "enable_beacon" in the BSS config maintained
in mac80211 is true - but the driver hasn't been notified yet.
This causes a panic, since the beacon interval is zero for this
interface and ath9k_cmn_beacon_config_ap() doesn't have a safety check.

Fix this panic by checking if the beacon params has been cached
for this context and use the "enable_beacon" flag maintained
locally in the driver. Also, recalculate the summary data
after the beacon params have been cached when BSS_CHANGED_BEACON_ENABLED
is received.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 0b3d4d8..2333776 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -916,8 +916,6 @@ static void ath9k_vif_iter(struct ath9k_vif_iter_data *iter_data,
 	switch (vif->type) {
 	case NL80211_IFTYPE_AP:
 		iter_data->naps++;
-		if (vif->bss_conf.enable_beacon)
-			iter_data->beacons = true;
 		break;
 	case NL80211_IFTYPE_STATION:
 		iter_data->nstations++;
@@ -1021,6 +1019,7 @@ void ath9k_calculate_summary_state(struct ath_softc *sc,
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_vif_iter_data iter_data;
+	struct ath_beacon_config *cur_conf;
 
 	ath_chanctx_check_active(sc, ctx);
 
@@ -1037,8 +1036,11 @@ void ath9k_calculate_summary_state(struct ath_softc *sc,
 	ath_hw_setbssidmask(common);
 
 	if (iter_data.naps > 0) {
+		cur_conf = &ctx->beacon;
 		ath9k_hw_set_tsfadjust(ah, true);
 		ah->opmode = NL80211_IFTYPE_AP;
+		if (cur_conf->enable_beacon)
+			iter_data.beacons = true;
 	} else {
 		ath9k_hw_set_tsfadjust(ah, false);
 
@@ -1695,9 +1697,9 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	if ((changed & BSS_CHANGED_BEACON_ENABLED) ||
 	    (changed & BSS_CHANGED_BEACON_INT) ||
 	    (changed & BSS_CHANGED_BEACON_INFO)) {
+		ath9k_beacon_config(sc, vif, changed);
 		if (changed & BSS_CHANGED_BEACON_ENABLED)
 			ath9k_calculate_summary_state(sc, avp->chanctx);
-		ath9k_beacon_config(sc, vif, changed);
 	}
 
 	if ((avp->chanctx == sc->cur_chan) &&
-- 
2.1.0

