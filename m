Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46890 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab3FXVDe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 17:03:34 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v3 3/3] rt2x00: rt2800lib: turn on tertiary PAs/LNAs for 3T/3R devices
Date: Mon, 24 Jun 2013 23:03:24 +0200
Message-Id: <1372107804-19679-4-git-send-email-juhosg@openwrt.org> (sfid-20130624_230340_292229_2E6B86B1)
In-Reply-To: <1372107804-19679-1-git-send-email-juhosg@openwrt.org>
References: <1372107804-19679-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 3T/3R devices are using the tertiary PAs/LNAs
however those are never turned on. Fix the code to
turn on those on for such devices.

Also modify the code to use switch statements to
improve readability.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
Changes in v3:
 - also move setting of the primary PA of the 5GHz band into the first
   switch statement
Changes in v2:
 - use a switch statement to improve readability as suggested
   by Gertjan
 - add detailed commit description
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   47 +++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index b7119e3..25f7dbe 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2678,30 +2678,53 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 
 	tx_pin = 0;
 
-	if (rt2x00dev->default_ant.tx_chain_num > 1) {
-		/* Turn on secondary PAs for 2T and for 3T devices*/
+	switch (rt2x00dev->default_ant.tx_chain_num) {
+	case 3:
+		/* Turn on tertiary PAs */
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A2_EN,
+				   rf->channel > 14);
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G2_EN,
+				   rf->channel <= 14);
+		/* fall-through */
+	case 2:
+		/* Turn on secondary PAs */
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A1_EN,
 				   rf->channel > 14);
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G1_EN,
 				   rf->channel <= 14);
+		/* fall-through */
+	case 1:
+		/* Turn on primary PAs */
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A0_EN,
+				   rf->channel > 14);
+		if (test_bit(CAPABILITY_BT_COEXIST, &rt2x00dev->cap_flags))
+			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G0_EN, 1);
+		else
+			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G0_EN,
+					   rf->channel <= 14);
+		break;
 	}
 
-	if (rt2x00dev->default_ant.rx_chain_num > 1) {
-		/* Turn on secondary LNAs for 2R and for 3R devices */
+	switch (rt2x00dev->default_ant.rx_chain_num) {
+	case 3:
+		/* Turn on tertiary LNAs */
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A2_EN, 1);
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G2_EN, 1);
+		/* fall-through */
+	case 2:
+		/* Turn on secondary LNAs */
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A1_EN, 1);
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G1_EN, 1);
+		/* fall-through */
+	case 1:
+		/* Turn on primary LNAs */
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A0_EN, 1);
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G0_EN, 1);
+		break;
 	}
 
-	rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A0_EN, 1);
-	rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G0_EN, 1);
 	rt2x00_set_field32(&tx_pin, TX_PIN_CFG_RFTR_EN, 1);
 	rt2x00_set_field32(&tx_pin, TX_PIN_CFG_TRSW_EN, 1);
-	if (test_bit(CAPABILITY_BT_COEXIST, &rt2x00dev->cap_flags))
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G0_EN, 1);
-	else
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G0_EN,
-				   rf->channel <= 14);
-	rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A0_EN, rf->channel > 14);
 
 	rt2800_register_write(rt2x00dev, TX_PIN_CFG, tx_pin);
 
-- 
1.7.10

