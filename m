Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:54068 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbZB0FuJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 00:50:09 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH] at76c50x-usb: use dev_name() instead of struct device.bus_id
To: linville@tuxdriver.com
Cc: linux-next@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
	Greg KH <greg@kroah.com>, linux-wireless@vger.kernel.org
Date: Fri, 27 Feb 2009 07:50:00 +0200
Message-ID: <20090227054959.25492.72388.stgit@tikku> (sfid-20090227_065013_424417_926A3B45)
In-Reply-To: <20090227134411.54e99731.sfr@canb.auug.org.au>
References: <20090227134411.54e99731.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Rothwell reported that bus_id from struct device will be removed, use
dev_name() instead.

Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 drivers/net/wireless/at76c50x-usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index cc2a267..0c02f1c 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -2268,7 +2268,7 @@ static int at76_init_new_device(struct at76_priv *priv,
 
 	printk(KERN_INFO "%s: USB %s, MAC %s, firmware %d.%d.%d-%d\n",
 	       wiphy_name(priv->hw->wiphy),
-	       interface->dev.bus_id, mac2str(priv->mac_addr),
+	       dev_name(&interface->dev), mac2str(priv->mac_addr),
 	       priv->fw_version.major, priv->fw_version.minor,
 	       priv->fw_version.patch, priv->fw_version.build);
 	printk(KERN_INFO "%s: regulatory domain 0x%02x: %s\n",

