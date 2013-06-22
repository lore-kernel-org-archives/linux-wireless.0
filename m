Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:59807 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab3FVPmW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Jun 2013 11:42:22 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 3/3] rt2x00: rt2800lib: turn on tertiary PAs/LNAs for 3T/3R devices
Date: Sat, 22 Jun 2013 17:42:14 +0200
Message-Id: <1371915734-13966-4-git-send-email-juhosg@openwrt.org> (sfid-20130622_174241_431856_81458450)
In-Reply-To: <1371915734-13966-1-git-send-email-juhosg@openwrt.org>
References: <1371915734-13966-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index f4cd3d8..664e9e1 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2684,12 +2684,26 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 				   rf->channel > 14);
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G1_EN,
 				   rf->channel <= 14);
+
+		if (rt2x00dev->default_ant.tx_chain_num > 2) {
+			/* Turn on tertiary PAs for 3T devices */
+			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A2_EN,
+					rf->channel > 14);
+			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G2_EN,
+					rf->channel <= 14);
+		}
 	}
 
 	if (rt2x00dev->default_ant.rx_chain_num > 1) {
 		/* Turn on secondary LNAs for 2R and for 3R devices */
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A1_EN, 1);
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G1_EN, 1);
+
+		if (rt2x00dev->default_ant.rx_chain_num > 2) {
+			/* Turn on tertiary LNAs for 3R devices */
+			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A2_EN, 1);
+			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G2_EN, 1);
+		}
 	}
 
 	rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A0_EN, 1);
-- 
1.7.10

