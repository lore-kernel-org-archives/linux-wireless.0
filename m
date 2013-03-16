Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:36917 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128Ab3CPSTj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:19:39 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 05/25] rt2800: 5592: MAC registers initalization
Date: Sat, 16 Mar 2013 19:19:33 +0100
Message-Id: <1363457993-15541-6-git-send-email-stf_xl@wp.pl> (sfid-20130316_191942_983340_E67707A7)
In-Reply-To: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
References: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Based on:
NICInitRT5592MacRegisters()

from:
DPO_RT5572_LinuxSTA_2.6.1.3_20121022/chips/rt5592.c

On vendor driver we do not initialize TX_SW_CFG{1,2}. However the same
difference is between rt2x00 and vendor driver for 5390 chip.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 079086b..a35bce4 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3377,7 +3377,8 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
 	} else if (rt2x00_rt(rt2x00dev, RT5390) ||
-		   rt2x00_rt(rt2x00dev, RT5392)) {
+		   rt2x00_rt(rt2x00dev, RT5392) ||
+		   rt2x00_rt(rt2x00dev, RT5592)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
@@ -3557,7 +3558,8 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, TXOP_CTRL_CFG_EXT_CWMIN, 0);
 	rt2800_register_write(rt2x00dev, TXOP_CTRL_CFG, reg);
 
-	rt2800_register_write(rt2x00dev, TXOP_HLDR_ET, 0x00000002);
+	reg = rt2x00_rt(rt2x00dev, RT5592) ? 0x00000082 : 0x00000002;
+	rt2800_register_write(rt2x00dev, TXOP_HLDR_ET, reg);
 
 	rt2800_register_read(rt2x00dev, TX_RTS_CFG, &reg);
 	rt2x00_set_field32(&reg, TX_RTS_CFG_AUTO_RTS_RETRY_LIMIT, 32);
-- 
1.7.4.4

