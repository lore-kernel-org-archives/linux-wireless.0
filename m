Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57773 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761704AbZLJWhW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 17:37:22 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/7 w-t and 2.6.33] iwlwifi: fix syslog message for event log dump size
Date: Thu, 10 Dec 2009 14:37:23 -0800
Message-Id: <1260484647-5114-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1260484647-5114-1-git-send-email-reinette.chatre@intel.com>
References: <1260484647-5114-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

When trigger event log dumping from debugfs, the entire event log
should be dumped and the size should match the number of events being
dump.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b8377ef..715db21 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1842,7 +1842,7 @@ void iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log)
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (!(iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS))
+	if (!(iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS) && !full_log)
 		size = (size > DEFAULT_DUMP_EVENT_LOG_ENTRIES)
 			? DEFAULT_DUMP_EVENT_LOG_ENTRIES : size;
 #else
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 994db4a..4c0e475 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1684,7 +1684,7 @@ void iwl3945_dump_nic_event_log(struct iwl_priv *priv, bool full_log)
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (!(iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS))
+	if (!(iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS) && !full_log)
 		size = (size > DEFAULT_IWL3945_DUMP_EVENT_LOG_ENTRIES)
 			? DEFAULT_IWL3945_DUMP_EVENT_LOG_ENTRIES : size;
 #else
-- 
1.5.6.3

