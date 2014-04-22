Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:57344 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417AbaDVLyx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 07:54:53 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so4549277eek.4
        for <linux-wireless@vger.kernel.org>; Tue, 22 Apr 2014 04:54:52 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] b43: use b43_software_rfkill helper
Date: Tue, 22 Apr 2014 13:54:36 +0200
Message-Id: <1398167677-9207-2-git-send-email-zajec5@gmail.com> (sfid-20140422_135507_711525_4A4A61E9)
In-Reply-To: <1398167677-9207-1-git-send-email-zajec5@gmail.com>
References: <1398167677-9207-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes dealing with pointers directly and allows tracking radio
state with radio_on variable.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index dbaa518..3e45989 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -96,7 +96,7 @@ int b43_phy_init(struct b43_wldev *dev)
 
 	phy->channel = ops->get_default_chan(dev);
 
-	ops->software_rfkill(dev, false);
+	b43_software_rfkill(dev, false);
 	err = ops->init(dev);
 	if (err) {
 		b43err(dev->wl, "PHY init failed\n");
@@ -116,7 +116,7 @@ err_phy_exit:
 	if (ops->exit)
 		ops->exit(dev);
 err_block_rf:
-	ops->software_rfkill(dev, true);
+	b43_software_rfkill(dev, true);
 
 	return err;
 }
@@ -125,7 +125,7 @@ void b43_phy_exit(struct b43_wldev *dev)
 {
 	const struct b43_phy_operations *ops = dev->phy.ops;
 
-	ops->software_rfkill(dev, true);
+	b43_software_rfkill(dev, true);
 	if (ops->exit)
 		ops->exit(dev);
 }
-- 
1.8.4.5

