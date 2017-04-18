Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:58249 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756894AbdDRJcr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 05:32:47 -0400
Date: Tue, 18 Apr 2017 11:32:35 +0200
From: Daniel Golle <daniel@makrotopia.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Tom Psyborg <pozega.tomislav@gmail.com>
Subject: [PATCH] rt2800: fix mt7620 vco calibration registers
Message-ID: <20170418093229.GA6026@makrotopia.org> (sfid-20170418_113315_468408_34E95BF7)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomislav Požega <pozega.tomislav@gmail.com>

Use register values from init LNA function instead of the ones from
restore LNA function. Apply register values based on rx path
configuration.

Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 870bf315f98b..86cffee6876a 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4932,7 +4932,7 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, TX_PIN_CFG, tx_pin);
 
 	if (rt2x00_rt(rt2x00dev, RT6352)) {
-		if (rt2x00dev->default_ant.tx_chain_num == 1) {
+		if (rt2x00dev->default_ant.rx_chain_num == 1) {
 			rt2800_bbp_write(rt2x00dev, 91, 0x07);
 			rt2800_bbp_write(rt2x00dev, 95, 0x1A);
 			rt2800_bbp_write(rt2x00dev, 195, 128);
@@ -4953,8 +4953,8 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
 		}
 
 		if (rt2x00_has_cap_external_lna_bg(rt2x00dev)) {
-			rt2800_bbp_write(rt2x00dev, 75, 0x60);
-			rt2800_bbp_write(rt2x00dev, 76, 0x44);
+			rt2800_bbp_write(rt2x00dev, 75, 0x68);
+			rt2800_bbp_write(rt2x00dev, 76, 0x4C);
 			rt2800_bbp_write(rt2x00dev, 79, 0x1C);
 			rt2800_bbp_write(rt2x00dev, 80, 0x0C);
 			rt2800_bbp_write(rt2x00dev, 82, 0xB6);
-- 
2.12.2
