Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:53676 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756083Ab3JNUAI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 16:00:08 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/3] rt2x00: rt2800lib: use {tx,rx}_chain_num to avoid superfluous EEPROM access
Date: Mon, 14 Oct 2013 21:59:50 +0200
Message-Id: <1381780792-28894-1-git-send-email-juhosg@openwrt.org> (sfid-20131014_220015_507469_BCF13027)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The {rx,tx}_chain_num fields of rt2x00dev->default_ant
contains the number of RX and TX chains already when the
rt2800_probe_hw_mode() function runs. Use those values
instead of parsing the EEPROM configuration values again.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index aa87894..3ca0d3e 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -7450,7 +7450,6 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	char *default_power2;
 	char *default_power3;
 	unsigned int i;
-	u16 eeprom;
 	u32 reg;
 
 	/*
@@ -7499,8 +7498,6 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->hw->max_report_rates = 7;
 	rt2x00dev->hw->max_rate_tries = 1;
 
-	rt2800_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
-
 	/*
 	 * Initialize hw_mode information.
 	 */
@@ -7566,22 +7563,21 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HT_CAP_SGI_20 |
 	    IEEE80211_HT_CAP_SGI_40;
 
-	if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_TXPATH) >= 2)
+	if (rt2x00dev->default_ant.tx_chain_num >= 2)
 		spec->ht.cap |= IEEE80211_HT_CAP_TX_STBC;
 
-	spec->ht.cap |=
-	    rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH) <<
-		IEEE80211_HT_CAP_RX_STBC_SHIFT;
+	spec->ht.cap |= rt2x00dev->default_ant.rx_chain_num <<
+			IEEE80211_HT_CAP_RX_STBC_SHIFT;
 
 	spec->ht.ampdu_factor = 3;
 	spec->ht.ampdu_density = 4;
 	spec->ht.mcs.tx_params =
 	    IEEE80211_HT_MCS_TX_DEFINED |
 	    IEEE80211_HT_MCS_TX_RX_DIFF |
-	    ((rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_TXPATH) - 1) <<
-		IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT);
+	    ((rt2x00dev->default_ant.tx_chain_num - 1) <<
+	     IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT);
 
-	switch (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH)) {
+	switch (rt2x00dev->default_ant.rx_chain_num) {
 	case 3:
 		spec->ht.mcs.rx_mask[2] = 0xff;
 	case 2:
-- 
1.7.10
