Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab3B1ItQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 03:49:16 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/2] mac80211: remove napi
Date: Thu, 28 Feb 2013 09:49:11 +0100
Message-Id: <1362041352-13110-1-git-send-email-sgruszka@redhat.com> (sfid-20130228_094919_248398_E8406604)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since two years no mac80211 driver implement support for NAPI. Looks
this feature is unneeded, so remove it from generic mac80211 code.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/ieee80211_i.h |  5 -----
 net/mac80211/iface.c       |  4 ----
 net/mac80211/main.c        | 30 ------------------------------
 3 files changed, 39 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6f3258a..8d9b45c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1127,11 +1127,6 @@ struct ieee80211_local {
 
 	struct ieee80211_sub_if_data __rcu *p2p_sdata;
 
-	/* dummy netdev for use w/ NAPI */
-	struct net_device napi_dev;
-
-	struct napi_struct napi;
-
 	/* virtual monitor interface */
 	struct ieee80211_sub_if_data __rcu *monitor_sdata;
 	struct cfg80211_chan_def monitor_chandef;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 2c059e5..e7f2d57 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -485,8 +485,6 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 		res = drv_start(local);
 		if (res)
 			goto err_del_bss;
-		if (local->ops->napi_poll)
-			napi_enable(&local->napi);
 		/* we're brought up, everything changes */
 		hw_reconf_flags = ~0;
 		ieee80211_led_radio(local, true);
@@ -851,8 +849,6 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	ieee80211_recalc_ps(local, -1);
 
 	if (local->open_count == 0) {
-		if (local->ops->napi_poll)
-			napi_disable(&local->napi);
 		ieee80211_clear_tx_pending(local);
 		ieee80211_stop_device(local);
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d0dd111..c10bf4d 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -399,30 +399,6 @@ static int ieee80211_ifa6_changed(struct notifier_block *nb,
 }
 #endif
 
-static int ieee80211_napi_poll(struct napi_struct *napi, int budget)
-{
-	struct ieee80211_local *local =
-		container_of(napi, struct ieee80211_local, napi);
-
-	return local->ops->napi_poll(&local->hw, budget);
-}
-
-void ieee80211_napi_schedule(struct ieee80211_hw *hw)
-{
-	struct ieee80211_local *local = hw_to_local(hw);
-
-	napi_schedule(&local->napi);
-}
-EXPORT_SYMBOL(ieee80211_napi_schedule);
-
-void ieee80211_napi_complete(struct ieee80211_hw *hw)
-{
-	struct ieee80211_local *local = hw_to_local(hw);
-
-	napi_complete(&local->napi);
-}
-EXPORT_SYMBOL(ieee80211_napi_complete);
-
 /* There isn't a lot of sense in it, but you can transmit anything you like */
 static const struct ieee80211_txrx_stypes
 ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
@@ -666,9 +642,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	skb_queue_head_init(&local->skb_queue);
 	skb_queue_head_init(&local->skb_queue_unreliable);
 
-	/* init dummy netdev for use w/ NAPI */
-	init_dummy_netdev(&local->napi_dev);
-
 	ieee80211_led_names(local);
 
 	ieee80211_roc_setup(local);
@@ -1023,9 +996,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		goto fail_ifa6;
 #endif
 
-	netif_napi_add(&local->napi_dev, &local->napi, ieee80211_napi_poll,
-			local->hw.napi_weight);
-
 	return 0;
 
 #if IS_ENABLED(CONFIG_IPV6)
-- 
1.7.11.7

