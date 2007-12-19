Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pmac.infradead.org ([90.155.92.200]:40766 "EHLO
	pmac.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbXLSQKK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 11:10:10 -0500
Subject: [PATCH 117/48] libertas: fix buffer handling of PS_MODE commands and responses
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J50tr-000202-Ra@pmac.infradead.org> (sfid-20071219_161013_989520_C9D22DCC)
Date: Wed, 19 Dec 2007 15:31:59 +0000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sun, 16 Dec 2007 23:26:54 -0500

Commit 5b8845345e7385d2eb37fac22ba9ab6905988be5 (or, in case the git
workflow is broken and patches get recommitted, the commit entitled
'libertas: rename and re-type bufvirtualaddr to cmdbuf' by dcbw),
introduced a number of bugs where we once had a pointer to a command
_payload_, but now we use the pointer to the command header instead.

The fix isn't wonderfully pretty for now, but it'll get better when we
finish converting all commands so the structures include the header.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |    4 ++--
 drivers/net/wireless/libertas/cmdresp.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 7682b9d..2765b9c 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1175,7 +1175,7 @@ static void lbs_queue_cmd(struct lbs_private *priv,
 
 	/* Exit_PS command needs to be queued in the header always. */
 	if (le16_to_cpu(cmdnode->cmdbuf->command) == CMD_802_11_PS_MODE) {
-		struct cmd_ds_802_11_ps_mode *psm = (void *) cmdnode->cmdbuf;
+		struct cmd_ds_802_11_ps_mode *psm = (void *) &cmdnode->cmdbuf[1];
 
 		if (psm->action == cpu_to_le16(CMD_SUBCMD_EXIT_PS)) {
 			if (priv->psstate != PS_STATE_FULL_POWER)
@@ -1889,7 +1889,7 @@ int lbs_execute_next_command(struct lbs_private *priv)
 				 * PS command. Ignore it if it is not Exit_PS.
 				 * otherwise send it down immediately.
 				 */
-				struct cmd_ds_802_11_ps_mode *psm = (void *)cmd;
+				struct cmd_ds_802_11_ps_mode *psm = (void *)&cmd[1];
 
 				lbs_deb_host(
 				       "EXEC_NEXT_CMD: PS cmd, action 0x%02x\n",
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index ef63c37..c05fef0 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -678,7 +678,7 @@ int lbs_process_rx_command(struct lbs_private *priv)
 	priv->cur_cmd_retcode = result;
 
 	if (respcmd == CMD_RET(CMD_802_11_PS_MODE)) {
-		struct cmd_ds_802_11_ps_mode *psmode = (void *) resp;
+		struct cmd_ds_802_11_ps_mode *psmode = (void *) &resp[1];
 		u16 action = le16_to_cpu(psmode->action);
 
 		lbs_deb_host(
-- 
1.5.3.4

