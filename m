Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9689 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181AbZIQRnx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 13:43:53 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/13] iwlwifi: allow user change protection mechanism for HT
Date: Thu, 17 Sep 2009 10:43:45 -0700
Message-Id: <1253209436-2309-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
References: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Allow user to change protection mechanism for HT between RTS/CTS and
CTS-to-self through sysfs:

Show current protection mechanism for HT
   cat /sys/class/net/wlan0/device/rts_ht_protection

Change protection mechanism for HT (only allowed while not-associated)
CTS-to-self:
   echo 0 > /sys/class/net/wlan0/device/rts_ht_protection
RTS/CTS:
   echo 1 > /sys/class/net/wlan0/device/rts_ht_protection

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   35 ++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c0939dc..0b2a1d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2613,6 +2613,40 @@ static ssize_t show_statistics(struct device *d,
 
 static DEVICE_ATTR(statistics, S_IRUGO, show_statistics, NULL);
 
+static ssize_t show_rts_ht_protection(struct device *d,
+			     struct device_attribute *attr, char *buf)
+{
+	struct iwl_priv *priv = dev_get_drvdata(d);
+
+	return sprintf(buf, "%s\n",
+		priv->cfg->use_rts_for_ht ? "RTS/CTS" : "CTS-to-self");
+}
+
+static ssize_t store_rts_ht_protection(struct device *d,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct iwl_priv *priv = dev_get_drvdata(d);
+	unsigned long val;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret)
+		IWL_INFO(priv, "Input is not in decimal form.\n");
+	else {
+		if (!iwl_is_associated(priv))
+			priv->cfg->use_rts_for_ht = val ? true : false;
+		else
+			IWL_ERR(priv, "Sta associated with AP - "
+				"Change protection mechanism is not allowed\n");
+		ret = count;
+	}
+	return ret;
+}
+
+static DEVICE_ATTR(rts_ht_protection, S_IWUSR | S_IRUGO,
+			show_rts_ht_protection, store_rts_ht_protection);
+
 
 /*****************************************************************************
  *
@@ -2669,6 +2703,7 @@ static struct attribute *iwl_sysfs_entries[] = {
 	&dev_attr_statistics.attr,
 	&dev_attr_temperature.attr,
 	&dev_attr_tx_power.attr,
+	&dev_attr_rts_ht_protection.attr,
 #ifdef CONFIG_IWLWIFI_DEBUG
 	&dev_attr_debug_level.attr,
 #endif
-- 
1.5.6.3

