Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52930 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab2CBRIq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 12:08:46 -0500
Received: by dajr28 with SMTP id r28so2206019daj.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2012 09:08:45 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@qca.qualcomm.com, me@bobcopeland.com,
	ath5k-devel@lists.ath5k.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] ath5k: allow AP and mesh mode to operate simultaneously
Date: Sat,  3 Mar 2012 09:48:56 +0800
Message-Id: <1330739336-1503-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120302_180850_902761_3630141F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows the possibility of having the mesh point and AP to be operated
simultaneously in one single radio. Previously, mesh point fails to generate the
mesh beacon if virtual AP is created for the same radio.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h        |    1 +
 drivers/net/wireless/ath/ath5k/base.c         |    6 ++++--
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    4 ++++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 6640326..8d434b8 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1320,6 +1320,7 @@ struct ath5k_hw {
 	struct ieee80211_vif	*bslot[ATH_BCBUF];
 	u16			num_ap_vifs;
 	u16			num_adhoc_vifs;
+	u16			num_mesh_vifs;
 	unsigned int		bhalq,		/* SW q for outgoing beacons */
 				bmisscount,	/* missed beacon transmits */
 				bintval,	/* beacon interval in TU */
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a339693..ba1345b 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1867,7 +1867,8 @@ ath5k_beacon_send(struct ath5k_hw *ah)
 		ah->bmisscount = 0;
 	}

-	if ((ah->opmode == NL80211_IFTYPE_AP && ah->num_ap_vifs > 1) ||
+	if ((ah->opmode == NL80211_IFTYPE_AP && ah->num_ap_vifs +
+			ah->num_mesh_vifs > 1) ||
 			ah->opmode == NL80211_IFTYPE_MESH_POINT) {
 		u64 tsf = ath5k_hw_get_tsf64(ah);
 		u32 tsftu = TSF_TO_TU(tsf);
@@ -1952,7 +1953,8 @@ ath5k_beacon_update_timers(struct ath5k_hw *ah, u64 bc_tsf)
 	u64 hw_tsf;

 	intval = ah->bintval & AR5K_BEACON_PERIOD;
-	if (ah->opmode == NL80211_IFTYPE_AP && ah->num_ap_vifs > 1) {
+	if (ah->opmode == NL80211_IFTYPE_AP && ah->num_ap_vifs
+		+ ah->num_mesh_vifs > 1) {
 		intval /= ATH_BCBUF;	/* staggered multi-bss beacons */
 		if (intval < 15)
 			ATH5K_WARN(ah, "intval %u is too low, min 15\n",
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index af4c7ec..5c53299 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -134,6 +134,8 @@ ath5k_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 			ah->num_ap_vifs++;
 		else if (avf->opmode == NL80211_IFTYPE_ADHOC)
 			ah->num_adhoc_vifs++;
+		else if (avf->opmode == NL80211_IFTYPE_MESH_POINT)
+			ah->num_mesh_vifs++;
 	}

 	/* Any MAC address is fine, all others are included through the
@@ -175,6 +177,8 @@ ath5k_remove_interface(struct ieee80211_hw *hw,
 		ah->num_ap_vifs--;
 	else if (avf->opmode == NL80211_IFTYPE_ADHOC)
 		ah->num_adhoc_vifs--;
+	else if (avf->opmode == NL80211_IFTYPE_MESH_POINT)
+		ah->num_mesh_vifs--;

 	ath5k_update_bssid_mask_and_opmode(ah, NULL);
 	mutex_unlock(&ah->lock);
--
1.7.0.4

