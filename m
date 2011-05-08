Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37400 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab1EHVmd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 May 2011 17:42:33 -0400
Received: by eyx24 with SMTP id 24so1389418eyx.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 May 2011 14:42:32 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: trivial: include ssb word in ssb specific functions
Date: Mon,  9 May 2011 00:20:16 +0200
Message-Id: <1304893216-32283-1-git-send-email-zajec5@gmail.com> (sfid-20110508_234237_089447_A4EBA1F9)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be helpful when we decide to add support for ther buses.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index b02fbab..fd8bd98 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4959,7 +4959,7 @@ out:
 	return err;
 }
 
-static int b43_probe(struct ssb_device *dev, const struct ssb_device_id *id)
+static int b43_ssb_probe(struct ssb_device *dev, const struct ssb_device_id *id)
 {
 	struct b43_wl *wl;
 	int err;
@@ -4997,7 +4997,7 @@ static int b43_probe(struct ssb_device *dev, const struct ssb_device_id *id)
 	return err;
 }
 
-static void b43_remove(struct ssb_device *dev)
+static void b43_ssb_remove(struct ssb_device *dev)
 {
 	struct b43_wl *wl = ssb_get_devtypedata(dev);
 	struct b43_wldev *wldev = ssb_get_drvdata(dev);
@@ -5040,8 +5040,8 @@ void b43_controller_restart(struct b43_wldev *dev, const char *reason)
 static struct ssb_driver b43_ssb_driver = {
 	.name		= KBUILD_MODNAME,
 	.id_table	= b43_ssb_tbl,
-	.probe		= b43_probe,
-	.remove		= b43_remove,
+	.probe		= b43_ssb_probe,
+	.remove		= b43_ssb_remove,
 };
 
 static void b43_print_driverinfo(void)
-- 
1.7.3.4

