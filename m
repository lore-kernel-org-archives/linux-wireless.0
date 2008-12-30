Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:43592 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbYL3Mtz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 07:49:55 -0500
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] p54: enable rx/tx antenna diversity by eeprom bits
Date: Tue, 30 Dec 2008 13:48:19 +0100
Cc: John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812301348.19849.chunkeey@web.de> (sfid-20081230_135007_627230_DBDBEB0E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Respect all documented bits in the eeprom about the device diversity features.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-12-26 21:17:42.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-12-27 00:27:49.000000000 +0100
@@ -553,6 +553,10 @@ static int p54_parse_eeprom(struct ieee8
 		dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &band_2GHz;
 	if (!(synth & PDR_SYNTH_5_GHZ_DISABLED))
 		dev->wiphy->bands[IEEE80211_BAND_5GHZ] = &band_5GHz;
+	if ((synth & PDR_SYNTH_RX_DIV_MASK) == PDR_SYNTH_RX_DIV_SUPPORTED)
+		priv->rx_diversity_mask = 3;
+	if ((synth & PDR_SYNTH_TX_DIV_MASK) == PDR_SYNTH_TX_DIV_SUPPORTED)
+		priv->tx_diversity_mask = 3;
 
 	if (!is_valid_ether_addr(dev->wiphy->perm_addr)) {
 		u8 perm_addr[ETH_ALEN];
@@ -1488,8 +1492,8 @@ static int p54_tx(struct ieee80211_hw *d
 	txhdr->hw_queue = queue;
 	txhdr->backlog = current_queue->len;
 	memset(txhdr->durations, 0, sizeof(txhdr->durations));
-	txhdr->tx_antenna = (info->antenna_sel_tx == 0) ?
-		2 : info->antenna_sel_tx - 1;
+	txhdr->tx_antenna = ((info->antenna_sel_tx == 0) ?
+		2 : info->antenna_sel_tx - 1) & priv->tx_diversity_mask;
 	txhdr->output_power = priv->output_power;
 	txhdr->cts_rate = cts_rate;
 	if (padding)
@@ -1560,7 +1564,7 @@ static int p54_setup_mac(struct ieee8021
 	setup->mac_mode = cpu_to_le16(mode);
 	memcpy(setup->mac_addr, priv->mac_addr, ETH_ALEN);
 	memcpy(setup->bssid, priv->bssid, ETH_ALEN);
-	setup->rx_antenna = 2; /* automatic */
+	setup->rx_antenna = 2 & priv->rx_diversity_mask; /* automatic */
 	setup->rx_align = 0;
 	if (priv->fw_var < 0x500) {
 		setup->v1.basic_rate_mask = cpu_to_le32(priv->basic_rate_mask);
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-12-26 21:19:13.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.h	2008-12-27 00:28:07.000000000 +0100
@@ -31,7 +31,7 @@ struct bootrec {
 #define PDR_SYNTH_IQ_CAL_DISABLED	0x0008
 #define PDR_SYNTH_IQ_CAL_ZIF		0x0010
 #define PDR_SYNTH_FAA_SWITCH_MASK	0x0020
-#define PDR_SYNTH_FAA_SWITCH_ENABLED	0x0001
+#define PDR_SYNTH_FAA_SWITCH_ENABLED	0x0020
 #define PDR_SYNTH_24_GHZ_MASK		0x0040
 #define PDR_SYNTH_24_GHZ_DISABLED	0x0040
 #define PDR_SYNTH_5_GHZ_MASK		0x0080
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-12-26 21:06:10.000000000 +0100
+++ b/drivers/net/wireless/p54/p54.h	2008-12-26 22:26:22.000000000 +0100
@@ -99,6 +99,8 @@ struct p54_common {
 	struct mutex conf_mutex;
 	u8 mac_addr[ETH_ALEN];
 	u8 bssid[ETH_ALEN];
+	u8 rx_diversity_mask;
+	u8 tx_diversity_mask;
 	struct pda_iq_autocal_entry *iq_autocal;
 	unsigned int iq_autocal_len;
 	struct pda_channel_output_limit *output_limit;
