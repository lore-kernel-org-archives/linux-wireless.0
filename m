Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:60933 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab3JASD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 14:03:28 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 3/3] rt2x00: rt2800lib: fix VGC programming for RT3572 and RT3593
Date: Tue,  1 Oct 2013 20:03:16 +0200
Message-Id: <1380650596-18659-3-git-send-email-juhosg@openwrt.org> (sfid-20131001_200341_237264_EAF0444C)
In-Reply-To: <1380650596-18659-1-git-send-email-juhosg@openwrt.org>
References: <1380650596-18659-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the DPO_RT5572_LinuxSTA_2.6.1.3_20121022
reference driver, programming of the 'BBP 66' register
on the RT3572 and on the RT3593 chipsets must be done
via the 'rt2800_bbp_write_with_rx_chain' function. This
ensures that value is correclty set for each RX
chain.

References:
  RT35xx_ChipAGCAdjust and RT35xx_SetAGCInitValue functions
  in chips/rt35xx.c

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 0dd15b2..c706ddc 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4442,11 +4442,17 @@ static inline void rt2800_set_vgc(struct rt2x00_dev *rt2x00dev,
 				  struct link_qual *qual, u8 vgc_level)
 {
 	if (qual->vgc_level != vgc_level) {
-		if (rt2x00_rt(rt2x00dev, RT5592)) {
+		if (rt2x00_rt(rt2x00dev, RT3572) ||
+		    rt2x00_rt(rt2x00dev, RT3593)) {
+			rt2800_bbp_write_with_rx_chain(rt2x00dev, 66,
+						       vgc_level);
+		} else if (rt2x00_rt(rt2x00dev, RT5592)) {
 			rt2800_bbp_write(rt2x00dev, 83, qual->rssi > -65 ? 0x4a : 0x7a);
 			rt2800_bbp_write_with_rx_chain(rt2x00dev, 66, vgc_level);
-		} else
+		} else {
 			rt2800_bbp_write(rt2x00dev, 66, vgc_level);
+		}
+
 		qual->vgc_level = vgc_level;
 		qual->vgc_level_reg = vgc_level;
 	}
-- 
1.7.10
