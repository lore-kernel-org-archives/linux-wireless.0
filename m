Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48307 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334AbZLBUwz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 15:52:55 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/3] iwlwifi: indicate uCode type when fail dump error/event log
Date: Wed,  2 Dec 2009 12:53:00 -0800
Message-Id: <1259787181-21303-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1259787181-21303-1-git-send-email-reinette.chatre@intel.com>
References: <1259787181-21303-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

error_event_table_ptr is only set upon receipt of REPLY_ALIVE. Until
then both event log and error log will fail. Add information to indicate
which uCode encounter the failure case.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c96513b..b8377ef 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1662,7 +1662,9 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 		base = le32_to_cpu(priv->card_alive.error_event_table_ptr);
 
 	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
-		IWL_ERR(priv, "Not valid error log pointer 0x%08X\n", base);
+		IWL_ERR(priv,
+			"Not valid error log pointer 0x%08X for %s uCode\n",
+			base, (priv->ucode_type == UCODE_INIT) ? "Init" : "RT");
 		return;
 	}
 
@@ -1807,7 +1809,9 @@ void iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log)
 		base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
 
 	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
-		IWL_ERR(priv, "Invalid event log pointer 0x%08X\n", base);
+		IWL_ERR(priv,
+			"Invalid event log pointer 0x%08X for %s uCode\n",
+			base, (priv->ucode_type == UCODE_INIT) ? "Init" : "RT");
 		return;
 	}
 
-- 
1.5.6.3

