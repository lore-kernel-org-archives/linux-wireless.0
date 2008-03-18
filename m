Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:28765 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbYCRKXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2008 06:23:15 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: fix scheduling while atomic bug in CMD_MAC_CONTROL
Date: Tue, 18 Mar 2008 11:20:21 +0100
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803181120.21570.hs4233@mail.mn-solutions.de> (sfid-20080318_102320_840218_68E84064)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The old code incorrectly used lbs_cmd_with_response() and now uses
lbs_cmd_async().

While there I noticed that there is no real useful return values for
asynchronous command functions, so I made the function "void".

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-03-18 10:09:21.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-03-18 10:09:25.000000000 +0100
@@ -1286,9 +1286,8 @@ int lbs_set_radio_control(struct lbs_pri
 	return ret;
 }
 
-int lbs_set_mac_control(struct lbs_private *priv)
+void lbs_set_mac_control(struct lbs_private *priv)
 {
-	int ret = 0;
 	struct cmd_ds_mac_control cmd;
 
 	lbs_deb_enter(LBS_DEB_CMD);
@@ -1297,10 +1296,10 @@ int lbs_set_mac_control(struct lbs_priva
 	cmd.action = cpu_to_le16(priv->mac_control);
 	cmd.reserved = 0;
 
-	ret = lbs_cmd_with_response(priv, CMD_MAC_CONTROL, &cmd);
+	lbs_cmd_async(priv, CMD_MAC_CONTROL,
+		&cmd.hdr, sizeof(cmd));
 
-	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
-	return ret;
+	lbs_deb_leave(LBS_DEB_CMD);
 }
 
 /**
Index: wireless-testing/drivers/net/wireless/libertas/decl.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/decl.h	2008-03-18 10:07:11.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/decl.h	2008-03-18 10:09:25.000000000 +0100
@@ -17,7 +17,7 @@ struct net_device;
 struct cmd_ctrl_node;
 struct cmd_ds_command;
 
-int lbs_set_mac_control(struct lbs_private *priv);
+void lbs_set_mac_control(struct lbs_private *priv);
 
 void lbs_send_tx_feedback(struct lbs_private *priv);
 
Index: wireless-testing/drivers/net/wireless/libertas/assoc.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/assoc.c	2008-03-18 10:07:11.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/assoc.c	2008-03-18 10:09:25.000000000 +0100
@@ -272,9 +272,7 @@ static int assoc_helper_wep_keys(struct 
 	else
 		priv->mac_control &= ~CMD_ACT_MAC_WEP_ENABLE;
 
-	ret = lbs_set_mac_control(priv);
-	if (ret)
-		goto out;
+	lbs_set_mac_control(priv);
 
 	mutex_lock(&priv->lock);
 
@@ -304,9 +302,7 @@ static int assoc_helper_secinfo(struct l
 	memcpy(&priv->secinfo, &assoc_req->secinfo,
 		sizeof(struct lbs_802_11_security));
 
-	ret = lbs_set_mac_control(priv);
-	if (ret)
-		goto out;
+	lbs_set_mac_control(priv);
 
 	/* If RSN is already enabled, don't try to enable it again, since
 	 * ENABLE_RSN resets internal state machines and will clobber the
