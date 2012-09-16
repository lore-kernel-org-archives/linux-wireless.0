Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:2043 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752683Ab2IPU36 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2012 16:29:58 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <users@rt2x00.serialmonkey.com>, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 5/5] rt2x00: Clean up RFCSR1 programming in rt2800_config_channel_rf3xxx.
Date: Sun, 16 Sep 2012 22:29:53 +0200
Message-Id: <1347827393-26948-6-git-send-email-gwingerde@gmail.com> (sfid-20120916_223100_161879_AF20D8D9)
In-Reply-To: <1347827393-26948-5-git-send-email-gwingerde@gmail.com>
References: <1347827393-26948-1-git-send-email-gwingerde@gmail.com>
 <1347827393-26948-2-git-send-email-gwingerde@gmail.com>
 <1347827393-26948-3-git-send-email-gwingerde@gmail.com>
 <1347827393-26948-4-git-send-email-gwingerde@gmail.com>
 <1347827393-26948-5-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setting of the individual fields of the RF register can be simplified.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index d745c32..540c94f 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1763,36 +1763,15 @@ static void rt2800_config_channel_rf3xxx(struct rt2x00_dev *rt2x00dev,
 
 	rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 0);
+	rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD,
+			  rt2x00dev->default_ant.rx_chain_num <= 1);
+	rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD,
+			  rt2x00dev->default_ant.rx_chain_num <= 2);
 	rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 0);
-	if (rt2x00_rt(rt2x00dev, RT3390)) {
-		rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD,
-				  rt2x00dev->default_ant.rx_chain_num == 1);
-		rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD,
-				  rt2x00dev->default_ant.tx_chain_num == 1);
-	} else {
-		rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 0);
-		rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 0);
-		rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 0);
-		rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 0);
-
-		switch (rt2x00dev->default_ant.tx_chain_num) {
-		case 1:
-			rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 1);
-			/* fall through */
-		case 2:
-			rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 1);
-			break;
-		}
-
-		switch (rt2x00dev->default_ant.rx_chain_num) {
-		case 1:
-			rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 1);
-			/* fall through */
-		case 2:
-			rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 1);
-			break;
-		}
-	}
+	rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD,
+			  rt2x00dev->default_ant.tx_chain_num <= 1);
+	rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD,
+			  rt2x00dev->default_ant.tx_chain_num <= 2);
 	rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
 
 	rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
-- 
1.7.11.1

