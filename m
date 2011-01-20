Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43654 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab1ATRch (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 12:32:37 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 3/3] ath9k: Support scanning on current channel.
Date: Thu, 20 Jan 2011 09:32:30 -0800
Message-Id: <1295544750-6704-3-git-send-email-greearb@candelatech.com>
In-Reply-To: <1295544750-6704-1-git-send-email-greearb@candelatech.com>
References: <1295544750-6704-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This adds support for scanning on only the current
channel.  We do not need to flush xmit queues or
otherwise impede traffic in this scenario.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 dab0271... fa5bd0d... M	drivers/net/wireless/ath/ath9k/ath9k.h
:100644 100644 333486d... ef182d1... M	drivers/net/wireless/ath/ath9k/debug.c
:100644 100644 f01de0e... a2454ba... M	drivers/net/wireless/ath/ath9k/main.c
:100644 100644 d205c66... 261a68a... M	drivers/net/wireless/ath/ath9k/virtual.c
 drivers/net/wireless/ath/ath9k/ath9k.h   |    1 +
 drivers/net/wireless/ath/ath9k/debug.c   |    2 ++
 drivers/net/wireless/ath/ath9k/main.c    |   22 ++++++++++++++++++----
 drivers/net/wireless/ath/ath9k/virtual.c |    6 ++++--
 4 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index dab0271..fa5bd0d 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -672,6 +672,7 @@ struct ath_wiphy {
 		ATH_WIPHY_PAUSING,
 		ATH_WIPHY_PAUSED,
 		ATH_WIPHY_SCAN,
+		ATH_WIPHY_SCAN_CUR,
 	} state;
 	bool idle;
 	int chan_idx;
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 333486d..ef182d1 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -394,6 +394,8 @@ static const char * ath_wiphy_state_str(enum ath_wiphy_state state)
 		return "PAUSED";
 	case ATH_WIPHY_SCAN:
 		return "SCAN";
+	case ATH_WIPHY_SCAN_CUR:
+		return "SCAN_CUR";
 	}
 	return "?";
 }
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f01de0e..a2454ba 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1220,7 +1220,9 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 	struct ath_tx_control txctl;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 
-	if (aphy->state != ATH_WIPHY_ACTIVE && aphy->state != ATH_WIPHY_SCAN) {
+	if (aphy->state != ATH_WIPHY_ACTIVE &&
+	    aphy->state != ATH_WIPHY_SCAN_CUR &&
+	    aphy->state != ATH_WIPHY_SCAN) {
 		ath_dbg(common, ATH_DBG_XMIT,
 			"ath9k: %s: TX in unexpected wiphy state %d\n",
 			wiphy_name(hw->wiphy), aphy->state);
@@ -1803,6 +1805,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			sc->sc_flags &= ~SC_OP_OFFCHANNEL;
 
 		if (aphy->state == ATH_WIPHY_SCAN ||
+		    aphy->state == ATH_WIPHY_SCAN_CUR ||
 		    aphy->state == ATH_WIPHY_ACTIVE)
 			ath9k_wiphy_pause_all_forced(sc, aphy);
 		else {
@@ -2262,7 +2265,8 @@ static int ath9k_get_survey(struct ieee80211_hw *hw, int idx,
 	return 0;
 }
 
-static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
+static void ath9k_sw_scan_start_cur(struct ieee80211_hw *hw,
+				    bool cur_only)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
@@ -2280,11 +2284,20 @@ static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 		return;
 	}
 
-	aphy->state = ATH_WIPHY_SCAN;
-	ath9k_wiphy_pause_all_forced(sc, aphy);
+	if (cur_only)
+		aphy->state = ATH_WIPHY_SCAN_CUR;
+	else {
+		aphy->state = ATH_WIPHY_SCAN;
+		ath9k_wiphy_pause_all_forced(sc, aphy);
+	}
 	mutex_unlock(&sc->mutex);
 }
 
+static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
+{
+	ath9k_sw_scan_start_cur(hw, false);
+}
+
 /*
  * XXX: this requires a revisit after the driver
  * scan_complete gets moved to another place/removed in mac80211.
@@ -2331,6 +2344,7 @@ struct ieee80211_ops ath9k_ops = {
 	.ampdu_action       = ath9k_ampdu_action,
 	.get_survey	    = ath9k_get_survey,
 	.sw_scan_start      = ath9k_sw_scan_start,
+	.sw_scan_start_cur  = ath9k_sw_scan_start_cur,
 	.sw_scan_complete   = ath9k_sw_scan_complete,
 	.rfkill_poll        = ath9k_rfkill_poll_state,
 	.set_coverage_class = ath9k_set_coverage_class,
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index d205c66..261a68a 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -176,11 +176,13 @@ static bool ath9k_wiphy_pausing(struct ath_softc *sc)
 static bool __ath9k_wiphy_scanning(struct ath_softc *sc)
 {
 	int i;
-	if (sc->pri_wiphy->state == ATH_WIPHY_SCAN)
+	if (sc->pri_wiphy->state == ATH_WIPHY_SCAN ||
+	    sc->pri_wiphy->state == ATH_WIPHY_SCAN_CUR)
 		return true;
 	for (i = 0; i < sc->num_sec_wiphy; i++) {
 		if (sc->sec_wiphy[i] &&
-		    sc->sec_wiphy[i]->state == ATH_WIPHY_SCAN)
+		    (sc->sec_wiphy[i]->state == ATH_WIPHY_SCAN ||
+		     sc->sec_wiphy[i]->state == ATH_WIPHY_SCAN_CUR))
 			return true;
 	}
 	return false;
-- 
1.7.2.3

