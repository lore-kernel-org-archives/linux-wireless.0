Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from glaubenleben.de ([85.214.105.140]:57587 "EHLO glaubenleben.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbcAFVSC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2016 16:18:02 -0500
From: Andreas Kemnade <andreas@kemnade.info>
To: Kalle Valo <kvalo@codeaurora.org>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Andreas Kemnade <andreas@kemnade.info>
Subject: [PATCH 5/6] wireless:libertas: go back to ps mode without commands pending
Date: Wed,  6 Jan 2016 22:08:13 +0100
Message-Id: <1452114494-6451-6-git-send-email-andreas@kemnade.info> (sfid-20160106_221818_527028_88D49BB0)
In-Reply-To: <1452114494-6451-1-git-send-email-andreas@kemnade.info>
References: <1452114494-6451-1-git-send-email-andreas@kemnade.info>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removes the old todo block and checks only whether ieee powersave
mode is requested. We still have to check for being connected as
this powersave mode includes logic for regularly waking up and
checking for packets which only makes sense when connected.
For not being connected, another mode is needed.

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
---
 drivers/net/wireless/libertas/cmd.c | 36 +++++-------------------------------
 1 file changed, 5 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 40467d6..4ddd0e5 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1428,40 +1428,14 @@ int lbs_execute_next_command(struct lbs_private *priv)
 		 * check if in power save mode, if yes, put the device back
 		 * to PS mode
 		 */
-#ifdef TODO
-		/*
-		 * This was the old code for libertas+wext. Someone that
-		 * understands this beast should re-code it in a sane way.
-		 *
-		 * I actually don't understand why this is related to WPA
-		 * and to connection status, shouldn't powering should be
-		 * independ of such things?
-		 */
 		if ((priv->psmode != LBS802_11POWERMODECAM) &&
 		    (priv->psstate == PS_STATE_FULL_POWER) &&
-		    ((priv->connect_status == LBS_CONNECTED) ||
-		    lbs_mesh_connected(priv))) {
-			if (priv->secinfo.WPAenabled ||
-			    priv->secinfo.WPA2enabled) {
-				/* check for valid WPA group keys */
-				if (priv->wpa_mcast_key.len ||
-				    priv->wpa_unicast_key.len) {
-					lbs_deb_host(
-					       "EXEC_NEXT_CMD: WPA enabled and GTK_SET"
-					       " go back to PS_SLEEP");
-					lbs_set_ps_mode(priv,
-							PS_MODE_ACTION_ENTER_PS,
-							false);
-				}
-			} else {
-				lbs_deb_host(
-				       "EXEC_NEXT_CMD: cmdpendingq empty, "
-				       "go back to PS_SLEEP");
-				lbs_set_ps_mode(priv, PS_MODE_ACTION_ENTER_PS,
-						false);
-			}
+		    (priv->connect_status == LBS_CONNECTED)) {
+			lbs_deb_host(
+				"EXEC_NEXT_CMD: cmdpendingq empty, go back to PS_SLEEP");
+			lbs_set_ps_mode(priv, PS_MODE_ACTION_ENTER_PS,
+					false);
 		}
-#endif
 	}
 
 	ret = 0;
-- 
2.1.4

