Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55978 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761451AbXLMG7w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:52 -0500
Subject: [PATCH 85/48] libertas: add missing newlines in debugging statements
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i38-0005tr-MQ@shinybook.infradead.org> (sfid-20071213_070636_511550_40699752)
Date: Thu, 13 Dec 2007 02:00:02 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Wed, 12 Dec 2007 00:14:21 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/assoc.c  |   10 +++++-----
 drivers/net/wireless/libertas/cmd.c    |    8 ++++----
 drivers/net/wireless/libertas/if_usb.c |    2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index 7b672fe..21a5696 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -198,7 +198,7 @@ static int assoc_helper_channel(struct lbs_private *priv,
 
 	ret = update_channel(priv);
 	if (ret < 0) {
-		lbs_deb_assoc("ASSOC: channel: error getting channel.");
+		lbs_deb_assoc("ASSOC: channel: error getting channel.\n");
 	}
 
 	if (assoc_req->channel == priv->curbssparams.channel)
@@ -215,14 +215,14 @@ static int assoc_helper_channel(struct lbs_private *priv,
 
 	ret = lbs_set_channel(priv, assoc_req->channel);
 	if (ret < 0)
-		lbs_deb_assoc("ASSOC: channel: error setting channel.");
+		lbs_deb_assoc("ASSOC: channel: error setting channel.\n");
 
 	/* FIXME: shouldn't need to grab the channel _again_ after setting
 	 * it since the firmware is supposed to return the new channel, but
 	 * whatever... */
 	ret = update_channel(priv);
 	if (ret < 0)
-		lbs_deb_assoc("ASSOC: channel: error getting channel.");
+		lbs_deb_assoc("ASSOC: channel: error getting channel.\n");
 
 	if (assoc_req->channel != priv->curbssparams.channel) {
 		lbs_deb_assoc("ASSOC: channel: failed to update channel to %d\n",
@@ -240,7 +240,7 @@ static int assoc_helper_channel(struct lbs_private *priv,
 	}
 
 	/* Must restart/rejoin adhoc networks after channel change */
-	set_bit(ASSOC_FLAG_SSID, &assoc_req->flags);
+ 	set_bit(ASSOC_FLAG_SSID, &assoc_req->flags);
 
  restore_mesh:
 	if (priv->mesh_dev)
@@ -334,7 +334,7 @@ static int assoc_helper_secinfo(struct lbs_private *priv,
 				    CMD_OPTION_WAITFORRSP,
 				    0, &rsn);
 	if (ret) {
-		lbs_deb_assoc("Failed to get RSN status: %d", ret);
+		lbs_deb_assoc("Failed to get RSN status: %d\n", ret);
 		goto out;
 	}
 
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 5ddb46a..8d8f9d9 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -222,7 +222,7 @@ static int lbs_cmd_802_11_set_wep(struct lbs_private *priv,
 		int i;
 
 		if (!assoc_req) {
-			lbs_deb_cmd("Invalid association request!");
+			lbs_deb_cmd("Invalid association request!\n");
 			ret = -1;
 			goto done;
 		}
@@ -2088,17 +2088,17 @@ void lbs_ps_confirm_sleep(struct lbs_private *priv, u16 psmode)
 
 	if (priv->dnld_sent) {
 		allowed = 0;
-		lbs_deb_host("dnld_sent was set");
+		lbs_deb_host("dnld_sent was set\n");
 	}
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
 	if (priv->cur_cmd) {
 		allowed = 0;
-		lbs_deb_host("cur_cmd was set");
+		lbs_deb_host("cur_cmd was set\n");
 	}
 	if (priv->intcounter > 0) {
 		allowed = 0;
-		lbs_deb_host("intcounter %d", priv->intcounter);
+		lbs_deb_host("intcounter %d\n", priv->intcounter);
 	}
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 6b8ac62..3f8b83c 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -220,7 +220,7 @@ static int if_usb_probe(struct usb_interface *intf,
 	/* Upload firmware */
 	cardp->rinfo.cardp = cardp;
 	if (if_usb_prog_firmware(cardp)) {
-		lbs_deb_usbd(&udev->dev, "FW upload failed");
+		lbs_deb_usbd(&udev->dev, "FW upload failed\n");
 		goto err_prog_firmware;
 	}
 
-- 
1.5.3.4

