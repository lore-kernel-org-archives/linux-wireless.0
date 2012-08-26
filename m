Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34479 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2HZW0t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2012 18:26:49 -0400
From: Marc Kleine-Budde <mkl@blackshift.org>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Marc Kleine-Budde <mkl@blackshift.org>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH] rt2x00: fix votage setting for RT3572/RT3592
Date: Mon, 27 Aug 2012 00:26:37 +0200
Message-Id: <1346019997-14487-1-git-send-email-mkl@blackshift.org> (sfid-20120827_002654_144840_0AC0AE4A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the vendor driver v2.6.0.1, during the rf register init the SRAM
voltage should be increased to 1.35V and after 1ms decreased back to 1.2V. This
patch adds the field setting of LDO_CFG0_LDO_CORE_VLEVEL accordingly.

Cc: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@blackshift.org>
---
Hello,

I don't have the hardware to test, just stumbled over this while hacking on the
rt3593.

regards,  Marc

 drivers/net/wireless/rt2x00/rt2800lib.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index cb8c2ac..b93516d 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4089,6 +4089,7 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
 		msleep(1);
 		rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
+		rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 0);
 		rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
 		rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
 	}
-- 
1.7.10

