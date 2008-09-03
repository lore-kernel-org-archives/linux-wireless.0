Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43814 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393AbYICDbL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:11 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 12/39] iwlwifi: use strict_strtoul instead of simple_strtoul
Date: Wed,  3 Sep 2008 11:26:32 +0800
Message-Id: <1220412419-15404-13-git-send-email-yi.zhu@intel.com> (sfid-20080903_053118_039667_031D0C81)
In-Reply-To: <1220412419-15404-12-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-10-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-11-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-12-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch makes use of strict_srtoul in sysfs code.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   49 +++++++++++++++++++++-----------
 1 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f1a5225..d436f70 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3619,11 +3619,11 @@ static ssize_t store_debug_level(struct device *d,
 				 const char *buf, size_t count)
 {
 	struct iwl_priv *priv = d->driver_data;
-	char *p = (char *)buf;
-	u32 val;
+	unsigned long val;
+	int ret;
 
-	val = simple_strtoul(p, &p, 0);
-	if (p == buf)
+	ret = strict_strtoul(buf, 0, &val);
+	if (ret)
 		printk(KERN_INFO DRV_NAME
 		       ": %s is not in hex or decimal form.\n", buf);
 	else
@@ -3695,11 +3695,11 @@ static ssize_t store_tx_power(struct device *d,
 			      const char *buf, size_t count)
 {
 	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
-	char *p = (char *)buf;
-	u32 val;
+	unsigned long val;
+	int ret;
 
-	val = simple_strtoul(p, &p, 10);
-	if (p == buf)
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret)
 		printk(KERN_INFO DRV_NAME
 		       ": %s is not in decimal form.\n", buf);
 	else
@@ -3723,7 +3723,12 @@ static ssize_t store_flags(struct device *d,
 			   const char *buf, size_t count)
 {
 	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
-	u32 flags = simple_strtoul(buf, NULL, 0);
+	unsigned long val;
+	u32 flags;
+	int ret = strict_strtoul(buf, 0, &val);
+	if (!ret)
+		return ret;
+	flags = (u32)val;
 
 	mutex_lock(&priv->mutex);
 	if (le32_to_cpu(priv->staging_rxon.flags) != flags) {
@@ -3731,8 +3736,7 @@ static ssize_t store_flags(struct device *d,
 		if (iwl_scan_cancel_timeout(priv, 100))
 			IWL_WARNING("Could not cancel scan.\n");
 		else {
-			IWL_DEBUG_INFO("Committing rxon.flags = 0x%04X\n",
-				       flags);
+			IWL_DEBUG_INFO("Commit rxon.flags = 0x%04X\n", flags);
 			priv->staging_rxon.flags = cpu_to_le32(flags);
 			iwl4965_commit_rxon(priv);
 		}
@@ -3758,7 +3762,12 @@ static ssize_t store_filter_flags(struct device *d,
 				  const char *buf, size_t count)
 {
 	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
-	u32 filter_flags = simple_strtoul(buf, NULL, 0);
+	unsigned long val;
+	u32 filter_flags;
+	int ret = strict_strtoul(buf, 0, &val);
+	if (!ret)
+		return ret;
+	filter_flags = (u32)val;
 
 	mutex_lock(&priv->mutex);
 	if (le32_to_cpu(priv->staging_rxon.filter_flags) != filter_flags) {
@@ -3859,10 +3868,12 @@ static ssize_t store_retry_rate(struct device *d,
 				const char *buf, size_t count)
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
+	long val;
+	int ret  = strict_strtol(buf, 10, &val);
+	if (!ret)
+		return ret;
 
-	priv->retry_rate = simple_strtoul(buf, NULL, 0);
-	if (priv->retry_rate <= 0)
-		priv->retry_rate = 1;
+	priv->retry_rate = (val > 0) ? val : 1;
 
 	return count;
 }
@@ -3883,9 +3894,9 @@ static ssize_t store_power_level(struct device *d,
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
 	int ret;
-	int mode;
+	unsigned long mode;
+
 
-	mode = simple_strtoul(buf, NULL, 0);
 	mutex_lock(&priv->mutex);
 
 	if (!iwl_is_ready(priv)) {
@@ -3893,6 +3904,10 @@ static ssize_t store_power_level(struct device *d,
 		goto out;
 	}
 
+	ret = strict_strtoul(buf, 10, &mode);
+	if (!ret)
+		goto out;
+
 	ret = iwl_power_set_user_mode(priv, mode);
 	if (ret) {
 		IWL_DEBUG_MAC80211("failed setting power mode.\n");
-- 
1.5.3.6

