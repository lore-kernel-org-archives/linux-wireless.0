Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7552 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbXGCPWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 11:22:47 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Tue, 3 Jul 2007 17:22:41 +0200
Subject: [PATCH] libertas: remove adapter->txrate
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200707031722.41223.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The value of txrate was only set by a CMD_802_11_TX_RATE_QUERY command,
but there was no code in the driver that ever issued this command.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---
 drivers/net/wireless/libertas/cmd.c     |    7 -------
 drivers/net/wireless/libertas/cmdresp.c |    3 ---
 drivers/net/wireless/libertas/dev.h     |    1 -
 3 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 2a5defe..0da013f 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1368,13 +1368,6 @@ int libertas_prepare_and_send_command(wlan_private * priv,
 					   S_DS_GEN);
 		ret = 0;
 		break;
-	case CMD_802_11_TX_RATE_QUERY:
-		cmdptr->command = cpu_to_le16(CMD_802_11_TX_RATE_QUERY);
-		cmdptr->size = cpu_to_le16(sizeof(struct cmd_tx_rate_query) +
-					   S_DS_GEN);
-		adapter->txrate = 0;
-		ret = 0;
-		break;
 	default:
 		lbs_deb_host("PREP_CMD: unknown command 0x%04x\n", cmd_no);
 		ret = -1;
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 465a087..02ef04d 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -702,9 +702,6 @@ static inline int handle_cmd_response(u16 respcmd,
 			memcpy(adapter->cur_cmd->pdata_buf, &resp->params.mesh,
 			       sizeof(resp->params.mesh));
 		break;
-	case CMD_RET(CMD_802_11_TX_RATE_QUERY):
-		priv->adapter->txrate = resp->params.txrate.txrate;
-		break;
 	default:
 		lbs_deb_host("CMD_RESP: unknown cmd response 0x%04x\n",
 			    resp->command);
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 3eae896..fcfb2d3 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -376,7 +376,6 @@ struct _wlan_adapter {
 
 	struct cmd_ds_802_11_get_log logmsg;
 
-	u16 txrate;
 	u8 fw_ready;
 
 	u8 last_scanned_channel;
-- 
1.5.2.1

