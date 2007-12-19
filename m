Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pmac.infradead.org ([90.155.92.200]:44867 "EHLO
	pmac.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbXLSQKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 11:10:19 -0500
Subject: [PATCH 121/48] libertas: Check for PS mode support on USB devices
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J50u0-00020Q-B9@pmac.infradead.org> (sfid-20071219_161024_119315_9C89DE8C)
Date: Wed, 19 Dec 2007 15:32:08 +0000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Mon, 17 Dec 2007 14:42:33 -0500

Move the various firmware setup bits into a separate function, which
used to do just boot2 version.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/if_usb.c |   28 ++++++++++++++++++++++------
 1 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 8bc23b3..3931fe6 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -102,9 +102,10 @@ static void if_usb_free(struct if_usb_card *cardp)
 	lbs_deb_leave(LBS_DEB_USB);
 }
 
-static void if_usb_set_boot2_ver(struct lbs_private *priv)
+static void if_usb_setup_firmware(struct lbs_private *priv)
 {
 	struct cmd_ds_set_boot2_ver b2_cmd;
+	struct cmd_ds_802_11_fw_wake_method wake_method;
 
 	b2_cmd.hdr.size = cpu_to_le16(sizeof(b2_cmd));
 	b2_cmd.action = 0;
@@ -112,6 +113,25 @@ static void if_usb_set_boot2_ver(struct lbs_private *priv)
 
 	if (lbs_cmd_with_response(priv, CMD_SET_BOOT2_VER, &b2_cmd))
 		lbs_deb_usb("Setting boot2 version failed\n");
+
+	priv->wol_gpio = 2; /* Wake via GPIO2... */
+	priv->wol_gap = 20; /* ... after 20ms    */
+	lbs_host_sleep_cfg(priv, EHS_WAKE_ON_UNICAST_DATA);
+
+	wake_method.hdr.size = cpu_to_le16(sizeof(wake_method));
+	wake_method.action = cpu_to_le16(CMD_ACT_GET);
+	if (lbs_cmd_with_response(priv, CMD_802_11_FW_WAKE_METHOD, &wake_method)) {
+		lbs_pr_info("Firmware does not seem to support PS mode\n");
+	} else {
+		if (le16_to_cpu(wake_method.method) == CMD_WAKE_METHOD_COMMAND_INT) {
+			lbs_deb_usb("Firmware seems to support PS with wake-via-command\n");
+			priv->ps_supported = 1;
+		} else {
+			/* The versions which boot up this way don't seem to
+			   work even if we set it to the command interrupt */
+			lbs_pr_info("Firmware doesn't wake via command interrupt; disabling PS mode\n");
+		}
+	}
 }
 
 static void if_usb_fw_timeo(unsigned long priv)
@@ -221,11 +241,7 @@ static int if_usb_probe(struct usb_interface *intf,
 	if (lbs_start_card(priv))
 		goto err_start_card;
 
-	if_usb_set_boot2_ver(priv);
-
-	priv->wol_gpio = 2; /* Wake via GPIO2... */
-	priv->wol_gap = 20; /* ... after 20ms    */
-	lbs_host_sleep_cfg(priv, EHS_WAKE_ON_UNICAST_DATA);
+	if_usb_setup_firmware(priv);
 
 	usb_get_dev(udev);
 	usb_set_intfdata(intf, cardp);
-- 
1.5.3.4

