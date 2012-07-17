Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4970 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab2GQLrX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 07:47:23 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20485.20583.628405.113210@gargle.gargle.HOWL> (sfid-20120717_134728_803720_DAB4EB88)
Date: Tue, 17 Jul 2012 17:15:43 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 03/12] ath9k: Cleanup interface handling
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
index ff65188..d4060ec 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -924,11 +924,9 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 
 	if (iter_data.naps > 0) {
 		ath9k_hw_set_tsfadjust(ah, true);
-		set_bit(SC_OP_TSF_RESET, &sc->sc_flags);
 		ah->opmode = NL80211_IFTYPE_AP;
 	} else {
 		ath9k_hw_set_tsfadjust(ah, false);
-		clear_bit(SC_OP_TSF_RESET, &sc->sc_flags);
 
 		if (iter_data.nmeshes)
 			ah->opmode = NL80211_IFTYPE_MESH_POINT;
@@ -940,25 +938,14 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
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
1.7.11.2

