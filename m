Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40320 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbaAVKfD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 05:35:03 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/7] mac80211: make rate control ops const
Date: Wed, 22 Jan 2014 11:34:52 +0100
Message-Id: <1390386898-14316-2-git-send-email-johannes@sipsolutions.net> (sfid-20140122_113530_623950_4842D0DB)
In-Reply-To: <1390386898-14316-1-git-send-email-johannes@sipsolutions.net>
References: <1390386898-14316-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Change the code to allow making all the rate control ops
const, nothing ever needs to change them. Also change all
drivers to make use of this and mark the ops const.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath9k/rc.c     |  2 +-
 drivers/net/wireless/iwlegacy/3945-rs.c |  2 +-
 drivers/net/wireless/iwlegacy/4965-rs.c |  2 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c   |  3 ++-
 drivers/net/wireless/iwlwifi/mvm/rs.c   |  3 ++-
 drivers/net/wireless/rtlwifi/rc.c       |  2 +-
 include/net/mac80211.h                  |  4 ++--
 net/mac80211/rate.c                     | 16 ++++++++--------
 net/mac80211/rate.h                     |  2 +-
 net/mac80211/rc80211_minstrel.c         |  2 +-
 net/mac80211/rc80211_minstrel.h         |  2 +-
 net/mac80211/rc80211_minstrel_ht.c      |  2 +-
 net/mac80211/rc80211_pid_algo.c         |  2 +-
 13 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index d829bb6..1219532 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1466,7 +1466,7 @@ static void ath_rate_free_sta(void *priv, struct ieee80211_sta *sta,
 	kfree(rate_priv);
 }
 
-static struct rate_control_ops ath_rate_ops = {
+static const struct rate_control_ops ath_rate_ops = {
 	.module = NULL,
 	.name = "ath9k_rate_control",
 	.tx_status = ath_tx_status,
diff --git a/drivers/net/wireless/iwlegacy/3945-rs.c b/drivers/net/wireless/iwlegacy/3945-rs.c
index aea667b..c81fb72 100644
--- a/drivers/net/wireless/iwlegacy/3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/3945-rs.c
@@ -892,7 +892,7 @@ il3945_rs_rate_init_stub(void *il_r, struct ieee80211_supported_band *sband,
 {
 }
 
-static struct rate_control_ops rs_ops = {
+static const struct rate_control_ops rs_ops = {
 	.module = NULL,
 	.name = RS_NAME,
 	.tx_status = il3945_rs_tx_status,
diff --git a/drivers/net/wireless/iwlegacy/4965-rs.c b/drivers/net/wireless/iwlegacy/4965-rs.c
index 3ccbaf7..5959031 100644
--- a/drivers/net/wireless/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -2808,7 +2808,7 @@ il4965_rs_rate_init_stub(void *il_r, struct ieee80211_supported_band *sband,
 {
 }
 
-static struct rate_control_ops rs_4965_ops = {
+static const struct rate_control_ops rs_4965_ops = {
 	.module = NULL,
 	.name = IL4965_RS_NAME,
 	.tx_status = il4965_rs_tx_status,
diff --git a/drivers/net/wireless/iwlwifi/dvm/rs.c b/drivers/net/wireless/iwlwifi/dvm/rs.c
index b647e50..77c050e 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.c
@@ -3320,7 +3320,8 @@ static void rs_rate_init_stub(void *priv_r, struct ieee80211_supported_band *sba
 			      struct ieee80211_sta *sta, void *priv_sta)
 {
 }
-static struct rate_control_ops rs_ops = {
+
+static const struct rate_control_ops rs_ops = {
 	.module = NULL,
 	.name = RS_NAME,
 	.tx_status = rs_tx_status,
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index bf6e29f..3f880e2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2802,7 +2802,8 @@ static void rs_rate_init_stub(void *mvm_r,
 			      struct ieee80211_sta *sta, void *mvm_sta)
 {
 }
-static struct rate_control_ops rs_mvm_ops = {
+
+static const struct rate_control_ops rs_mvm_ops = {
 	.module = NULL,
 	.name = RS_NAME,
 	.tx_status = rs_tx_status,
diff --git a/drivers/net/wireless/rtlwifi/rc.c b/drivers/net/wireless/rtlwifi/rc.c
index a98acef..1503d9e 100644
--- a/drivers/net/wireless/rtlwifi/rc.c
+++ b/drivers/net/wireless/rtlwifi/rc.c
@@ -260,7 +260,7 @@ static void rtl_rate_free_sta(void *rtlpriv,
 	kfree(rate_priv);
 }
 
-static struct rate_control_ops rtl_rate_ops = {
+static const struct rate_control_ops rtl_rate_ops = {
 	.module = NULL,
 	.name = "rtl_rc",
 	.alloc = rtl_rate_alloc,
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index df1004b..0c2676e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4555,8 +4555,8 @@ int rate_control_set_rates(struct ieee80211_hw *hw,
 			   struct ieee80211_sta *pubsta,
 			   struct ieee80211_sta_rates *rates);
 
-int ieee80211_rate_control_register(struct rate_control_ops *ops);
-void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
+int ieee80211_rate_control_register(const struct rate_control_ops *ops);
+void ieee80211_rate_control_unregister(const struct rate_control_ops *ops);
 
 static inline bool
 conf_is_ht20(struct ieee80211_conf *conf)
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 22b223f..255b59e 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -18,7 +18,7 @@
 
 struct rate_control_alg {
 	struct list_head list;
-	struct rate_control_ops *ops;
+	const struct rate_control_ops *ops;
 };
 
 static LIST_HEAD(rate_ctrl_algs);
@@ -29,7 +29,7 @@ module_param(ieee80211_default_rc_algo, charp, 0644);
 MODULE_PARM_DESC(ieee80211_default_rc_algo,
 		 "Default rate control algorithm for mac80211 to use");
 
-int ieee80211_rate_control_register(struct rate_control_ops *ops)
+int ieee80211_rate_control_register(const struct rate_control_ops *ops)
 {
 	struct rate_control_alg *alg;
 
@@ -60,7 +60,7 @@ int ieee80211_rate_control_register(struct rate_control_ops *ops)
 }
 EXPORT_SYMBOL(ieee80211_rate_control_register);
 
-void ieee80211_rate_control_unregister(struct rate_control_ops *ops)
+void ieee80211_rate_control_unregister(const struct rate_control_ops *ops)
 {
 	struct rate_control_alg *alg;
 
@@ -76,11 +76,11 @@ void ieee80211_rate_control_unregister(struct rate_control_ops *ops)
 }
 EXPORT_SYMBOL(ieee80211_rate_control_unregister);
 
-static struct rate_control_ops *
+static const struct rate_control_ops *
 ieee80211_try_rate_control_ops_get(const char *name)
 {
 	struct rate_control_alg *alg;
-	struct rate_control_ops *ops = NULL;
+	const struct rate_control_ops *ops = NULL;
 
 	if (!name)
 		return NULL;
@@ -98,10 +98,10 @@ ieee80211_try_rate_control_ops_get(const char *name)
 }
 
 /* Get the rate control algorithm. */
-static struct rate_control_ops *
+static const struct rate_control_ops *
 ieee80211_rate_control_ops_get(const char *name)
 {
-	struct rate_control_ops *ops;
+	const struct rate_control_ops *ops;
 	const char *alg_name;
 
 	kparam_block_sysfs_write(ieee80211_default_rc_algo);
@@ -127,7 +127,7 @@ ieee80211_rate_control_ops_get(const char *name)
 	return ops;
 }
 
-static void ieee80211_rate_control_ops_put(struct rate_control_ops *ops)
+static void ieee80211_rate_control_ops_put(const struct rate_control_ops *ops)
 {
 	module_put(ops->module);
 }
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index b95e16c..9aa2a11 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -21,7 +21,7 @@
 
 struct rate_control_ref {
 	struct ieee80211_local *local;
-	struct rate_control_ops *ops;
+	const struct rate_control_ops *ops;
 	void *priv;
 };
 
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index f3d88b0..26fd94f 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -657,7 +657,7 @@ minstrel_free(void *priv)
 	kfree(priv);
 }
 
-struct rate_control_ops mac80211_minstrel = {
+const struct rate_control_ops mac80211_minstrel = {
 	.name = "minstrel",
 	.tx_status = minstrel_tx_status,
 	.get_rate = minstrel_get_rate,
diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index f4301f4..046d1bd 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -123,7 +123,7 @@ struct minstrel_debugfs_info {
 	char buf[];
 };
 
-extern struct rate_control_ops mac80211_minstrel;
+extern const struct rate_control_ops mac80211_minstrel;
 void minstrel_add_sta_debugfs(void *priv, void *priv_sta, struct dentry *dir);
 void minstrel_remove_sta_debugfs(void *priv, void *priv_sta);
 
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index c1b5b73..a6d6cc5 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1031,7 +1031,7 @@ minstrel_ht_free(void *priv)
 	mac80211_minstrel.free(priv);
 }
 
-static struct rate_control_ops mac80211_minstrel_ht = {
+static const struct rate_control_ops mac80211_minstrel_ht = {
 	.name = "minstrel_ht",
 	.tx_status = minstrel_ht_tx_status,
 	.get_rate = minstrel_ht_get_rate,
diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_algo.c
index 958fad0..d0da2a7 100644
--- a/net/mac80211/rc80211_pid_algo.c
+++ b/net/mac80211/rc80211_pid_algo.c
@@ -452,7 +452,7 @@ static void rate_control_pid_free_sta(void *priv, struct ieee80211_sta *sta,
 	kfree(priv_sta);
 }
 
-static struct rate_control_ops mac80211_rcpid = {
+static const struct rate_control_ops mac80211_rcpid = {
 	.name = "pid",
 	.tx_status = rate_control_pid_tx_status,
 	.get_rate = rate_control_pid_get_rate,
-- 
1.8.5.1

