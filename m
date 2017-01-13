Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:60018 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdAMVVH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:21:07 -0500
Date: Fri, 13 Jan 2017 22:20:59 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 05/40] rt2x00: rt2800lib: add hw_beacon_count field to struct
 rt2800_drv_data
Message-ID: <20170113212054.GA3383@makrotopia.org> (sfid-20170113_222110_755834_857E27E9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

Some chipsets can handle more than 8 beacons at once.
Add a new field to the rt2800_drv_data structure which
will hold the number of supported beacons of the given
chipset.

Update the rt2x00_init_registers function to get the
beacon count from the new field instead of using a
hardcoded value.

In order to keep the current behaviour, initialize the
new field with the actually used value.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 4 +++-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index dcacfa54b3d6..0893d9147af9 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -5025,7 +5025,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Clear all beacons
 	 */
-	for (i = 0; i < 8; i++)
+	for (i = 0; i < drv_data->hw_beacon_count; i++)
 		rt2800_clear_beacon_register(rt2x00dev, i);
 
 	if (rt2x00_is_usb(rt2x00dev)) {
@@ -7875,6 +7875,8 @@ int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev)
 	if (rt2x00_rt(rt2x00dev, RT3593))
 		__set_bit(RT2800_HAS_HIGH_SHARED_MEM, &drv_data->rt2800_flags);
 
+	drv_data->hw_beacon_count = 8;
+
 	/*
 	 * Allocate eeprom data.
 	 */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
index ccfa8cf1f5ac..ab49e6feeeb9 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
@@ -37,6 +37,7 @@ struct rt2800_drv_data {
 	u8 max_psdu;
 	unsigned int tbtt_tick;
 	unsigned int ampdu_factor_cnt[4];
+	unsigned int hw_beacon_count;
 	DECLARE_BITMAP(sta_ids, STA_IDS_SIZE);
 
 	unsigned long rt2800_flags;
-- 
2.11.0
