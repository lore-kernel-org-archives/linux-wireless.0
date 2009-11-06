Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9497 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759914AbZKFWw6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:52:58 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/20] iwlwifi: change debug message to error in failure case
Date: Fri,  6 Nov 2009 14:52:44 -0800
Message-Id: <1257547983-12590-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
References: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Since these messages indicate failure we would be interested in seeing them
always.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-hcmd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index ccf50a9..a231659 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -200,13 +200,13 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	}
 
 	if (test_bit(STATUS_RF_KILL_HW, &priv->status)) {
-		IWL_DEBUG_INFO(priv, "Command %s aborted: RF KILL Switch\n",
+		IWL_ERR(priv, "Command %s aborted: RF KILL Switch\n",
 			       get_cmd_string(cmd->id));
 		ret = -ECANCELED;
 		goto fail;
 	}
 	if (test_bit(STATUS_FW_ERROR, &priv->status)) {
-		IWL_DEBUG_INFO(priv, "Command %s failed: FW Error\n",
+		IWL_ERR(priv, "Command %s failed: FW Error\n",
 			       get_cmd_string(cmd->id));
 		ret = -EIO;
 		goto fail;
-- 
1.5.6.3

