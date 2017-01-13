Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:35216 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751207AbdAMV3q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:29:46 -0500
Date: Fri, 13 Jan 2017 22:29:37 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 27/40] rt2x00: rt2800lib: fix antenna configuration for RT3883
Message-ID: <20170113212932.GA3570@makrotopia.org> (sfid-20170113_222948_347066_2689F249)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index ba73be7101b7..bde8177c30c4 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -1971,7 +1971,8 @@ void rt2800_config_ant(struct rt2x00_dev *rt2x00dev, struct antenna_setup *ant)
 	rt2800_bbp_write(rt2x00dev, 3, r3);
 	rt2800_bbp_write(rt2x00dev, 1, r1);
 
-	if (rt2x00_rt(rt2x00dev, RT3593)) {
+	if (rt2x00_rt(rt2x00dev, RT3593) ||
+	    rt2x00_rt(rt2x00dev, RT3883)) {
 		if (ant->rx_chain_num == 1)
 			rt2800_bbp_write(rt2x00dev, 86, 0x00);
 		else
-- 
2.11.0
