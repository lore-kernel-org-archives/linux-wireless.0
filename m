Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7604 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101AbXGCPXN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 11:23:13 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Tue, 3 Jul 2007 17:23:06 +0200
Subject: [PATCH] libertas: remove adapter->locallisteninterval
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200707031723.06584.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

locallisteninterval was initialized with 0, but there is no code that
changes it, rendering it rather useless.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---
 drivers/net/wireless/libertas/cmd.c  |    6 +-----
 drivers/net/wireless/libertas/dev.h  |    1 -
 drivers/net/wireless/libertas/main.c |    1 -
 3 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index f5d4971..276d981 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -56,7 +56,6 @@ static int wlan_cmd_802_11_ps_mode(wlan_private * priv,
 				   u16 cmd_action)
 {
 	struct cmd_ds_802_11_ps_mode *psm = &cmd->params.psmode;
-	wlan_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
@@ -68,11 +67,8 @@ static int wlan_cmd_802_11_ps_mode(wlan_private * priv,
 	switch (cmd_action) {
 	case CMD_SUBCMD_ENTER_PS:
 		lbs_deb_cmd("PS command:" "SubCode- Enter PS\n");
-		lbs_deb_cmd("locallisteninterval %d\n",
-		       adapter->locallisteninterval);
 
-		psm->locallisteninterval =
-		    cpu_to_le16(adapter->locallisteninterval);
+		psm->locallisteninterval = 0;
 		psm->nullpktinterval = 0;
 		psm->multipledtim =
 		    cpu_to_le16(priv->adapter->multipledtim);
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 2d203c6..807746b 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -312,7 +312,6 @@ struct _wlan_adapter {
 	u8 needtowakeup;
 
 	struct PS_CMD_ConfirmSleep libertas_ps_confirm_sleep;
-	u16 locallisteninterval;
 
 	struct assoc_request * pending_assoc_req;
 	struct assoc_request * in_progress_assoc_req;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 2e56801..245aada 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1053,7 +1053,6 @@ static void wlan_init_adapter(wlan_private * priv)
 
 	adapter->psstate = PS_STATE_FULL_POWER;
 	adapter->needtowakeup = 0;
-	adapter->locallisteninterval = 0;	/* default value in firmware will be used */
 
 	adapter->intcounter = 0;
 
-- 
1.5.2.1

