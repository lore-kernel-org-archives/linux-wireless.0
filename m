Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:5965 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbXLEQ5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 11:57:48 -0500
From: Holger Schurig <h.schurig@mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: [PATCH 4/5] libertas: make more functions static
Date: Wed, 5 Dec 2007 17:58:06 +0100
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	David Woodhouse <dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200712051758.07087.h.schurig@mn-solutions.de> (sfid-20071205_165750_915917_6AEDE4E4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These functions were used in the old debugfs code for events, but
as this code is now gone, there's no need to export those functions.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>


---
I've renamed lbs_get_free_cmd_ctrl_node() to a shorter name just
to make checkpatch.pl not bark about an 80 column violation.


Index: wireless-2.6/drivers/net/wireless/libertas/decl.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-2.6.orig/drivers/net/wireless/libertas/decl.h	2007-12-05 1=
8:04:10.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/decl.h	2007-12-05 18:06:=
20.000000000 +0100
@@ -15,18 +15,13 @@ struct lbs_private;
 struct lbs_adapter;
 struct sk_buff;
 struct net_device;
+struct cmd_ctrl_node;
=20
 int lbs_set_mac_packet_filter(struct lbs_private *priv);
=20
 void lbs_send_tx_feedback(struct lbs_private *priv);
=20
 int lbs_free_cmd_buffer(struct lbs_private *priv);
-struct cmd_ctrl_node;
-struct cmd_ctrl_node *lbs_get_free_cmd_ctrl_node(struct lbs_private *p=
riv);
-
-void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
-	struct cmd_ctrl_node *ptempnode,
-	u16 wait_option, void *pdata_buf);
=20
 int lbs_prepare_and_send_command(struct lbs_private *priv,
 	u16 cmd_no,
Index: wireless-2.6/drivers/net/wireless/libertas/cmd.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-2.6.orig/drivers/net/wireless/libertas/cmd.c	2007-12-05 18=
:06:31.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/cmd.c	2007-12-05 18:07:1=
6.000000000 +0100
@@ -13,6 +13,11 @@
 #include "wext.h"
=20
 static void cleanup_cmdnode(struct cmd_ctrl_node *ptempnode);
+struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv);
+void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
+		    struct cmd_ctrl_node *ptempnode,
+		    u16 wait_option, void *pdata_buf);
+
=20
 static u16 commands_allowed_in_ps[] =3D {
 	CMD_802_11_RSSI,
@@ -1220,7 +1225,7 @@ int lbs_prepare_and_send_command(struct=20
 		goto done;
 	}
=20
-	cmdnode =3D lbs_get_free_cmd_ctrl_node(priv);
+	cmdnode =3D lbs_get_cmd_ctrl_node(priv);
=20
 	if (cmdnode =3D=3D NULL) {
 		lbs_deb_host("PREP_CMD: cmdnode is NULL\n");
@@ -1623,7 +1628,7 @@ done:
  *  @param priv		A pointer to struct lbs_private structure
  *  @return cmd_ctrl_node A pointer to cmd_ctrl_node structure or NULL
  */
-struct cmd_ctrl_node *lbs_get_free_cmd_ctrl_node(struct lbs_private *p=
riv)
+struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv)
 {
 	struct cmd_ctrl_node *tempnode;
 	struct lbs_adapter *adapter =3D priv->adapter;

--=20
M&N Solutions GmbH          Ein Unternehmen der Datagroup AG
Holger Schurig
Raiffeisenstr. 10           ACHTUNG: die Stra=DFe hat sich ge=E4ndert
61191 Rosbach
Tel: 06003/9141-15          Fax 06003/9141-49
http://www.mn-solutions.de/

Handelsregister Friedberg, HRB 5903
Gesch=E4ftsf=FChrer: H.Herzig, P.Schrittenlocher
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
