Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:9987 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbYAPOx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2008 09:53:26 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] libertas: always show firmware release
Date: Wed, 16 Jan 2008 15:55:22 +0100
Cc: libertas-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801161555.22380.hs4233@mail.mn-solutions.de> (sfid-20080116_145329_051422_048EEACE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Always shows the firmware release.

Also converts the firmware release into something that is easily comparable.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---

I've made this patch because recently different firmware versions behaved
different, e.g. the MESH TLV differs according to fw release.


Index: wireless-2.6/drivers/net/wireless/libertas/cmd.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/cmd.c	2008-01-16 11:09:23.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/cmd.c	2008-01-16 11:53:43.000000000 +0100
@@ -60,13 +60,24 @@ int lbs_update_hw_spec(struct lbs_privat
 		goto out;
 
 	priv->fwcapinfo = le32_to_cpu(cmd.fwcapinfo);
-	memcpy(priv->fwreleasenumber, cmd.fwreleasenumber, 4);
 
-	lbs_deb_cmd("GET_HW_SPEC: firmware release %u.%u.%up%u\n",
-		    priv->fwreleasenumber[2], priv->fwreleasenumber[1],
-		    priv->fwreleasenumber[0], priv->fwreleasenumber[3]);
-	lbs_deb_cmd("GET_HW_SPEC: MAC addr %s\n",
-		    print_mac(mac, cmd.permanentaddr));
+	/* The firmware release is in an interesting format: the patch
+	 * level is in the most significant nibble ... so fix that: */
+	priv->fwrelease = le32_to_cpu(cmd.fwrelease);
+	priv->fwrelease = (priv->fwrelease << 8) |
+		(priv->fwrelease >> 24 & 0xff);
+
+	/* Some firmware capabilities:
+	 * CF card    firmware 5.0.16p0:   cap 0x00000303
+	 * USB dongle firmware 5.110.17p2: cap 0x00000303
+	 */
+	printk("libertas: %s, fw %u.%u.%up%u, cap 0x%08x\n",
+		print_mac(mac, cmd.permanentaddr),
+		priv->fwrelease >> 24 & 0xff,
+		priv->fwrelease >> 16 & 0xff,
+		priv->fwrelease >>  8 & 0xff,
+		priv->fwrelease       & 0xff,
+		priv->fwcapinfo);
 	lbs_deb_cmd("GET_HW_SPEC: hardware interface 0x%x, hardware spec 0x%04x\n",
 		    cmd.hwifversion, cmd.version);
 
Index: wireless-2.6/drivers/net/wireless/libertas/dev.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/dev.h	2008-01-16 11:15:15.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/dev.h	2008-01-16 11:15:25.000000000 +0100
@@ -161,7 +161,7 @@ struct lbs_private {
 
 	/** Wlan adapter data structure*/
 	/** STATUS variables */
-	u8 fwreleasenumber[4];
+	u32 fwrelease;
 	u32 fwcapinfo;
 	/* protected with big lock */
 
Index: wireless-2.6/drivers/net/wireless/libertas/hostcmd.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/hostcmd.h	2008-01-16 11:18:07.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/hostcmd.h	2008-01-16 11:18:43.000000000 +0100
@@ -136,8 +136,8 @@ struct cmd_ds_get_hw_spec {
 	/* Number of antenna used */
 	__le16 nr_antenna;
 
-	/* FW release number, example 1,2,3,4 = 3.2.1p4 */
-	u8 fwreleasenumber[4];
+	/* FW release number, example 0x01030304 = 2.3.4p1 */
+	__le32 fwrelease;
 
 	/* Base Address of TxPD queue */
 	__le32 wcb_base;
Index: wireless-2.6/drivers/net/wireless/libertas/wext.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/wext.c	2008-01-16 11:17:13.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/wext.c	2008-01-16 11:52:40.000000000 +0100
@@ -2071,17 +2071,11 @@ void lbs_get_fwversion(struct lbs_privat
 
 	mutex_lock(&priv->lock);
 
-	if (priv->fwreleasenumber[3] == 0)
-		sprintf(fwver, "%u.%u.%u",
-			priv->fwreleasenumber[2],
-			priv->fwreleasenumber[1],
-			priv->fwreleasenumber[0]);
-	else
-		sprintf(fwver, "%u.%u.%u.p%u",
-			priv->fwreleasenumber[2],
-			priv->fwreleasenumber[1],
-			priv->fwreleasenumber[0],
-			priv->fwreleasenumber[3]);
+	sprintf(fwver, "%u.%u.%u.p%u",
+		priv->fwrelease >> 24 & 0xff,
+		priv->fwrelease >> 16 & 0xff,
+		priv->fwrelease >>  8 & 0xff,
+		priv->fwrelease       & 0xff);
 
 	mutex_unlock(&priv->lock);
 	snprintf(fwversion, maxlen, fwver);
