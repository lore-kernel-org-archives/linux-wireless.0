Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:3248 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbXJOFy4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 01:54:56 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ian Schram <ischram@telenet.be>
Subject: [PATCH 4/5] iwlwifi: remove late null-check and duplicate bug_on
Date: Mon, 15 Oct 2007 07:54:46 +0200
Message-Id: <11924276862407-git-send-email-tomas.winkler@intel.com> (sfid-20071015_065459_227024_543FB5C8)
Content-Type: text/plain; charset="us-ascii"
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
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 -------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    7 -------
 2 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 724a569..d93d169 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -809,10 +809,6 @@ out:
 
 int iwl_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
-	/* A command can not be asynchronous AND expect an SKB to be set. */
-	BUG_ON((cmd->meta.flags & CMD_ASYNC) &&
-	       (cmd->meta.flags & CMD_WANT_SKB));
-
 	if (cmd->meta.flags & CMD_ASYNC)
 		return iwl_send_cmd_async(priv, cmd);
 
@@ -1958,9 +1954,6 @@ static void iwl_activate_qos(struct iwl_priv *priv, u8 force)
 {
 	unsigned long flags;
 
-	if (priv == NULL)
-		return;
-
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index cb3a368..a198b01 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -807,10 +807,6 @@ out:
 
 int iwl_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
-	/* A command can not be asynchronous AND expect an SKB to be set. */
-	BUG_ON((cmd->meta.flags & CMD_ASYNC) &&
-	       (cmd->meta.flags & CMD_WANT_SKB));
-
 	if (cmd->meta.flags & CMD_ASYNC)
 		return iwl_send_cmd_async(priv, cmd);
 
@@ -2030,9 +2026,6 @@ static void iwl_activate_qos(struct iwl_priv *priv, u8 force)
 {
 	unsigned long flags;
 
-	if (priv == NULL)
-		return;
-
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
