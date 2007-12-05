Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:5952 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbXLEQ5l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 11:57:41 -0500
From: Holger Schurig <h.schurig@mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: [PATCH 3/5] libertas: remove cmd_ctrl_node->status
Date: Wed, 5 Dec 2007 17:57:58 +0100
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	David Woodhouse <dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200712051757.58489.h.schurig@mn-solutions.de> (sfid-20071205_165744_545969_FB86BE47)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was no code that ever did set this variable.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>


Index: wireless-2.6/drivers/net/wireless/libertas/cmd.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-2.6.orig/drivers/net/wireless/libertas/cmd.c	2007-12-05 18=
:07:16.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/cmd.c	2007-12-05 18:11:2=
7.000000000 +0100
@@ -1672,7 +1672,6 @@ static void cleanup_cmdnode(struct cmd_c
 		return;
 	ptempnode->cmdwaitqwoken =3D 1;
 	wake_up_interruptible(&ptempnode->cmdwait_q);
-	ptempnode->status =3D 0;
 	ptempnode->wait_option =3D 0;
 	ptempnode->pdata_buf =3D NULL;
=20
Index: wireless-2.6/drivers/net/wireless/libertas/hostcmd.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-2.6.orig/drivers/net/wireless/libertas/hostcmd.h	2007-12-0=
5 18:03:40.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/hostcmd.h	2007-12-05 18:=
10:38.000000000 +0100
@@ -68,7 +68,6 @@ struct rxpd {
 struct cmd_ctrl_node {
 	/* CMD link list */
 	struct list_head list;
-	u32 status;
 	/*CMD wait option: wait for finish or no wait */
 	u16 wait_option;
 	/* command parameter */

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
