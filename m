Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60518 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751482AbdAMO7m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 09:59:42 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Daniel Golle <daniel@makrotopia.org>
Subject: [PATCH] rt2800: remove warning on bcn_num != rt2x00dev->intf_beaconing
Date: Fri, 13 Jan 2017 15:55:07 +0100
Message-Id: <1484319307-10821-1-git-send-email-sgruszka@redhat.com> (sfid-20170113_155945_249903_DD621CC6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since rt2800pci update beacon settings asynchronously from
tbtt tasklet, without beacon_skb_mutex protection, number of
currently active beacons entries can be different than
number pointed by rt2x00dev->intf_beaconing. Remove warning
about that inconsistency.

Reported-by: evaxige@qq.com
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 4fb79e0..1abe38f 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -967,8 +967,6 @@ static void rt2800_update_beacons_setup(struct rt2x00_dev *rt2x00dev)
 		bcn_num++;
 	}
 
-	WARN_ON_ONCE(bcn_num != rt2x00dev->intf_beaconing);
-
 	rt2800_register_write(rt2x00dev, BCN_OFFSET0, (u32) reg);
 	rt2800_register_write(rt2x00dev, BCN_OFFSET1, (u32) (reg >> 32));
 
-- 
1.8.3.1
