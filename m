Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:62501 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbZLHOWB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 09:22:01 -0500
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Stefan Seyfried <seife@sphairon.com>
Subject: [PATCH 2/2] zd1211rw: improve ejecting of fake CDROM
Date: Tue,  8 Dec 2009 15:21:35 +0100
Message-Id: <1260282095-17042-3-git-send-email-stefan.seyfried@googlemail.com>
In-Reply-To: <1260282095-17042-2-git-send-email-stefan.seyfried@googlemail.com>
References: <1260282095-17042-1-git-send-email-stefan.seyfried@googlemail.com>
 <1260282095-17042-2-git-send-email-stefan.seyfried@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stefan Seyfried <seife@sphairon.com>

The zd1211rw always assumed that the storage device is at endpoint 1,
but there are devices (Spairon Homelink 1202) that are at endpoint 0.
Try both, starting with 1 to make sure to not break existing setups.

Signed-off-by: Stefan Seyfried <seife@sphairon.com>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index ac19ecd..4daf1c9 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -1078,11 +1078,15 @@ static int eject_installer(struct usb_interface *intf)
 	int r;
 
 	/* Find bulk out endpoint */
-	endpoint = &iface_desc->endpoint[1].desc;
-	if (usb_endpoint_dir_out(endpoint) &&
-	    usb_endpoint_xfer_bulk(endpoint)) {
-		bulk_out_ep = endpoint->bEndpointAddress;
-	} else {
+	for (r = 1; r >= 0; r--) {
+		endpoint = &iface_desc->endpoint[r].desc;
+		if (usb_endpoint_dir_out(endpoint) &&
+		    usb_endpoint_xfer_bulk(endpoint)) {
+			bulk_out_ep = endpoint->bEndpointAddress;
+			break;
+		}
+	}
+	if (r == -1) {
 		dev_err(&udev->dev,
 			"zd1211rw: Could not find bulk out endpoint\n");
 		return -ENODEV;
-- 
1.6.5.3

