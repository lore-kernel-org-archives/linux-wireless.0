Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:56729 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758473AbXIJPmF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 11:42:05 -0400
Date: Mon, 10 Sep 2007 10:41:38 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: Don't cancel the restart workqueue in  wireless_core_exit
Message-ID: <46e565b2.UeI48jNziAkn2wBs%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Index: wireless-dev/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-dev/drivers/net/wireless/b43legacy/main.c
@@ -3021,6 +3021,7 @@ static void b43legacy_wireless_core_exit
 	B43legacy_WARN_ON(b43legacy_status(dev) > B43legacy_STAT_INITIALIZED);
 	if (b43legacy_status(dev) != B43legacy_STAT_INITIALIZED)
 		return;
+	b43_set_status(dev, B43_STAT_UNINIT);
 
 	b43legacy_rng_exit(dev->wl);
 	b43legacy_pio_free(dev);
@@ -3520,6 +3521,7 @@ static void b43legacy_one_core_detach(st
 
 	wldev = ssb_get_drvdata(dev);
 	wl = wldev->wl;
+	cancel_work_sync(&wldev->restart_work);
 	b43legacy_debugfs_remove_device(wldev);
 	b43legacy_wireless_core_detach(wldev);
 	list_del(&wldev->list);
