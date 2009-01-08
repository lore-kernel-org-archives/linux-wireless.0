Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4925 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756143AbZAHSSZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 13:18:25 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 07/11] iwlwifi: remove CMD_WANT_SKB flag if send_cmd_sync failure
Date: Thu,  8 Jan 2009 10:19:58 -0800
Message-Id: <1231438802-10991-8-git-send-email-reinette.chatre@intel.com> (sfid-20090108_191841_028684_FE6E7432)
In-Reply-To: <1231438802-10991-7-git-send-email-reinette.chatre@intel.com>
References: <>
 <1231438802-10991-1-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-2-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-3-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-4-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-5-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-6-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-7-git-send-email-reinette.chatre@intel.com>
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
---
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 0accf88..c35805c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -225,7 +225,7 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		IWL_ERR(priv, "Error: Response NULL in '%s'\n",
 			  get_cmd_string(cmd->id));
 		ret = -EIO;
-		goto out;
+		goto cancel;
 	}
 
 	ret = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index a4c44d2..f1158a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -623,7 +623,7 @@ static int iwl3945_send_cmd_sync(struct iwl_priv *priv,
 		IWL_ERR(priv, "Error: Response NULL in '%s'\n",
 			  get_cmd_string(cmd->id));
 		ret = -EIO;
-		goto out;
+		goto cancel;
 	}
 
 	ret = 0;
-- 
1.5.4.3

