Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37081 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbYLVDit (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 22:38:49 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 08/10] iwlwifi: kill retry_rate sysfs for iwlagn
Date: Mon, 22 Dec 2008 11:31:21 +0800
Message-Id: <1229916683-9772-9-git-send-email-yi.zhu@intel.com> (sfid-20081222_043857_492228_E745AF2E)
In-Reply-To: <1229916683-9772-8-git-send-email-yi.zhu@intel.com>
References: <1229916683-9772-1-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-2-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-3-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-4-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-5-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-6-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-7-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-8-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch kills retry_rate in sysfs for iwlagn. It's not used.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   26 --------------------------
 drivers/net/wireless/iwlwifi/iwl-core.c |    1 -
 2 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ecf8141..002a151 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3540,31 +3540,6 @@ static ssize_t store_filter_flags(struct device *d,
 static DEVICE_ATTR(filter_flags, S_IWUSR | S_IRUGO, show_filter_flags,
 		   store_filter_flags);
 
-static ssize_t store_retry_rate(struct device *d,
-				struct device_attribute *attr,
-				const char *buf, size_t count)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	long val;
-	int ret  = strict_strtol(buf, 10, &val);
-	if (!ret)
-		return ret;
-
-	priv->retry_rate = (val > 0) ? val : 1;
-
-	return count;
-}
-
-static ssize_t show_retry_rate(struct device *d,
-			       struct device_attribute *attr, char *buf)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	return sprintf(buf, "%d", priv->retry_rate);
-}
-
-static DEVICE_ATTR(retry_rate, S_IWUSR | S_IRUSR, show_retry_rate,
-		   store_retry_rate);
-
 static ssize_t store_power_level(struct device *d,
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
@@ -3720,7 +3695,6 @@ static struct attribute *iwl_sysfs_entries[] = {
 	&dev_attr_flags.attr,
 	&dev_attr_filter_flags.attr,
 	&dev_attr_power_level.attr,
-	&dev_attr_retry_rate.attr,
 	&dev_attr_statistics.attr,
 	&dev_attr_temperature.attr,
 	&dev_attr_tx_power.attr,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index eaae79b..44e27fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -863,7 +863,6 @@ int iwl_init_drv(struct iwl_priv *priv)
 {
 	int ret;
 
-	priv->retry_rate = 1;
 	priv->ibss_beacon = NULL;
 
 	spin_lock_init(&priv->lock);
-- 
1.5.3.6

