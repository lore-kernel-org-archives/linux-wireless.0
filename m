Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44790 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754872AbcKBOMc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Nov 2016 10:12:32 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 07/10] rt2800: correct TX_SW_CFG1 for 5592
Date: Wed,  2 Nov 2016 15:11:02 +0100
Message-Id: <1478095865-8651-8-git-send-email-sgruszka@redhat.com> (sfid-20161102_151236_015761_2067A866)
In-Reply-To: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
References: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Those TX_SW_CFG1 values are used in vendor driver.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index ff4a7c3..812f8e7 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4670,11 +4670,14 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 					      0x00000000);
 		}
 	} else if (rt2x00_rt(rt2x00dev, RT5390) ||
-		   rt2x00_rt(rt2x00dev, RT5392) ||
-		   rt2x00_rt(rt2x00dev, RT5592)) {
+		   rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
+	} else if (rt2x00_rt(rt2x00dev, RT5592)) {
+		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
 	} else {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000000);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
-- 
1.7.1
