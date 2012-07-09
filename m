Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64728 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab2GIJQK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 05:16:10 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20474.41227.340474.446454@gargle.gargle.HOWL> (sfid-20120709_111614_898136_2D2295C1)
Date: Mon, 9 Jul 2012 14:44:51 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC/WIP 03/11] ath9k: Cleanup interface handling
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Do not set/clear TSF when adding/deleting an interface.
  This should be done when the BSS is set up and should also
  take into account the existence of other interfaces.

* Set opmode explicitly.

* ANI setup needs to be decided based on multiple interfaces.
  This can be done via the bss_info_changed() callback.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1265add..2619bd3 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -913,11 +913,9 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 
 	if (iter_data.naps > 0) {
 		ath9k_hw_set_tsfadjust(ah, true);
-		set_bit(SC_OP_TSF_RESET, &sc->sc_flags);
 		ah->opmode = NL80211_IFTYPE_AP;
 	} else {
 		ath9k_hw_set_tsfadjust(ah, false);
-		clear_bit(SC_OP_TSF_RESET, &sc->sc_flags);
 
 		if (iter_data.nmeshes)
 			ah->opmode = NL80211_IFTYPE_MESH_POINT;
@@ -929,25 +927,14 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 			ah->opmode = NL80211_IFTYPE_STATION;
 	}
 
+	ath9k_hw_setopmode(ah);
+
 	if ((iter_data.nstations + iter_data.nadhocs + iter_data.nmeshes) > 0)
 		ah->imask |= ATH9K_INT_TSFOOR;
 	else
 		ah->imask &= ~ATH9K_INT_TSFOOR;
 
 	ath9k_hw_set_interrupts(ah);
-
-	if (iter_data.naps > 0) {
-		sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
-
-		if (!common->disable_ani) {
-			set_bit(SC_OP_ANI_RUN, &sc->sc_flags);
-			ath_start_ani(common);
-		}
-
-	} else {
-		clear_bit(SC_OP_ANI_RUN, &sc->sc_flags);
-		del_timer_sync(&common->ani.timer);
-	}
 }
 
 static int ath9k_add_interface(struct ieee80211_hw *hw,
-- 
1.7.11.1

