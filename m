Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:12378 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161318AbXBUQD2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Feb 2007 11:03:28 -0500
Received: by nf-out-0910.google.com with SMTP id o25so242959nfa
        for <linux-wireless@vger.kernel.org>; Wed, 21 Feb 2007 08:03:26 -0800 (PST)
To: Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Subject: [PATCH 1/3] d80211: Split antenna selection into TX and RX antenna
Date: Wed, 21 Feb 2007 17:02:46 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702211702.46661.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently d80211 only uses a single variable for antenna selection,
some devices (rt2x00) can configure the TX and RX antenna
seperately from eachother.
Assuming that antenna_sel is only for tx, and rx is "the other antenna"
is flawed and does hinder possible switching of RX antenna based
on RSSI results. And configuring the wrong antenna also impacts
transfer rates and link quality.

This patch will remove the usage of the IOCTL call:
PRISM2_PARAM_ANTENNA_SEL but will restore the usage of
(the already excisting) IOCTL calls PRISM2_PARAM_ANTSEL_TX and
PRISM2_PARAM_ANTSEL_RX.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/include/net/d80211.h b/include/net/d80211.h
index 551fe46..68c8c8a 100644
--- a/include/net/d80211.h
+++ b/include/net/d80211.h
@@ -196,7 +196,8 @@ struct ieee80211_tx_control {
 						* above */
 	u8 retry_limit;		/* 1 = only first attempt, 2 = one retry, .. */
 	u8 power_level;		/* per-packet transmit power level, in dBm */
-	u8 antenna_sel; 	/* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */
+	u8 antenna_sel_tx; 	/* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */
+	u8 antenna_sel_rx; 	/* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */
 	s8 key_idx;		/* -1 = do not encrypt, >= 0 keyidx from
 				 * hw->set_key() */
 	u8 icv_len;		/* length of the ICV/MIC field in octets */
@@ -285,10 +286,9 @@ struct ieee80211_conf {
         u8 antenna_max;			/* maximum antenna gain */
 	short tx_power_reduction; /* in 0.1 dBm */
 
-	int antenna_sel;		/* default antenna conf:
-					 *	0 = default/diversity,
-			  		 *	1 = Ant0,
-					 *	2 = Ant1 */
+	/* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */
+	u8 antenna_sel_tx;
+	u8 antenna_sel_rx;
 
         int antenna_def;
         int antenna_mode;
diff --git a/net/d80211/ieee80211.c b/net/d80211/ieee80211.c
index 273cba1..53c47db 100644
--- a/net/d80211/ieee80211.c
+++ b/net/d80211/ieee80211.c
@@ -1075,9 +1075,12 @@ __ieee80211_tx_prepare(struct ieee80211_txrx_data *tx,
 		control->flags |= IEEE80211_TXCTL_CLEAR_DST_MASK;
 		tx->sta->clear_dst_mask = 0;
 	}
-	control->antenna_sel = local->hw.conf.antenna_sel;
-	if (local->sta_antenna_sel != STA_ANTENNA_SEL_AUTO && tx->sta)
-		control->antenna_sel = tx->sta->antenna_sel;
+	control->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
+	control->antenna_sel_rx = local->hw.conf.antenna_sel_rx;
+	if (local->sta_antenna_sel != STA_ANTENNA_SEL_AUTO && tx->sta) {
+		control->antenna_sel_tx = tx->sta->antenna_sel_tx;
+		control->antenna_sel_rx = tx->sta->antenna_sel_rx;
+	}
 	hdrlen = ieee80211_get_hdrlen(tx->fc);
 	if (skb->len > hdrlen + sizeof(rfc1042_header) + 2) {
 		u8 *pos = &skb->data[hdrlen + sizeof(rfc1042_header)];
@@ -1788,7 +1791,8 @@ struct sk_buff * ieee80211_beacon_get(struct ieee80211_hw *hw, int if_id,
 		control->tx_rate = (local->short_preamble &&
 				    (rate->flags & IEEE80211_RATE_PREAMBLE2)) ?
 			rate->val2 : rate->val;
-		control->antenna_sel = local->hw.conf.antenna_sel;
+		control->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
+		control->antenna_sel_rx = local->hw.conf.antenna_sel_rx;
 		control->power_level = local->hw.conf.power_level;
 		control->flags |= IEEE80211_TXCTL_NO_ACK;
 		control->retry_limit = 1;
diff --git a/net/d80211/ieee80211_ioctl.c b/net/d80211/ieee80211_ioctl.c
index cad4d54..20a200a 100644
--- a/net/d80211/ieee80211_ioctl.c
+++ b/net/d80211/ieee80211_ioctl.c
@@ -2480,6 +2480,18 @@ static int ieee80211_ioctl_prism2_param(struct net_device *dev,
 			       "for low-level driver\n", dev->name, value);
 		break;
 
+	case PRISM2_PARAM_ANTSEL_TX:
+		local->hw.conf.antenna_sel_tx = value;
+		if (ieee80211_hw_config(local))
+			ret = -EINVAL;
+		break;
+
+	case PRISM2_PARAM_ANTSEL_RX:
+		local->hw.conf.antenna_sel_rx = value;
+		if (ieee80211_hw_config(local))
+			ret = -EINVAL;
+		break;
+
 	case PRISM2_PARAM_CTS_PROTECT_ERP_FRAMES:
 		local->cts_protect_erp_frames = value;
 		break;
@@ -2532,12 +2544,6 @@ static int ieee80211_ioctl_prism2_param(struct net_device *dev,
 		ret = ieee80211_ioctl_set_radio_enabled(dev, value);
 		break;
 
-	case PRISM2_PARAM_ANTENNA_SEL:
-		local->hw.conf.antenna_sel = value;
-		if (ieee80211_hw_config(local))
-			ret = -EINVAL;
-		break;
-
 	case PRISM2_PARAM_ANTENNA_MODE:
 		local->hw.conf.antenna_mode = value;
 		if (ieee80211_hw_config(local))
@@ -2712,6 +2718,14 @@ static int ieee80211_ioctl_get_prism2_param(struct net_device *dev,
 		*param = sdata->ieee802_1x;
 		break;
 
+	case PRISM2_PARAM_ANTSEL_TX:
+		*param = local->hw.conf.antenna_sel_tx;
+		break;
+
+	case PRISM2_PARAM_ANTSEL_RX:
+		*param = local->hw.conf.antenna_sel_rx;
+		break;
+
 	case PRISM2_PARAM_CTS_PROTECT_ERP_FRAMES:
 		*param = local->cts_protect_erp_frames;
 		break;
@@ -2735,10 +2749,6 @@ static int ieee80211_ioctl_get_prism2_param(struct net_device *dev,
 		*param = local->next_mode;
 		break;
 
-	case PRISM2_PARAM_ANTENNA_SEL:
-		*param = local->hw.conf.antenna_sel;
-		break;
-
 	case PRISM2_PARAM_ANTENNA_MODE:
 		*param = local->hw.conf.antenna_mode;
 		break;
diff --git a/net/d80211/ieee80211_sta.c b/net/d80211/ieee80211_sta.c
index f5dd80f..1442afb 100644
--- a/net/d80211/ieee80211_sta.c
+++ b/net/d80211/ieee80211_sta.c
@@ -2220,7 +2220,8 @@ static int ieee80211_sta_join_ibss(struct net_device *dev,
 		control.tx_rate = (local->short_preamble &&
 				   (rate->flags & IEEE80211_RATE_PREAMBLE2)) ?
 			rate->val2 : rate->val;
-		control.antenna_sel = local->hw.conf.antenna_sel;
+		control.antenna_sel_tx = local->hw.conf.antenna_sel_tx;
+		control.antenna_sel_rx = local->hw.conf.antenna_sel_rx;
 		control.power_level = local->hw.conf.power_level;
 		control.flags |= IEEE80211_TXCTL_NO_ACK;
 		control.retry_limit = 1;
diff --git a/net/d80211/ieee80211_sysfs.c b/net/d80211/ieee80211_sysfs.c
index b9d0973..4c44c73 100644
--- a/net/d80211/ieee80211_sysfs.c
+++ b/net/d80211/ieee80211_sysfs.c
@@ -153,7 +153,8 @@ static ssize_t ieee80211_local_show_##name(struct class_device *cd,	\
 IEEE80211_LOCAL_SHOW(channel, hw.conf.channel, "%d");
 IEEE80211_LOCAL_SHOW(frequency, hw.conf.freq, "%d");
 IEEE80211_LOCAL_SHOW(radar_detect, hw.conf.radar_detect, "%d");
-IEEE80211_LOCAL_SHOW(antenna_sel, hw.conf.antenna_sel, "%d");
+IEEE80211_LOCAL_SHOW(antenna_sel_tx, hw.conf.antenna_sel_tx, "%d");
+IEEE80211_LOCAL_SHOW(antenna_sel_rx, hw.conf.antenna_sel_rx, "%d");
 IEEE80211_LOCAL_SHOW(bridge_packets, bridge_packets, "%d");
 IEEE80211_LOCAL_SHOW(key_tx_rx_threshold, key_tx_rx_threshold, "%d");
 IEEE80211_LOCAL_SHOW(rts_threshold, rts_threshold, "%d");
@@ -216,7 +217,8 @@ static struct class_device_attribute ieee80211_class_dev_attrs[] = {
 	__ATTR(channel, S_IRUGO, ieee80211_local_show_channel, NULL),
 	__ATTR(frequency, S_IRUGO, ieee80211_local_show_frequency, NULL),
 	__ATTR(radar_detect, S_IRUGO, ieee80211_local_show_radar_detect, NULL),
-	__ATTR(antenna_sel, S_IRUGO, ieee80211_local_show_antenna_sel, NULL),
+	__ATTR(antenna_sel_tx, S_IRUGO, ieee80211_local_show_antenna_sel_tx, NULL),
+	__ATTR(antenna_sel_rx, S_IRUGO, ieee80211_local_show_antenna_sel_rx, NULL),
 	__ATTR(bridge_packets, S_IRUGO, ieee80211_local_show_bridge_packets, NULL),
 	__ATTR(key_tx_rx_threshold, S_IRUGO, ieee80211_local_show_key_tx_rx_threshold, NULL),
 	__ATTR(rts_threshold, S_IRUGO, ieee80211_local_show_rts_threshold, NULL),
diff --git a/net/d80211/rc80211_simple.c b/net/d80211/rc80211_simple.c
index 3634d00..91468b2 100644
--- a/net/d80211/rc80211_simple.c
+++ b/net/d80211/rc80211_simple.c
@@ -137,13 +137,14 @@ static void rate_control_simple_tx_status(void *priv, struct net_device *dev,
 	srctrl = sta->rate_ctrl_priv;
 	srctrl->tx_num_xmit++;
 	if (status->excessive_retries) {
-		sta->antenna_sel = sta->antenna_sel == 1 ? 2 : 1;
+		sta->antenna_sel_tx = sta->antenna_sel_tx == 1 ? 2 : 1;
+		sta->antenna_sel_rx = sta->antenna_sel_rx == 1 ? 2 : 1;
 		if (local->sta_antenna_sel == STA_ANTENNA_SEL_SW_CTRL_DEBUG) {
 			printk(KERN_DEBUG "%s: " MAC_FMT " TX antenna --> %d "
-			       "(@%lu)\n",
+			       "RX antenna --> %d (@%lu)\n",
 			       dev->name, MAC_ARG(hdr->addr1),
-			       sta->antenna_sel, jiffies);
-		}
+			       sta->antenna_sel_tx, sta->antenna_sel_rx, jiffies);
+ 		}
 		srctrl->tx_num_failures++;
 		sta->tx_retry_failed++;
 		sta->tx_num_consecutive_failures++;
diff --git a/net/d80211/sta_info.h b/net/d80211/sta_info.h
index ad000a2..4622902 100644
--- a/net/d80211/sta_info.h
+++ b/net/d80211/sta_info.h
@@ -89,7 +89,8 @@ struct sta_info {
         int channel_use;
         int channel_use_raw;
 
-	int antenna_sel;
+	int antenna_sel_tx;
+	int antenna_sel_rx;
 
 
 	int key_idx_compression; /* key table index for compression and TX
