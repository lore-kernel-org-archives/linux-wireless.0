Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:41587 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317AbYJPXKf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2008 19:10:35 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] p54: more definitions form lmac_longbow.h and pda.h
Date: Fri, 17 Oct 2008 01:14:45 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810170114.45742.chunkeey@web.de> (sfid-20081017_011040_346138_395D1E42)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch ports more useful features to p54
 - PDR definitions for the synth chips & regulatory domain
 - IEEE80211_TX_CTL_ASSIGN_SEQ
 - add some lost mutex_lock & mutex_unlock
 
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
John,

don't forget Larry's fix when you merge it into wireless-testing.
Thanks!
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-10-16 23:06:55.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-10-17 00:32:12.000000000 +0200
@@ -221,10 +221,10 @@ int p54_parse_firmware(struct ieee80211_
 
 	if (priv->fw_var >= 0x300) {
 		/* Firmware supports QoS, use it! */
-		priv->tx_stats[4].limit = 3;
-		priv->tx_stats[5].limit = 4;
-		priv->tx_stats[6].limit = 3;
-		priv->tx_stats[7].limit = 1;
+		priv->tx_stats[4].limit = 3;		/* AC_VO */
+		priv->tx_stats[5].limit = 4;		/* AC_VI */
+		priv->tx_stats[6].limit = 3;		/* AC_BE */
+		priv->tx_stats[7].limit = 2;		/* AC_BK */
 		dev->queues = 4;
 	}
 
@@ -436,12 +436,12 @@ static int p54_parse_eeprom(struct ieee8
 		goto err;
 	}
 
-	priv->rxhw = synth & 0x07;
+	priv->rxhw = synth & PDR_SYNTH_FRONTEND_MASK;
 	if (priv->rxhw == 4)
 		p54_init_xbow_synth(dev);
-	if (!(synth & 0x40))
+	if (!(synth & PDR_SYNTH_24_GHZ_DISABLED))
 		dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &band_2GHz;
-	if (!(synth & 0x80))
+	if (!(synth & PDR_SYNTH_5_GHZ_DISABLED))
 		dev->wiphy->bands[IEEE80211_BAND_5GHZ] = &band_5GHz;
 
 	if (!is_valid_ether_addr(dev->wiphy->perm_addr)) {
@@ -739,9 +739,9 @@ static int p54_rx_control(struct ieee802
 /* returns zero if skb can be reused */
 int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
-	u8 type = le16_to_cpu(*((__le16 *)skb->data)) >> 8;
+	u16 type = le16_to_cpu(*((__le16 *)skb->data));
 
-	if (type == 0x80)
+	if (type & P54_HDR_FLAG_CONTROL)
 		return p54_rx_control(dev, skb);
 	else
 		return p54_rx_data(dev, skb);
@@ -905,12 +905,13 @@ EXPORT_SYMBOL_GPL(p54_read_eeprom);
 static int p54_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_tx_queue_stats *current_queue;
+	struct ieee80211_tx_queue_stats *current_queue = NULL;
 	struct p54_common *priv = dev->priv;
 	struct p54_hdr *hdr;
 	struct p54_tx_data *txhdr;
 	size_t padding, len;
 	int i, j, ridx;
+	u16 hdr_flags = 0;
 	u8 rate;
 	u8 cts_rate = 0x20;
 	u8 rc_flags;
@@ -932,9 +933,7 @@ static int p54_tx(struct ieee80211_hw *d
 	hdr = (struct p54_hdr *) skb_push(skb, sizeof(*hdr));
 
 	if (padding)
-		hdr->flags = cpu_to_le16(P54_HDR_FLAG_DATA_ALIGN);
-	else
-		hdr->flags = cpu_to_le16(0);
+		hdr_flags |= P54_HDR_FLAG_DATA_ALIGN;
 	hdr->len = cpu_to_le16(len);
 	hdr->type = (info->flags & IEEE80211_TX_CTL_NO_ACK) ? 0 : cpu_to_le16(1);
 	hdr->rts_tries = info->control.rates[0].count;
@@ -1003,6 +1002,12 @@ static int p54_tx(struct ieee80211_hw *d
 			ridx++;
 		}
 	}
+
+	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
+		hdr_flags |= P54_HDR_FLAG_DATA_OUT_SEQNR;
+
+	/* TODO: enable bursting */
+	hdr->flags = cpu_to_le16(hdr_flags);
 	hdr->tries = ridx;
 	txhdr->crypt_offset = 0;
 	txhdr->rts_rate_idx = 0;
@@ -1021,6 +1026,10 @@ static int p54_tx(struct ieee80211_hw *d
 	/* modifies skb->cb and with it info, so must be last! */
 	if (unlikely(p54_assign_address(dev, skb, hdr, skb->len))) {
 		skb_pull(skb, sizeof(*hdr) + sizeof(*txhdr) + padding);
+		if (current_queue) {
+			current_queue->len--;
+			current_queue->count--;
+		}
 		return NETDEV_TX_BUSY;
 	}
 	priv->tx(dev, skb, 0);
@@ -1074,13 +1083,14 @@ static int p54_setup_mac(struct ieee8021
 	return 0;
 }
 
-static int p54_set_freq(struct ieee80211_hw *dev, __le16 freq)
+static int p54_set_freq(struct ieee80211_hw *dev, u16 frequency)
 {
 	struct p54_common *priv = dev->priv;
 	struct sk_buff *skb;
 	struct p54_scan *chan;
 	unsigned int i;
 	void *entry;
+	__le16 freq = cpu_to_le16(frequency);
 
 	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*chan) +
 			    sizeof(struct p54_hdr), P54_CONTROL_TYPE_SCAN,
@@ -1237,6 +1247,7 @@ static int p54_start(struct ieee80211_hw
 	struct p54_common *priv = dev->priv;
 	int err;
 
+	mutex_lock(&priv->conf_mutex);
 	err = priv->open(dev);
 	if (!err)
 		priv->mode = NL80211_IFTYPE_MONITOR;
@@ -1248,6 +1259,7 @@ static int p54_start(struct ieee80211_hw
 	if (!err)
 		err = p54_init_stats(dev);
 
+	mutex_unlock(&priv->conf_mutex);
 	return err;
 }
 
@@ -1256,6 +1268,7 @@ static void p54_stop(struct ieee80211_hw
 	struct p54_common *priv = dev->priv;
 	struct sk_buff *skb;
 
+	mutex_lock(&priv->conf_mutex);
 	del_timer(&priv->stats_timer);
 	p54_free_skb(dev, priv->cached_stats);
 	priv->cached_stats = NULL;
@@ -1265,6 +1278,7 @@ static void p54_stop(struct ieee80211_hw
 	priv->stop(dev);
 	priv->tsf_high32 = priv->tsf_low32 = 0;
 	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
+	mutex_unlock(&priv->conf_mutex);
 }
 
 static int p54_add_interface(struct ieee80211_hw *dev,
@@ -1272,14 +1286,18 @@ static int p54_add_interface(struct ieee
 {
 	struct p54_common *priv = dev->priv;
 
-	if (priv->mode != NL80211_IFTYPE_MONITOR)
+	mutex_lock(&priv->conf_mutex);
+	if (priv->mode != NL80211_IFTYPE_MONITOR) {
+		mutex_unlock(&priv->conf_mutex);
 		return -EOPNOTSUPP;
+	}
 
 	switch (conf->type) {
 	case NL80211_IFTYPE_STATION:
 		priv->mode = conf->type;
 		break;
 	default:
+		mutex_unlock(&priv->conf_mutex);
 		return -EOPNOTSUPP;
 	}
 
@@ -1298,6 +1316,7 @@ static int p54_add_interface(struct ieee
 
 	p54_set_leds(dev, 1, 0, 0);
 
+	mutex_unlock(&priv->conf_mutex);
 	return 0;
 }
 
@@ -1305,9 +1324,12 @@ static void p54_remove_interface(struct 
 				 struct ieee80211_if_init_conf *conf)
 {
 	struct p54_common *priv = dev->priv;
+
+	mutex_lock(&priv->conf_mutex);
+	p54_setup_mac(dev, P54_FILTER_TYPE_NONE, NULL);
 	priv->mode = NL80211_IFTYPE_MONITOR;
 	memset(priv->mac_addr, 0, ETH_ALEN);
-	p54_setup_mac(dev, P54_FILTER_TYPE_NONE, NULL);
+	mutex_unlock(&priv->conf_mutex);
 }
 
 static int p54_config(struct ieee80211_hw *dev, u32 changed)
@@ -1319,7 +1341,7 @@ static int p54_config(struct ieee80211_h
 	mutex_lock(&priv->conf_mutex);
 	priv->rx_antenna = 2; /* automatic */
 	priv->output_power = conf->power_level << 2;
-	ret = p54_set_freq(dev, cpu_to_le16(conf->channel->center_freq));
+	ret = p54_set_freq(dev, conf->channel->center_freq);
 	if (!ret)
 		ret = p54_set_edcf(dev);
 	mutex_unlock(&priv->conf_mutex);
@@ -1372,14 +1394,18 @@ static int p54_conf_tx(struct ieee80211_
 		       const struct ieee80211_tx_queue_params *params)
 {
 	struct p54_common *priv = dev->priv;
+	int ret;
 
+	mutex_lock(&priv->conf_mutex);
 	if ((params) && !(queue > 4)) {
 		P54_SET_QUEUE(priv->qos_params[queue], params->aifs,
 			params->cw_min, params->cw_max, params->txop);
 	} else
-		return -EINVAL;
-
-	return p54_set_edcf(dev);
+		ret = -EINVAL;
+	if (!ret)
+		ret = p54_set_edcf(dev);
+	mutex_unlock(&priv->conf_mutex);
+	return ret;
 }
 
 static int p54_init_xbow_synth(struct ieee80211_hw *dev)
@@ -1488,19 +1514,14 @@ struct ieee80211_hw *p54_init_common(siz
 		     IEEE80211_HW_SIGNAL_DBM |
 		     IEEE80211_HW_NOISE_DBM;
 
-	/*
-	 * XXX: when this driver gets support for any mode that
-	 *	requires beacons (AP, MESH, IBSS) then it must
-	 *	implement IEEE80211_TX_CTL_ASSIGN_SEQ.
-	 */
 	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
-	priv->tx_stats[0].limit = 1;
-	priv->tx_stats[1].limit = 1;
-	priv->tx_stats[2].limit = 1;
-	priv->tx_stats[3].limit = 1;
-	priv->tx_stats[4].limit = 5;
+	priv->tx_stats[0].limit = 1;		/* Beacon queue */
+	priv->tx_stats[1].limit = 1;		/* Probe queue for HW scan */
+	priv->tx_stats[2].limit = 3;		/* queue for MLMEs */
+	priv->tx_stats[3].limit = 3;		/* Broadcast / MC queue */
+	priv->tx_stats[4].limit = 5;		/* Data */
 	dev->queues = 1;
 	priv->noise = -94;
 	/*
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-10-15 19:24:42.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.h	2008-10-16 23:37:49.000000000 +0200
@@ -25,6 +25,22 @@ struct bootrec {
 	u32 data[10];
 } __attribute__((packed));
 
+#define PDR_SYNTH_FRONTEND_MASK		0x0007
+#define PDR_SYNTH_IQ_CAL_MASK		0x0018
+#define PDR_SYNTH_IQ_CAL_PA_DETECTOR	0x0000
+#define PDR_SYNTH_IQ_CAL_DISABLED	0x0008
+#define PDR_SYNTH_IQ_CAL_ZIF		0x0010
+#define PDR_SYNTH_FAA_SWITCH_MASK	0x0020
+#define PDR_SYNTH_FAA_SWITCH_ENABLED	0x0001
+#define PDR_SYNTH_24_GHZ_MASK		0x0040
+#define PDR_SYNTH_24_GHZ_DISABLED	0x0040
+#define PDR_SYNTH_5_GHZ_MASK		0x0080
+#define PDR_SYNTH_5_GHZ_DISABLED	0x0080
+#define PDR_SYNTH_RX_DIV_MASK		0x0100
+#define PDR_SYNTH_RX_DIV_SUPPORTED	0x0100
+#define PDR_SYNTH_TX_DIV_MASK		0x0200
+#define PDR_SYNTH_TX_DIV_SUPPORTED	0x0200
+
 struct bootrec_exp_if {
 	__le16 role;
 	__le16 if_id;
@@ -210,6 +226,19 @@ struct pda_pa_curve_data {
 #define PDR_BASEBAND_REGISTERS			0x8000
 #define PDR_PER_CHANNEL_BASEBAND_REGISTERS	0x8001
 
+/* PDR definitions for default country & country list */
+#define PDR_COUNTRY_CERT_CODE		0x80
+#define PDR_COUNTRY_CERT_CODE_REAL	0x00
+#define PDR_COUNTRY_CERT_CODE_PSEUDO	0x80
+#define PDR_COUNTRY_CERT_BAND		0x40
+#define PDR_COUNTRY_CERT_BAND_2GHZ	0x00
+#define PDR_COUNTRY_CERT_BAND_5GHZ	0x40
+#define PDR_COUNTRY_CERT_IODOOR		0x30
+#define PDR_COUNTRY_CERT_IODOOR_BOTH	0x00
+#define PDR_COUNTRY_CERT_IODOOR_INDOOR	0x20
+#define PDR_COUNTRY_CERT_IODOOR_OUTDOOR	0x30
+#define PDR_COUNTRY_CERT_INDEX		0x0F
+
 /* stored in skb->cb */
 struct memrecord {
 	u32 start_addr;
@@ -507,7 +536,7 @@ struct p54_sta_unlock {
 } __attribute__ ((packed));
 
 #define P54_TIM_CLEAR BIT(15)
-struct p54_tx_control_tim {
+struct p54_tim {
 	u8 count;
 	u8 padding[3];
 	__le16 entry[8];
