Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24719 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbZGaV2J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 17:28:09 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel C Halperin <daniel.c.halperin@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/4] iwlwifi: clear iwl_cmd_meta structure before use
Date: Fri, 31 Jul 2009 14:28:06 -0700
Message-Id: <1249075689-8973-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1249075689-8973-1-git-send-email-reinette.chatre@intel.com>
References: <1249075689-8973-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel C Halperin <daniel.c.halperin@intel.com>

Resolve an issue in which out-dated fields in iwl_cmd_meta
could be used for later hardware commands.

Signed-off-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 6bb9602..288b871 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -970,6 +970,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	out_cmd = txq->cmd[idx];
 	out_meta = &txq->meta[idx];
 
+	memset(out_meta, 0, sizeof(*out_meta));	/* re-initialize to NULL */
 	out_meta->flags = cmd->flags;
 	if (cmd->flags & CMD_WANT_SKB)
 		out_meta->source = cmd;
-- 
1.5.6.3

