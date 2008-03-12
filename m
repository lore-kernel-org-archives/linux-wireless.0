Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:19560 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbYCLPJq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 11:09:46 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: libertas: rename packetfilter to mac_control
Date: Wed, 12 Mar 2008 16:06:43 +0100
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803121606.43783.hs4233@mail.mn-solutions.de> (sfid-20080312_150951_384199_9F3E0413)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The CMD_MAC_CONTROL can be used for other things than just filtering
packets, e.g. to enable and disable WMM. This uses the same term mac_control
for the define, the function and the shadow value in struct lbs_private.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-testing/drivers/net/wireless/libertas/assoc.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/assoc.c	2008-03-12 14:51:41.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/assoc.c	2008-03-12 14:59:41.000000000 +0100
@@ -268,11 +268,11 @@ static int assoc_helper_wep_keys(struct 
 
 	/* enable/disable the MAC's WEP packet filter */
 	if (assoc_req->secinfo.wep_enabled)
-		priv->currentpacketfilter |= CMD_ACT_MAC_WEP_ENABLE;
+		priv->mac_control |= CMD_ACT_MAC_WEP_ENABLE;
 	else
-		priv->currentpacketfilter &= ~CMD_ACT_MAC_WEP_ENABLE;
+		priv->mac_control &= ~CMD_ACT_MAC_WEP_ENABLE;
 
-	ret = lbs_set_mac_packet_filter(priv);
+	ret = lbs_set_mac_control(priv);
 	if (ret)
 		goto out;
 
@@ -304,7 +304,7 @@ static int assoc_helper_secinfo(struct l
 	memcpy(&priv->secinfo, &assoc_req->secinfo,
 		sizeof(struct lbs_802_11_security));
 
-	ret = lbs_set_mac_packet_filter(priv);
+	ret = lbs_set_mac_control(priv);
 	if (ret)
 		goto out;
 
Index: wireless-testing/drivers/net/wireless/libertas/dev.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/dev.h	2008-03-12 14:51:41.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/dev.h	2008-03-12 14:59:42.000000000 +0100
@@ -252,7 +252,7 @@ struct lbs_private {
 	struct sk_buff *currenttxskb;
 
 	/** NIC Operation characteristics */
-	u16 currentpacketfilter;
+	u16 mac_control;
 	u32 connect_status;
 	u32 mesh_connect_status;
 	u16 regioncode;
Index: wireless-testing/drivers/net/wireless/libertas/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-03-12 14:51:41.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-03-12 15:03:19.000000000 +0100
@@ -581,45 +581,45 @@ static int lbs_copy_multicast_address(st
 static void lbs_set_multicast_list(struct net_device *dev)
 {
 	struct lbs_private *priv = dev->priv;
-	int oldpacketfilter;
+	int old_mac_control;
 	DECLARE_MAC_BUF(mac);
 
 	lbs_deb_enter(LBS_DEB_NET);
 
-	oldpacketfilter = priv->currentpacketfilter;
+	old_mac_control = priv->mac_control;
 
 	if (dev->flags & IFF_PROMISC) {
 		lbs_deb_net("enable promiscuous mode\n");
-		priv->currentpacketfilter |=
+		priv->mac_control |=
 		    CMD_ACT_MAC_PROMISCUOUS_ENABLE;
-		priv->currentpacketfilter &=
+		priv->mac_control &=
 		    ~(CMD_ACT_MAC_ALL_MULTICAST_ENABLE |
 		      CMD_ACT_MAC_MULTICAST_ENABLE);
 	} else {
 		/* Multicast */
-		priv->currentpacketfilter &=
+		priv->mac_control &=
 		    ~CMD_ACT_MAC_PROMISCUOUS_ENABLE;
 
 		if (dev->flags & IFF_ALLMULTI || dev->mc_count >
 		    MRVDRV_MAX_MULTICAST_LIST_SIZE) {
 			lbs_deb_net( "enabling all multicast\n");
-			priv->currentpacketfilter |=
+			priv->mac_control |=
 			    CMD_ACT_MAC_ALL_MULTICAST_ENABLE;
-			priv->currentpacketfilter &=
+			priv->mac_control &=
 			    ~CMD_ACT_MAC_MULTICAST_ENABLE;
 		} else {
-			priv->currentpacketfilter &=
+			priv->mac_control &=
 			    ~CMD_ACT_MAC_ALL_MULTICAST_ENABLE;
 
 			if (!dev->mc_count) {
 				lbs_deb_net("no multicast addresses, "
 				       "disabling multicast\n");
-				priv->currentpacketfilter &=
+				priv->mac_control &=
 				    ~CMD_ACT_MAC_MULTICAST_ENABLE;
 			} else {
 				int i;
 
-				priv->currentpacketfilter |=
+				priv->mac_control |=
 				    CMD_ACT_MAC_MULTICAST_ENABLE;
 
 				priv->nr_of_multicastmacaddr =
@@ -642,9 +642,8 @@ static void lbs_set_multicast_list(struc
 		}
 	}
 
-	if (priv->currentpacketfilter != oldpacketfilter) {
-		lbs_set_mac_packet_filter(priv);
-	}
+	if (priv->mac_control != old_mac_control)
+		lbs_set_mac_control(priv);
 
 	lbs_deb_leave(LBS_DEB_NET);
 }
@@ -945,7 +944,7 @@ static int lbs_setup_firmware(struct lbs
 		goto done;
 	}
 
-	lbs_set_mac_packet_filter(priv);
+	lbs_set_mac_control(priv);
 
 	ret = lbs_get_data_rate(priv);
 	if (ret < 0) {
@@ -1036,7 +1035,7 @@ static int lbs_init_adapter(struct lbs_p
 	priv->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
 	priv->mode = IW_MODE_INFRA;
 	priv->curbssparams.channel = DEFAULT_AD_HOC_CHANNEL;
-	priv->currentpacketfilter = CMD_ACT_MAC_RX_ON | CMD_ACT_MAC_TX_ON;
+	priv->mac_control = CMD_ACT_MAC_RX_ON | CMD_ACT_MAC_TX_ON;
 	priv->radioon = RADIO_ON;
 	priv->auto_rate = 1;
 	priv->capability = WLAN_CAPABILITY_SHORT_PREAMBLE;
Index: wireless-testing/drivers/net/wireless/libertas/decl.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/decl.h	2008-03-12 14:51:41.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/decl.h	2008-03-12 14:59:42.000000000 +0100
@@ -17,7 +17,7 @@ struct net_device;
 struct cmd_ctrl_node;
 struct cmd_ds_command;
 
-int lbs_set_mac_packet_filter(struct lbs_private *priv);
+int lbs_set_mac_control(struct lbs_private *priv);
 
 void lbs_send_tx_feedback(struct lbs_private *priv);
 
Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-03-12 14:59:46.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-03-12 15:00:57.000000000 +0100
@@ -1286,7 +1286,7 @@ int lbs_set_radio_control(struct lbs_pri
 	return ret;
 }
 
-int lbs_set_mac_packet_filter(struct lbs_private *priv)
+int lbs_set_mac_control(struct lbs_private *priv)
 {
 	int ret = 0;
 	struct cmd_ds_mac_control cmd;
@@ -1294,7 +1294,7 @@ int lbs_set_mac_packet_filter(struct lbs
 	lbs_deb_enter(LBS_DEB_CMD);
 
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-	cmd.action = cpu_to_le16(priv->currentpacketfilter);
+	cmd.action = cpu_to_le16(priv->mac_control);
 	cmd.reserved = 0;
 
 	ret = lbs_cmd_with_response(priv, CMD_MAC_CONTROL, &cmd);
