Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48543 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab2FKJyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 05:54:16 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 12/13] iwlwifi: turn on a lockdep assertion
Date: Mon, 11 Jun 2012 11:53:11 +0200
Message-Id: <1339408392-19425-13-git-send-email-johannes@sipsolutions.net> (sfid-20120611_115424_237343_5EFC5B2A)
In-Reply-To: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
References: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

CMD_SYNC is zero so the if (cmd->flags & CMD_SYNC) is never true and we
never check the assertion.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/lib.c b/drivers/net/wireless/iwlwifi/dvm/lib.c
index cb1ca7a..76f2592 100644
--- a/drivers/net/wireless/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/lib.c
@@ -1265,7 +1265,7 @@ int iwl_dvm_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	 * the mutex, this ensures we don't try to send two
 	 * (or more) synchronous commands at a time.
 	 */
-	if (cmd->flags & CMD_SYNC)
+	if (!(cmd->flags & CMD_ASYNC))
 		lockdep_assert_held(&priv->mutex);
 
 	if (priv->ucode_owner == IWL_OWNERSHIP_TM &&
-- 
1.7.10

