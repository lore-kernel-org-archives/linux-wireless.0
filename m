Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:51025 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbXI3Sjv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:39:51 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 11/26] at76_usb: Stop worrying about line termination in  ethtool info
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:39:49 -0400
Message-ID: <20070930183949.23921.85840.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver's responsibility is not to overwrite the buffer and not to
leak kernel data.  Line termination is the userspace responsibility.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index b6f931a..2bb23e8 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -3322,14 +3322,12 @@ static void at76_ethtool_get_drvinfo(struct net_device *netdev,
 {
 	struct at76_priv *priv = netdev_priv(netdev);
 
-	strncpy(info->driver, DRIVER_NAME, sizeof(info->driver) - 1);
-
+	strncpy(info->driver, DRIVER_NAME, sizeof(info->driver));
 	strncpy(info->version, DRIVER_VERSION, sizeof(info->version));
-	info->version[sizeof(info->version) - 1] = '\0';
 
 	usb_make_path(priv->udev, info->bus_info, sizeof(info->bus_info));
 
-	snprintf(info->fw_version, sizeof(info->fw_version) - 1, "%d.%d.%d-%d",
+	snprintf(info->fw_version, sizeof(info->fw_version), "%d.%d.%d-%d",
 		 priv->fw_version.major, priv->fw_version.minor,
 		 priv->fw_version.patch, priv->fw_version.build);
 }
