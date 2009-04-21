Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.dnainternet.fi ([87.94.96.72]:15473 "EHLO
	smtp4.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbZDUQsT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 12:48:19 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/2] rndis_wlan: free priv correctly when rndis_wext_bind fails
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Date: Tue, 21 Apr 2009 19:48:15 +0300
Message-ID: <20090421164815.3635.74504.stgit@fate.lan> (sfid-20090421_184822_036788_D36D41A2)
In-Reply-To: <20090421164807.3635.43002.stgit@fate.lan>
References: <20090421164807.3635.43002.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Private structure is allocated by wiphy_new now, so use
wiphy_free instead of kfree.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index d8b2e6a..eadfc30 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2449,8 +2449,8 @@ static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	set_wiphy_dev(wiphy, &usbdev->udev->dev);
 
 	if (wiphy_register(wiphy)) {
-		wiphy_free(wiphy);
-		return -ENODEV;
+		retval = -ENODEV;
+		goto fail;
 	}
 
 	set_default_iw_params(usbdev);
@@ -2472,7 +2472,7 @@ fail:
 	flush_workqueue(priv->workqueue);
 	destroy_workqueue(priv->workqueue);
 
-	kfree(priv);
+	wiphy_free(wiphy);
 	return retval;
 }
 

