Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:55378 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab1GTRX5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 13:23:57 -0400
Received: by fxd18 with SMTP id 18so2066589fxd.11
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2011 10:23:56 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: (un)initialize driver on the BCMA bus
Date: Wed, 20 Jul 2011 20:02:39 +0200
Message-Id: <1311184959-4393-1-git-send-email-zajec5@gmail.com> (sfid-20110720_192401_024324_F8095043)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c |   48 +++++++++++++++++++++++++++++++++++---
 1 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 269483a..d9f53b7 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -5235,19 +5235,59 @@ static struct b43_wl *b43_wireless_init(struct b43_bus_dev *dev)
 static int b43_bcma_probe(struct bcma_device *core)
 {
 	struct b43_bus_dev *dev;
+	struct b43_wl *wl;
+	int err;
 
 	dev = b43_bus_dev_bcma_init(core);
 	if (!dev)
 		return -ENODEV;
 
-	b43err(NULL, "BCMA is not supported yet!");
-	kfree(dev);
-	return -EOPNOTSUPP;
+	wl = b43_wireless_init(dev);
+	if (IS_ERR(wl)) {
+		err = PTR_ERR(wl);
+		goto bcma_out;
+	}
+
+	err = b43_one_core_attach(dev, wl);
+	if (err)
+		goto bcma_err_wireless_exit;
+
+	err = ieee80211_register_hw(wl->hw);
+	if (err)
+		goto bcma_err_one_core_detach;
+	b43_leds_register(wl->current_dev);
+
+bcma_out:
+	return err;
+
+bcma_err_one_core_detach:
+	b43_one_core_detach(dev);
+bcma_err_wireless_exit:
+	ieee80211_free_hw(wl->hw);
+	return err;
 }
 
 static void b43_bcma_remove(struct bcma_device *core)
 {
-	/* TODO */
+	struct b43_wldev *wldev = bcma_get_drvdata(core);
+	struct b43_wl *wl = wldev->wl;
+
+	/* We must cancel any work here before unregistering from ieee80211,
+	 * as the ieee80211 unreg will destroy the workqueue. */
+	cancel_work_sync(&wldev->restart_work);
+
+	/* Restore the queues count before unregistering, because firmware detect
+	 * might have modified it. Restoring is important, so the networking
+	 * stack can properly free resources. */
+	wl->hw->queues = wl->mac80211_initially_registered_queues;
+	b43_leds_stop(wldev);
+	ieee80211_unregister_hw(wl->hw);
+
+	b43_one_core_detach(wldev->dev);
+
+	b43_leds_unregister(wl);
+
+	ieee80211_free_hw(wl->hw);
 }
 
 static struct bcma_driver b43_bcma_driver = {
-- 
1.7.3.4

