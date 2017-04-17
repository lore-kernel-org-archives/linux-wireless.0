Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:38393 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753679AbdDQTa1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Apr 2017 15:30:27 -0400
Date: Mon, 17 Apr 2017 21:30:12 +0200
From: Daniel Golle <daniel@makrotopia.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 1/2] rt2800: fix LNA gain assignment for MT7620
Message-ID: <20170417193007.GA3436@makrotopia.org> (sfid-20170417_213032_085358_A6763B22)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The base value used for MT7620 differs from Rt5392 which resulted in
quite bad RX signal quality. Fix this by using the correct base value as
well as the LNA calibration values for HT20.

Reported-by: Tom Psyborg <pozega.tomislav@gmail.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index ba06ac2d876d..7135519a638c 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -3806,11 +3806,25 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	}
 
 	if (rt2x00_rt(rt2x00dev, RT5592) || rt2x00_rt(rt2x00dev, RT6352)) {
+		reg = 0x10;
+		if (!conf_is_ht40(conf)) {
+			if (rt2x00_rt(rt2x00dev, RT6352) &&
+			    rt2x00_has_cap_external_lna_bg(rt2x00dev)) {
+				reg |= 0x5;
+			} else {
+				reg |= 0xa;
+			}
+		}
 		rt2800_bbp_write(rt2x00dev, 195, 141);
-		rt2800_bbp_write(rt2x00dev, 196, conf_is_ht40(conf) ? 0x10 : 0x1a);
+		rt2800_bbp_write(rt2x00dev, 196, reg);
 
 		/* AGC init */
-		reg = (rf->channel <= 14 ? 0x1c : 0x24) + 2 * rt2x00dev->lna_gain;
+		if (rt2x00_rt(rt2x00dev, RT6352))
+			reg = 0x04;
+		else
+			reg = rf->channel <= 14 ? 0x1c : 0x24;
+
+		reg += 2 * rt2x00dev->lna_gain;
 		rt2800_bbp_write_with_rx_chain(rt2x00dev, 66, reg);
 
 		rt2800_iq_calibrate(rt2x00dev, rf->channel);
-- 
2.12.2
