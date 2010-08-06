Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55956 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab0HFOSE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 10:18:04 -0400
Subject: [PATCH 2.6.36] iwlwifi: fix locking assertions
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Thomas Meyer <thomas@m3y3r.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Wey-Yi W Guy <wey-yi.w.guy@intel.com>,
	"Zhao, Shanyu" <shanyu.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 16:17:53 +0200
Message-ID: <1281104273.3853.504.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

spin_is_locked() can return zero on some (UP?)
configurations because locks don't exist, and
that causes an endless amount of warnings. Use
lockdep_assert_held() instead, which has two
advantages:
 1) it verifies the current task is holding
    the lock or mutex
 2) it compiles away completely when lockdep
    is not enabled

Cc: stable@kernel.org [2.6.34+, maybe only parts of patch]
Reported-by: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c     |    6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn-lib.c	2010-07-27 09:50:28.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn-lib.c	2010-08-06 16:12:24.000000000 +0200
@@ -1429,7 +1429,7 @@ int iwlagn_manage_ibss_station(struct iw
 void iwl_free_tfds_in_queue(struct iwl_priv *priv,
 			    int sta_id, int tid, int freed)
 {
-	WARN_ON(!spin_is_locked(&priv->sta_lock));
+	lockdep_assert_held(&priv->sta_lock);
 
 	if (priv->stations[sta_id].tid[tid].tfds_in_queue >= freed)
 		priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn-tx.c	2010-08-05 23:30:25.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn-tx.c	2010-08-06 16:12:24.000000000 +0200
@@ -1117,7 +1117,7 @@ int iwlagn_txq_check_empty(struct iwl_pr
 	u8 *addr = priv->stations[sta_id].sta.sta.addr;
 	struct iwl_tid_data *tid_data = &priv->stations[sta_id].tid[tid];
 
-	WARN_ON(!spin_is_locked(&priv->sta_lock));
+	lockdep_assert_held(&priv->sta_lock);
 
 	switch (priv->stations[sta_id].tid[tid].agg.state) {
 	case IWL_EMPTYING_HW_QUEUE_DELBA:
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-scan.c	2010-07-30 08:43:30.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-scan.c	2010-08-06 16:12:24.000000000 +0200
@@ -298,7 +298,7 @@ EXPORT_SYMBOL(iwl_init_scan_params);
 
 static int iwl_scan_initiate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
-	WARN_ON(!mutex_is_locked(&priv->mutex));
+	lockdep_assert_held(&priv->mutex);
 
 	IWL_DEBUG_INFO(priv, "Starting scan...\n");
 	set_bit(STATUS_SCANNING, &priv->status);
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-sta.c	2010-08-05 23:30:25.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-sta.c	2010-08-06 16:12:24.000000000 +0200
@@ -773,7 +773,7 @@ static int iwl_send_static_wepkey_cmd(st
 
 int iwl_restore_default_wep_keys(struct iwl_priv *priv)
 {
-	WARN_ON(!mutex_is_locked(&priv->mutex));
+	lockdep_assert_held(&priv->mutex);
 
 	return iwl_send_static_wepkey_cmd(priv, 0);
 }
@@ -784,7 +784,7 @@ int iwl_remove_default_wep_key(struct iw
 {
 	int ret;
 
-	WARN_ON(!mutex_is_locked(&priv->mutex));
+	lockdep_assert_held(&priv->mutex);
 
 	IWL_DEBUG_WEP(priv, "Removing default WEP key: idx=%d\n",
 		      keyconf->keyidx);
@@ -808,7 +808,7 @@ int iwl_set_default_wep_key(struct iwl_p
 {
 	int ret;
 
-	WARN_ON(!mutex_is_locked(&priv->mutex));
+	lockdep_assert_held(&priv->mutex);
 
 	if (keyconf->keylen != WEP_KEY_LEN_128 &&
 	    keyconf->keylen != WEP_KEY_LEN_64) {


