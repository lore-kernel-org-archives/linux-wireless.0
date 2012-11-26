Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35482 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab2KZLoY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 06:44:24 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: support P2P GO powersave configuration
Date: Mon, 26 Nov 2012 12:44:49 +0100
Message-Id: <1353930289-2710-3-git-send-email-johannes@sipsolutions.net> (sfid-20121126_124429_345320_69BD38C6)
In-Reply-To: <1353930289-2710-1-git-send-email-johannes@sipsolutions.net>
References: <1353930289-2710-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the low-level driver wants to support P2P GO
powersave configuration, it must set the cfg80211
flags and mac80211 will pass the parameters to it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

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
-- 
1.8.0

