Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:28274 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbXGCP2Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 11:28:25 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH, take 2] libertas: remove adapter->{rx,tx}antenna
Date: Tue, 3 Jul 2007 17:28:19 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200707031728.19720.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Holger Schurig <hs4233@mail.mn-solutions.de>

There was nowhere any code that used the values of those variables.
This patch also removes two static functions that are now unused.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---

This is non-wordwrapped. Sorry.

 drivers/net/wireless/libertas/cmd.c     |   25 -------------------------
 drivers/net/wireless/libertas/cmdresp.c |   24 ------------------------
 drivers/net/wireless/libertas/dev.h     |    6 ------
 drivers/net/wireless/libertas/main.c    |    2 --
 4 files changed, 0 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index d3402e1..2a5defe 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -570,26 +570,6 @@ static int wlan_cmd_802_11_rf_tx_power(wlan_private * priv,
 	return 0;
 }
 
-static int wlan_cmd_802_11_rf_antenna(wlan_private * priv,
-				      struct cmd_ds_command *cmd,
-				      u16 cmd_action, void *pdata_buf)
-{
-	struct cmd_ds_802_11_rf_antenna *rant = &cmd->params.rant;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-	cmd->command = cpu_to_le16(CMD_802_11_RF_ANTENNA);
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_rf_antenna) +
-				S_DS_GEN);
-
-	rant->action = cpu_to_le16(cmd_action);
-	if ((cmd_action == CMD_ACT_SET_RX) || (cmd_action == CMD_ACT_SET_TX)) {
-		rant->antennamode = cpu_to_le16((u16) (*(u32 *) pdata_buf));
-	}
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
 static int wlan_cmd_802_11_rate_adapt_rateset(wlan_private * priv,
 					      struct cmd_ds_command *cmd,
 					      u16 cmd_action)
@@ -1252,11 +1232,6 @@ int libertas_prepare_and_send_command(wlan_private * priv,
 		ret = wlan_cmd_802_11_radio_control(priv, cmdptr, cmd_action);
 		break;
 
-	case CMD_802_11_RF_ANTENNA:
-		ret = wlan_cmd_802_11_rf_antenna(priv, cmdptr,
-						 cmd_action, pdata_buf);
-		break;
-
 	case CMD_802_11_DATA_RATE:
 		ret = wlan_cmd_802_11_data_rate(priv, cmdptr, cmd_action);
 		break;
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 646b591..465a087 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -383,27 +383,6 @@ static int wlan_ret_802_11_rf_tx_power(wlan_private * priv,
 	return 0;
 }
 
-static int wlan_ret_802_11_rf_antenna(wlan_private * priv,
-				      struct cmd_ds_command *resp)
-{
-	struct cmd_ds_802_11_rf_antenna *pAntenna = &resp->params.rant;
-	wlan_adapter *adapter = priv->adapter;
-	u16 action = le16_to_cpu(pAntenna->action);
-
-	lbs_deb_enter(LBS_DEB_CMD);
-	if (action == CMD_ACT_GET_RX)
-		adapter->rxantennamode = le16_to_cpu(pAntenna->antennamode);
-
-	if (action == CMD_ACT_GET_TX)
-		adapter->txantennamode = le16_to_cpu(pAntenna->antennamode);
-
-	lbs_deb_cmd("RF_ANT_RESP: action 0x%x, mode 0x%04x\n",
-	       action, le16_to_cpu(pAntenna->antennamode));
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
 static int wlan_ret_802_11_rate_adapt_rateset(wlan_private * priv,
 					      struct cmd_ds_command *resp)
 {
@@ -620,9 +599,6 @@ static inline int handle_cmd_response(u16 respcmd,
 		spin_unlock_irqrestore(&adapter->driver_lock, flags);
 
 		break;
-	case CMD_RET(CMD_802_11_RF_ANTENNA):
-		ret = wlan_ret_802_11_rf_antenna(priv, resp);
-		break;
 
 	case CMD_RET(CMD_MAC_MULTICAST_ADR):
 	case CMD_RET(CMD_MAC_CONTROL):
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 7c0ee0f..765c0c4 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -284,9 +284,6 @@ struct _wlan_adapter {
 	/** control G rates */
 	u8 adhoc_grate_enabled;
 
-	u32 txantenna;
-	u32 rxantenna;
-
 	u32 fragthsd;
 	u32 rtsthsd;
 
@@ -337,9 +334,6 @@ struct _wlan_adapter {
 	u8 wpa_ie[MAX_WPA_IE_LEN];
 	u8 wpa_ie_len;
 
-	u16 rxantennamode;
-	u16 txantennamode;
-
 	/** Requested Signal Strength*/
 	u16 bcn_avg_factor;
 	u16 data_avg_factor;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 1b6b09d..5b4a134 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1049,8 +1049,6 @@ static void wlan_init_adapter(wlan_private * priv)
 	    CMD_ACT_MAC_RX_ON | CMD_ACT_MAC_TX_ON;
 
 	adapter->radioon = RADIO_ON;
-	adapter->txantenna = RF_ANTENNA_2;
-	adapter->rxantenna = RF_ANTENNA_AUTO;
 
 	adapter->auto_rate = 1;
 	adapter->cur_rate = 0;
-- 
1.5.2.1

