Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:38008 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbdAMVag (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:30:36 -0500
Date: Fri, 13 Jan 2017 22:30:28 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 29/40] rt2x00: rt2800lib: fix VGC setup for RT3883
Message-ID: <20170113213015.GA3592@makrotopia.org> (sfid-20170113_223039_122722_622B30C8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index da430e304d1f..e79714b898b9 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4850,7 +4850,8 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 		else
 			vgc = 0x2e + rt2x00dev->lna_gain;
 	} else { /* 5GHZ band */
-		if (rt2x00_rt(rt2x00dev, RT3593))
+		if (rt2x00_rt(rt2x00dev, RT3593) ||
+		    rt2x00_rt(rt2x00dev, RT3883))
 			vgc = 0x20 + (rt2x00dev->lna_gain * 5) / 3;
 		else if (rt2x00_rt(rt2x00dev, RT5592))
 			vgc = 0x24 + (2 * rt2x00dev->lna_gain);
@@ -4870,7 +4871,8 @@ static inline void rt2800_set_vgc(struct rt2x00_dev *rt2x00dev,
 {
 	if (qual->vgc_level != vgc_level) {
 		if (rt2x00_rt(rt2x00dev, RT3572) ||
-		    rt2x00_rt(rt2x00dev, RT3593)) {
+		    rt2x00_rt(rt2x00dev, RT3593) ||
+		    rt2x00_rt(rt2x00dev, RT3883)) {
 			rt2800_bbp_write_with_rx_chain(rt2x00dev, 66,
 						       vgc_level);
 		} else if (rt2x00_rt(rt2x00dev, RT5592)) {
@@ -4917,6 +4919,11 @@ void rt2800_link_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual,
 		}
 		break;
 
+	case RT3883:
+		if (qual->rssi > -65)
+			vgc += 0x10;
+		break;
+
 	case RT5592:
 		if (qual->rssi > -65)
 			vgc += 0x20;
-- 
2.11.0
