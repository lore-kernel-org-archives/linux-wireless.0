Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 220-135-115-6.HINET-IP.hinet.net ([220.135.115.6]:61564 "EHLO
	ns.kevlo.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab3KNFy3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 00:54:29 -0500
Date: Thu, 14 Nov 2013 13:53:44 +0800
From: Kevin Lo <kevlo@kevlo.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: [PATCH] rt2x00: rt2800lib: no need to write RF register 3 twice for
 RT5592
Message-ID: <20131114055344.GA74271@ns.kevlo.org> (sfid-20131114_065438_521715_45B09B92)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In rt2800_init_rfcsr_5592(), there's no need to write RF register 3 twice.

Signed-off-by: Kevin Lo <kevlo@kevlo.org>
---

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 776aff3..18506f8 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -6602,7 +6602,6 @@ static void rt2800_init_rfcsr_5592(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_rfcsr_write(rt2x00dev, 1, 0x3F);
 	rt2800_rfcsr_write(rt2x00dev, 3, 0x08);
-	rt2800_rfcsr_write(rt2x00dev, 3, 0x08);
 	rt2800_rfcsr_write(rt2x00dev, 5, 0x10);
 	rt2800_rfcsr_write(rt2x00dev, 6, 0xE4);
 	rt2800_rfcsr_write(rt2x00dev, 7, 0x00);
