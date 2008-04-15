Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61085 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbYDOXCK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 19:02:10 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/11] iwlwifi: introduce host commands callbacks
Date: Tue, 15 Apr 2008 16:01:42 -0700
Message-Id: <1208300507-25628-7-git-send-email-reinette.chatre@intel.com> (sfid-20080416_000234_270783_BC8C461C)
In-Reply-To: <1208300507-25628-6-git-send-email-reinette.chatre@intel.com>
References: <1208300507-25628-1-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-2-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-3-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-4-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-5-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds place holder for host command handlers
for supporting different implementations per HW

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-core.h |    3 +++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 4a40109..9fa803a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4905,6 +4905,10 @@ void iwl4965_hw_cancel_deferred_work(struct iwl_priv *priv)
 	cancel_delayed_work(&priv->init_alive_start);
 }
 
+
+static struct iwl_hcmd_ops iwl4965_hcmd = {
+};
+
 static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
 	.enqueue_hcmd = iwl4965_enqueue_hcmd,
 };
@@ -4927,6 +4931,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 
 static struct iwl_ops iwl4965_ops = {
 	.lib = &iwl4965_lib,
+	.hcmd = &iwl4965_hcmd,
 	.utils = &iwl4965_hcmd_utils,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 0ff0978..64bab66 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -82,6 +82,8 @@ struct iwl_cmd;
 #define IWL_SKU_A       0x2
 #define IWL_SKU_N       0x8
 
+struct iwl_hcmd_ops {
+};
 struct iwl_hcmd_utils_ops {
 	int (*enqueue_hcmd)(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
 };
@@ -111,6 +113,7 @@ struct iwl_lib_ops {
 
 struct iwl_ops {
 	const struct iwl_lib_ops *lib;
+	const struct iwl_hcmd_ops *hcmd;
 	const struct iwl_hcmd_utils_ops *utils;
 };
 
-- 
1.5.3.4

