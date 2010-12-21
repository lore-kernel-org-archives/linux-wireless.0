Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:51478 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab0LUUoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 15:44:23 -0500
Subject: [PATCH 3/7] rndis_wlan: turn radio off before interface is bring up
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 21 Dec 2010 22:44:20 +0200
Message-ID: <20101221204420.12250.34667.stgit@fate.lan>
In-Reply-To: <20101221204405.12250.35410.stgit@fate.lan>
References: <20101221204405.12250.35410.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Radio should be off when interface is down.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rndis_wlan.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 9e6105c..42e19e8 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -3398,9 +3398,9 @@ static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	rndis_set_wiphy_params(wiphy,
 			WIPHY_PARAM_FRAG_THRESHOLD | WIPHY_PARAM_RTS_THRESHOLD);
 
-	/* turn radio on */
-	priv->radio_on = true;
-	disassociate(usbdev, true);
+	/* turn radio off on init */
+	priv->radio_on = false;
+	disassociate(usbdev, false);
 	netif_carrier_off(usbdev->net);
 
 	return 0;

