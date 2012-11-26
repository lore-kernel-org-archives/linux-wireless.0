Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35739 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab2KZNUJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 08:20:09 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 2/2] mac80211: support P2P GO powersave configuration
Date: Mon, 26 Nov 2012 14:20:30 +0100
Message-Id: <1353936030-16958-2-git-send-email-johannes@sipsolutions.net> (sfid-20121126_142016_298792_7C9FC6A8)
In-Reply-To: <1353936030-16958-1-git-send-email-johannes@sipsolutions.net>
References: <1353930289-2710-1-git-send-email-johannes@sipsolutions.net>
 <1353936030-16958-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the low-level driver wants to support P2P GO
powersave configuration, it must set the cfg80211
flags and mac80211 will pass the parameters to it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c  | 16 +++++++++++++++-
 net/mac80211/util.c |  2 +-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5d30e5f..97cf615 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -893,7 +893,8 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	u32 changed = BSS_CHANGED_BEACON_INT |
 		      BSS_CHANGED_BEACON_ENABLED |
 		      BSS_CHANGED_BEACON |
-		      BSS_CHANGED_SSID;
+		      BSS_CHANGED_SSID |
+		      BSS_CHANGED_P2P_PS;
 	int err;
 
 	old = rtnl_dereference(sdata->u.ap.beacon);
@@ -932,6 +933,9 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	sdata->vif.bss_conf.hidden_ssid =
 		(params->hidden_ssid != NL80211_HIDDEN_SSID_NOT_IN_USE);
 
+	sdata->vif.bss_conf.p2p_ctwindow = params->p2p_ctwindow;
+	sdata->vif.bss_conf.p2p_oppps = params->p2p_opp_ps;
+
 	err = ieee80211_assign_beacon(sdata, &params->beacon);
 	if (err < 0)
 		return err;
@@ -1807,6 +1811,16 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 		changed |= BSS_CHANGED_HT;
 	}
 
+	if (params->p2p_ctwindow >= 0) {
+		sdata->vif.bss_conf.p2p_ctwindow = params->p2p_ctwindow;
+		changed |= BSS_CHANGED_P2P_PS;
+	}
+
+	if (params->p2p_opp_ps >= 0) {
+		sdata->vif.bss_conf.p2p_oppps = params->p2p_opp_ps;
+		changed |= BSS_CHANGED_P2P_PS;
+	}
+
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	return 0;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index dc7f6b2..6e4c8bd 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1527,7 +1527,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			changed |= BSS_CHANGED_IBSS;
 			/* fall through */
 		case NL80211_IFTYPE_AP:
-			changed |= BSS_CHANGED_SSID;
+			changed |= BSS_CHANGED_SSID | BSS_CHANGED_P2P_PS;
 
 			if (sdata->vif.type == NL80211_IFTYPE_AP) {
 				changed |= BSS_CHANGED_AP_PROBE_RESP;
-- 
1.8.0

