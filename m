Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:60277 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbdAMVeL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:34:11 -0500
Date: Fri, 13 Jan 2017 22:34:03 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 39/40] rt2x00: fix rf id for RT3352
Message-ID: <20170113213358.GA3670@makrotopia.org> (sfid-20170113_223413_741875_08CCA3D7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 5f49117b9035..823bdc1b0322 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -7861,10 +7861,11 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * RT53xx: defined in "EEPROM_CHIP_ID" field
 	 */
 	if (rt2x00_rt(rt2x00dev, RT3290) ||
-	    rt2x00_rt(rt2x00dev, RT3352) ||
 	    rt2x00_rt(rt2x00dev, RT5390) ||
 	    rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_eeprom_read(rt2x00dev, EEPROM_CHIP_ID, &rf);
+	else if (rt2x00_rt(rt2x00dev, RT3352))
+		rf = RF3322;
 	else if (rt2x00_rt(rt2x00dev, RT3883))
 		rf = RF3853;
 	else if (rt2x00_rt(rt2x00dev, RT5350))
-- 
2.11.0
