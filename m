Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47912 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757427AbZEHUi0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 16:38:26 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/11] iwlwifi: show qos AC parameters
Date: Fri,  8 May 2009 13:44:44 -0700
Message-Id: <1241815486-13510-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1241815486-13510-9-git-send-email-reinette.chatre@intel.com>
References: <1241815486-13510-1-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-2-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-3-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-4-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-5-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-6-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-7-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-8-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-9-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Show current qos AC parameters in sysfs

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 13a35dc..3ebf6cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2475,6 +2475,26 @@ static ssize_t show_power_level(struct device *d,
 static DEVICE_ATTR(power_level, S_IWUSR | S_IRUSR, show_power_level,
 		   store_power_level);
 
+static ssize_t show_qos(struct device *d,
+				struct device_attribute *attr, char *buf)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
+	char *p = buf;
+	int   q;
+
+	for (q = 0; q < AC_NUM; q++) {
+		p += sprintf(p, "\tcw_min\tcw_max\taifsn\ttxop\n");
+		p += sprintf(p, "AC[%d]\t%u\t%u\t%u\t%u\n", q,
+			     priv->qos_data.def_qos_parm.ac[q].cw_min,
+			     priv->qos_data.def_qos_parm.ac[q].cw_max,
+			     priv->qos_data.def_qos_parm.ac[q].aifsn,
+			     priv->qos_data.def_qos_parm.ac[q].edca_txop);
+	}
+
+	return p - buf + 1;
+}
+
+static DEVICE_ATTR(qos, S_IRUGO, show_qos, NULL);
 
 static ssize_t show_statistics(struct device *d,
 			       struct device_attribute *attr, char *buf)
@@ -2572,7 +2592,7 @@ static struct attribute *iwl_sysfs_entries[] = {
 	&dev_attr_debug_level.attr,
 #endif
 	&dev_attr_version.attr,
-
+	&dev_attr_qos.attr,
 	NULL
 };
 
-- 
1.5.6.3

