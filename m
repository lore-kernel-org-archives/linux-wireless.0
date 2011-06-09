Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55720 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab1FIHKA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 03:10:00 -0400
Date: Thu, 9 Jun 2011 10:09:34 +0300
From: Dan Carpenter <error27@gmail.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"open list:B43 WIRELESS DRIVER" <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: [patch] b43: check for allocation failures
Message-ID: <20110609070934.GE4069@shale.localdomain> (sfid-20110609_091007_816329_2C2C7057)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add some error handling if the allocation fails.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/b43/bus.c b/drivers/net/wireless/b43/bus.c
index 6c63aec..8a10b82 100644
--- a/drivers/net/wireless/b43/bus.c
+++ b/drivers/net/wireless/b43/bus.c
@@ -83,7 +83,11 @@ void b43_bus_ssb_block_write(struct b43_bus_dev *dev, const void *buffer,
 
 struct b43_bus_dev *b43_bus_dev_ssb_init(struct ssb_device *sdev)
 {
-	struct b43_bus_dev *dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	struct b43_bus_dev *dev;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return NULL;
 
 	dev->bus_type = B43_BUS_SSB;
 	dev->sdev = sdev;
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index cae3146..c8131a0 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -5025,6 +5025,8 @@ int b43_ssb_probe(struct ssb_device *sdev, const struct ssb_device_id *id)
 	int first = 0;
 
 	dev = b43_bus_dev_ssb_init(sdev);
+	if (!dev)
+		return -ENOMEM;
 
 	wl = ssb_get_devtypedata(sdev);
 	if (!wl) {
