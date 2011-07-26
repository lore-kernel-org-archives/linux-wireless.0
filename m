Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:12954 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465Ab1GZPhS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 11:37:18 -0400
Subject: [PATCH 1/2] b43legacy: report core number
To: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Tue, 26 Jul 2011 11:36:48 -0400
Message-ID: <20110726153648.24611.49190.stgit@mj.roinet.com> (sfid-20110726_173757_428321_B21069F2)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 0 files changed, 0 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index ffa4671..224991a 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -3785,7 +3785,8 @@ static int b43legacy_wireless_init(struct ssb_device *dev)
 	INIT_WORK(&wl->beacon_update_trigger, b43legacy_beacon_update_trigger_work);
 
 	ssb_set_devtypedata(dev, wl);
-	b43legacyinfo(wl, "Broadcom %04X WLAN found\n", dev->bus->chip_id);
+	b43legacyinfo(wl, "Broadcom %04X WLAN found (core revision %u)\n",
+		      dev->bus->chip_id, dev->id.revision);
 	err = 0;
 out:
 	return err;
