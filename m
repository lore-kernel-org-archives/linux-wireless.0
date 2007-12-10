Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45604 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbXLJRX2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:23:28 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 15/48] libertas: Use lbs_cmd() for setting Boot2 version
Message-Id: <E1J1kpJ-0006lK-RS@shinybook.infradead.org> (sfid-20071210_172330_159712_98F6F356)
Date: Mon, 10 Dec 2007 10:45:49 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Thu, 6 Dec 2007 12:51:00 +0000

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/if_usb.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index f858928..4d89fd0 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -101,6 +101,21 @@ static void if_usb_free(struct usb_card_rec *cardp)
 	lbs_deb_leave(LBS_DEB_USB);
 }
 
+static void if_usb_set_boot2_ver(struct lbs_private *priv)
+{
+	struct cmd_ds_set_boot2_ver b2_cmd;
+	int rsp_len = sizeof(b2_cmd);
+
+	b2_cmd.action = 0;
+	b2_cmd.version = cpu_to_le16(priv->boot2_version);
+
+	if (lbs_cmd(priv, CMD_SET_BOOT2_VER, &b2_cmd, sizeof(b2_cmd),
+		    &b2_cmd, &rsp_len)) {
+		lbs_deb_usb("Setting boot2 version failed\n");
+	}
+}
+
+
 /**
  *  @brief sets the configuration values
  *  @param ifnum	interface number
@@ -222,10 +237,7 @@ static int if_usb_probe(struct usb_interface *intf,
 	if (lbs_start_card(priv))
 		goto err_start_card;
 
-	/* Set the boot2 version in firmware, ignoring errors. */
-	(void)lbs_prepare_and_send_command(priv, CMD_SET_BOOT2_VER,
-					   0, CMD_OPTION_WAITFORRSP, 0, NULL);
-
+	if_usb_set_boot2_ver(priv);
 
 	usb_get_dev(udev);
 	usb_set_intfdata(intf, cardp);
-- 
1.5.3.4

