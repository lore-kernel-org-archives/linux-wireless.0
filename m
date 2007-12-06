Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:2451 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbXLFJPd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 04:15:33 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] libertas: fix data packet size errors
Date: Thu, 6 Dec 2007 10:15:54 +0100
Cc: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200712061015.54478.hs4233@mail.mn-solutions.de> (sfid-20071206_091750_821738_8CE53D0C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I wondered about junk bytes at the end when using "lbsdebug +hex
+host" until I noticed that firmware for the CF card sends my
extranous bytes. It says "I have 20 bytes", I take 20 bytes, but
the last 8 bytes of this are just data junk.

Also, in the new lbs_cmd() where was a size miscalulation
that made itself clear after fixing this bug.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>


---
The length the low-level-driver (usb, cf, sdio)
if_XXX_receive_cmdres() reports back via *len ends up
in "priv->upld_len". upld_len is only used in debugging
statements, all code was looking at the "__le16 size" field
anyway.

We might as well remove "priv->upld_len" completely.


Index: wireless-2.6/drivers/net/wireless/libertas/if_cs.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/if_cs.c	2007-12-06 10:48:02.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/if_cs.c	2007-12-06 11:02:43.000000000 +0100
@@ -373,6 +373,9 @@ static int if_cs_receive_cmdres(struct l
 	if (*len & 1)
 		data[*len-1] = if_cs_read8(priv->card, IF_CS_C_CMD);
 
+	/* This is a workaround for a firmware that reports too much
+	 * bytes */
+	*len -= 8
 	ret = 0;
 out:
 	lbs_deb_leave_args(LBS_DEB_CS, "ret %d, len %d", ret, *len);
Index: wireless-2.6/drivers/net/wireless/libertas/cmdresp.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/cmdresp.c	2007-12-06 10:42:41.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/cmdresp.c	2007-12-06 10:50:02.000000000 +0100
@@ -882,7 +882,7 @@ int lbs_process_rx_command(struct lbs_pr
 
 	if (adapter->cur_cmd->pdata_size) {
 		struct cmd_ds_gen *r = (struct cmd_ds_gen *)resp;
-		u16 sz = cpu_to_le16(resp->size);
+		u16 sz = cpu_to_le16(resp->size) - S_DS_GEN;
 		if (sz > *adapter->cur_cmd->pdata_size) {
 			lbs_pr_err("response 0x%04x doesn't fit into "
 				"buffer (%d > %d)\n", respcmd,
