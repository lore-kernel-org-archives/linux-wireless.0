Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:59801 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711Ab3FVPmW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Jun 2013 11:42:22 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/3] rt2x00: rt2800lib: turn on secondary PAs/LNAs for 3T/3R devices
Date: Sat, 22 Jun 2013 17:42:13 +0200
Message-Id: <1371915734-13966-3-git-send-email-juhosg@openwrt.org> (sfid-20130622_174238_555666_3D45F57D)
In-Reply-To: <1371915734-13966-1-git-send-email-juhosg@openwrt.org>
References: <1371915734-13966-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The secondary PAs/LNAs are turned on only for 2T/2R
devices, however these are used for 3T/3R devices as
well. Always turn those on if the device uses more
than one tx/rx chains.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 4072242..f4cd3d8 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2678,16 +2678,16 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 
 	tx_pin = 0;
 
-	/* Turn on unused PA or LNA when not using 1T or 1R */
-	if (rt2x00dev->default_ant.tx_chain_num == 2) {
+	if (rt2x00dev->default_ant.tx_chain_num > 1) {
+		/* Turn on secondary PAs for 2T adn for 3T devices*/
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A1_EN,
 				   rf->channel > 14);
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G1_EN,
 				   rf->channel <= 14);
 	}
 
-	/* Turn on unused PA or LNA when not using 1T or 1R */
-	if (rt2x00dev->default_ant.rx_chain_num == 2) {
+	if (rt2x00dev->default_ant.rx_chain_num > 1) {
+		/* Turn on secondary LNAs for 2R and for 3R devices */
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A1_EN, 1);
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G1_EN, 1);
 	}
-- 
1.7.10

