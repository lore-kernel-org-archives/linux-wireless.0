Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:36356 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbYIFMWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 08:22:44 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] p54: 802.11a 5GHz phy support
Date: Sat, 6 Sep 2008 14:25:58 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809061425.58346.chunkeey@web.de> (sfid-20080906_142247_319608_201BEC02)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch brings the 5GHz Phy in any prism54 devices (of course, only those who have one) to life.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-09-06 13:48:52.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-09-06 14:09:16.000000000 +0200
@@ -27,7 +27,7 @@ MODULE_DESCRIPTION("Softmac Prism54 comm
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("prism54common");
 
-static struct ieee80211_rate p54_rates[] = {
+static struct ieee80211_rate p54_bgrates[] = {
 	{ .bitrate = 10, .hw_value = 0, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
 	{ .bitrate = 20, .hw_value = 1, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
 	{ .bitrate = 55, .hw_value = 2, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
@@ -42,7 +42,7 @@ static struct ieee80211_rate p54_rates[]
 	{ .bitrate = 540, .hw_value = 11, },
 };
 
-static struct ieee80211_channel p54_channels[] = {
+static struct ieee80211_channel p54_bgchannels[] = {
 	{ .center_freq = 2412, .hw_value = 1, },
 	{ .center_freq = 2417, .hw_value = 2, },
 	{ .center_freq = 2422, .hw_value = 3, },
@@ -60,10 +60,66 @@ static struct ieee80211_channel p54_chan
 };
 
 static struct ieee80211_supported_band band_2GHz = {
-	.channels = p54_channels,
-	.n_channels = ARRAY_SIZE(p54_channels),
-	.bitrates = p54_rates,
-	.n_bitrates = ARRAY_SIZE(p54_rates),
+	.channels = p54_bgchannels,
+	.n_channels = ARRAY_SIZE(p54_bgchannels),
+	.bitrates = p54_bgrates,
+	.n_bitrates = ARRAY_SIZE(p54_bgrates),
+};
+
+static struct ieee80211_rate p54_arates[] = {
+	{ .bitrate = 60, .hw_value = 4, },
+	{ .bitrate = 90, .hw_value = 5, },
+	{ .bitrate = 120, .hw_value = 6, },
+	{ .bitrate = 180, .hw_value = 7, },
+	{ .bitrate = 240, .hw_value = 8, },
+	{ .bitrate = 360, .hw_value = 9, },
+	{ .bitrate = 480, .hw_value = 10, },
+	{ .bitrate = 540, .hw_value = 11, },
+};
+
+static struct ieee80211_channel p54_achannels[] = {
+	{ .center_freq = 4920 },
+	{ .center_freq = 4940 },
+	{ .center_freq = 4960 },
+	{ .center_freq = 4980 },
+	{ .center_freq = 5040 },
+	{ .center_freq = 5060 },
+	{ .center_freq = 5080 },
+	{ .center_freq = 5170 },
+	{ .center_freq = 5180 },
+	{ .center_freq = 5190 },
+	{ .center_freq = 5200 },
+	{ .center_freq = 5210 },
+	{ .center_freq = 5220 },
+	{ .center_freq = 5230 },
+	{ .center_freq = 5240 },
+	{ .center_freq = 5260 },
+	{ .center_freq = 5280 },
+	{ .center_freq = 5300 },
+	{ .center_freq = 5320 },
+	{ .center_freq = 5500 },
+	{ .center_freq = 5520 },
+	{ .center_freq = 5540 },
+	{ .center_freq = 5560 },
+	{ .center_freq = 5580 },
+	{ .center_freq = 5600 },
+	{ .center_freq = 5620 },
+	{ .center_freq = 5640 },
+	{ .center_freq = 5660 },
+	{ .center_freq = 5680 },
+	{ .center_freq = 5700 },
+	{ .center_freq = 5745 },
+	{ .center_freq = 5765 },
+	{ .center_freq = 5785 },
+	{ .center_freq = 5805 },
+	{ .center_freq = 5825 },
+};
+
+static struct ieee80211_supported_band band_5GHz = {
+	.channels = p54_achannels,
+	.n_channels = ARRAY_SIZE(p54_achannels),
+	.bitrates = p54_arates,
+	.n_bitrates = ARRAY_SIZE(p54_arates),
 };
 
 int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
@@ -252,6 +308,7 @@ static int p54_convert_rev1(struct ieee8
 
 const char* p54_rf_chips[] = { "NULL", "Indigo?", "Duette",
                               "Frisbee", "Xbow", "Longbow" };
+static int p54_init_xbow_synth(struct ieee80211_hw *dev);
 
 int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 {
@@ -371,20 +428,20 @@ int p54_parse_eeprom(struct ieee80211_hw
 	}
 
 	switch (priv->rxhw) {
-		case 4: /* XBow */	
-		case 1: /* Indigo? */
-		case 2: /* Duette */
-			/* TODO: 5GHz initialization goes here */
-
-		case 3: /* Frisbee */
-		case 5: /* Longbow */
-			dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &band_2GHz;
-			break;
-		default:
-			printk(KERN_ERR "%s: unsupported RF-Chip\n",
-				wiphy_name(dev->wiphy));
-			err = -EINVAL;
-			goto err;
+	case 4: /* XBow */
+		p54_init_xbow_synth(dev);
+	case 1: /* Indigo? */
+	case 2: /* Duette */
+		dev->wiphy->bands[IEEE80211_BAND_5GHZ] = &band_5GHz;
+	case 3: /* Frisbee */
+	case 5: /* Longbow */
+		dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &band_2GHz;
+		break;
+	default:
+		printk(KERN_ERR "%s: unsupported RF-Chip\n",
+			wiphy_name(dev->wiphy));
+		err = -EINVAL;
+		goto err;
 	}
 
 	if (!is_valid_ether_addr(dev->wiphy->perm_addr)) {
@@ -1225,6 +1282,33 @@ static int p54_conf_tx(struct ieee80211_
 	return 0;
 }
 
+static int p54_init_xbow_synth(struct ieee80211_hw *dev)
+{
+	struct p54_common *priv = dev->priv;
+	struct p54_control_hdr *hdr;
+	struct p54_tx_control_xbow_synth *xbow;
+
+	hdr = kzalloc(sizeof(*hdr) + sizeof(*xbow) +
+		      priv->tx_hdr_len, GFP_KERNEL);
+	if (!hdr)
+		return -ENOMEM;
+
+	hdr = (void *)hdr + priv->tx_hdr_len;
+	hdr->magic1 = cpu_to_le16(0x8001);
+	hdr->len = cpu_to_le16(sizeof(*xbow));
+	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_XBOW_SYNTH_CFG);
+	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*xbow));
+
+	xbow = (struct p54_tx_control_xbow_synth *) hdr->data;
+	xbow->magic1 = cpu_to_le16(0x1);
+	xbow->magic2 = cpu_to_le16(0x2);
+	xbow->freq = cpu_to_le16(5390);
+
+	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*xbow), 1);
+
+	return 0;
+}
+
 static void p54_statistics_timer(unsigned long data)
 {
 	struct ieee80211_hw *dev = (struct ieee80211_hw *) data;
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-09-06 13:48:05.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.h	2008-09-06 13:57:06.000000000 +0200
@@ -314,4 +314,11 @@ struct p54_statistics {
 	__le32 unkn[10]; /* CCE / CCA / RADAR */
 } __attribute__ ((packed));
 
+struct p54_tx_control_xbow_synth {
+	__le16 magic1;
+	__le16 magic2;
+	__le16 freq;
+	u32 padding[5];
+} __attribute__ ((packed));
+
 #endif /* P54COMMON_H */

