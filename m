Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42988 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbZBMTro (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 14:47:44 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>,
	Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 2/3] iwlwifi: use singlethread workqueue
Date: Fri, 13 Feb 2009 11:51:18 -0800
Message-Id: <1234554679-30186-3-git-send-email-reinette.chatre@intel.com> (sfid-20090213_204754_593091_09635180)
In-Reply-To: <1234554679-30186-2-git-send-email-reinette.chatre@intel.com>
References: <>
 <1234554679-30186-1-git-send-email-reinette.chatre@intel.com>
 <1234554679-30186-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use one workqueue instead of one per CPU.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
cc: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 397577c..432aee2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3370,7 +3370,7 @@ static DEVICE_ATTR(statistics, S_IRUGO, show_statistics, NULL);
 
 static void iwl_setup_deferred_work(struct iwl_priv *priv)
 {
-	priv->workqueue = create_workqueue(DRV_NAME);
+	priv->workqueue = create_singlethread_workqueue(DRV_NAME);
 
 	init_waitqueue_head(&priv->wait_command_queue);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d068e18..f78a69a 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5201,7 +5201,7 @@ static DEVICE_ATTR(dump_events, S_IWUSR, NULL, dump_event_log);
 
 static void iwl3945_setup_deferred_work(struct iwl_priv *priv)
 {
-	priv->workqueue = create_workqueue(DRV_NAME);
+	priv->workqueue = create_singlethread_workqueue(DRV_NAME);
 
 	init_waitqueue_head(&priv->wait_command_queue);
 
-- 
1.5.4.3

