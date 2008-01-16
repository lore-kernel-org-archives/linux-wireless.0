Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:9665 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbYAPOvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2008 09:51:03 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] libertas: move cardspecific data to driver
Date: Wed, 16 Jan 2008 15:52:58 +0100
Cc: libertas-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801161552.59089.hs4233@mail.mn-solutions.de> (sfid-20080116_145107_241766_55FD793D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

boot2_version is purely USB specific, so move it to struct if_usb_card.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>


Index: wireless-2.6/drivers/net/wireless/libertas/dev.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/dev.h	2008-01-16 11:08:27.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/dev.h	2008-01-16 11:08:38.000000000 +0100
@@ -102,7 +102,6 @@ struct lbs_private {
 	int mesh_open;
 	int infra_open;
 	int mesh_autostart_enabled;
-	__le16 boot2_version;
 
 	char name[DEV_NAME_LEN];
 
Index: wireless-2.6/drivers/net/wireless/libertas/if_usb.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/if_usb.c	2008-01-16 11:08:27.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/if_usb.c	2008-01-16 11:08:38.000000000 +0100
@@ -104,12 +104,13 @@ static void if_usb_free(struct if_usb_ca
 
 static void if_usb_setup_firmware(struct lbs_private *priv)
 {
+	struct if_usb_card *cardp = priv->card;
 	struct cmd_ds_set_boot2_ver b2_cmd;
 	struct cmd_ds_802_11_fw_wake_method wake_method;
 
 	b2_cmd.hdr.size = cpu_to_le16(sizeof(b2_cmd));
 	b2_cmd.action = 0;
-	b2_cmd.version = priv->boot2_version;
+	b2_cmd.version = cardp->boot2_version;
 
 	if (lbs_cmd_with_response(priv, CMD_SET_BOOT2_VER, &b2_cmd))
 		lbs_deb_usb("Setting boot2 version failed\n");
@@ -234,7 +235,7 @@ static int if_usb_probe(struct usb_inter
 	priv->hw_host_to_card = if_usb_host_to_card;
 	priv->hw_get_int_status = if_usb_get_int_status;
 	priv->hw_read_event_cause = if_usb_read_event_cause;
-	priv->boot2_version = udev->descriptor.bcdDevice;
+	cardp->boot2_version = udev->descriptor.bcdDevice;
 
 	if_usb_submit_rx_urb(cardp);
 
Index: wireless-2.6/drivers/net/wireless/libertas/if_usb.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/if_usb.h	2008-01-16 11:08:27.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/if_usb.h	2008-01-16 11:08:38.000000000 +0100
@@ -70,6 +70,7 @@ struct if_usb_card {
 	uint8_t fwfinalblk;
 	uint8_t surprise_removed;
 
+	__le16 boot2_version;
 };
 
 /** fwheader */
