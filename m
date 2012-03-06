Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58272 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031491Ab2CFWng (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 17:43:36 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 19/33] iwlwifi: use watchdog timeout from hw_params
Date: Tue,  6 Mar 2012 13:30:54 -0800
Message-Id: <1331069468-11074-20-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120306_234353_323766_8732C2C4)
In-Reply-To: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is the version that can be modified, the
config params should be read-only.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c    |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 95ffa01..71c5621 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1340,7 +1340,7 @@ void iwl_bg_watchdog(unsigned long data)
 	if (iwl_is_rfkill(priv->shrd))
 		return;
 
-	timeout = cfg(priv)->base_params->wd_timeout;
+	timeout = hw_params(priv).wd_timeout;
 	if (timeout == 0)
 		return;
 
@@ -1366,7 +1366,7 @@ void iwl_bg_watchdog(unsigned long data)
 
 void iwl_setup_watchdog(struct iwl_priv *priv)
 {
-	unsigned int timeout = cfg(priv)->base_params->wd_timeout;
+	unsigned int timeout = hw_params(priv).wd_timeout;
 
 	if (!iwlagn_mod_params.wd_disable) {
 		/* use system default */
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 04eb8d3..b729128 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2368,7 +2368,7 @@ static ssize_t iwl_dbgfs_wd_timeout_write(struct file *file,
 	if (timeout < 0 || timeout > IWL_MAX_WD_TIMEOUT)
 		timeout = IWL_DEF_WD_TIMEOUT;
 
-	cfg(priv)->base_params->wd_timeout = timeout;
+	hw_params(priv).wd_timeout = timeout;
 	iwl_setup_watchdog(priv);
 	return count;
 }
-- 
1.7.0.4

