Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:55522 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751595AbeCVTSL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Mar 2018 15:18:11 -0400
From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Subject: [PATCH v3] mac80211: notify driver for change in multicast rates
Date: Thu, 22 Mar 2018 12:18:03 -0700
Message-Id: <1521746283-25497-1-git-send-email-pradeepc@codeaurora.org> (sfid-20180322_201815_098650_A305B582)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is required to pass the rate information to driver/firmware
when rate control is offloaded to firmware. This helps in changing
multicast traffic rates thereby improving the network performance.

Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
---
V3:
  - Added Documentation
V2:
  - Set the flag in missing places

 include/net/mac80211.h | 3 +++
 net/mac80211/cfg.c     | 2 ++
 net/mac80211/ibss.c    | 2 +-
 net/mac80211/mesh.c    | 3 ++-
 net/mac80211/util.c    | 3 ++-
 5 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4c99c13..f0e4f8a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -309,6 +309,8 @@ struct ieee80211_vif_chanctx_switch {
  * @BSS_CHANGED_MU_GROUPS: VHT MU-MIMO group id or user position changed
  * @BSS_CHANGED_KEEP_ALIVE: keep alive options (idle period or protected
  *	keep alive) changed.
+ * @BSS_CHANGED_MCAST_RATE: Multicast Rate setting changed for this interface
+ *
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -336,6 +338,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_OCB                 = 1<<22,
 	BSS_CHANGED_MU_GROUPS		= 1<<23,
 	BSS_CHANGED_KEEP_ALIVE		= 1<<24,
+	BSS_CHANGED_MCAST_RATE		= 1<<25,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0763792..22bb82e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2313,6 +2313,8 @@ static int ieee80211_set_mcast_rate(struct wiphy *wiphy, struct net_device *dev,
 	memcpy(sdata->vif.bss_conf.mcast_rate, rate,
 	       sizeof(int) * NUM_NL80211_BANDS);
 
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_MCAST_RATE);
+
 	return 0;
 }
 
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index e9c6aa3..f4b0634 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1840,7 +1840,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 		  IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED
 		| IEEE80211_HT_PARAM_RIFS_MODE;
 
-	changed |= BSS_CHANGED_HT;
+	changed |= BSS_CHANGED_HT | BSS_CHANGED_MCAST_RATE;
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 277398d..55c04e1 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -884,7 +884,8 @@ int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 		      BSS_CHANGED_BEACON_ENABLED |
 		      BSS_CHANGED_HT |
 		      BSS_CHANGED_BASIC_RATES |
-		      BSS_CHANGED_BEACON_INT;
+		      BSS_CHANGED_BEACON_INT |
+		      BSS_CHANGED_MCAST_RATE;
 
 	local->fif_other_bss++;
 	/* mesh ifaces must set allmulti to forward mcast traffic */
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 6aef679..6594df0 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1971,7 +1971,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			  BSS_CHANGED_CQM |
 			  BSS_CHANGED_QOS |
 			  BSS_CHANGED_IDLE |
-			  BSS_CHANGED_TXPOWER;
+			  BSS_CHANGED_TXPOWER |
+			  BSS_CHANGED_MCAST_RATE;
 
 		if (sdata->vif.mu_mimo_owner)
 			changed |= BSS_CHANGED_MU_GROUPS;
-- 
1.9.1
