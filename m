Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:36331 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbYIFMWk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 08:22:40 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] p54: control output power levels
Date: Sat, 6 Sep 2008 14:25:53 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809061425.53943.chunkeey@web.de> (sfid-20080906_142245_282893_09EA4BCE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I hope this patch is enough to cover at least the basic requirements of IEEE 802.11h's TPC.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
Yeah, I know... but, I made these changes such a long time ago, that I
forgot them yesterday... sorry!
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-09-06 02:44:35.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-09-06 13:48:52.000000000 +0200
@@ -800,7 +800,7 @@ static int p54_tx(struct ieee80211_hw *d
 	txhdr->hw_queue = skb_get_queue_mapping(skb) + 4;
 	txhdr->tx_antenna = (info->antenna_sel_tx == 0) ?
 		2 : info->antenna_sel_tx - 1;
-	txhdr->output_power = 0x7f; // HW Maximum
+	txhdr->output_power = priv->output_power;
 	txhdr->cts_rate = (info->flags & IEEE80211_TX_CTL_NO_ACK) ?
 			  0 : cts_rate;
 	if (padding)
@@ -1154,6 +1154,7 @@ static int p54_config(struct ieee80211_h
 	mutex_lock(&priv->conf_mutex);
 	priv->rx_antenna = (conf->antenna_sel_rx == 0) ?
 		2 : conf->antenna_sel_tx - 1;
+	priv->output_power = conf->power_level << 2;
 	ret = p54_set_freq(dev, cpu_to_le16(conf->channel->center_freq));
 	p54_set_vdcf(dev);
 	mutex_unlock(&priv->conf_mutex);
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-09-05 21:11:06.000000000 +0200
+++ b/drivers/net/wireless/p54/p54.h	2008-09-06 13:49:13.000000000 +0200
@@ -88,6 +88,7 @@ struct p54_common {
 	void *cached_vdcf;
 	unsigned int fw_var;
 	unsigned int fw_interface;
+	unsigned int output_power;
 	u32 tsf_low32;
 	u32 tsf_high32;
 	struct ieee80211_tx_queue_stats tx_stats[8];

