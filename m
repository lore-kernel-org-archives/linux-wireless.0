Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58368 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbYJPOzb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2008 10:55:31 -0400
Subject: [PATCH] mac80211: remove rate_control_clear
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Julia Lawall <julia@diku.dk>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 16 Oct 2008 11:21:49 +0200
Message-Id: <1224148909.735.54.camel@johannes.berg> (sfid-20081016_165536_926860_99A51E64)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Clearing" the rate control algorithm is pointless, none of
the algorithms actually uses this operation and it's not even
invoked properly for all channel switching. Also, there's no
need to since rate control algorithms work per station.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Partially done with this spatch:

@ rule1 @
identifier X, Y;
@@
 struct rate_control_ops X = {
-.clear = Y,
};

@@
identifier rule1.Y;
identifier Z;
@@
- void Y(void *Z) { ... }

but that didn't remove the spurious whitespace (expected) nor
the #ifdef and comments within the function (unexpected to me),
it looked like this:

-static void rs_clear(void *priv_rate)
-{
 #ifdef CONFIG_IWLWIFI_DEBUG
-       struct iwl_priv *priv = (struct iwl_priv *) priv_rate;
 
-       IWL_DEBUG_RATE("enter\n");
 
        /* TODO - add rate scale state reset */
 
-       IWL_DEBUG_RATE("leave\n");
 #endif /* CONFIG_IWLWIFI_DEBUG */
-}
+

 drivers/net/wireless/ath9k/rc.c            |    6 ------
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |    7 -------
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |   14 --------------
 include/net/mac80211.h                     |    1 -
 net/mac80211/rate.h                        |    6 ------
 net/mac80211/rc80211_minstrel.c            |    6 ------
 net/mac80211/rc80211_pid_algo.c            |    5 -----
 net/mac80211/util.c                        |    2 --
 8 files changed, 47 deletions(-)

--- everything.orig/drivers/net/wireless/ath9k/rc.c	2008-10-15 08:34:23.000000000 +0200
+++ everything/drivers/net/wireless/ath9k/rc.c	2008-10-16 11:12:42.000000000 +0200
@@ -2039,11 +2039,6 @@ static void ath_rate_init(void *priv, st
 	ath_rc_node_update(sc->hw, priv_sta);
 }
 
-static void ath_rate_clear(void *priv)
-{
-	return;
-}
-
 static void *ath_rate_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
 {
 	struct ath_softc *sc = hw->priv;
@@ -2093,7 +2088,6 @@ static struct rate_control_ops ath_rate_
 	.tx_status = ath_tx_status,
 	.get_rate = ath_get_rate,
 	.rate_init = ath_rate_init,
-	.clear = ath_rate_clear,
 	.alloc = ath_rate_alloc,
 	.free = ath_rate_free,
 	.alloc_sta = ath_rate_alloc_sta,
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-10-15 08:34:19.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-10-16 11:13:12.000000000 +0200
@@ -355,12 +355,6 @@ static void rs_free(void *priv)
 	return;
 }
 
-static void rs_clear(void *priv)
-{
-	return;
-}
-
-
 static void *rs_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
 {
 	struct iwl3945_rs_sta *rs_sta;
@@ -785,7 +779,6 @@ static struct rate_control_ops rs_ops = 
 	.tx_status = rs_tx_status,
 	.get_rate = rs_get_rate,
 	.rate_init = rs_rate_init,
-	.clear = rs_clear,
 	.alloc = rs_alloc,
 	.free = rs_free,
 	.alloc_sta = rs_alloc_sta,
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2008-10-15 08:34:23.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2008-10-16 11:11:58.000000000 +0200
@@ -2399,19 +2399,6 @@ static void rs_free(void *priv_rate)
 	return;
 }
 
-static void rs_clear(void *priv_rate)
-{
-#ifdef CONFIG_IWLWIFI_DEBUG
-	struct iwl_priv *priv = (struct iwl_priv *) priv_rate;
-
-	IWL_DEBUG_RATE("enter\n");
-
-	/* TODO - add rate scale state reset */
-
-	IWL_DEBUG_RATE("leave\n");
-#endif /* CONFIG_IWLWIFI_DEBUG */
-}
-
 static void rs_free_sta(void *priv_r, struct ieee80211_sta *sta,
 			void *priv_sta)
 {
@@ -2599,7 +2586,6 @@ static struct rate_control_ops rs_ops = 
 	.tx_status = rs_tx_status,
 	.get_rate = rs_get_rate,
 	.rate_init = rs_rate_init,
-	.clear = rs_clear,
 	.alloc = rs_alloc,
 	.free = rs_free,
 	.alloc_sta = rs_alloc_sta,
--- everything.orig/net/mac80211/rc80211_minstrel.c	2008-10-15 08:34:19.000000000 +0200
+++ everything/net/mac80211/rc80211_minstrel.c	2008-10-16 11:13:29.000000000 +0200
@@ -486,11 +486,6 @@ minstrel_free_sta(void *priv, struct iee
 	kfree(mi);
 }
 
-static void
-minstrel_clear(void *priv)
-{
-}
-
 static void *
 minstrel_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
 {
@@ -544,7 +539,6 @@ static struct rate_control_ops mac80211_
 	.tx_status = minstrel_tx_status,
 	.get_rate = minstrel_get_rate,
 	.rate_init = minstrel_rate_init,
-	.clear = minstrel_clear,
 	.alloc = minstrel_alloc,
 	.free = minstrel_free,
 	.alloc_sta = minstrel_alloc_sta,
--- everything.orig/net/mac80211/rc80211_pid_algo.c	2008-10-15 08:34:19.000000000 +0200
+++ everything/net/mac80211/rc80211_pid_algo.c	2008-10-16 11:13:39.000000000 +0200
@@ -446,10 +446,6 @@ static void rate_control_pid_free(void *
 	kfree(pinfo);
 }
 
-static void rate_control_pid_clear(void *priv)
-{
-}
-
 static void *rate_control_pid_alloc_sta(void *priv, struct ieee80211_sta *sta,
 					gfp_t gfp)
 {
@@ -480,7 +476,6 @@ static struct rate_control_ops mac80211_
 	.tx_status = rate_control_pid_tx_status,
 	.get_rate = rate_control_pid_get_rate,
 	.rate_init = rate_control_pid_rate_init,
-	.clear = rate_control_pid_clear,
 	.alloc = rate_control_pid_alloc,
 	.free = rate_control_pid_free,
 	.alloc_sta = rate_control_pid_alloc_sta,
--- everything.orig/include/net/mac80211.h	2008-10-16 11:11:19.000000000 +0200
+++ everything/include/net/mac80211.h	2008-10-16 11:11:26.000000000 +0200
@@ -1919,7 +1919,6 @@ struct rate_control_ops {
 	struct module *module;
 	const char *name;
 	void *(*alloc)(struct ieee80211_hw *hw, struct dentry *debugfsdir);
-	void (*clear)(void *priv);
 	void (*free)(void *priv);
 
 	void *(*alloc_sta)(void *priv, struct ieee80211_sta *sta, gfp_t gfp);
--- everything.orig/net/mac80211/rate.h	2008-10-16 11:11:12.000000000 +0200
+++ everything/net/mac80211/rate.h	2008-10-16 11:11:16.000000000 +0200
@@ -63,12 +63,6 @@ static inline void rate_control_rate_ini
 }
 
 
-static inline void rate_control_clear(struct ieee80211_local *local)
-{
-	struct rate_control_ref *ref = local->rate_ctrl;
-	ref->ops->clear(ref->priv);
-}
-
 static inline void *rate_control_alloc_sta(struct rate_control_ref *ref,
 					   struct ieee80211_sta *sta,
 					   gfp_t gfp)
--- everything.orig/net/mac80211/util.c	2008-10-16 11:11:42.000000000 +0200
+++ everything/net/mac80211/util.c	2008-10-16 11:11:45.000000000 +0200
@@ -647,8 +647,6 @@ int ieee80211_set_freq(struct ieee80211_
 		else
 			ret = ieee80211_hw_config(
 				local, IEEE80211_CONF_CHANGE_CHANNEL);
-
-		rate_control_clear(local);
 	}
 
 	return ret;


