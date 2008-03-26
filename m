Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:12420 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbYCZJB3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 05:01:29 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: convert CMD_802_11_MAC_ADDRESS to a direct command
Date: Wed, 26 Mar 2008 09:58:32 +0100
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803260958.32270.hs4233@mail.mn-solutions.de> (sfid-20080326_090131_250099_2ABD857F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* directly call lbs_cmd_with_response()
* only overwrite priv->current_addr once the firmware call succeeded

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c
+++ wireless-testing/drivers/net/wireless/libertas/cmd.c
@@ -970,29 +970,6 @@
 	return 0;
 }
 
-static int lbs_cmd_802_11_mac_address(struct lbs_private *priv,
-				       struct cmd_ds_command *cmd,
-				       u16 cmd_action)
-{
-
-	lbs_deb_enter(LBS_DEB_CMD);
-	cmd->command = cpu_to_le16(CMD_802_11_MAC_ADDRESS);
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_mac_address) +
-			     S_DS_GEN);
-	cmd->result = 0;
-
-	cmd->params.macadd.action = cpu_to_le16(cmd_action);
-
-	if (cmd_action == CMD_ACT_SET) {
-		memcpy(cmd->params.macadd.macadd,
-		       priv->current_addr, ETH_ALEN);
-		lbs_deb_hex(LBS_DEB_CMD, "SET_CMD: MAC addr", priv->current_addr, 6);
-	}
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
 static int lbs_cmd_802_11_eeprom_access(struct cmd_ds_command *cmd,
 					void *pdata_buf)
 {
@@ -1448,10 +1425,6 @@
 		ret = lbs_cmd_80211_ad_hoc_stop(cmdptr);
 		break;
 
-	case CMD_802_11_MAC_ADDRESS:
-		ret = lbs_cmd_802_11_mac_address(priv, cmdptr, cmd_action);
-		break;
-
 	case CMD_802_11_EEPROM_ACCESS:
 		ret = lbs_cmd_802_11_eeprom_access(cmdptr, pdata_buf);
 		break;
--- wireless-testing.orig/drivers/net/wireless/libertas/cmdresp.c
+++ wireless-testing/drivers/net/wireless/libertas/cmdresp.c
@@ -179,19 +179,6 @@
 	return 0;
 }
 
-static int lbs_ret_802_11_mac_address(struct lbs_private *priv,
-				       struct cmd_ds_command *resp)
-{
-	struct cmd_ds_802_11_mac_address *macadd = &resp->params.macadd;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	memcpy(priv->current_addr, macadd->macadd, ETH_ALEN);
-
-	lbs_deb_enter(LBS_DEB_CMD);
-	return 0;
-}
-
 static int lbs_ret_802_11_rf_tx_power(struct lbs_private *priv,
 				       struct cmd_ds_command *resp)
 {
@@ -325,10 +312,6 @@
 		ret = lbs_ret_802_11_rate_adapt_rateset(priv, resp);
 		break;
 
-	case CMD_RET(CMD_802_11_MAC_ADDRESS):
-		ret = lbs_ret_802_11_mac_address(priv, resp);
-		break;
-
 	case CMD_RET(CMD_802_11_AD_HOC_STOP):
 		ret = lbs_ret_80211_ad_hoc_stop(priv);
 		break;
--- wireless-testing.orig/drivers/net/wireless/libertas/hostcmd.h
+++ wireless-testing/drivers/net/wireless/libertas/hostcmd.h
@@ -429,6 +429,8 @@
 };
 
 struct cmd_ds_802_11_mac_address {
+	struct cmd_header hdr;
+
 	__le16 action;
 	u8 macadd[ETH_ALEN];
 };
@@ -716,7 +718,6 @@
 		struct cmd_ds_mac_multicast_adr madr;
 		struct cmd_ds_802_11_ad_hoc_join adj;
 		struct cmd_ds_802_11_disassociate dassociate;
-		struct cmd_ds_802_11_mac_address macadd;
 		struct cmd_ds_mac_reg_access macreg;
 		struct cmd_ds_bbp_reg_access bbpreg;
 		struct cmd_ds_rf_reg_access rfreg;
--- wireless-testing.orig/drivers/net/wireless/libertas/main.c
+++ wireless-testing/drivers/net/wireless/libertas/main.c
@@ -530,34 +530,27 @@
 	int ret = 0;
 	struct lbs_private *priv = (struct lbs_private *) dev->priv;
 	struct sockaddr *phwaddr = addr;
+	struct cmd_ds_802_11_mac_address cmd;
 
 	lbs_deb_enter(LBS_DEB_NET);
 
 	/* In case it was called from the mesh device */
-	dev = priv->dev ;
-
-	memset(priv->current_addr, 0, ETH_ALEN);
-
-	/* dev->dev_addr is 8 bytes */
-	lbs_deb_hex(LBS_DEB_NET, "dev->dev_addr", dev->dev_addr, ETH_ALEN);
-
-	lbs_deb_hex(LBS_DEB_NET, "addr", phwaddr->sa_data, ETH_ALEN);
-	memcpy(priv->current_addr, phwaddr->sa_data, ETH_ALEN);
+	dev = priv->dev;
 
-	ret = lbs_prepare_and_send_command(priv, CMD_802_11_MAC_ADDRESS,
-				    CMD_ACT_SET,
-				    CMD_OPTION_WAITFORRSP, 0, NULL);
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_ACT_SET);
+	memcpy(cmd.macadd, phwaddr->sa_data, ETH_ALEN);
 
+	ret = lbs_cmd_with_response(priv, CMD_802_11_MAC_ADDRESS, &cmd);
 	if (ret) {
 		lbs_deb_net("set MAC address failed\n");
-		ret = -1;
 		goto done;
 	}
 
-	lbs_deb_hex(LBS_DEB_NET, "priv->macaddr", priv->current_addr, ETH_ALEN);
-	memcpy(dev->dev_addr, priv->current_addr, ETH_ALEN);
+	memcpy(priv->current_addr, phwaddr->sa_data, ETH_ALEN);
+	memcpy(dev->dev_addr, phwaddr->sa_data, ETH_ALEN);
 	if (priv->mesh_dev)
-		memcpy(priv->mesh_dev->dev_addr, priv->current_addr, ETH_ALEN);
+		memcpy(priv->mesh_dev->dev_addr, phwaddr->sa_data, ETH_ALEN);
 
 done:
 	lbs_deb_leave_args(LBS_DEB_NET, "ret %d", ret);
