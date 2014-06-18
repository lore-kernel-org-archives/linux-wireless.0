Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:4584 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750962AbaFROxP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2014 10:53:15 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-wireless@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 1/1] drivers/net/wireless/rt2x00/rt2x00dev.c: remove null test before kfree
Date: Wed, 18 Jun 2014 16:51:29 +0200
Message-Id: <1403103089-1951-1-git-send-email-fabf@skynet.be> (sfid-20140618_165507_841230_B3B06B64)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 2bde672..c2c2300 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1452,8 +1452,7 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Free the driver data.
 	 */
-	if (rt2x00dev->drv_data)
-		kfree(rt2x00dev->drv_data);
+	kfree(rt2x00dev->drv_data);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_remove_dev);
 
-- 
1.8.4.5

