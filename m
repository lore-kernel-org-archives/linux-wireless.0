Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:60938 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754821AbdDRJwU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 05:52:20 -0400
Date: Tue, 18 Apr 2017 11:52:07 +0200
From: Daniel Golle <daniel@makrotopia.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Tom Psyborg <pozega.tomislav@gmail.com>
Subject: [PATCH] rt2800: fix mt7620 E2 channel registers
Message-ID: <20170418095202.GA7086@makrotopia.org> (sfid-20170418_115251_316619_D2539C23)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomislav Požega <pozega.tomislav@gmail.com>

update RF register 47 and 54 values according to vendor driver

Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 86cffee6876a..8585cdc3de53 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -8145,9 +8145,11 @@ static void rt2800_init_rfcsr_6352(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write_chanreg(rt2x00dev, 44, 0xB3);
 	rt2800_rfcsr_write_chanreg(rt2x00dev, 45, 0xD5);
 	rt2800_rfcsr_write_chanreg(rt2x00dev, 46, 0x27);
-	rt2800_rfcsr_write_chanreg(rt2x00dev, 47, 0x69);
+	rt2800_rfcsr_write_bank(rt2x00dev, 4, 47, 0x67);
+	rt2800_rfcsr_write_bank(rt2x00dev, 6, 47, 0x69);
 	rt2800_rfcsr_write_chanreg(rt2x00dev, 48, 0xFF);
-	rt2800_rfcsr_write_chanreg(rt2x00dev, 54, 0x20);
+	rt2800_rfcsr_write_bank(rt2x00dev, 4, 54, 0x27);
+	rt2800_rfcsr_write_bank(rt2x00dev, 6, 54, 0x20);
 	rt2800_rfcsr_write_chanreg(rt2x00dev, 55, 0x66);
 	rt2800_rfcsr_write_chanreg(rt2x00dev, 56, 0xFF);
 	rt2800_rfcsr_write_chanreg(rt2x00dev, 57, 0x1C);
-- 
2.12.2
