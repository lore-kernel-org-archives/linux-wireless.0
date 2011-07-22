Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:20019 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab1GVWHP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 18:07:15 -0400
Subject: [PATCH] b43: fix invalid memory access in b43_ssb_remove()
To: =?utf-8?b?UmFmYcWC?= =?utf-8?q?Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Fri, 22 Jul 2011 18:07:13 -0400
Message-ID: <20110722220016.15648.30628.stgit@mj.roinet.com> (sfid-20110723_000719_551688_533E0F75)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wldev is freed in b43_one_core_detach() and should not be accessed after
that call.  Keep wldev->dev in a local variable.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

Linux 3.0 is not affected.  The bug was introduced in 482f0538.

 drivers/net/wireless/b43/main.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index d9f53b7..85d6a1f 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -5350,6 +5350,7 @@ static void b43_ssb_remove(struct ssb_device *sdev)
 {
 	struct b43_wl *wl = ssb_get_devtypedata(sdev);
 	struct b43_wldev *wldev = ssb_get_drvdata(sdev);
+	struct b43_bus_dev *dev = wldev->dev;
 
 	/* We must cancel any work here before unregistering from ieee80211,
 	 * as the ieee80211 unreg will destroy the workqueue. */
@@ -5365,14 +5366,14 @@ static void b43_ssb_remove(struct ssb_device *sdev)
 		ieee80211_unregister_hw(wl->hw);
 	}
 
-	b43_one_core_detach(wldev->dev);
+	b43_one_core_detach(dev);
 
 	if (list_empty(&wl->devlist)) {
 		b43_leds_unregister(wl);
 		/* Last core on the chip unregistered.
 		 * We can destroy common struct b43_wl.
 		 */
-		b43_wireless_exit(wldev->dev, wl);
+		b43_wireless_exit(dev, wl);
 	}
 }
 
