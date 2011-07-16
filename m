Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:56040 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab1GPXNb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 19:13:31 -0400
Received: by fxd18 with SMTP id 18so4520760fxd.11
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jul 2011 16:13:30 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFC][PATCH] b43: correctly display longer chipsets ids
Date: Sun, 17 Jul 2011 01:52:09 +0200
Message-Id: <1310860329-6855-1-git-send-email-zajec5@gmail.com> (sfid-20110717_011336_753163_3E29D2CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some of the newer Broadcom chipsets have longe names like BCM43224,
BCM43225, etc. However Broadcom decided to keep using u16 for storing
them. Use %X or %d depending on chip_id value to avoid BCMA8D8, etc.
---
Is there any nicer way of doing that? Currently I have whole string
duplicated. Can we define part of the format using condition? Like
(chip_id > 0x9999) ? "%d" : "%04X"
?
---
 drivers/net/wireless/b43/main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 22f20e1..549555e 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -5202,7 +5202,9 @@ static struct b43_wl *b43_wireless_init(struct b43_bus_dev *dev)
 	INIT_WORK(&wl->tx_work, b43_tx_work);
 	skb_queue_head_init(&wl->tx_queue);
 
-	b43info(wl, "Broadcom %04X WLAN found (core revision %u)\n",
+	b43info(wl, (dev->chip_id > 0x9999) ?
+		"Broadcom %d WLAN found (core revision %u)\n" :
+		"Broadcom %04X WLAN found (core revision %u)\n",
 		dev->chip_id, dev->core_rev);
 	return wl;
 }
-- 
1.7.3.4

