Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:55084 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbaINVJX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2014 17:09:23 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: zajec5@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/5] b43: tell ucode the phy type and version
Date: Sun, 14 Sep 2014 23:09:09 +0200
Message-Id: <1410728952-25779-2-git-send-email-hauke@hauke-m.de> (sfid-20140914_230931_443795_8679E836)
In-Reply-To: <1410728952-25779-1-git-send-email-hauke@hauke-m.de>
References: <1410728952-25779-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/b43/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index f22a801..2d7716e 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4859,6 +4859,10 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 	/* Maximum Contention Window */
 	b43_shm_write16(dev, B43_SHM_SCRATCH, B43_SHM_SC_MAXCONT, 0x3FF);
 
+	/* write phytype and phyvers */
+	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_PHYTYPE, phy->type);
+	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_PHYVER, phy->rev);
+
 	if (b43_bus_host_is_pcmcia(dev->dev) ||
 	    b43_bus_host_is_sdio(dev->dev)) {
 		dev->__using_pio_transfers = true;
-- 
1.9.1

