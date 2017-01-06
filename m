Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40540 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033956AbdAFNKE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 08:10:04 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>
Subject: [PATCH 9/9] rt2800: set max_psdu to 3 on usb devices
Date: Fri,  6 Jan 2017 14:05:18 +0100
Message-Id: <1483707918-31480-10-git-send-email-sgruszka@redhat.com> (sfid-20170106_141134_885981_069E7D6D)
In-Reply-To: <1483707918-31480-1-git-send-email-sgruszka@redhat.com>
References: <1483707918-31480-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All Ralink USB devices I have, including old ones, work well with
max_psdu = 3 (64kB tx AMPDUs).

Fix indent on the way.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 6cac311..de7a564 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4743,15 +4743,16 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_register_read(rt2x00dev, MAX_LEN_CFG, &reg);
 	rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_MPDU, AGGREGATION_SIZE);
-	if (rt2x00_rt_rev_gte(rt2x00dev, RT2872, REV_RT2872E) ||
-	    rt2x00_rt(rt2x00dev, RT2883) ||
-	    rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070E)) {
+	if (rt2x00_is_usb(rt2x00dev)) {
+		drv_data->max_psdu = 3;
+	} else if (rt2x00_rt_rev_gte(rt2x00dev, RT2872, REV_RT2872E) ||
+		   rt2x00_rt(rt2x00dev, RT2883) ||
+		   rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070E)) {
 		drv_data->max_psdu = 2;
-		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 2);
 	} else {
 		drv_data->max_psdu = 1;
-		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 1);
 	}
+	rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, drv_data->max_psdu);
 	rt2x00_set_field32(&reg, MAX_LEN_CFG_MIN_PSDU, 10);
 	rt2x00_set_field32(&reg, MAX_LEN_CFG_MIN_MPDU, 10);
 	rt2800_register_write(rt2x00dev, MAX_LEN_CFG, reg);
-- 
2.7.4
