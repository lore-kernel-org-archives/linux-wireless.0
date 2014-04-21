Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:56904 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaDUEyw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 00:54:52 -0400
Received: by mail-pb0-f54.google.com with SMTP id ma3so3358508pbc.13
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 21:54:51 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 01/12] mac80211: unify debug function
Date: Mon, 21 Apr 2014 12:52:56 +0800
Message-Id: <45c72e6eaa809929a39e4ea4c253877e761f0aa3.1398055853.git.gamerh2o@gmail.com> (sfid-20140421_065455_160632_775AE613)
In-Reply-To: <cover.1398055853.git.gamerh2o@gmail.com>
References: <cover.1398055853.git.gamerh2o@gmail.com>
In-Reply-To: <cover.1398055853.git.gamerh2o@gmail.com>
References: <cover.1398055853.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both wiphy_debug() and wiphy_dbg() are used in mac80211. Change
wiphy_debug() to wiphy_dbg() so all the debug messages can be
dynamically controled whether to be generated or not.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/mac80211/cfg.c  |  6 +++---
 net/mac80211/main.c |  8 ++++----
 net/mac80211/mlme.c | 10 +++++-----
 net/mac80211/rate.c |  4 ++--
 net/mac80211/rx.c   |  6 +++---
 net/mac80211/tx.c   |  4 ++--
 6 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index aa39381..83d9e0f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2106,9 +2106,9 @@ static int ieee80211_set_txq_params(struct wiphy *wiphy,
 
 	sdata->tx_conf[params->ac] = p;
 	if (drv_conf_tx(local, sdata, params->ac, &p)) {
-		wiphy_debug(local->hw.wiphy,
-			    "failed to set TX queue parameters for AC %d\n",
-			    params->ac);
+		wiphy_dbg(local->hw.wiphy,
+			  "failed to set TX queue parameters for AC %d\n",
+			  params->ac);
 		return -EINVAL;
 	}
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index cfc24e9..b83a913 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -994,8 +994,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	result = ieee80211_wep_init(local);
 	if (result < 0)
-		wiphy_debug(local->hw.wiphy, "Failed to initialize wep: %d\n",
-			    result);
+		wiphy_dbg(local->hw.wiphy, "Failed to initialize wep: %d\n",
+			  result);
 
 	local->hw.conf.flags = IEEE80211_CONF_IDLE;
 
@@ -1006,8 +1006,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	result = ieee80211_init_rate_ctrl_alg(local,
 					      hw->rate_control_algorithm);
 	if (result < 0) {
-		wiphy_debug(local->hw.wiphy,
-			    "Failed to initialize rate control algorithm\n");
+		wiphy_dbg(local->hw.wiphy,
+			  "Failed to initialize rate control algorithm\n");
 		goto fail_rate;
 	}
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index dee50ae..1e1bdd2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3523,11 +3523,11 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 			 * We actually lost the connection ... or did we?
 			 * Let's make sure!
 			 */
-			wiphy_debug(local->hw.wiphy,
-				    "%s: No probe response from AP %pM"
-				    " after %dms, disconnecting.\n",
-				    sdata->name,
-				    bssid, probe_wait_ms);
+			wiphy_dbg(local->hw.wiphy,
+				  "%s: No probe response from AP %pM"
+				  " after %dms, disconnecting.\n",
+				  sdata->name,
+				  bssid, probe_wait_ms);
 
 			ieee80211_sta_connection_lost(sdata, bssid,
 				WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY, false);
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 8fdadfd..b91be51 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -739,8 +739,8 @@ int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
 	WARN_ON(local->rate_ctrl);
 	local->rate_ctrl = ref;
 
-	wiphy_debug(local->hw.wiphy, "Selected rate control algorithm '%s'\n",
-		    ref->ops->name);
+	wiphy_dbg(local->hw.wiphy, "Selected rate control algorithm '%s'\n",
+		  ref->ops->name);
 
 	return 0;
 }
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 216c45b..c86a4d6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3176,9 +3176,9 @@ static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
 		skb = skb_copy(skb, GFP_ATOMIC);
 		if (!skb) {
 			if (net_ratelimit())
-				wiphy_debug(local->hw.wiphy,
-					"failed to copy skb for %s\n",
-					sdata->name);
+				wiphy_dbg(local->hw.wiphy,
+					  "failed to copy skb for %s\n",
+					  sdata->name);
 			return true;
 		}
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 19d36d4..48650da 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1483,8 +1483,8 @@ static int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
 		return 0;
 
 	if (pskb_expand_head(skb, head_need, tail_need, GFP_ATOMIC)) {
-		wiphy_debug(local->hw.wiphy,
-			    "failed to reallocate TX buffer\n");
+		wiphy_dbg(local->hw.wiphy,
+			  "failed to reallocate TX buffer\n");
 		return -ENOMEM;
 	}
 
-- 
1.9.0

