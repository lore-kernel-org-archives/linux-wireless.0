Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:59437 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750701AbdAMVoq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:44:46 -0500
Date: Fri, 13 Jan 2017 22:25:15 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 14/40] rt2x00: rt2800lib: add MAC register initialization for
 RT3883
Message-ID: <20170113212510.GA3447@makrotopia.org> (sfid-20170113_224449_558939_F7D00017)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 7c5061d5328d..cf9a8cfd4fbc 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -5020,6 +5020,12 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 			rt2800_register_write(rt2x00dev, TX_SW_CFG2,
 					      0x00000000);
 		}
+	} else if (rt2x00_rt(rt2x00dev, RT3883)) {
+		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000402);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00040000);
+		rt2800_register_write(rt2x00dev, TX_TXBF_CFG_0, 0x8000fc21);
+		rt2800_register_write(rt2x00dev, TX_TXBF_CFG_3, 0x00009c40);
 	} else if (rt2x00_rt(rt2x00dev, RT5390) ||
 		   rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
@@ -5053,7 +5059,10 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_register_read(rt2x00dev, MAX_LEN_CFG, &reg);
 	rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_MPDU, AGGREGATION_SIZE);
-	if (rt2x00_rt_rev_gte(rt2x00dev, RT2872, REV_RT2872E) ||
+	if (rt2x00_rt(rt2x00dev, RT3883)) {
+		drv_data->max_psdu = 3;
+		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 3);
+	} else if (rt2x00_rt_rev_gte(rt2x00dev, RT2872, REV_RT2872E) ||
 	    rt2x00_rt(rt2x00dev, RT2883) ||
 	    rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070E)) {
 		drv_data->max_psdu = 2;
@@ -5211,6 +5220,11 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	reg = rt2x00_rt(rt2x00dev, RT5592) ? 0x00000082 : 0x00000002;
 	rt2800_register_write(rt2x00dev, TXOP_HLDR_ET, reg);
 
+	if (rt2x00_rt(rt2x00dev, RT3883)) {
+		rt2800_register_write(rt2x00dev, TX_FBK_CFG_3S_0, 0x12111008);
+		rt2800_register_write(rt2x00dev, TX_FBK_CFG_3S_1, 0x16151413);
+	}
+
 	rt2800_register_read(rt2x00dev, TX_RTS_CFG, &reg);
 	rt2x00_set_field32(&reg, TX_RTS_CFG_AUTO_RTS_RETRY_LIMIT, 32);
 	rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_THRES,
-- 
2.11.0
