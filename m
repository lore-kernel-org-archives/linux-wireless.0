Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:49923 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab3F1TNR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jun 2013 15:13:17 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 12/19] rt2x00: rt2800lib: add default_power3 field for three-chain devices
Date: Fri, 28 Jun 2013 21:12:26 +0200
Message-Id: <1372446753-11408-13-git-send-email-juhosg@openwrt.org> (sfid-20130628_211323_206561_1B1DB3E3)
In-Reply-To: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
References: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The actual code uses two default TX power values.
This is enough for 1T and for 2T devices however
on 3T devices another value is needed for the third
chain.

Add a new field to struct channel_info and initialize
it from the 'rt2800_probe_hw_mode' function. Also modify
the 'rt2800_config_channel' to handle the new field as
well.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   22 ++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00.h    |    1 +
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index f079d70..bc21a57 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2769,6 +2769,10 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 						     info->default_power1);
 	info->default_power2 = rt2800_txpower_to_dev(rt2x00dev, rf->channel,
 						     info->default_power2);
+	if (rt2x00dev->default_ant.tx_chain_num > 2)
+		info->default_power3 =
+			rt2800_txpower_to_dev(rt2x00dev, rf->channel,
+					      info->default_power3);
 
 	switch (rt2x00dev->chip.rf) {
 	case RF2020:
@@ -6964,6 +6968,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	struct channel_info *info;
 	char *default_power1;
 	char *default_power2;
+	char *default_power3;
 	unsigned int i;
 	u16 eeprom;
 	u32 reg;
@@ -7116,9 +7121,17 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	default_power1 = rt2800_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG1);
 	default_power2 = rt2800_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG2);
 
+	if (rt2x00dev->default_ant.tx_chain_num > 2)
+		default_power3 = rt2800_eeprom_addr(rt2x00dev,
+						    EEPROM_EXT_TXPOWER_BG3);
+	else
+		default_power3 = NULL;
+
 	for (i = 0; i < 14; i++) {
 		info[i].default_power1 = default_power1[i];
 		info[i].default_power2 = default_power2[i];
+		if (default_power3)
+			info[i].default_power3 = default_power3[i];
 	}
 
 	if (spec->num_channels > 14) {
@@ -7127,9 +7140,18 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		default_power2 = rt2800_eeprom_addr(rt2x00dev,
 						    EEPROM_TXPOWER_A2);
 
+		if (rt2x00dev->default_ant.tx_chain_num > 2)
+			default_power3 =
+				rt2800_eeprom_addr(rt2x00dev,
+						   EEPROM_EXT_TXPOWER_A3);
+		else
+			default_power3 = NULL;
+
 		for (i = 14; i < spec->num_channels; i++) {
 			info[i].default_power1 = default_power1[i - 14];
 			info[i].default_power2 = default_power2[i - 14];
+			if (default_power3)
+				info[i].default_power3 = default_power3[i - 14];
 		}
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index ee3fc57..fe4c572 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -211,6 +211,7 @@ struct channel_info {
 	short max_power;
 	short default_power1;
 	short default_power2;
+	short default_power3;
 };
 
 /*
-- 
1.7.10

