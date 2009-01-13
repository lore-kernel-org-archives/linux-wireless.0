Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:7825 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755057AbZAMUQh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 15:16:37 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH v2.6.29] iwlwifi: remove CMD_WANT_SKB flag if send_cmd_sync failure
Date: Tue, 13 Jan 2009 12:18:35 -0800
Message-Id: <1231877915-6123-1-git-send-email-reinette.chatre@intel.com> (sfid-20090113_211642_481720_8C101287)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

In function iwl_send_cmd_sync(), if the flag CMD_WANT_SKB is set but
we are not provided with a valid SKB (cmd->meta.u.skb == NULL), we need
to remove the CMD_WANT_SKB flag from the TX cmd queue. Otherwise in case
the cmd comes in later, it will possibly set an invalid address. Thus
it causes an invalid memory access.

This fixed the bug http://bugzilla.kernel.org/show_bug.cgi?id=11326.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
John,

This patch is already in wireless-testing. Could you please include it
in the fixes for 2.6.29?


 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 43e028e..af14d8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -226,7 +226,7 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		IWL_ERROR("Error: Response NULL in '%s'\n",
 			  get_cmd_string(cmd->id));
 		ret = -EIO;
-		goto out;
+		goto cancel;
 	}
 
 	ret = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 283d755..3147502 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -622,7 +622,7 @@ static int iwl3945_send_cmd_sync(struct iwl_priv *priv,
 		IWL_ERROR("Error: Response NULL in '%s'\n",
 			  get_cmd_string(cmd->id));
 		ret = -EIO;
-		goto out;
+		goto cancel;
 	}
 
 	ret = 0;
-- 
1.5.4.3

