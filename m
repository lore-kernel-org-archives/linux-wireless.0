Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:11397 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab0CJFWH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:07 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 19/24] iwlwifi: remove needlessly exported symbols
Date: Tue,  9 Mar 2010 21:21:47 -0800
Message-Id: <1268198512-6572-20-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

iwl_apm_stop_master and iwl_internal_short_hw_scan
are only used within iwlcore and thus do not need to be exported.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    3 +--
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 -
 drivers/net/wireless/iwlwifi/iwl-scan.c |    1 -
 3 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index a962fb3..ec435e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1356,7 +1356,7 @@ void iwl_irq_handle_error(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_irq_handle_error);
 
-int iwl_apm_stop_master(struct iwl_priv *priv)
+static int iwl_apm_stop_master(struct iwl_priv *priv)
 {
 	int ret = 0;
 
@@ -1372,7 +1372,6 @@ int iwl_apm_stop_master(struct iwl_priv *priv)
 
 	return ret;
 }
-EXPORT_SYMBOL(iwl_apm_stop_master);
 
 void iwl_apm_stop(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index bec00c7..aced12f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -675,7 +675,6 @@ extern void iwl_rx_reply_rx_phy(struct iwl_priv *priv,
 void iwl_rx_reply_compressed_ba(struct iwl_priv *priv,
 					   struct iwl_rx_mem_buffer *rxb);
 void iwl_apm_stop(struct iwl_priv *priv);
-int iwl_apm_stop_master(struct iwl_priv *priv);
 int iwl_apm_init(struct iwl_priv *priv);
 
 void iwl_setup_rxon_timing(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index dd9ff2e..ccad04c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -580,7 +580,6 @@ int iwl_internal_short_hw_scan(struct iwl_priv *priv)
 out:
 	return ret;
 }
-EXPORT_SYMBOL(iwl_internal_short_hw_scan);
 
 #define IWL_SCAN_CHECK_WATCHDOG (7 * HZ)
 
-- 
1.6.3.3

