Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:43350 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbYCaM3M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 08:29:12 -0400
From: Chr <chunkeey@web.de>
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Subject: Re: [RFC][PATCH 2/2] p54: statistic readback and other changes
Date: Mon, 31 Mar 2008 14:29:07 +0200
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
References: <200803302349.27450.chunkeey@web.de> <200803310002.44110.florian.fainelli@telecomint.eu>
In-Reply-To: <200803310002.44110.florian.fainelli@telecomint.eu>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_TkN8HFjtu05qt4e"
Message-Id: <200803311429.07640.chunkeey@web.de> (sfid-20080331_133806_304641_05275510)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_TkN8HFjtu05qt4e
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 31 March 2008 00:02:43 Florian Fainelli wrote:
> Hi Christian,
>
> Le dimanche 30 mars 2008, Chr a =E9crit=A0:
> > This patch brings some of the new features for both
> > (PCI and USB) devices... unfortunately I don't know if
> > the readback works on USB.
>
> @@ -53,10 +53,10 @@ struct pda_entry {
>  } __attribute__ ((packed));
>
>  struct eeprom_pda_wrap {
> -	__le32 magic;
> -	__le16 pad;
> -	__le16 len;
> -	__le32 arm_opcode;
> +	u32 magic;
> +	u16 pad;
> +	u16 len;
> +	u32 arm_opcode;
>  	u8 data[0];
>  } __attribute__ ((packed));
Ahh...=20

> This change will break p54 on big-endian hosts which is something that has
> been fixed few weeks ago.
>
> Will have some test	on a prism54 usb device and report back here.
Is it a USB v1 (one with a net2280) or ISL3887?

Regards,
	Chr.

--Boundary-00=_TkN8HFjtu05qt4e
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="p54-stats-v2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54-stats-v2.diff"

diff -Nurp a/drivers/net/wireless/p54common.c b/drivers/net/wireless/p54common.c
--- a/drivers/net/wireless/p54common.c	2008-03-31 14:16:44.000000000 +0200
+++ b/drivers/net/wireless/p54common.c	2008-03-31 14:25:32.000000000 +0200
@@ -296,10 +296,6 @@ int p54_parse_eeprom(struct ieee80211_hw
 			/* make it overrun */
 			entry_len = len;
 			break;
-		default:
-			printk(KERN_INFO "p54: unknown eeprom code : 0x%x\n",
-				le16_to_cpu(entry->code));
-			break;
 		}
 
 		entry = (void *)entry + (entry_len + 1)*2;
@@ -334,6 +330,11 @@ int p54_parse_eeprom(struct ieee80211_hw
 }
 EXPORT_SYMBOL_GPL(p54_parse_eeprom);
 
+static inline int p54_rssi_to_dbm(u8 rssi)
+{
+	return rssi / 2 - 100;
+}
+
 void p54_fill_eeprom_readback(struct p54_control_hdr *hdr)
 {
 	struct p54_eeprom_lm86 *eeprom_hdr;
@@ -348,16 +349,28 @@ void p54_fill_eeprom_readback(struct p54
 }
 EXPORT_SYMBOL_GPL(p54_fill_eeprom_readback);
 
-static void p54_rx_data(struct ieee80211_hw *dev, struct sk_buff *skb)
+static int p54_rx_data(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
+	struct p54_common *priv = dev->priv;
 	struct p54_rx_hdr *hdr = (struct p54_rx_hdr *) skb->data;
 	struct ieee80211_rx_status rx_status = {0};
-	u16 freq = le16_to_cpu(hdr->freq);
 
-	rx_status.ssi = hdr->rssi;
-	/* XX correct? */
+	if (!(hdr->magic & cpu_to_le16(0x01))) {
+		if (priv->rx_filter == P54_RX_FILTER_FCSFAIL)
+			rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
+		else
+			/* reuse skb */
+			return 0;
+	}
+	rx_status.ssi = p54_rssi_to_dbm(hdr->rssi);
+	rx_status.noise = priv->stats.noise_floor;
+	if (rx_status.ssi > rx_status.noise)
+		rx_status.signal = rx_status.ssi - rx_status.noise;
+
+	/* FIX MAC80211: for now we remove the short preamble flag */
 	rx_status.rate_idx = hdr->rate & 0xf;
-	rx_status.freq = freq;
+
+	rx_status.freq = le16_to_cpu(hdr->freq);
 	rx_status.band = IEEE80211_BAND_2GHZ;
 	rx_status.antenna = hdr->antenna;
 	rx_status.mactime = le64_to_cpu(hdr->timestamp);
@@ -367,6 +380,8 @@ static void p54_rx_data(struct ieee80211
 	skb_trim(skb, le16_to_cpu(hdr->len));
 
 	ieee80211_rx_irqsafe(dev, skb, &rx_status);
+
+	return -1;
 }
 
 static void inline p54_wake_free_queues(struct ieee80211_hw *dev)
@@ -451,6 +466,21 @@ out:
 		p54_wake_free_queues(dev);
 }
 
+static void p54_rx_stats(struct ieee80211_hw *dev, struct sk_buff *skb)
+{
+	struct p54_common *priv = dev->priv;
+	struct p54_control_hdr *hdr = (struct p54_control_hdr *) skb->data;
+	struct p54_statistics *hw_stats = (struct p54_statistics *)hdr->data;
+
+	priv->stats.rx_success = le32_to_cpu(hw_stats->rx_success);
+	priv->stats.rx_errors = le32_to_cpu(hw_stats->rx_errors);
+	priv->stats.rx_aborts = le32_to_cpu(hw_stats->rx_aborts);
+	priv->stats.rx_aborts_phy = le32_to_cpu(hw_stats->rx_aborts_phy);
+	priv->stats.rx_rts_success = le32_to_cpu(hw_stats->rx_rts_success);
+	priv->stats.rx_rts_failed = le32_to_cpu(hw_stats->rx_rts_failed);
+	priv->stats.noise_floor = p54_rssi_to_dbm(hw_stats->noise_floor);
+}
+
 static void p54_rx_control(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54_control_hdr *hdr = (struct p54_control_hdr *) skb->data;
@@ -459,6 +489,9 @@ static void p54_rx_control(struct ieee80
 	case P54_CONTROL_TYPE_TXDONE:
 		p54_rx_frame_sent(dev, skb);
 		break;
+	case P54_CONTROL_TYPE_STAT_READBACK:
+		p54_rx_stats(dev, skb);
+		break;
 	case P54_CONTROL_TYPE_BBP:
 		break;
 	default:
@@ -475,8 +508,7 @@ int p54_rx(struct ieee80211_hw *dev, str
 	switch (type) {
 	case 0x00:
 	case 0x01:
-		p54_rx_data(dev, skb);
-		return -1;
+		return p54_rx_data(dev, skb);
 	case 0x4d:
 		/* TODO: do something better... but then again, I've never seen this happen */
 		printk(KERN_ERR "%s: Received fault. Probably need to restart hardware now..\n",
@@ -597,28 +629,26 @@ static int p54_tx(struct ieee80211_hw *d
 	hdr->retry1 = hdr->retry2 = control->retry_limit;
 	p54_assign_address(dev, skb, hdr, skb->len, control_copy);
 
-	memset(txhdr->wep_key, 0x0, 16);
-	txhdr->padding = 0;
-	txhdr->padding2 = 0;
-
 	/* TODO: add support for alternate retry TX rates */
 	rate = control->tx_rate->hw_value;
-	if (control->flags & IEEE80211_TXCTL_SHORT_PREAMBLE)
-		rate |= 0x10;
 	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS)
 		rate |= 0x40;
 	else if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
 		rate |= 0x20;
 	memset(txhdr->rateset, rate, 8);
-	txhdr->wep_key_present = 0;
-	txhdr->wep_key_len = 0;
+	txhdr->key_type = 0;
+	txhdr->key_len = 0;
 	txhdr->frame_type = cpu_to_le32(control->queue + 4);
-	txhdr->magic4 = 0;
 	txhdr->antenna = (control->antenna_sel_tx == 0) ?
 		2 : control->antenna_sel_tx - 1;
-	txhdr->output_power = 0x7f;
-	txhdr->magic5 = (control->flags & IEEE80211_TXCTL_NO_ACK) ?
-		0 : ((rate > 0x3) ? cpu_to_le32(0x33) : cpu_to_le32(0x23));
+	txhdr->output_power = 0x7f; /* 0.25 dbm / unit */
+	if (control->rts_cts_rate)
+		txhdr->cts_rate = (control->flags & IEEE80211_TXCTL_NO_ACK) ?
+			0 : (control->rts_cts_rate->hw_value | 0x20);
+	else
+		txhdr->cts_rate = (control->flags & IEEE80211_TXCTL_NO_ACK) ?
+			0 : (0x23);
+
 	if (padding)
 		txhdr->align[0] = padding;
 
@@ -626,9 +656,10 @@ static int p54_tx(struct ieee80211_hw *d
 	return 0;
 }
 
-static int p54_set_filter(struct ieee80211_hw *dev, u16 filter_type,
-			  const u8 *dst, const u8 *src, u8 antenna,
-			  u32 magic3, u32 magic8, u32 magic9)
+const static unsigned char p54_client_rts_rates[8] = { 8, 6, 4, 1, 0, 0, 0, 0 };
+const static unsigned char p54_ap_rts_rates[8] = { 3, 3, 1, 0, 0, 0, 0, 0 };
+
+static int p54_set_filter(struct ieee80211_hw *dev, u8 filter_type)
 {
 	struct p54_common *priv = dev->priv;
 	struct p54_control_hdr *hdr;
@@ -647,19 +678,26 @@ static int p54_set_filter(struct ieee802
 	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*filter), NULL);
 	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_FILTER_SET);
 
-	filter->filter_type = cpu_to_le16(filter_type);
-	memcpy(filter->dst, dst, ETH_ALEN);
-	if (!src)
-		memset(filter->src, ~0, ETH_ALEN);
-	else
-		memcpy(filter->src, src, ETH_ALEN);
-	filter->antenna = antenna;
-	filter->magic3 = cpu_to_le32(magic3);
+	filter->filter_type = filter_type;
+	memcpy(filter->our_mac, priv->mac_addr, ETH_ALEN);
+
+	/* 0x15F is a bitrate mask
+	 * = 0000000101011111b
+	 * = 24MBits 12MBits 6MBit 11MBit 5.5MBits 2MBits 1Mbit */
+	filter->bss_basic_rates = cpu_to_le32(0x15F);
+	memcpy(filter->rts_rates, p54_client_rts_rates, 8);
+	memset(filter->bss_filter_mac, ~0, ETH_ALEN);
+
+	filter->rx_antenna = (dev->conf.antenna_sel_rx == 0) ? 2 :
+		dev->conf.antenna_sel_rx - 1;
 	filter->rx_addr = cpu_to_le32(priv->rx_end);
 	filter->max_rx = cpu_to_le16(0x0620);	/* FIXME: for usb ver 1.. maybe */
 	filter->rxhw = priv->rxhw;
-	filter->magic8 = cpu_to_le16(magic8);
-	filter->magic9 = cpu_to_le16(magic9);
+
+	/* that's beacon_int * dtim_period * 5, unless
+	 * there's a way to get these values here, let's
+	 * use the standard ones */
+	filter->dtim_timer = cpu_to_le16(500);
 
 	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*filter), 1);
 	return 0;
@@ -738,6 +776,7 @@ static int p54_set_freq(struct ieee80211
 	memcpy(hdr->data + payload_len - 4, &chan->val_bpsk, 4);
 
 	priv->tx(dev, hdr, sizeof(*hdr) + payload_len, 1);
+	priv->freq = freq;
 	return 0;
 
  err:
@@ -875,20 +914,24 @@ static int p54_add_interface(struct ieee
 
 	memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
 
-	p54_set_filter(dev, 0, priv->mac_addr, NULL, 0, 1, 0, 0xF642);
-	p54_set_filter(dev, 0, priv->mac_addr, NULL, 1, 0, 0, 0xF642);
+	p54_set_filter(dev, P54_FILTER_TYPE_NONE);
 
 	switch (conf->type) {
 	case IEEE80211_IF_TYPE_STA:
-		p54_set_filter(dev, 1, priv->mac_addr, NULL, 0, 0x15F, 0x1F4, 0);
+		priv->filter_type = P54_FILTER_TYPE_STA;
 		break;
 	default:
 		BUG();	/* impossible */
 		break;
 	}
 
+	p54_set_filter(dev, priv->filter_type);
+
 	p54_set_leds(dev, 1, 0, 0);
 
+	/* start statistics readback timer */
+	mod_timer(&priv->stats.timer, jiffies + HZ);
+
 	return 0;
 }
 
@@ -896,9 +939,12 @@ static void p54_remove_interface(struct 
 				 struct ieee80211_if_init_conf *conf)
 {
 	struct p54_common *priv = dev->priv;
+
+	del_timer(&priv->stats.timer);
 	priv->mode = IEEE80211_IF_TYPE_MNTR;
+	priv->filter_type = P54_FILTER_TYPE_NONE;
 	memset(priv->mac_addr, 0, ETH_ALEN);
-	p54_set_filter(dev, 0, priv->mac_addr, NULL, 2, 0, 0, 0);
+	p54_set_filter(dev, P54_FILTER_TYPE_NONE);
 }
 
 static int p54_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
@@ -916,10 +962,14 @@ static int p54_config_interface(struct i
 {
 	struct p54_common *priv = dev->priv;
 
-	p54_set_filter(dev, 0, priv->mac_addr, conf->bssid, 0, 1, 0, 0xF642);
-	p54_set_filter(dev, 0, priv->mac_addr, conf->bssid, 2, 0, 0, 0);
-	p54_set_leds(dev, 1, !is_multicast_ether_addr(conf->bssid), 0);
-	memcpy(priv->bssid, conf->bssid, ETH_ALEN);
+	switch (conf->type) {
+	case IEEE80211_IF_TYPE_STA:
+		memcpy(priv->bssid, conf->bssid, ETH_ALEN);
+		p54_set_filter(dev, P54_FILTER_TYPE_STA);
+		p54_set_leds(dev, 1, !is_multicast_ether_addr(conf->bssid), 0);
+		break;
+	}
+
 	return 0;
 }
 
@@ -929,16 +979,34 @@ static void p54_configure_filter(struct 
 				 int mc_count, struct dev_mc_list *mclist)
 {
 	struct p54_common *priv = dev->priv;
+	unsigned flags = FIF_BCN_PRBRESP_PROMISC | FIF_PROMISC_IN_BSS;
 
-	*total_flags &= FIF_BCN_PRBRESP_PROMISC;
+	if (priv->filter_type & P54_FILTER_TYPE_PROMISC)
+		flags |= FIF_FCSFAIL;
+
+	*total_flags &= flags;
 
 	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
 		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
-			p54_set_filter(dev, 0, priv->mac_addr,
-				       NULL, 2, 0, 0, 0);
+			p54_set_filter(dev, P54_FILTER_TYPE_NONE);
+		else
+			p54_set_filter(dev, priv->filter_type);
+	}
+
+	if (changed_flags & FIF_PROMISC_IN_BSS) {
+		if (*total_flags & FIF_PROMISC_IN_BSS)
+			priv->filter_type |= P54_FILTER_TYPE_PROMISC;
 		else
-			p54_set_filter(dev, 0, priv->mac_addr,
-				       priv->bssid, 2, 0, 0, 0);
+			priv->filter_type &= ~P54_FILTER_TYPE_PROMISC;
+
+		p54_set_filter(dev, priv->filter_type);
+	}
+
+	if (changed_flags & FIF_FCSFAIL) {
+		if (*total_flags & FIF_FCSFAIL)
+			priv->rx_filter |= P54_RX_FILTER_FCSFAIL;
+		else
+			priv->rx_filter &= ~P54_RX_FILTER_FCSFAIL;
 	}
 }
 
@@ -962,10 +1030,38 @@ static int p54_conf_tx(struct ieee80211_
 	return 0;
 }
 
+static void p54_stats_timer(unsigned long data)
+{
+	struct ieee80211_hw *dev = (struct ieee80211_hw *)data;
+	struct p54_common *priv = dev->priv;
+	struct p54_control_hdr *hdr;
+	struct p54_statistics *stat;
+
+	hdr = (void *)priv->stats.cached_stats + priv->tx_hdr_len;
+	hdr->magic1 = cpu_to_le16(0x8000);
+	hdr->len = cpu_to_le16(sizeof(*stat));
+	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_STAT_READBACK);
+	hdr->retry1 = hdr->retry2 = 0;
+	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*stat), NULL);
+
+	stat = (struct p54_statistics *)hdr->data;
+	memset(stat, 0x0, sizeof(*stat));
+
+	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*stat), 0);
+
+	/* get stats every 5 seconds */
+	mod_timer(&priv->stats.timer, jiffies + 5*HZ);
+}
+
 static int p54_get_stats(struct ieee80211_hw *dev,
 			 struct ieee80211_low_level_stats *stats)
 {
-	/* TODO */
+	struct p54_common *priv = dev->priv;
+
+	stats->dot11RTSFailureCount = priv->stats.rx_rts_failed;
+	stats->dot11RTSSuccessCount = priv->stats.rx_rts_success;
+	stats->dot11FCSErrorCount = priv->stats.rx_errors;
+
 	return 0;
 }
 
@@ -1009,25 +1105,37 @@ struct ieee80211_hw *p54_init_common(siz
 	priv->mode = IEEE80211_IF_TYPE_INVALID;
 	skb_queue_head_init(&priv->tx_queue);
 	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &band_2GHz;
-	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING | /* not sure */
+	dev->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
+		    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING | /* not sure */
 		    IEEE80211_HW_RX_INCLUDES_FCS;
-	dev->channel_change_time = 1000;	/* TODO: find actual value */
-	dev->max_rssi = 127;
+
+	dev->channel_change_time = 5000;
+	priv->stats.noise_floor = -93;
+	dev->max_signal = 64;
+	dev->max_rssi = -36;
+	dev->max_noise = -36;
 
 	priv->tx_stats.data[0].limit = 5;
+	priv->filter_type = P54_FILTER_TYPE_NONE;
+	priv->rx_filter = P54_RX_FILTER_NOTHING;
 	dev->queues = 1;
 
 	dev->extra_tx_headroom = sizeof(struct p54_control_hdr) + 4 +
 				 sizeof(struct p54_tx_control_allocdata);
 
         priv->cached_vdcf = kzalloc(sizeof(struct p54_tx_control_vdcf) +
-              priv->tx_hdr_len + sizeof(struct p54_control_hdr), GFP_KERNEL);
-
-	if (!priv->cached_vdcf) {
+		priv->tx_hdr_len + sizeof(struct p54_control_hdr), GFP_KERNEL);
+	priv->stats.cached_stats = kzalloc(sizeof(struct p54_statistics) +
+		priv->tx_hdr_len + sizeof(struct p54_control_hdr), GFP_KERNEL);
+
+	if (!priv->cached_vdcf || !priv->stats.cached_stats) {
+		kfree(priv->cached_vdcf);
+		kfree(priv->stats.cached_stats);
 		ieee80211_free_hw(dev);
 		return NULL;
 	}
 
+	setup_timer(&priv->stats.timer, p54_stats_timer, (unsigned long)dev);
 	p54_init_vdcf(dev);
 
 	return dev;
@@ -1041,6 +1149,7 @@ void p54_free_common(struct ieee80211_hw
 	kfree(priv->output_limit);
 	kfree(priv->curve_data);
 	kfree(priv->cached_vdcf);
+	kfree(priv->stats.cached_stats);
 }
 EXPORT_SYMBOL_GPL(p54_free_common);
 
diff -Nurp a/drivers/net/wireless/p54common.h b/drivers/net/wireless/p54common.h
--- a/drivers/net/wireless/p54common.h	2008-03-29 16:06:06.000000000 +0100
+++ b/drivers/net/wireless/p54common.h	2008-03-31 00:21:04.000000000 +0200
@@ -89,14 +89,14 @@ struct pda_pa_curve_data_sample_rev1 {
 	u8 data_qpsk;
 	u8 data_16qam;
 	u8 data_64qam;
-	u8 padding;
+	u8 :8;
 } __attribute__ ((packed));
 
 struct pda_pa_curve_data {
 	u8 cal_method_rev;
 	u8 channels;
 	u8 points_per_channel;
-	u8 padding;
+	u8 :8;
 	u8 data[0];
 } __attribute__ ((packed));
 
@@ -161,6 +161,14 @@ struct p54_eeprom_lm86 {
 	u8 data[0];
 } __attribute__ ((packed));
 
+enum {
+	P54_KEY_TYPE_NONE = 0,
+	P54_KEY_TYPE_WEP,
+	P54_KEY_TYPE_EAPOL,
+	P54_KEY_TYPE_TKIP,
+	P54_KEY_TYPE_CCX = 6
+};
+
 struct p54_rx_hdr {
 	__le16 magic;
 	__le16 len;
@@ -169,7 +177,8 @@ struct p54_rx_hdr {
 	u8 rate;
 	u8 rssi;
 	u8 quality;
-	u16 unknown2;
+	u8 key_type;
+	u8 channel_activity;
 	__le64 timestamp;
 	u8 data[0];
 } __attribute__ ((packed));
@@ -182,34 +191,49 @@ struct p54_frame_sent_hdr {
 	u16 rate;
 } __attribute__ ((packed));
 
+#define P54_FILTER_TYPE_NONE 	0
+#define P54_FILTER_TYPE_STA	1
+#define P54_FILTER_TYPE_ADHOC	2
+#define P54_FILTER_TYPE_AP 	4
+#define P54_FILTER_TYPE_PROMISC 8
+#define P54_FILTER_TYPE_MONITOR 16
+#define P54_FILTER_TYPE_SLEEP 	32
+
+#define P54_RX_FILTER_NOTHING	0
+#define P54_RX_FILTER_FCSFAIL 	1
+#define P54_RX_FILTER_OTHER_BSS	2
+
 struct p54_tx_control_allocdata {
 	u8 rateset[8];
-	u16 padding;
-	u8 wep_key_present;
-	u8 wep_key_len;
-	u8 wep_key[16];
-	__le32 frame_type;
-	u32 padding2;
-	__le16 magic4;
+	u16 :16;
+	u8 key_type;
+	u8 key_len;
+	u8 key[16];
+	u8 frame_type;
+	u32 :24;
+	u32 :32;
+	u16 :16;
 	u8 antenna;
 	u8 output_power;
-	__le32 magic5;
+	u8 cts_rate;
+	u32 :24;
 	u8 align[0];
 } __attribute__ ((packed));
 
 struct p54_tx_control_filter {
-	__le16 filter_type;
-	u8 dst[ETH_ALEN];
-	u8 src[ETH_ALEN];
-	u8 antenna;
-	u8 debug;
-	__le32 magic3;
-	u8 rates[8];	// FIXME: what's this for?
+	u8 filter_type;
+	u8 :8;
+	u8 our_mac[ETH_ALEN];
+	u8 bss_filter_mac[ETH_ALEN];
+	u8 rx_antenna;
+	u8 rx_align;
+	__le32 bss_basic_rates;
+	u8 rts_rates[8];
 	__le32 rx_addr;
 	__le16 max_rx;
 	__le16 rxhw;
-	__le16 magic8;
-	__le16 magic9;
+	__le16 dtim_timer;
+	u16 :16;
 } __attribute__ ((packed));
 
 struct p54_tx_control_channel {
@@ -242,13 +266,29 @@ struct p54_tx_vdcf_queues {
 } __attribute__ ((packed));
 
 struct p54_tx_control_vdcf {
-	u8 padding;
+	u8 :8;
 	u8 slottime;
 	u8 magic1;
 	u8 magic2;
 	struct p54_tx_vdcf_queues queue[8];
-	u8 pad2[4];
+	u8 offset1;
+	u8 offset2;
+	u16 :16;
 	__le16 frameburst;
 } __attribute__ ((packed));
 
+struct p54_statistics {
+	__le32 rx_success;
+	__le32 rx_errors;
+	__le32 rx_aborts;
+	__le32 rx_aborts_phy;
+	__le32 rx_rts_success;
+	__le32 rx_rts_failed;
+	__le32 tsf;
+	__le32 unknown_stat;
+	u8 noise_floor;
+	u32 :24;
+	u8 unknown[40];		/* CCA / CCQ / RADAR data */
+} __attribute__ ((packed));
+
 #endif /* PRISM54COMMON_H */
diff -Nurp a/drivers/net/wireless/p54.h b/drivers/net/wireless/p54.h
--- a/drivers/net/wireless/p54.h	2008-03-29 16:06:06.000000000 +0100
+++ b/drivers/net/wireless/p54.h	2008-03-31 14:26:54.000000000 +0200
@@ -14,18 +14,29 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/timer.h>
+
 enum control_frame_types {
 	P54_CONTROL_TYPE_FILTER_SET = 0,
 	P54_CONTROL_TYPE_CHANNEL_CHANGE,
 	P54_CONTROL_TYPE_FREQDONE,
 	P54_CONTROL_TYPE_DCFINIT,
-	P54_CONTROL_TYPE_FREEQUEUE = 7,
+	P54_CONTROL_TYPE_CRYPTO,
+	P54_CONTROL_TYPE_TIM,
+	P54_CONTROL_TYPE_POWERMGT_RADAR,
+	P54_CONTROL_TYPE_FREEQUEUE,
 	P54_CONTROL_TYPE_TXDONE,
 	P54_CONTROL_TYPE_PING,
 	P54_CONTROL_TYPE_STAT_READBACK,
 	P54_CONTROL_TYPE_BBP,
 	P54_CONTROL_TYPE_EEPROM_READBACK,
-	P54_CONTROL_TYPE_LED
+	P54_CONTROL_TYPE_LED,
+	P54_CONTROL_TYPE_GPIO,
+	P54_CONTROL_TYPE_TIMERS,
+	P54_CONTROL_TYPE_MODULATION,
+	P54_CONTROL_TYPE_SYNTH_CONFIG,
+	P54_CONTROL_TYPE_DETECTOR_VALUE,
+	P54_CONTROL_TYPE_5GHZ_SYNTH
 };
 
 struct p54_control_hdr {
@@ -38,6 +49,19 @@ struct p54_control_hdr {
 	u8 data[0];
 } __attribute__ ((packed));
 
+struct p54_stats {
+	void *cached_stats;
+	struct timer_list timer;
+	u32 rx_success;
+	u32 rx_errors;
+	u32 rx_aborts;
+	u32 rx_aborts_phy;
+	u32 rx_rts_success;
+	u32 rx_rts_failed;
+	u32 tsf;
+	int noise_floor;
+};
+
 #define EEPROM_READBACK_LEN (sizeof(struct p54_control_hdr) + 4 /* p54_eeprom_lm86 */)
 #define MAX_RX_SIZE (IEEE80211_MAX_RTS_THRESHOLD + sizeof(struct p54_control_hdr) + 20 /* length of struct p54_rx_hdr */ + 16 )
 
@@ -60,10 +84,14 @@ struct p54_common {
 	unsigned int output_limit_len;
 	struct pda_pa_curve_data *curve_data;
 	__le16 rxhw;
+	__le16 freq;
+	u8 filter_type;
 	u8 version;
+	unsigned int rx_filter;
 	unsigned int tx_hdr_len;
 	void *cached_vdcf;
 	unsigned int fw_var;
+	struct p54_stats stats;
 	struct ieee80211_tx_queue_stats tx_stats;
 };
 

--Boundary-00=_TkN8HFjtu05qt4e--
