Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:60516 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751620AbdAPDOB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 15 Jan 2017 22:14:01 -0500
Date: Mon, 16 Jan 2017 04:13:01 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 11/14] rt2x00: rt2800lib: fix rf id for RT3352
Message-ID: <20170116031246.GA32267@makrotopia.org> (sfid-20170116_041404_860747_5D3927B2)
References: <874m114lwq.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <874m114lwq.fsf@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 4f454e143266..366310011491 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -7229,6 +7229,8 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	    rt2x00_rt(rt2x00dev, RT5390) ||
 	    rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_eeprom_read(rt2x00dev, EEPROM_CHIP_ID, &rf);
+	else if (rt2x00_rt(rt2x00dev, RT3352))
+		rf = RF3322;
 	else
 		rf = rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RF_TYPE);
 
-- 
2.11.0
