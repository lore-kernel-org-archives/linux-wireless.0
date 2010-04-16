Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23465 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932582Ab0DPVwm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:52:42 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/21] iwlwifi: remove redundant iwl_dump_lq_cmd()
Date: Fri, 16 Apr 2010 14:52:29 -0700
Message-Id: <1271454758-14351-13-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
References: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

This function is called twice in a row, remove the second one.

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 09d9c4d..db93447 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1206,7 +1206,6 @@ int iwl_send_lq_cmd(struct iwl_priv *priv,
 	iwl_dump_lq_cmd(priv, lq);
 	BUG_ON(init && (cmd.flags & CMD_ASYNC));
 
-	iwl_dump_lq_cmd(priv, lq);
 	ret = iwl_send_cmd(priv, &cmd);
 	if (ret || (cmd.flags & CMD_ASYNC))
 		return ret;
-- 
1.6.3.3

