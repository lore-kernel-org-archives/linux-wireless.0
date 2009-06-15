Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f187.google.com ([209.85.222.187]:50506 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbZFOUAl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 16:00:41 -0400
Received: by pzk17 with SMTP id 17so2163931pzk.33
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2009 13:00:43 -0700 (PDT)
From: Andrey Yurovsky <andrey@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org, dcbw@redhat.com,
	Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] libertas: Fix re-enabling IEEE PS with WPA/WPA2
Date: Mon, 15 Jun 2009 13:01:51 -0700
Message-Id: <1245096111-20884-1-git-send-email-andrey@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With IEEE PS enabled, the driver will temporarily take the device out of
PS mode to issue commands and then re-enable PS once the commands have
completed.  With WPA or WPA2 security, the driver fails to re-enable PS
mode because of a check for key lengths that are always zero.

This patch removes the key lengths check (the local copy of the keys is
not maintained) and fixes IEEE PS mode with WPA or WPA2 security.
Tested on GSPI and SDIO interfaces with V9 firmware.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 drivers/net/wireless/libertas/cmd.c |   29 +++++++----------------------
 1 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 01db705..5825396 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1782,32 +1782,17 @@ int lbs_execute_next_command(struct lbs_private *priv)
 		lbs_deb_host("EXEC_NEXT_CMD: sending command 0x%04x\n",
 			    le16_to_cpu(cmd->command));
 		lbs_submit_command(priv, cmdnode);
-	} else {
+	} else if ((priv->psmode != LBS802_11POWERMODECAM) &&
+		   (priv->psstate == PS_STATE_FULL_POWER) &&
+		   ((priv->connect_status == LBS_CONNECTED) ||
+		   (priv->mesh_connect_status == LBS_CONNECTED))) {
 		/*
 		 * check if in power save mode, if yes, put the device back
 		 * to PS mode
 		 */
-		if ((priv->psmode != LBS802_11POWERMODECAM) &&
-		    (priv->psstate == PS_STATE_FULL_POWER) &&
-		    ((priv->connect_status == LBS_CONNECTED) ||
-		    (priv->mesh_connect_status == LBS_CONNECTED))) {
-			if (priv->secinfo.WPAenabled ||
-			    priv->secinfo.WPA2enabled) {
-				/* check for valid WPA group keys */
-				if (priv->wpa_mcast_key.len ||
-				    priv->wpa_unicast_key.len) {
-					lbs_deb_host(
-					       "EXEC_NEXT_CMD: WPA enabled and GTK_SET"
-					       " go back to PS_SLEEP");
-					lbs_ps_sleep(priv, 0);
-				}
-			} else {
-				lbs_deb_host(
-				       "EXEC_NEXT_CMD: cmdpendingq empty, "
-				       "go back to PS_SLEEP");
-				lbs_ps_sleep(priv, 0);
-			}
-		}
+		lbs_deb_host("EXEC_NEXT_CMD: cmdpendingq empty, "
+				"go back to PS_SLEEP");
+		lbs_ps_sleep(priv, 0);
 	}
 
 	ret = 0;
-- 
1.5.6.3

