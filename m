Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:63136 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbYJCUst (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 16:48:49 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1801100wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 03 Oct 2008 13:48:49 -0700 (PDT)
Subject: [PATCH 2/8] b43: remove remaining b43_radio_{read|write}16 from
 main.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 13:48:46 -0700
Message-Id: <1223066926.6512.27.camel@brick> (sfid-20081003_224857_463366_E5466199)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 16 is not necessary anymore and is defnined to read/write.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 6df9b65..cc1f4a9 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -789,7 +789,7 @@ void b43_dummy_transmission(struct b43_wldev *dev)
 	b43_write16(dev, 0x0502, 0x0030);
 
 	if (phy->radio_ver == 0x2050 && phy->radio_rev <= 0x5)
-		b43_radio_write16(dev, 0x0051, 0x0017);
+		b43_radio_write(dev, 0x0051, 0x0017);
 	for (i = 0x00; i < max_loop; i++) {
 		value = b43_read16(dev, 0x050E);
 		if (value & 0x0080)
@@ -809,7 +809,7 @@ void b43_dummy_transmission(struct b43_wldev *dev)
 		udelay(10);
 	}
 	if (phy->radio_ver == 0x2050 && phy->radio_rev <= 0x5)
-		b43_radio_write16(dev, 0x0051, 0x0037);
+		b43_radio_write(dev, 0x0051, 0x0037);
 
 	write_unlock(&wl->tx_lock);
 	spin_unlock_irq(&wl->irq_lock);
-- 
1.6.0.2.471.g47a76


