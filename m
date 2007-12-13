Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56518 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760761AbXLMG7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:17 -0500
Subject: [PATCH 54/48] libertas: clean up is_command_allowed_in_ps()
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2V-0005rC-Jf@shinybook.infradead.org> (sfid-20071213_065940_011214_E8ACA057)
Date: Thu, 13 Dec 2007 01:59:23 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Williams <dcbw@redhat.com>
Date: Mon, 10 Dec 2007 15:24:47 -0500

Total overkill to have an array when there's only one command in it.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c |   24 +++++++++---------------
 1 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index c7c226c..2efba57 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -19,26 +19,20 @@ void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
 		    u16 wait_option, void *pdata_buf);
 
 
-static u16 commands_allowed_in_ps[] = {
-	CMD_802_11_RSSI,
-};
-
 /**
- *  @brief This function checks if the commans is allowed
- *  in PS mode not.
+ *  @brief Checks whether a command is allowed in Power Save mode
  *
  *  @param command the command ID
- *  @return 	   TRUE or FALSE
+ *  @return 	   1 if allowed, 0 if not allowed
  */
-static u8 is_command_allowed_in_ps(__le16 command)
+static u8 is_command_allowed_in_ps(u16 cmd)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(commands_allowed_in_ps); i++) {
-		if (command == cpu_to_le16(commands_allowed_in_ps[i]))
-			return 1;
+	switch (cmd) {
+	case CMD_802_11_RSSI:
+		return 1;
+	default:
+		break;
 	}
-
 	return 0;
 }
 
@@ -1715,7 +1709,7 @@ int lbs_execute_next_command(struct lbs_private *priv)
 	if (cmdnode) {
 		cmdptr = (struct cmd_ds_command *)cmdnode->bufvirtualaddr;
 
-		if (is_command_allowed_in_ps(cmdptr->command)) {
+		if (is_command_allowed_in_ps(le16_to_cpu(cmdptr->command))) {
 			if ((priv->psstate == PS_STATE_SLEEP) ||
 			    (priv->psstate == PS_STATE_PRE_SLEEP)) {
 				lbs_deb_host(
-- 
1.5.3.4

