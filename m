Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:20200 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab2FJLZo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jun 2012 07:25:44 -0400
Date: Sun, 10 Jun 2012 14:25:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v2] iwlwifi: turn on a lockdep assertion
Message-ID: <20120610112521.GA20676@elgon.mountain> (sfid-20120610_132551_124529_BB46BBBB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1339265576.5029.1.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CMD_SYNC is zero so the if (cmd->flags & CMD_SYNC) is never true and we
never check the assertion.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: enables the assertion even more than v1 (based on feedback from
Johannes Berg).

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index e55ec6c..5c04895 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1259,7 +1259,7 @@ int iwl_dvm_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	 * the mutex, this ensures we don't try to send two
 	 * (or more) synchronous commands at a time.
 	 */
-	if (cmd->flags & CMD_SYNC)
+	if (!(cmd->flags & CMD_ASYNC))
 		lockdep_assert_held(&priv->mutex);
 
 	if (priv->ucode_owner == IWL_OWNERSHIP_TM &&
