Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55837 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338AbYLQI7t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 03:59:49 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@linux.intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 8/8] iwlwifi: indicate txpower is off in sysfs
Date: Wed, 17 Dec 2008 16:52:34 +0800
Message-Id: <1229503954-30347-9-git-send-email-yi.zhu@intel.com> (sfid-20081217_095955_972928_BA24017C)
In-Reply-To: <1229503954-30347-8-git-send-email-yi.zhu@intel.com>
References: <1229503954-30347-1-git-send-email-yi.zhu@intel.com>
 <1229503954-30347-2-git-send-email-yi.zhu@intel.com>
 <1229503954-30347-3-git-send-email-yi.zhu@intel.com>
 <1229503954-30347-4-git-send-email-yi.zhu@intel.com>
 <1229503954-30347-5-git-send-email-yi.zhu@intel.com>
 <1229503954-30347-6-git-send-email-yi.zhu@intel.com>
 <1229503954-30347-7-git-send-email-yi.zhu@intel.com>
 <1229503954-30347-8-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@linux.intel.com>

The patch checks if the radio is disabled before displaying the tx power
level. Previously when the txpower was set off show_tx_power still
returned the prior power level. Now it will indicate the power has been
turned off.

Signed-off-by: Jay Sternberg <jay.e.sternberg@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8102815..b6c74a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3430,7 +3430,11 @@ static ssize_t show_tx_power(struct device *d,
 			     struct device_attribute *attr, char *buf)
 {
 	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
-	return sprintf(buf, "%d\n", priv->tx_power_user_lmt);
+
+	if (!iwl_is_ready_rf(priv))
+		return sprintf(buf, "off\n");
+	else
+		return sprintf(buf, "%d\n", priv->tx_power_user_lmt);
 }
 
 static ssize_t store_tx_power(struct device *d,
-- 
1.5.3.6

