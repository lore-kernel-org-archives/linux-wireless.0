Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47257
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbXFYO3s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2007 10:29:48 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jiri Benc <jbenc@suse.cz>
Subject: [PATCH] mac80211: Export short-preamble bit to drivers
Date: Mon, 25 Jun 2007 16:28:00 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200706251628.00838.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Export the short-preamble-enabled-bit so drivers can use it.
Drivers like bcm43xx make decisions in the firmware on
the short-preamble state, so the driver needs to tell firmware
about it.
There's no functional change to mac80211 in this patch.
A patch for bcm43xx will follow once this got merged.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: mac80211/include/net/mac80211.h
===================================================================
--- mac80211.orig/include/net/mac80211.h	2007-06-25 16:18:58.000000000 +0200
+++ mac80211/include/net/mac80211.h	2007-06-25 16:19:00.000000000 +0200
@@ -283,6 +283,8 @@ struct ieee80211_conf {
 #define IEEE80211_CONF_SSID_HIDDEN	(1<<1) /* do not broadcast the ssid */
 #define IEEE80211_CONF_RADIOTAP		(1<<2) /* use radiotap if supported
 						  check this bit at RX time */
+#define IEEE80211_CONF_SHORT_PREAMBLE	(1<<3) /* use short preamble
+						* with IEEE 802.11b */
 	u32 flags;			/* configuration flags defined above */
 
 	u8 power_level;			/* transmit power limit for current
Index: mac80211/net/mac80211/ieee80211_i.h
===================================================================
--- mac80211.orig/net/mac80211/ieee80211_i.h	2007-06-25 16:18:58.000000000 +0200
+++ mac80211/net/mac80211/ieee80211_i.h	2007-06-25 16:19:00.000000000 +0200
@@ -449,7 +449,6 @@ struct ieee80211_local {
 	int fragmentation_threshold;
 	int short_retry_limit; /* dot11ShortRetryLimit */
 	int long_retry_limit; /* dot11LongRetryLimit */
-	int short_preamble; /* use short preamble with IEEE 802.11b */
 
 	struct crypto_blkcipher *wep_tx_tfm;
 	struct crypto_blkcipher *wep_rx_tfm;
Index: mac80211/net/mac80211/ieee80211.c
===================================================================
--- mac80211.orig/net/mac80211/ieee80211.c	2007-06-25 16:18:58.000000000 +0200
+++ mac80211/net/mac80211/ieee80211.c	2007-06-25 16:19:00.000000000 +0200
@@ -409,8 +409,10 @@ static int ieee80211_is_eapol(const stru
 static ieee80211_txrx_result
 ieee80211_tx_h_rate_ctrl(struct ieee80211_txrx_data *tx)
 {
+	struct ieee80211_hw *hw;
 	struct rate_control_extra extra;
 
+	hw = local_to_hw(tx->local);
 	memset(&extra, 0, sizeof(extra));
 	extra.mode = tx->u.tx.mode;
 	extra.mgmt_data = tx->sdata &&
@@ -444,7 +446,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 	}
 	tx->u.tx.control->tx_rate = tx->u.tx.rate->val;
 	if ((tx->u.tx.rate->flags & IEEE80211_RATE_PREAMBLE2) &&
-	    tx->local->short_preamble &&
+	    (hw->conf.flags & IEEE80211_CONF_SHORT_PREAMBLE) &&
 	    (!tx->sta || (tx->sta->flags & WLAN_STA_SHORT_PREAMBLE))) {
 		tx->u.tx.short_preamble = 1;
 		tx->u.tx.control->tx_rate = tx->u.tx.rate->val2;
@@ -707,8 +709,8 @@ __le16 ieee80211_generic_frame_duration(
 	int erp;
 
 	erp = ieee80211_is_erp_rate(hw->conf.phymode, rate);
-	dur = ieee80211_frame_duration(local, frame_len, rate,
-				       erp, local->short_preamble);
+	dur = ieee80211_frame_duration(local, frame_len, rate, erp,
+				       (hw->conf.flags & IEEE80211_CONF_SHORT_PREAMBLE));
 
 	return cpu_to_le16(dur);
 }
@@ -721,9 +723,12 @@ static u16 ieee80211_duration(struct iee
 	int rate, mrate, erp, dur, i;
 	struct ieee80211_rate *txrate = tx->u.tx.rate;
 	struct ieee80211_local *local = tx->local;
+	struct ieee80211_hw *hw = local_to_hw(local);
 	struct ieee80211_hw_mode *mode = tx->u.tx.mode;
+	int short_preamble;
 
 	erp = txrate->flags & IEEE80211_RATE_ERP;
+	short_preamble = (hw->conf.flags & IEEE80211_CONF_SHORT_PREAMBLE);
 
 	/*
 	 * data and mgmt (except PS Poll):
@@ -805,7 +810,7 @@ static u16 ieee80211_duration(struct iee
 	 * to closest integer */
 
 	dur = ieee80211_frame_duration(local, 10, rate, erp,
-				       local->short_preamble);
+				       short_preamble);
 
 	if (next_frag_len) {
 		/* Frame is fragmented: duration increases with time needed to
@@ -814,7 +819,7 @@ static u16 ieee80211_duration(struct iee
 		/* next fragment */
 		dur += ieee80211_frame_duration(local, next_frag_len,
 						txrate->rate, erp,
-						local->short_preamble);
+						short_preamble);
 	}
 
 	return dur;
@@ -1877,9 +1882,11 @@ struct sk_buff * ieee80211_beacon_get(st
 			return NULL;
 		}
 
-		control->tx_rate = (local->short_preamble &&
-				    (rate->flags & IEEE80211_RATE_PREAMBLE2)) ?
-			rate->val2 : rate->val;
+		if ((hw->conf.flags & IEEE80211_CONF_SHORT_PREAMBLE) &&
+		    (rate->flags & IEEE80211_RATE_PREAMBLE2))
+			control->tx_rate = rate->val2;
+		else
+			control->tx_rate = rate->val;
 		control->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
 		control->power_level = local->hw.conf.power_level;
 		control->flags |= IEEE80211_TXCTL_NO_ACK;
@@ -1898,7 +1905,7 @@ __le16 ieee80211_rts_duration(struct iee
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate;
-	int short_preamble = local->short_preamble;
+	int short_preamble = (hw->conf.flags & IEEE80211_CONF_SHORT_PREAMBLE);
 	int erp;
 	u16 dur;
 
@@ -1926,7 +1933,7 @@ __le16 ieee80211_ctstoself_duration(stru
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate;
-	int short_preamble = local->short_preamble;
+	int short_preamble = (hw->conf.flags & IEEE80211_CONF_SHORT_PREAMBLE);
 	int erp;
 	u16 dur;
 
Index: mac80211/net/mac80211/ieee80211_ioctl.c
===================================================================
--- mac80211.orig/net/mac80211/ieee80211_ioctl.c	2007-06-25 16:18:58.000000000 +0200
+++ mac80211/net/mac80211/ieee80211_ioctl.c	2007-06-25 16:26:56.000000000 +0200
@@ -2434,7 +2434,12 @@ static int ieee80211_ioctl_prism2_param(
 		break;
 
 	case PRISM2_PARAM_PREAMBLE:
-		local->short_preamble = value;
+		if (value)
+			local_to_hw(local)->conf.flags |= IEEE80211_CONF_SHORT_PREAMBLE;
+		else
+			local_to_hw(local)->conf.flags &= ~IEEE80211_CONF_SHORT_PREAMBLE;
+		if (ieee80211_hw_config(local))
+			ret = -EINVAL;
 		break;
 
 	case PRISM2_PARAM_STAT_TIME:
@@ -2664,7 +2669,7 @@ static int ieee80211_ioctl_get_prism2_pa
 		break;
 
 	case PRISM2_PARAM_PREAMBLE:
-		*param = local->short_preamble;
+		*param = !!(local_to_hw(local)->conf.flags & IEEE80211_CONF_SHORT_PREAMBLE);
 		break;
 
 	case PRISM2_PARAM_STAT_TIME:
Index: mac80211/net/mac80211/ieee80211_sta.c
===================================================================
--- mac80211.orig/net/mac80211/ieee80211_sta.c	2007-06-25 16:18:58.000000000 +0200
+++ mac80211/net/mac80211/ieee80211_sta.c	2007-06-25 16:19:00.000000000 +0200
@@ -2298,6 +2298,7 @@ static int ieee80211_sta_join_ibss(struc
 				   struct ieee80211_sta_bss *bss)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hw *hw = local_to_hw(local);
 	int res, rates, i, j;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
@@ -2397,9 +2398,11 @@ static int ieee80211_sta_join_ibss(struc
 			       "for IBSS beacon\n", dev->name);
 			break;
 		}
-		control.tx_rate = (local->short_preamble &&
-				   (rate->flags & IEEE80211_RATE_PREAMBLE2)) ?
-			rate->val2 : rate->val;
+		if ((hw->conf.flags & IEEE80211_CONF_SHORT_PREAMBLE) &&
+		    (rate->flags & IEEE80211_RATE_PREAMBLE2))
+			control.tx_rate = rate->val2;
+		else
+			control.tx_rate = rate->val;
 		control.antenna_sel_tx = local->hw.conf.antenna_sel_tx;
 		control.power_level = local->hw.conf.power_level;
 		control.flags |= IEEE80211_TXCTL_NO_ACK;


-- 
Greetings Michael.
