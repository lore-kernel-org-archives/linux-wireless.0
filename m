Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:59571 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbYKNSml (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 13:42:41 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] p54: honour bss_info_changed's basic_rates and other settings
Date: Fri, 14 Nov 2008 19:42:39 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200811141942.39666.chunkeey@web.de> (sfid-20081114_194245_687599_F692F4F0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As was pointed out in "p54: honour bss_info_changed's short slot time settings" (84c693dbf07503...)

bss_info_changed provides more useful settings that can be used by the driver.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-11-14 18:12:15.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-11-14 18:37:34.000000000 +0100
@@ -1262,20 +1262,20 @@ static int p54_setup_mac(struct ieee8021
 	setup->rx_antenna = priv->rx_antenna;
 	setup->rx_align = 0;
 	if (priv->fw_var < 0x500) {
-		setup->v1.basic_rate_mask = cpu_to_le32(0x15f);
+		setup->v1.basic_rate_mask = cpu_to_le32(priv->basic_rate_mask);
 		memset(setup->v1.rts_rates, 0, 8);
 		setup->v1.rx_addr = cpu_to_le32(priv->rx_end);
 		setup->v1.max_rx = cpu_to_le16(priv->rx_mtu);
 		setup->v1.rxhw = cpu_to_le16(priv->rxhw);
-		setup->v1.wakeup_timer = cpu_to_le16(500);
+		setup->v1.wakeup_timer = cpu_to_le16(priv->wakeup_timer);
 		setup->v1.unalloc0 = cpu_to_le16(0);
 	} else {
 		setup->v2.rx_addr = cpu_to_le32(priv->rx_end);
 		setup->v2.max_rx = cpu_to_le16(priv->rx_mtu);
 		setup->v2.rxhw = cpu_to_le16(priv->rxhw);
-		setup->v2.timer = cpu_to_le16(1000);
+		setup->v2.timer = cpu_to_le16(priv->wakeup_timer);
 		setup->v2.truncate = cpu_to_le16(48896);
-		setup->v2.basic_rate_mask = cpu_to_le32(0x15f);
+		setup->v2.basic_rate_mask = cpu_to_le32(priv->basic_rate_mask);
 		setup->v2.sbss_offset = 0;
 		setup->v2.mcast_window = 0;
 		setup->v2.rx_rssi_threshold = 0;
@@ -1361,7 +1361,7 @@ static int p54_set_freq(struct ieee80211
 	} else {
 		chan->v2.rssical_mul = cpu_to_le16(130);
 		chan->v2.rssical_add = cpu_to_le16(0xfe70);
-		chan->v2.basic_rate_mask = cpu_to_le32(0x15f);
+		chan->v2.basic_rate_mask = cpu_to_le32(priv->basic_rate_mask);
 		memset(chan->v2.rts_rates, 0, 8);
 	}
 	priv->tx(dev, skb, 1);
@@ -1821,6 +1821,24 @@ static void p54_bss_info_changed(struct 
 		priv->use_short_slot = info->use_short_slot;
 		p54_set_edcf(dev);
 	}
+	if (changed & BSS_CHANGED_BASIC_RATES) {
+		if (dev->conf.channel->band == IEEE80211_BAND_5GHZ)
+			priv->basic_rate_mask = (info->basic_rates << 4);
+		else
+			priv->basic_rate_mask = info->basic_rates;
+		p54_setup_mac(dev, priv->mac_mode, priv->bssid);
+		if (priv->fw_var >= 0x500)
+			p54_set_freq(dev, dev->conf.channel->center_freq);
+	}
+	if (changed & BSS_CHANGED_ASSOC) {
+		if (info->assoc) {
+			priv->aid = info->aid;
+			priv->wakeup_timer = info->beacon_int *
+					     info->dtim_period * 5;
+			p54_setup_mac(dev, priv->mac_mode, priv->bssid);
+		}
+	}
+
 }
 
 static const struct ieee80211_ops p54_ops = {
@@ -1850,6 +1868,7 @@ struct ieee80211_hw *p54_init_common(siz
 
 	priv = dev->priv;
 	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
+	priv->basic_rate_mask = 0x15f;
 	skb_queue_head_init(&priv->tx_queue);
 	dev->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		     IEEE80211_HW_SIGNAL_DBM |
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-11-05 23:31:28.000000000 +0100
+++ b/drivers/net/wireless/p54/p54.h	2008-11-14 17:19:36.000000000 +0100
@@ -103,6 +103,9 @@ struct p54_common {
 	unsigned int output_power;
 	u32 tsf_low32;
 	u32 tsf_high32;
+	u64 basic_rate_mask;
+	u16 wakeup_timer;
+	u16 aid;
 	struct ieee80211_tx_queue_stats tx_stats[8];
 	struct p54_edcf_queue_param qos_params[8];
 	struct ieee80211_low_level_stats stats;
