Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:5944 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbXLEQ5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 11:57:39 -0500
From: Holger Schurig <h.schurig@mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: [PATCH 2/5] libertas: remove cmd_ctrl_node->cmdflags
Date: Wed, 5 Dec 2007 17:57:56 +0100
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	David Woodhouse <dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200712051757.56664.h.schurig@mn-solutions.de> (sfid-20071205_165743_096034_024FC7D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was no code that ever did set this flag.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>


Index: wireless-2.6/drivers/net/wireless/libertas/cmdresp.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-2.6.orig/drivers/net/wireless/libertas/cmdresp.c	2007-12-0=
5 14:50:37.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/cmdresp.c	2007-12-05 17:=
59:51.000000000 +0100
@@ -856,13 +856,6 @@ int lbs_process_rx_command(struct lbs_pr
 		goto done;
 	}
=20
-	if (adapter->cur_cmd->cmdflags & CMD_F_HOSTCMD) {
-		/* Copy the response back to response buffer */
-		memcpy(adapter->cur_cmd->pdata_buf, resp,
-		       le16_to_cpu(resp->size));
-		adapter->cur_cmd->cmdflags &=3D ~CMD_F_HOSTCMD;
-	}
-
 	/* If the command is not successful, cleanup and return failure */
 	if ((result !=3D 0 || !(respcmd & 0x8000))) {
 		lbs_deb_host("CMD_RESP: error 0x%04x in command reply 0x%04x\n",
Index: wireless-2.6/drivers/net/wireless/libertas/hostcmd.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-2.6.orig/drivers/net/wireless/libertas/hostcmd.h	2007-12-0=
5 14:50:37.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/hostcmd.h	2007-12-05 17:=
59:51.000000000 +0100
@@ -75,7 +75,6 @@ struct cmd_ctrl_node {
 	void *pdata_buf;
 	/*command data */
 	u8 *bufvirtualaddr;
-	u16 cmdflags;
 	/* wait queue */
 	u16 cmdwaitqwoken;
 	wait_queue_head_t cmdwait_q;

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
