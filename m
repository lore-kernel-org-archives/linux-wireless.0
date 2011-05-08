Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50735 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab1EHVnf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 May 2011 17:43:35 -0400
Received: by ewy4 with SMTP id 4so1390602ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 May 2011 14:43:34 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2] b43: trivial: include ssb word in ssb specific functions
Date: Mon,  9 May 2011 00:21:18 +0200
Message-Id: <1304893278-32318-1-git-send-email-zajec5@gmail.com> (sfid-20110508_234338_048547_65461D98)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be helpful when we decide to add support for other buses.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: commit message typo
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

