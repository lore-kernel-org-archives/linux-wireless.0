Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:22661 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYAPOzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2008 09:55:47 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] libertas: don't blindly try mesh
Date: Wed, 16 Jan 2008 15:57:44 +0100
Cc: libertas-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801161557.44241.hs4233@mail.mn-solutions.de> (sfid-20080116_145550_163738_CDEDD93A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The CF card only has a very old firmware (5.0.16p0). This firmware doesn't
know anything about mesh config. However, current code blindly calls
mesh_config when the card is inserted. So check the firmware version before
issuing this command.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---

This depends on my previous patch that allows an easier comparision of the firmware
release.

Index: wireless-2.6/drivers/net/wireless/libertas/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/main.c	2008-01-16 11:50:05.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/main.c	2008-01-16 11:54:07.000000000 +0100
@@ -1192,31 +1192,35 @@ int lbs_start_card(struct lbs_private *p
 	if (device_create_file(&dev->dev, &dev_attr_lbs_rtap))
 		lbs_pr_err("cannot register lbs_rtap attribute\n");
 
-	/* Enable mesh, if supported, and work out which TLV it uses.
-	   0x100 + 291 is an unofficial value used in 5.110.20.pXX
-	   0x100 + 37 is the official value used in 5.110.21.pXX
-	   but we check them in that order because 20.pXX doesn't
-	   give an error -- it just silently fails. */
+	lbs_update_channel(priv);
 
-	/* 5.110.20.pXX firmware will fail the command if the channel
-	   doesn't match the existing channel. But only if the TLV
-	   is correct. If the channel is wrong, _BOTH_ versions will
-	   give an error to 0x100+291, and allow 0x100+37 to succeed.
-	   It's just that 5.110.20.pXX will not have done anything
-	   useful */
+	/* 5.0.16p0 is known to NOT support any mesh */
+	if (priv->fwrelease > 0x05001000) {
+		/* Enable mesh, if supported, and work out which TLV it uses.
+		   0x100 + 291 is an unofficial value used in 5.110.20.pXX
+		   0x100 + 37 is the official value used in 5.110.21.pXX
+		   but we check them in that order because 20.pXX doesn't
+		   give an error -- it just silently fails. */
 
-	lbs_update_channel(priv);
-	priv->mesh_tlv = 0x100 + 291;
-	if (lbs_mesh_config(priv, 1, priv->curbssparams.channel)) {
-		priv->mesh_tlv = 0x100 + 37;
-		if (lbs_mesh_config(priv, 1, priv->curbssparams.channel))
-			priv->mesh_tlv = 0;
-	}
-	if (priv->mesh_tlv) {
-		lbs_add_mesh(priv);
+		/* 5.110.20.pXX firmware will fail the command if the channel
+		   doesn't match the existing channel. But only if the TLV
+		   is correct. If the channel is wrong, _BOTH_ versions will
+		   give an error to 0x100+291, and allow 0x100+37 to succeed.
+		   It's just that 5.110.20.pXX will not have done anything
+		   useful */
 
-		if (device_create_file(&dev->dev, &dev_attr_lbs_mesh))
-			lbs_pr_err("cannot register lbs_mesh attribute\n");
+		priv->mesh_tlv = 0x100 + 291;
+		if (lbs_mesh_config(priv, 1, priv->curbssparams.channel)) {
+			priv->mesh_tlv = 0x100 + 37;
+			if (lbs_mesh_config(priv, 1, priv->curbssparams.channel))
+				priv->mesh_tlv = 0;
+		}
+		if (priv->mesh_tlv) {
+			lbs_add_mesh(priv);
+
+			if (device_create_file(&dev->dev, &dev_attr_lbs_mesh))
+				lbs_pr_err("cannot register lbs_mesh attribute\n");
+		}
 	}
 
 	lbs_debugfs_init_one(priv, dev);
