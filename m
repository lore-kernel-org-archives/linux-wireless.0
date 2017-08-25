Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41818 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756282AbdHYLib (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Aug 2017 07:38:31 -0400
Date: Fri, 25 Aug 2017 13:38:29 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Daniel Golle <daniel@makrotopia.org>
Subject: [PATCH] rt2800: fix TX_PIN_CFG setting for non MT7620 chips
Message-ID: <20170825113828.GA3959@redhat.com> (sfid-20170825_133835_370916_5085A04A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit 41977e86c984 ("rt2x00: add support for MT7620") we do not
initialize TX_PIN_CFG setting. This cause breakage at least on some
RT3573 devices. To fix the problem patch restores previous behaviour
for non MT7620 chips.

Fixes: 41977e86c984 ("rt2x00: add support for MT7620")
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1480829
Reported-and-tested-by: Jussi Eloranta <jussi.eloranta@csun.edu>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index d11c7b2..5672aec 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -3699,7 +3699,10 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	if (rt2x00_rt(rt2x00dev, RT3572))
 		rt2800_rfcsr_write(rt2x00dev, 8, 0);
 
-	rt2800_register_read(rt2x00dev, TX_PIN_CFG, &tx_pin);
+	if (rt2x00_rt(rt2x00dev, RT6352))
+		rt2800_register_read(rt2x00dev, TX_PIN_CFG, &tx_pin);
+	else
+		tx_pin = 0;
 
 	switch (rt2x00dev->default_ant.tx_chain_num) {
 	case 3:
-- 
2.7.5
