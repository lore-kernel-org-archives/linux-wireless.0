Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:57117 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbXI3Sks (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:40:48 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 20/26] at76_usb: Revert to network device names starting with  "wlan"
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:40:47 -0400
Message-ID: <20070930184046.23921.46695.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The change to the default "eth" in 0.16 was unnecessary and broke some
setups.  Reported by Mark Sansome <msansome@troodos.demon.co.uk>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index fb339ab..6dc8e23 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -5294,6 +5294,7 @@ static int at76_init_new_device(struct at76_priv *priv,
 	netdev->wireless_handlers = &at76_handler_def;
 	netdev->set_multicast_list = at76_set_multicast;
 	netdev->set_mac_address = at76_set_mac_address;
+	dev_alloc_name(netdev, "wlan%d");
 
 	ret = register_netdev(priv->netdev);
 	if (ret) {
