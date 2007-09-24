Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:53879 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199AbXIXR4A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 13:56:00 -0400
From: Chr <chunkeey@web.de>
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] p54: Adapt to filter configuration API
Date: Mon, 24 Sep 2007 19:55:56 +0200
Cc: linux-wireless@vger.kernel.org
References: <200709241106.04902.flamingice@sourmilk.net> <200709241107.28275.flamingice@sourmilk.net>
In-Reply-To: <200709241107.28275.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_so/9GuJC6hqcvhk"
Message-Id: <200709241955.57014.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_so/9GuJC6hqcvhk
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday, 24. September 2007, Michael Wu wrote:
> On Monday 24 September 2007 11:06, Michael Wu wrote:
> > From: Michael Wu <flamingice@sourmilk.net>
> >
> > This makes p54 use the new filter configuration API in mac80211.
> >
> > Signed-off-by: Michael Wu <flamingice@sourmilk.net>
> Err, and the title should be:
> 
> [PATCH] p54: Adapt to filter configuration API 
> 
> Ugh.
> 
> -Michael Wu
> 

K, I couldn't test it,  but it looks OK! I'll provide a tested-by as soon as the API
can be found in the git tree ;)

---

(the attached patch is just something to look at (although it should work too), 
it contains new information about the some remaining unknown fields and magics...)  

--Boundary-00=_so/9GuJC6hqcvhk
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="p54-stuff.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54-stuff.diff"

diff -Nurp a/drivers/net/wireless/p54.h b/drivers/net/wireless/p54.h
--- a/drivers/net/wireless/p54.h	2007-09-20 21:53:22.000000000 +0200
+++ b/drivers/net/wireless/p54.h	2007-09-24 19:21:15.000000000 +0200
@@ -32,9 +32,9 @@ struct p54_control_hdr {
 	__le16 magic1;
 	__le16 len;
 	__le32 req_id;
-	__le16 type;	/* enum control_frame_types */
-	u8 retry1;
-	u8 retry2;
+	__le16 type;	/* enum control_frame_types, or AID for all kinds for data frames */
+	u8 short_retry;
+	u8 long_retry;
 	u8 data[0];
 } __attribute__ ((packed));
 
@@ -52,6 +52,11 @@ struct p54_common {
 	int (*open)(struct ieee80211_hw *dev);
 	void (*stop)(struct ieee80211_hw *dev);
 	int mode;
+	int rx_antenna;
+	int slot_time;
+	__le16 freq;
+	int dtim_wakeup;
+	int rate_mask;
 	u8 *mac_addr;
 	struct pda_iq_autocal_entry *iq_autocal;
 	unsigned int iq_autocal_len;
diff -Nurp a/drivers/net/wireless/p54common.c b/drivers/net/wireless/p54common.c
--- a/drivers/net/wireless/p54common.c	2007-09-20 21:53:22.000000000 +0200
+++ b/drivers/net/wireless/p54common.c	2007-09-24 19:43:07.000000000 +0200
@@ -294,7 +294,7 @@ void p54_fill_eeprom_readback(struct p54
 	hdr->magic1 = cpu_to_le16(0x8000);
 	hdr->len = cpu_to_le16(sizeof(*eeprom_hdr) + 0x2000);
 	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_EEPROM_READBACK);
-	hdr->retry1 = hdr->retry2 = 0;
+	hdr->short_retry = hdr->long_retry = 0;
 	eeprom_hdr = (struct p54_eeprom_lm86 *) hdr->data;
 	eeprom_hdr->offset = 0x0;
 	eeprom_hdr->len = cpu_to_le16(0x2000);
@@ -502,6 +502,11 @@ static void p54_assign_address(struct ie
 	data->req_id = cpu_to_le32(target_addr + 0x70);
 }
 
+static int inline p54_antenna_sel(int antenna)
+{
+	return (antenna == 0) ? 2 : antenna - 1;
+}
+
 static int p54_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 		  struct ieee80211_tx_control *control)
 {
@@ -538,12 +543,11 @@ static int p54_tx(struct ieee80211_hw *d
 		hdr->magic1 = cpu_to_le16(0x0010);
 	hdr->len = cpu_to_le16(len);
 	hdr->type = (control->flags & IEEE80211_TXCTL_NO_ACK) ? 0 : cpu_to_le16(1);
-	hdr->retry1 = hdr->retry2 = control->retry_limit;
+	hdr->short_retry = hdr->long_retry = control->retry_limit;
 	p54_assign_address(dev, skb, hdr, skb->len, control_copy);
 
-	memset(txhdr->wep_key, 0x0, 16);
-	txhdr->padding = 0;
-	txhdr->padding2 = 0;
+	memset(txhdr->hw_crypt_key, 0x0, 16);
+	memset(&txhdr->padding2, 0, sizeof(txhdr->padding2));
 
 	/* TODO: add support for alternate retry TX rates */
 	rate = control->tx_rate;
@@ -552,15 +556,13 @@ static int p54_tx(struct ieee80211_hw *d
 	else if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
 		rate |= 0x20;
 	memset(txhdr->rateset, rate, 8);
-	txhdr->wep_key_present = 0;
-	txhdr->wep_key_len = 0;
-	txhdr->frame_type = cpu_to_le32(control->queue + 4);
-	txhdr->magic4 = 0;
-	txhdr->antenna = (control->antenna_sel_tx == 0) ?
-		2 : control->antenna_sel_tx - 1;
+	txhdr->hw_crypt_key_type = 0;
+	txhdr->hw_crypt_key_len = 0;
+	txhdr->frame_queue = control->queue + 4;
+	txhdr->antenna = p54_antenna_sel(control->antenna_sel_tx);
 	txhdr->output_power = 0x7f; // HW Maximum
-	txhdr->magic5 = (control->flags & IEEE80211_TXCTL_NO_ACK) ?
-		0 : ((rate > 0x3) ? cpu_to_le32(0x33) : cpu_to_le32(0x23));
+	txhdr->cts_rate = (control->flags & IEEE80211_TXCTL_NO_ACK) ?
+		(0) : (control->rts_cts_rate | 0x20);
 	if (padding)
 		txhdr->align[0] = padding;
 
@@ -569,8 +571,7 @@ static int p54_tx(struct ieee80211_hw *d
 }
 
 static int p54_set_filter(struct ieee80211_hw *dev, u16 filter_type,
-			  const u8 *dst, const u8 *src, u8 antenna,
-			  u32 magic3, u32 magic8, u32 magic9)
+			  const u8 *dst, const u8 *src)
 {
 	struct p54_common *priv = dev->priv;
 	struct p54_control_hdr *hdr;
@@ -591,19 +592,29 @@ static int p54_set_filter(struct ieee802
 
 	filter->filter_type = cpu_to_le16(filter_type);
 	memcpy(filter->dst, dst, ETH_ALEN);
+
 	if (!src)
 		memset(filter->src, ~0, ETH_ALEN);
 	else
 		memcpy(filter->src, src, ETH_ALEN);
-	filter->antenna = antenna;
-	filter->magic3 = cpu_to_le32(magic3);
+
+	if (filter_type) {
+		filter->wakeup_period = cpu_to_le16(priv->dtim_wakeup);
+		filter->bss_basic_rate_mask = cpu_to_le16(priv->rate_mask);
+	}
+	filter->rx_antenna = p54_antenna_sel(priv->rx_antenna);
 	filter->rx_addr = cpu_to_le32(priv->rx_end);
 	filter->max_rx = cpu_to_le16(0x0620);	/* FIXME: for usb ver 1.. maybe */
 	filter->rxhw = priv->rxhw;
-	filter->magic8 = cpu_to_le16(magic8);
-	filter->magic9 = cpu_to_le16(magic9);
+	filter->padding = 0;
+	filter->padding2 = 0;
 
 	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*filter), 1);
+
+	/* give the device some msecs to initialize the new settings... */
+	msleep(100);
+	priv->freq = 0;
+
 	return 0;
 }
 
@@ -633,7 +644,7 @@ static int p54_set_freq(struct ieee80211
 	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + payload_len, NULL);
 
 	chan->magic1 = cpu_to_le16(0x1);
-	chan->magic2 = cpu_to_le16(0x0);
+	chan->magic2 = cpu_to_le16(0x1);
 
 	for (i = 0; i < priv->iq_autocal_len; i++) {
 		if (priv->iq_autocal[i].freq != freq)
@@ -677,6 +688,7 @@ static int p54_set_freq(struct ieee80211
 		break;
 	}
 
+	priv->freq = freq;
 	memcpy(hdr->data + payload_len - 4, &chan->val_bpsk, 4);
 
 	priv->tx(dev, hdr, sizeof(*hdr) + payload_len, 1);
@@ -768,6 +780,8 @@ static void p54_set_vdcf(struct ieee8021
 		vdcf->magic2 = 0x06;
 	}
 
+	priv->slot_time = dev->conf.flags & IEEE80211_CONF_SHORT_SLOT_TIME;
+
 	/* (see prism54/isl_oid.h for further details) */
 	vdcf->frameburst = cpu_to_le16(0);
 
@@ -780,37 +794,47 @@ static int p54_add_interface(struct ieee
 	struct p54_common *priv = dev->priv;
 	int err;
 
-	/* NOTE: using IEEE80211_IF_TYPE_MGMT to indicate no mode selected */
-	if (priv->mode != IEEE80211_IF_TYPE_MGMT)
+	/* NOTE: using P54_FILTER_NOFILTER to indicate no mode selected */
+	if (priv->mode != P54_FILTER_NOFILTER)
 		return -1;
 
 	switch (conf->type) {
 	case IEEE80211_IF_TYPE_STA:
-		priv->mode = conf->type;
+		priv->mode = P54_FILTER_STA;
+		break;
+	case IEEE80211_IF_TYPE_MNTR:
+		priv->mode = P54_FILTER_MNTR;
 		break;
 	default:
 		return -EOPNOTSUPP;
 	}
 
-	priv->mac_addr = conf->mac_addr;
+	priv->mac_addr = conf->mac_addr ? conf->mac_addr : dev->wiphy->perm_addr;
 
 	err = priv->open(dev);
 	if (err) {
-		priv->mode = IEEE80211_IF_TYPE_MGMT;
+		priv->mode = P54_FILTER_NOFILTER;
 		skb_queue_purge(&priv->tx_queue);
 		return err;
 	}
 
-	p54_set_filter(dev, 0, priv->mac_addr, NULL, 0, 1, 0, 0xF642);
-	p54_set_filter(dev, 0, priv->mac_addr, NULL, 1, 0, 0, 0xF642);
+	err = p54_set_filter(dev, P54_FILTER_NOFILTER, priv->mac_addr, NULL);
+	if (err)
+		return err;
+
 	p54_set_vdcf(dev);
 
-	switch (conf->type) {
-	case IEEE80211_IF_TYPE_STA:
-		p54_set_filter(dev, 1, priv->mac_addr, NULL, 0, 0x15F, 0x1F4, 0);
+	switch (priv->mode) {
+	case P54_FILTER_STA:
+		priv->rate_mask = 0x15f;
+		err = p54_set_filter(dev, priv->mode, priv->mac_addr, NULL);
+		break;
+	case P54_FILTER_MNTR:
+		priv->rate_mask = 0xffff;
+		err = p54_set_filter(dev, priv->mode, priv->mac_addr, NULL);
 		break;
 	}
-
+	
 	p54_set_leds(dev, 1, 0, 0);
 
 	return 0;
@@ -827,27 +851,35 @@ static void p54_remove_interface(struct 
 			kfree(range->control);
 		kfree_skb(skb);
 	}
-	priv->mode = IEEE80211_IF_TYPE_MGMT;
+
+	priv->mode = P54_FILTER_NOFILTER;
 	priv->stop(dev);
 }
 
 static int p54_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
 {
-	int ret;
+	struct p54_common *priv = dev->priv;
+	int ret = 0;
+
+	if (priv->rx_antenna != conf->antenna_sel_rx) {
+		priv->rx_antenna = conf->antenna_sel_rx;
+		p54_set_filter(dev, priv->mode, priv->mac_addr, NULL);
+	}
+	
+	if ((dev->flags & IEEE80211_CONF_SHORT_SLOT_TIME) != priv->slot_time)
+		p54_set_vdcf(dev);
 
 	ret = p54_set_freq(dev, cpu_to_le16(conf->freq));
-	p54_set_vdcf(dev);
+
 	return ret;
 }
 
 static int p54_config_interface(struct ieee80211_hw *dev, int if_id,
 				struct ieee80211_if_conf *conf)
 {
-	struct p54_common *priv = dev->priv;
+	if (conf->bssid)
+		p54_set_leds(dev, 1, !is_multicast_ether_addr(conf->bssid), 0);
 
-	p54_set_filter(dev, 0, priv->mac_addr, conf->bssid, 0, 1, 0, 0xF642);
-	p54_set_filter(dev, 0, priv->mac_addr, conf->bssid, 2, 0, 0, 0);
-	p54_set_leds(dev, 1, !is_multicast_ether_addr(conf->bssid), 0);
 	return 0;
 }
 
@@ -913,7 +945,7 @@ struct ieee80211_hw *p54_init_common(siz
 		return NULL;
 
 	priv = dev->priv;
-	priv->mode = IEEE80211_IF_TYPE_MGMT;
+	priv->mode = P54_FILTER_NOFILTER;
 	skb_queue_head_init(&priv->tx_queue);
 	memcpy(priv->channels, p54_channels, sizeof(p54_channels));
 	memcpy(priv->rates, p54_rates, sizeof(p54_rates));
@@ -933,6 +965,10 @@ struct ieee80211_hw *p54_init_common(siz
 	dev->max_rssi = 127;
 
 	priv->tx_stats.data[0].limit = 5;
+	priv->rx_antenna = 0;
+	priv->rate_mask = 1;
+	priv->freq = 0;
+
 	dev->queues = 1;
 
 	dev->extra_tx_headroom = sizeof(struct p54_control_hdr) + 4 +
diff -Nurp a/drivers/net/wireless/p54common.h b/drivers/net/wireless/p54common.h
--- a/drivers/net/wireless/p54common.h	2007-09-20 21:53:22.000000000 +0200
+++ b/drivers/net/wireless/p54common.h	2007-09-24 19:34:06.000000000 +0200
@@ -161,6 +161,20 @@ struct p54_eeprom_lm86 {
 	u8 data[0];
 } __attribute__ ((packed));
 
+struct p54_statistics {
+	__le32 rx_success;
+	__le32 rx_errors;
+	__le32 rx_aborts;
+	__le32 rx_aborts_phy;
+	__le32 rx_rts_success;
+	__le32 rx_rts_failed;
+	__le32 timestamp;
+	__le32 unknown_stat;
+	u8 noise_floor_rssi;
+	u8 padding[3];
+	u8 unknown[36];	// used for radar and Clear Channel Assessment
+} __attribute__ ((packed));
+
 struct p54_rx_hdr {
 	__le16 magic;
 	__le16 len;
@@ -169,7 +183,8 @@ struct p54_rx_hdr {
 	u8 rate;
 	u8 rssi;
 	u8 quality;
-	u16 unknown2;
+	u8 hw_crypt_key_type;
+	u8 channel_activity;	// raw RSSI
 	__le64 timestamp;
 	u8 data[0];
 } __attribute__ ((packed));
@@ -185,31 +200,41 @@ struct p54_frame_sent_hdr {
 struct p54_tx_control_allocdata {
 	u8 rateset[8];
 	u16 padding;
-	u8 wep_key_present;
-	u8 wep_key_len;
-	u8 wep_key[16];
-	__le32 frame_type;
-	u32 padding2;
-	__le16 magic4;
+	u8 hw_crypt_key_type;
+	u8 hw_crypt_key_len;
+	u8 hw_crypt_key[16];
+	u8 frame_queue;
+	u8 padding2[9];
 	u8 antenna;
 	u8 output_power;
-	__le32 magic5;
+	u8 cts_rate;
+	u8 padding3[3];
 	u8 align[0];
 } __attribute__ ((packed));
 
+enum {
+	P54_FILTER_NOFILTER = 0,
+	P54_FILTER_STA = 1,
+	P54_FILTER_ADHOC = 2,
+	P54_FILTER_AP = 4,
+	P54_FILTER_PROMISC = 8,
+	P54_FILTER_MNTR = 16,
+} P54_FILTER_TYPES;
+
 struct p54_tx_control_filter {
-	__le16 filter_type;
+	__le16 filter_type;	/* enum P54_FILTER_TYPES */
 	u8 dst[ETH_ALEN];
 	u8 src[ETH_ALEN];
-	u8 antenna;
-	u8 debug;
-	__le32 magic3;
-	u8 rates[8];	// FIXME: what's this for?
+	u8 rx_antenna;
+	u8 rx_align;
+	__le16 bss_basic_rate_mask;
+	__le16 padding;
+	u8 rts_rates[8];
 	__le32 rx_addr;
 	__le16 max_rx;
 	__le16 rxhw;
-	__le16 magic8;
-	__le16 magic9;
+	__le16 wakeup_period;
+	__le16 padding2;
 } __attribute__ ((packed));
 
 struct p54_tx_control_channel {
@@ -247,7 +272,9 @@ struct p54_tx_control_vdcf {
 	u8 magic1;
 	u8 magic2;
 	struct p54_tx_vdcf_queues queue[8];
-	u8 pad2[4];
+	u8 queue5_offset;
+	u8 queue6_offset;
+	u8 pad2[2];
 	__le16 frameburst;
 } __attribute__ ((packed));
 

--Boundary-00=_so/9GuJC6hqcvhk--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
