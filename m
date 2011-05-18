Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57019 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab1EQX3C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 19:29:02 -0400
Received: by eyx24 with SMTP id 24so286932eyx.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 16:29:01 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/9] b43: rename ssb_device variable in ssb specific functions
Date: Wed, 18 May 2011 02:06:35 +0200
Message-Id: <1305677203-16660-1-git-send-email-zajec5@gmail.com> (sfid-20110518_012907_655368_0943490B)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index eb41596..1e81a0d 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4982,26 +4982,27 @@ static struct b43_wl *b43_wireless_init(struct ssb_device *dev)
 	return wl;
 }
 
-static int b43_ssb_probe(struct ssb_device *dev, const struct ssb_device_id *id)
+static
+int b43_ssb_probe(struct ssb_device *sdev, const struct ssb_device_id *id)
 {
 	struct b43_wl *wl;
 	int err;
 	int first = 0;
 
-	wl = ssb_get_devtypedata(dev);
+	wl = ssb_get_devtypedata(sdev);
 	if (!wl) {
 		/* Probing the first core. Must setup common struct b43_wl */
 		first = 1;
-		b43_sprom_fixup(dev->bus);
-		wl = b43_wireless_init(dev);
+		b43_sprom_fixup(sdev->bus);
+		wl = b43_wireless_init(sdev);
 		if (IS_ERR(wl)) {
 			err = PTR_ERR(wl);
 			goto out;
 		}
-		ssb_set_devtypedata(dev, wl);
-		B43_WARN_ON(ssb_get_devtypedata(dev) != wl);
+		ssb_set_devtypedata(sdev, wl);
+		B43_WARN_ON(ssb_get_devtypedata(sdev) != wl);
 	}
-	err = b43_one_core_attach(dev, wl);
+	err = b43_one_core_attach(sdev, wl);
 	if (err)
 		goto err_wireless_exit;
 
@@ -5016,17 +5017,17 @@ static int b43_ssb_probe(struct ssb_device *dev, const struct ssb_device_id *id)
 	return err;
 
       err_one_core_detach:
-	b43_one_core_detach(dev);
+	b43_one_core_detach(sdev);
       err_wireless_exit:
 	if (first)
-		b43_wireless_exit(dev, wl);
+		b43_wireless_exit(sdev, wl);
 	return err;
 }
 
-static void b43_ssb_remove(struct ssb_device *dev)
+static void b43_ssb_remove(struct ssb_device *sdev)
 {
-	struct b43_wl *wl = ssb_get_devtypedata(dev);
-	struct b43_wldev *wldev = ssb_get_drvdata(dev);
+	struct b43_wl *wl = ssb_get_devtypedata(sdev);
+	struct b43_wldev *wldev = ssb_get_drvdata(sdev);
 
 	/* We must cancel any work here before unregistering from ieee80211,
 	 * as the ieee80211 unreg will destroy the workqueue. */
@@ -5042,14 +5043,14 @@ static void b43_ssb_remove(struct ssb_device *dev)
 		ieee80211_unregister_hw(wl->hw);
 	}
 
-	b43_one_core_detach(dev);
+	b43_one_core_detach(sdev);
 
 	if (list_empty(&wl->devlist)) {
 		b43_leds_unregister(wl);
 		/* Last core on the chip unregistered.
 		 * We can destroy common struct b43_wl.
 		 */
-		b43_wireless_exit(dev, wl);
+		b43_wireless_exit(sdev, wl);
 	}
 }
 
-- 
1.7.3.4

