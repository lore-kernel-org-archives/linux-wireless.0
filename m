Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:56691 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333AbaDQN2D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 09:28:03 -0400
Received: by mail-pb0-f54.google.com with SMTP id ma3so382313pbc.27
        for <linux-wireless@vger.kernel.org>; Thu, 17 Apr 2014 06:28:02 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 5/6] mac80211: replace wiphy_debug() with wiphy_dbg()
Date: Thu, 17 Apr 2014 21:27:13 +0800
Message-Id: <b3169c1d090d6e5b97ff397585dcea6d548227b3.1397741141.git.gamerh2o@gmail.com> (sfid-20140417_152807_896230_D0C96462)
In-Reply-To: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com>
References: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com>
In-Reply-To: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com>
References: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dynamic debug function wiphy_dbg() is more convenient for debugging,
and if user doesn't enable CONFIG_DYNAMIC_DEBUG, it will fall back to
normal static debug, just as what wiphy_debug() does.

When all the users of wiphy_debug() are gone, wiphy_debug() can be
removed.

Cc: Johannes Berg <johannes@sipsolutions.net>
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
index aaa59d7..4ac047e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2097,9 +2097,9 @@ static int ieee80211_set_txq_params(struct wiphy *wiphy,
 
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
index b055f6a5..aed2f5d 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -993,8 +993,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	result = ieee80211_wep_init(local);
 	if (result < 0)
-		wiphy_debug(local->hw.wiphy, "Failed to initialize wep: %d\n",
-			    result);
+		wiphy_dbg(local->hw.wiphy, "Failed to initialize wep: %d\n",
+			  result);
 
 	local->hw.conf.flags = IEEE80211_CONF_IDLE;
 
@@ -1005,8 +1005,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
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

