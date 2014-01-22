Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40332 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaAVKfE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 05:35:04 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7/7] mac80211: remove module handling from rate control ops
Date: Wed, 22 Jan 2014 11:34:58 +0100
Message-Id: <1390386898-14316-8-git-send-email-johannes@sipsolutions.net> (sfid-20140122_113517_495432_B5F81993)
In-Reply-To: <1390386898-14316-1-git-send-email-johannes@sipsolutions.net>
References: <1390386898-14316-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's not a single rate control algorithm actually in
a separate module where the module refcount would be
required. Similarly, there's no specific rate control
module.

Therefore, all the module handling code in rate control
is really just dead code, so remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath9k/rc.c     |  1 -
 drivers/net/wireless/iwlegacy/3945-rs.c |  1 -
 drivers/net/wireless/iwlegacy/4965-rs.c |  1 -
 drivers/net/wireless/iwlwifi/dvm/rs.c   |  1 -
 drivers/net/wireless/iwlwifi/mvm/rs.c   |  1 -
 drivers/net/wireless/rtlwifi/rc.c       |  1 -
 include/net/mac80211.h                  |  1 -
 net/mac80211/rate.c                     | 29 +++++++----------------------
 8 files changed, 7 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 1219532..7b5afee 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1467,7 +1467,6 @@ static void ath_rate_free_sta(void *priv, struct ieee80211_sta *sta,
 }
 
 static const struct rate_control_ops ath_rate_ops = {
-	.module = NULL,
 	.name = "ath9k_rate_control",
 	.tx_status = ath_tx_status,
 	.get_rate = ath_get_rate,
diff --git a/drivers/net/wireless/iwlegacy/3945-rs.c b/drivers/net/wireless/iwlegacy/3945-rs.c
index c81fb72..8543265 100644
--- a/drivers/net/wireless/iwlegacy/3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/3945-rs.c
@@ -893,7 +893,6 @@ il3945_rs_rate_init_stub(void *il_r, struct ieee80211_supported_band *sband,
 }
 
 static const struct rate_control_ops rs_ops = {
-	.module = NULL,
 	.name = RS_NAME,
 	.tx_status = il3945_rs_tx_status,
 	.get_rate = il3945_rs_get_rate,
diff --git a/drivers/net/wireless/iwlegacy/4965-rs.c b/drivers/net/wireless/iwlegacy/4965-rs.c
index 5959031..5d44b2e 100644
--- a/drivers/net/wireless/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -2809,7 +2809,6 @@ il4965_rs_rate_init_stub(void *il_r, struct ieee80211_supported_band *sband,
 }
 
 static const struct rate_control_ops rs_4965_ops = {
-	.module = NULL,
 	.name = IL4965_RS_NAME,
 	.tx_status = il4965_rs_tx_status,
 	.get_rate = il4965_rs_get_rate,
diff --git a/drivers/net/wireless/iwlwifi/dvm/rs.c b/drivers/net/wireless/iwlwifi/dvm/rs.c
index 77c050e..90a4369 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.c
@@ -3322,7 +3322,6 @@ static void rs_rate_init_stub(void *priv_r, struct ieee80211_supported_band *sba
 }
 
 static const struct rate_control_ops rs_ops = {
-	.module = NULL,
 	.name = RS_NAME,
 	.tx_status = rs_tx_status,
 	.get_rate = rs_get_rate,
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 3f880e2..28c87ac 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2804,7 +2804,6 @@ static void rs_rate_init_stub(void *mvm_r,
 }
 
 static const struct rate_control_ops rs_mvm_ops = {
-	.module = NULL,
 	.name = RS_NAME,
 	.tx_status = rs_tx_status,
 	.get_rate = rs_get_rate,
diff --git a/drivers/net/wireless/rtlwifi/rc.c b/drivers/net/wireless/rtlwifi/rc.c
index 1503d9e..ee28a1a 100644
--- a/drivers/net/wireless/rtlwifi/rc.c
+++ b/drivers/net/wireless/rtlwifi/rc.c
@@ -261,7 +261,6 @@ static void rtl_rate_free_sta(void *rtlpriv,
 }
 
 static const struct rate_control_ops rtl_rate_ops = {
-	.module = NULL,
 	.name = "rtl_rc",
 	.alloc = rtl_rate_alloc,
 	.free = rtl_rate_free,
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0c2676e..f844770 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4453,7 +4453,6 @@ struct ieee80211_tx_rate_control {
 };
 
 struct rate_control_ops {
-	struct module *module;
 	const char *name;
 	void *(*alloc)(struct ieee80211_hw *hw, struct dentry *debugfsdir);
 	void (*free)(void *priv);
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 255b59e..2ac4684 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -10,8 +10,8 @@
 
 #include <linux/kernel.h>
 #include <linux/rtnetlink.h>
-#include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include "rate.h"
 #include "ieee80211_i.h"
 #include "debugfs.h"
@@ -88,10 +88,8 @@ ieee80211_try_rate_control_ops_get(const char *name)
 	mutex_lock(&rate_ctrl_mutex);
 	list_for_each_entry(alg, &rate_ctrl_algs, list) {
 		if (!strcmp(alg->ops->name, name))
-			if (try_module_get(alg->ops->module)) {
-				ops = alg->ops;
-				break;
-			}
+			ops = alg->ops;
+			break;
 	}
 	mutex_unlock(&rate_ctrl_mutex);
 	return ops;
@@ -111,10 +109,6 @@ ieee80211_rate_control_ops_get(const char *name)
 		alg_name = name;
 
 	ops = ieee80211_try_rate_control_ops_get(alg_name);
-	if (!ops) {
-		request_module("rc80211_%s", alg_name);
-		ops = ieee80211_try_rate_control_ops_get(alg_name);
-	}
 	if (!ops && name)
 		/* try default if specific alg requested but not found */
 		ops = ieee80211_try_rate_control_ops_get(ieee80211_default_rc_algo);
@@ -127,11 +121,6 @@ ieee80211_rate_control_ops_get(const char *name)
 	return ops;
 }
 
-static void ieee80211_rate_control_ops_put(const struct rate_control_ops *ops)
-{
-	module_put(ops->module);
-}
-
 #ifdef CONFIG_MAC80211_DEBUGFS
 static ssize_t rcname_read(struct file *file, char __user *userbuf,
 			   size_t count, loff_t *ppos)
@@ -158,11 +147,11 @@ static struct rate_control_ref *rate_control_alloc(const char *name,
 
 	ref = kmalloc(sizeof(struct rate_control_ref), GFP_KERNEL);
 	if (!ref)
-		goto fail_ref;
+		return NULL;
 	ref->local = local;
 	ref->ops = ieee80211_rate_control_ops_get(name);
 	if (!ref->ops)
-		goto fail_ops;
+		goto free;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	debugfsdir = debugfs_create_dir("rc", local->hw.wiphy->debugfsdir);
@@ -172,14 +161,11 @@ static struct rate_control_ref *rate_control_alloc(const char *name,
 
 	ref->priv = ref->ops->alloc(&local->hw, debugfsdir);
 	if (!ref->priv)
-		goto fail_priv;
+		goto free;
 	return ref;
 
-fail_priv:
-	ieee80211_rate_control_ops_put(ref->ops);
-fail_ops:
+free:
 	kfree(ref);
-fail_ref:
 	return NULL;
 }
 
@@ -192,7 +178,6 @@ static void rate_control_free(struct rate_control_ref *ctrl_ref)
 	ctrl_ref->local->debugfs.rcdir = NULL;
 #endif
 
-	ieee80211_rate_control_ops_put(ctrl_ref->ops);
 	kfree(ctrl_ref);
 }
 
-- 
1.8.5.1

