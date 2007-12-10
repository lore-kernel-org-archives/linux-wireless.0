Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45591 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbXLJRV7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:21:59 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 10/48] libertas: Move SET_BOOT2_VER command to if_usb where it belongs
Message-Id: <E1J1kpE-0006kv-JZ@shinybook.infradead.org> (sfid-20071210_172201_689715_4125EB87)
Date: Mon, 10 Dec 2007 10:45:44 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Thu, 6 Dec 2007 14:41:08 +0000

This is meaningless for non-USB devices and unimplemented in their
firmware. It's somewhat dubious for USB devices too, but that's a
different story.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/if_usb.c |    5 +++++
 drivers/net/wireless/libertas/main.c   |    4 ----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 418dcab..f858928 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -222,6 +222,11 @@ static int if_usb_probe(struct usb_interface *intf,
 	if (lbs_start_card(priv))
 		goto err_start_card;
 
+	/* Set the boot2 version in firmware, ignoring errors. */
+	(void)lbs_prepare_and_send_command(priv, CMD_SET_BOOT2_VER,
+					   0, CMD_OPTION_WAITFORRSP, 0, NULL);
+
+
 	usb_get_dev(udev);
 	usb_set_intfdata(intf, cardp);
 
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index ed02c02..a5b573c 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -999,10 +999,6 @@ static int lbs_setup_firmware(struct lbs_private *priv)
 		priv->mesh_autostart_enabled = 0;
 	}
 
-       /* Set the boot2 version in firmware */
-       ret = lbs_prepare_and_send_command(priv, CMD_SET_BOOT2_VER,
-                                   0, CMD_OPTION_WAITFORRSP, 0, NULL);
-
 	ret = 0;
 done:
 	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
-- 
1.5.3.4

