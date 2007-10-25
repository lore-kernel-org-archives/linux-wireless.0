Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44836 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079AbXJYJWk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:22:40 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ian Schram <ischram@telenet.be>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 09/30] iwlwifi: remove late null-check and duplicate bug_on
Date: Thu, 25 Oct 2007 17:15:30 +0800
Message-Id: <11933037641168-git-send-email-yi.zhu@intel.com> (sfid-20071025_102257_858515_1385B868)
In-Reply-To: <1193303762680-git-send-email-yi.zhu@intel.com>
References: <11933037512140-git-send-email-yi.zhu@intel.com>
 <11933037541699-git-send-email-yi.zhu@intel.com>
 <11933037553170-git-send-email-yi.zhu@intel.com>
 <119330375796-git-send-email-yi.zhu@intel.com>
 <11933037584069-git-send-email-yi.zhu@intel.com>
 <11933037601236-git-send-email-yi.zhu@intel.com>
 <11933037613709-git-send-email-yi.zhu@intel.com>
 <1193303762680-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Schram <ischram@telenet.be>

These pieces of code appear to be useless. The BUG_ON is also performed in
iwl_send_cmd_async.

Serious karma would be needed to enter iwl_ativate_qos with a null priv.
I had a deja vu when patching this, but for the life of me I couldn't track
down a similar patch.

Signed-off-by: Ian Schram <ischram@telenet.be>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 -------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    7 -------
 2 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index cd2ed1d..7fb73c3 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -807,10 +807,6 @@ out:
 
 int iwl_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
-	/* A command can not be asynchronous AND expect an SKB to be set. */
-	BUG_ON((cmd->meta.flags & CMD_ASYNC) &&
-	       (cmd->meta.flags & CMD_WANT_SKB));
-
 	if (cmd->meta.flags & CMD_ASYNC)
 		return iwl_send_cmd_async(priv, cmd);
 
@@ -1966,9 +1962,6 @@ static void iwl_activate_qos(struct iwl_priv *priv, u8 force)
 {
 	unsigned long flags;
 
-	if (priv == NULL)
-		return;
-
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 976171c..315f3ab 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -805,10 +805,6 @@ out:
 
 int iwl_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
-	/* A command can not be asynchronous AND expect an SKB to be set. */
-	BUG_ON((cmd->meta.flags & CMD_ASYNC) &&
-	       (cmd->meta.flags & CMD_WANT_SKB));
-
 	if (cmd->meta.flags & CMD_ASYNC)
 		return iwl_send_cmd_async(priv, cmd);
 
@@ -2038,9 +2034,6 @@ static void iwl_activate_qos(struct iwl_priv *priv, u8 force)
 {
 	unsigned long flags;
 
-	if (priv == NULL)
-		return;
-
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-- 
1.5.2
