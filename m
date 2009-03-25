Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:38632 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787AbZCYCJS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 22:09:18 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] p54: clean up p54.h's struct p54_common
Date: Wed, 25 Mar 2009 03:11:58 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903250311.58614.chunkeey@web.de> (sfid-20090325_030922_127663_6FF094D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch rearrange and regroups most elements in p54_common.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
this is testing material... especially 3/3!
---
diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index ecf8b6e..04d95a1 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -133,55 +133,72 @@ struct p54_led_dev {
 
 struct p54_common {
 	struct ieee80211_hw *hw;
-	u32 rx_start;
-	u32 rx_end;
-	struct sk_buff_head tx_queue;
 	void (*tx)(struct ieee80211_hw *dev, struct sk_buff *skb);
 	int (*open)(struct ieee80211_hw *dev);
 	void (*stop)(struct ieee80211_hw *dev);
-	int mode;
+	struct sk_buff_head tx_queue;
+	struct mutex conf_mutex;
+
+	/* memory management (as seen by the firmware) */
+	u32 rx_start;
+	u32 rx_end;
 	u16 rx_mtu;
 	u8 headroom;
 	u8 tailroom;
-	struct mutex conf_mutex;
-	u8 mac_addr[ETH_ALEN];
-	u8 bssid[ETH_ALEN];
+
+	/* firmware/hardware info */
+	unsigned int tx_hdr_len;
+	unsigned int fw_var;
+	unsigned int fw_interface;
+	u8 version;
+
+	/* (e)DCF / QOS state */
+	bool use_short_slot;
+	struct ieee80211_tx_queue_stats tx_stats[8];
+	struct p54_edcf_queue_param qos_params[8];
+
+	/* Radio data */
+	u16 rxhw;
 	u8 rx_diversity_mask;
 	u8 tx_diversity_mask;
+	unsigned int output_power;
+	int noise;
+	/* calibration, output power limit and rssi<->dBm conversation data */
 	struct pda_iq_autocal_entry *iq_autocal;
 	unsigned int iq_autocal_len;
-	struct p54_cal_database *output_limit;
 	struct p54_cal_database *curve_data;
+	struct p54_cal_database *output_limit;
 	struct p54_rssi_linear_approximation rssical_db[IEEE80211_NUM_BANDS];
+
+	/* BBP/MAC state */
+	u8 mac_addr[ETH_ALEN];
+	u8 bssid[ETH_ALEN];
+	u16 wakeup_timer;
 	unsigned int filter_flags;
-	bool use_short_slot;
-	u16 rxhw;
-	u8 version;
-	unsigned int tx_hdr_len;
-	unsigned int fw_var;
-	unsigned int fw_interface;
-	unsigned int output_power;
-	u32 tsf_low32;
-	u32 tsf_high32;
+	int mode;
+	u32 tsf_low32, tsf_high32;
 	u32 basic_rate_mask;
-	u16 wakeup_timer;
 	u16 aid;
-	struct ieee80211_tx_queue_stats tx_stats[8];
-	struct p54_edcf_queue_param qos_params[8];
-	struct ieee80211_low_level_stats stats;
-	struct delayed_work work;
 	struct sk_buff *cached_beacon;
-	int noise;
-	void *eeprom;
-	struct completion eeprom_comp;
+
+	/* cryptographic engine information */
 	u8 privacy_caps;
 	u8 rx_keycache_size;
+
 	/* LED management */
 #ifdef CONFIG_P54_LEDS
 	struct p54_led_dev assoc_led;
 	struct p54_led_dev tx_led;
 #endif /* CONFIG_P54_LEDS */
 	u16 softled_state;		/* bit field of glowing LEDs */
+
+	/* statistics */
+	struct ieee80211_low_level_stats stats;
+	struct delayed_work work;
+
+	/* eeprom handling */
+	void *eeprom;
+	struct completion eeprom_comp;
 };
 
 int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb);
