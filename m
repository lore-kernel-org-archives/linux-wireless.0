Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from glaubenleben.de ([85.214.105.140]:57591 "EHLO glaubenleben.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbcAFVSG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2016 16:18:06 -0500
From: Andreas Kemnade <andreas@kemnade.info>
To: Kalle Valo <kvalo@codeaurora.org>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Andreas Kemnade <andreas@kemnade.info>
Subject: [PATCH 1/6] wireless:libertas: do not strip header for PS_MODE commands
Date: Wed,  6 Jan 2016 22:08:09 +0100
Message-Id: <1452114494-6451-2-git-send-email-andreas@kemnade.info> (sfid-20160106_221820_256894_BCEA8AB9)
In-Reply-To: <1452114494-6451-1-git-send-email-andreas@kemnade.info>
References: <1452114494-6451-1-git-send-email-andreas@kemnade.info>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct cmd_ds_802_11_ps_mode
contains the command header and a pointer to it was
initialized with data points to the body which leads to
mis-interpretation of the cmd_ds_802_11_ps_mode.action member.

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
---
 drivers/net/wireless/libertas/cmd.c     | 4 ++--
 drivers/net/wireless/libertas/cmdresp.c | 5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 0387a5b..40467d6 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -957,7 +957,7 @@ static void lbs_queue_cmd(struct lbs_private *priv,
 
 	/* Exit_PS command needs to be queued in the header always. */
 	if (le16_to_cpu(cmdnode->cmdbuf->command) == CMD_802_11_PS_MODE) {
-		struct cmd_ds_802_11_ps_mode *psm = (void *) &cmdnode->cmdbuf;
+		struct cmd_ds_802_11_ps_mode *psm = (void *)cmdnode->cmdbuf;
 
 		if (psm->action == cpu_to_le16(PS_MODE_ACTION_EXIT_PS)) {
 			if (priv->psstate != PS_STATE_FULL_POWER)
@@ -1387,7 +1387,7 @@ int lbs_execute_next_command(struct lbs_private *priv)
 				 * PS command. Ignore it if it is not Exit_PS.
 				 * otherwise send it down immediately.
 				 */
-				struct cmd_ds_802_11_ps_mode *psm = (void *)&cmd[1];
+				struct cmd_ds_802_11_ps_mode *psm = (void *)cmd;
 
 				lbs_deb_host(
 				       "EXEC_NEXT_CMD: PS cmd, action 0x%02x\n",
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index e5442e8..701125f 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -123,7 +123,10 @@ int lbs_process_command_response(struct lbs_private *priv, u8 *data, u32 len)
 	priv->cmd_timed_out = 0;
 
 	if (respcmd == CMD_RET(CMD_802_11_PS_MODE)) {
-		struct cmd_ds_802_11_ps_mode *psmode = (void *) &resp[1];
+		/* struct cmd_ds_802_11_ps_mode also contains
+		 * the header
+		 */
+		struct cmd_ds_802_11_ps_mode *psmode = (void *)resp;
 		u16 action = le16_to_cpu(psmode->action);
 
 		lbs_deb_host(
-- 
2.1.4

