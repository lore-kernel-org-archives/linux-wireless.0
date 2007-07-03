Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7622 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215AbXGCPXW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 11:23:22 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Tue, 3 Jul 2007 17:23:12 +0200
Subject: [PATCH] libertas: remove adapter->multipledtim
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200707031723.12974.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

multipledtim was initialized with MRVDRV_DEFAULT_MULTIPLE_DTIM and then
kept at that value, so we could use that define directly.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---
 drivers/net/wireless/libertas/cmd.c  |    2 +-
 drivers/net/wireless/libertas/dev.h  |    1 -
 drivers/net/wireless/libertas/main.c |    1 -
 3 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 276d981..517489a 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -71,7 +71,7 @@ static int wlan_cmd_802_11_ps_mode(wlan_private * priv,
 		psm->locallisteninterval = 0;
 		psm->nullpktinterval = 0;
 		psm->multipledtim =
-		    cpu_to_le16(priv->adapter->multipledtim);
+		    cpu_to_le16(MRVDRV_DEFAULT_MULTIPLE_DTIM);
 		break;
 
 	case CMD_SUBCMD_EXIT_PS:
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 807746b..383d689 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -307,7 +307,6 @@ struct _wlan_adapter {
 
 	u16 psmode;		/* Wlan802_11PowermodeCAM=disable
 				   Wlan802_11PowermodeMAX_PSP=enable */
-	u16 multipledtim;
 	u32 psstate;
 	u8 needtowakeup;
 
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 245aada..d26df1a 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1047,7 +1047,6 @@ static void wlan_init_adapter(wlan_private * priv)
 	adapter->capability = WLAN_CAPABILITY_SHORT_PREAMBLE;
 
 	adapter->psmode = WLAN802_11POWERMODECAM;
-	adapter->multipledtim = MRVDRV_DEFAULT_MULTIPLE_DTIM;
 
 	adapter->listeninterval = MRVDRV_DEFAULT_LISTEN_INTERVAL;
 
-- 
1.5.2.1

