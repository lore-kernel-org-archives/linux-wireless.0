Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:53930 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143Ab3EHJ4V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 05:56:21 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, <arik@wizery.com>, <eliad@wizery.com>
Subject: [PATCH v2] wl18xx: use locally administered MAC address if not available from fuse
Date: Wed, 8 May 2013 12:54:56 +0300
Message-ID: <1368006896-24468-1-git-send-email-coelho@ti.com> (sfid-20130508_115625_865216_E38344F7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some R&D chips, the device may be left untrimmed and with the MAC
address missing from fuse ROM.  In order to support those devices,
apply a random locally administered MAC address instead.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---

In v2:

* use eth_random_addr() to generate the locally assigned address,
  instead of hardcoding it. (thanks Johannes)

 drivers/net/wireless/ti/wl18xx/main.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index ae85ae4..7aa0eb8 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -23,6 +23,7 @@
 #include <linux/platform_device.h>
 #include <linux/ip.h>
 #include <linux/firmware.h>
+#include <linux/etherdevice.h>
 
 #include "../wlcore/wlcore.h"
 #include "../wlcore/debug.h"
@@ -1318,6 +1319,16 @@ static int wl18xx_get_mac(struct wl1271 *wl)
 		((mac1 & 0xff000000) >> 24);
 	wl->fuse_nic_addr = (mac1 & 0xffffff);
 
+	if (!wl->fuse_oui_addr && !wl->fuse_nic_addr) {
+		u8 mac[ETH_ALEN];
+
+		eth_random_addr(mac);
+
+		wl->fuse_oui_addr = (mac[0] << 16) + (mac[1] << 8) + mac[2];
+		wl->fuse_nic_addr = (mac[3] << 16) + (mac[4] << 8) + mac[5];
+		wl1271_warning("MAC address from fuse not available, using random locally administered addresses.");
+	}
+
 	ret = wlcore_set_partition(wl, &wl->ptable[PART_DOWN]);
 
 out:
-- 
1.7.10.4

