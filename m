Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48192 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765017AbXGaSeL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:34:11 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121179ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:34:10 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/24] rt2x00: rt2x00pci should use rf_size
Date: Tue, 31 Jul 2007 20:37:17 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312037.17895.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 0d1c0140cc51bec92a8c6219ed76beaa32227b08 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 28 Jul 2007 12:03:35 +0200
Subject: [PATCH 10/24] rt2x00: rt2x00pci should use rf_size

rt2x00pci should use the rf_size field instead
of the hardcoded 4 * sizeof(u32).

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00pci.c b/drivers/net/wireless/rt2x00pci.c
index 80e2204..b1cff2c 100644
--- a/drivers/net/wireless/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00pci.c
@@ -329,7 +329,7 @@ static void rt2x00pci_free_eeprom(struct rt2x00_dev *rt2x00dev)
 
 static int rt2x00pci_alloc_rf(struct rt2x00_dev *rt2x00dev)
 {
-	rt2x00dev->rf = kzalloc(4 * sizeof(u32), GFP_KERNEL);
+	rt2x00dev->rf = kzalloc(rt2x00dev->ops->rf_size, GFP_KERNEL);
 	if (!rt2x00dev->rf)
 		return -ENOMEM;
 
-- 
1.5.2.4

