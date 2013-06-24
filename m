Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46885 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab3FXVDd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 17:03:33 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v3 2/3] rt2x00: rt2800lib: turn on secondary PAs/LNAs for 3T/3R devices
Date: Mon, 24 Jun 2013 23:03:23 +0200
Message-Id: <1372107804-19679-3-git-send-email-juhosg@openwrt.org> (sfid-20130624_230337_398800_45C0974F)
In-Reply-To: <1372107804-19679-1-git-send-email-juhosg@openwrt.org>
References: <1372107804-19679-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The secondary PAs/LNAs are turned on only for 2T/2R
devices, however these are used for 3T/3R devices as
well. Always turn those on if the device uses more
than one tx/rx chains.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
Changes in v3: ---
Changes in v2:
  - fix a typo
  - add Acked-by tags
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 4072242..b7119e3 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2678,16 +2678,16 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 
 	tx_pin = 0;
 
-	/* Turn on unused PA or LNA when not using 1T or 1R */
-	if (rt2x00dev->default_ant.tx_chain_num == 2) {
+	if (rt2x00dev->default_ant.tx_chain_num > 1) {
+		/* Turn on secondary PAs for 2T and for 3T devices*/
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

