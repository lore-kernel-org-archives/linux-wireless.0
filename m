Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:50289 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdAMV1E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:27:04 -0500
Date: Fri, 13 Jan 2017 22:26:55 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 19/40] rt2x00: rt2800lib: force rf type to RF3853 on RT3883
Message-ID: <20170113212648.GA3502@makrotopia.org> (sfid-20170113_222708_243572_D77D74BE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index e3b9a97b1fc2..005fd02c0226 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -7629,6 +7629,8 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	    rt2x00_rt(rt2x00dev, RT5390) ||
 	    rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_eeprom_read(rt2x00dev, EEPROM_CHIP_ID, &rf);
+	else if (rt2x00_rt(rt2x00dev, RT3883))
+		rf = RF3853;
 	else
 		rf = rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RF_TYPE);
 
-- 
2.11.0
