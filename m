Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49775 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbZGIRdn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 13:33:43 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>, stable@kernel.org
Subject: [PATCH 2/6 2.6.31 and w-t] iwlwifi: only show active power level via sysfs
Date: Thu,  9 Jul 2009 10:33:37 -0700
Message-Id: <1247160821-14989-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1247160821-14989-2-git-send-email-reinette.chatre@intel.com>
References: <1247160821-14989-1-git-send-email-reinette.chatre@intel.com>
 <1247160821-14989-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

This changes the power_level file to adhere to the "one value
per file" sysfs rule. The user will know which power level was
requested as it will be the number just written to this file. It
is thus not necessary to create a new sysfs file for this value.

In addition it fixes a problem where powertop's parsing expects
this value to be the first value in this file without any descriptions.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
cc: stable@kernel.org
---
Needed in 2.6.31 and 2.6.30 because without it powertop
is not able to parse the power level correctly.

Applies to both wireless-testing and 2.6.31, but not to 2.6.30.

Backporting will be done at the time this patch becomes available in
2.6.31. Will resend to stable@kernel.org at that time. Now just adding
stable@kernel.org as cc to bring patch to your attention.

 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 +---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 13279b1..ad50022 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2617,12 +2617,10 @@ static ssize_t show_power_level(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
-	int mode = priv->power_data.user_power_setting;
 	int level = priv->power_data.power_mode;
 	char *p = buf;
 
-	p += sprintf(p, "INDEX:%d\t", level);
-	p += sprintf(p, "USER:%d\n", mode);
+	p += sprintf(p, "%d\n", level);
 	return p - buf + 1;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 303c4b4..7ff95f8 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3573,12 +3573,10 @@ static ssize_t show_power_level(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
-	int mode = priv->power_data.user_power_setting;
 	int level = priv->power_data.power_mode;
 	char *p = buf;
 
-	p += sprintf(p, "INDEX:%d\t", level);
-	p += sprintf(p, "USER:%d\n", mode);
+	p += sprintf(p, "%d\n", level);
 	return p - buf + 1;
 }
 
-- 
1.5.6.3

