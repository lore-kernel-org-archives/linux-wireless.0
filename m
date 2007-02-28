Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:42772 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751762AbXB1U6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 15:58:42 -0500
Received: from localhost (localhost.rutgers.edu [127.0.0.1])
	by annwn13.rutgers.edu (Postfix) with ESMTP id 4261F324069
	for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 15:58:40 -0500 (EST)
Received: from annwn13.rutgers.edu ([127.0.0.1])
	by localhost (annwn13.rutgers.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 25726-06 for <linux-wireless@vger.kernel.org>;
	Wed, 28 Feb 2007 15:58:40 -0500 (EST)
Received: from [192.168.1.103] (resnet-172.23.52.117.resnet.rutgers.edu [172.23.52.117])
	by annwn13.rutgers.edu (Postfix) with ESMTP id E45BB32403F
	for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 15:58:39 -0500 (EST)
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 1/5] d80211: Remove curr_rates and fix related concurrency issues
Date: Wed, 28 Feb 2007 15:39:43 -0500
To: linux-wireless@vger.kernel.org
Message-Id: <20070228203943.11473.95222.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This switches the code from curr_rates and num_curr_rates to directly using
the mode and converts portions of the code to use pointers to rates instead
of indices to refer to rates. Two new fields are introduced in struct
ieee80211_conf which may replace the channel/frequency/channel_val/phymode
fields in the future. The rate control is now cleared only when the
operating channel is changed.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 include/net/mac80211.h             |    7 ++-
 net/mac80211/ieee80211.c           |   97 +++++++++++++++++-------------------
 net/mac80211/ieee80211_i.h         |    7 +--
 net/mac80211/ieee80211_ioctl.c     |   40 ++++++++++-----
 net/mac80211/ieee80211_rate.h      |    3 -
 net/mac80211/ieee80211_scan.c      |    2 -
 net/mac80211/ieee80211_sta.c       |   64 ++++++++++++++----------
 net/mac80211/ieee80211_sysfs_sta.c |    5 +-
 net/mac80211/rc80211_simple.c      |   57 ++++++++++++---------
 net/mac80211/sta_info.c            |    4 +
 10 files changed, 156 insertions(+), 130 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c5257d2..394b0fd 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -209,8 +209,9 @@ struct ieee80211_tx_control {
 	u8 sw_retry_attempt;	/* number of times hw has tried to
 				 * transmit frame (not incl. hw retries) */
 
-	int rateidx;		/* internal 80211.o rateidx */
-	int rts_rateidx;	/* internal 80211.o rateidx for RTS/CTS */
+	struct ieee80211_rate *rate;		/* internal 80211.o rate */
+	struct ieee80211_rate *rts_rate;	/* internal 80211.o rate
+						 * for RTS/CTS */
 	int alt_retry_rate; /* retry rate for the last retries, given as the
 			     * hw specific value for the rate (from
 			     * struct ieee80211_rate). To be used to limit
@@ -272,6 +273,8 @@ struct ieee80211_conf {
 	int channel_val;		/* hw specific value for the channel */
 
 	int phymode;			/* MODE_IEEE80211A, .. */
+	struct ieee80211_channel *chan;
+	struct ieee80211_hw_mode *mode;
 	unsigned int regulatory_domain;
 	int radio_enabled;
 
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 577dbe3..bbdf928 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -136,16 +136,16 @@ static int rate_list_match(const int *ra
 void ieee80211_prepare_rates(struct ieee80211_local *local)
 {
 	int i;
+	struct ieee80211_hw_mode *mode = local->oper_hw_mode;
 
-	for (i = 0; i < local->num_curr_rates; i++) {
-		struct ieee80211_rate *rate = &local->curr_rates[i];
+	for (i = 0; i < mode->num_rates; i++) {
+		struct ieee80211_rate *rate = &mode->rates[i];
 
 		rate->flags &= ~(IEEE80211_RATE_SUPPORTED |
 				 IEEE80211_RATE_BASIC);
 
-		if (local->supp_rates[local->hw.conf.phymode]) {
-			if (!rate_list_match(local->supp_rates
-					     [local->hw.conf.phymode],
+		if (local->supp_rates[mode->mode]) {
+			if (!rate_list_match(local->supp_rates[mode->mode],
 					     rate->rate))
 				continue;
 		}
@@ -154,12 +154,11 @@ void ieee80211_prepare_rates(struct ieee
 
 		/* Use configured basic rate set if it is available. If not,
 		 * use defaults that are sane for most cases. */
-		if (local->basic_rates[local->hw.conf.phymode]) {
-			if (rate_list_match(local->basic_rates
-					    [local->hw.conf.phymode],
+		if (local->basic_rates[mode->mode]) {
+			if (rate_list_match(local->basic_rates[mode->mode],
 					    rate->rate))
 				rate->flags |= IEEE80211_RATE_BASIC;
-		} else switch (local->hw.conf.phymode) {
+		} else switch (mode->mode) {
 		case MODE_IEEE80211A:
 			if (rate->rate == 60 || rate->rate == 120 ||
 			    rate->rate == 240)
@@ -182,7 +181,7 @@ void ieee80211_prepare_rates(struct ieee
 		}
 
 		/* Set ERP and MANDATORY flags based on phymode */
-		switch (local->hw.conf.phymode) {
+		switch (mode->mode) {
 		case MODE_IEEE80211A:
 			if (rate->rate == 60 || rate->rate == 120 ||
 			    rate->rate == 240)
@@ -358,11 +357,10 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 	struct rate_control_extra extra;
 
 	memset(&extra, 0, sizeof(extra));
+	extra.mode = tx->u.tx.mode;
 	extra.mgmt_data = tx->sdata &&
 		tx->sdata->type == IEEE80211_IF_TYPE_MGMT;
 	extra.ethertype = tx->ethertype;
-	extra.startidx  = 0;
-	extra.endidx    = tx->local->num_curr_rates;
 
 	tx->u.tx.rate = rate_control_get_rate(tx->local, tx->dev, tx->skb,
 					      &extra);
@@ -376,20 +374,18 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 	}
 	if (!tx->u.tx.rate)
 		return TXRX_DROP;
-	if (tx->local->hw.conf.phymode == MODE_IEEE80211G &&
+	if (tx->u.tx.mode->mode == MODE_IEEE80211G &&
 	    tx->local->cts_protect_erp_frames && tx->fragmented &&
 	    extra.nonerp) {
 		tx->u.tx.last_frag_rate = tx->u.tx.rate;
-		tx->u.tx.last_frag_rateidx = extra.rateidx;
 		tx->u.tx.probe_last_frag = extra.probe ? 1 : 0;
 
 		tx->u.tx.rate = extra.nonerp;
-		tx->u.tx.control->rateidx = extra.nonerp_idx;
+		tx->u.tx.control->rate = extra.nonerp;
 		tx->u.tx.control->flags &= ~IEEE80211_TXCTL_RATE_CTRL_PROBE;
 	} else {
 		tx->u.tx.last_frag_rate = tx->u.tx.rate;
-		tx->u.tx.last_frag_rateidx = extra.rateidx;
-		tx->u.tx.control->rateidx = extra.rateidx;
+		tx->u.tx.control->rate = tx->u.tx.rate;
 	}
 	tx->u.tx.control->tx_rate = tx->u.tx.rate->val;
 	if ((tx->u.tx.rate->flags & IEEE80211_RATE_PREAMBLE2) &&
@@ -657,6 +653,7 @@ static u16 ieee80211_duration(struct iee
 	int rate, mrate, erp, dur, i;
 	struct ieee80211_rate *txrate = tx->u.tx.rate;
 	struct ieee80211_local *local = tx->local;
+	struct ieee80211_hw_mode *mode = tx->u.tx.mode;
 
 	erp = txrate->flags & IEEE80211_RATE_ERP;
 
@@ -715,8 +712,8 @@ static u16 ieee80211_duration(struct iee
 	 */
 	rate = -1;
 	mrate = 10; /* use 1 Mbps if everything fails */
-	for (i = 0; i < local->num_curr_rates; i++) {
-		struct ieee80211_rate *r = &local->curr_rates[i];
+	for (i = 0; i < mode->num_rates; i++) {
+		struct ieee80211_rate *r = &mode->rates[i];
 		if (r->rate > txrate->rate)
 			break;
 
@@ -762,6 +759,7 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
 	u16 dur;
 	struct ieee80211_tx_control *control = tx->u.tx.control;
+	struct ieee80211_hw_mode *mode = tx->u.tx.mode;
 
 	if (!is_multicast_ether_addr(hdr->addr1)) {
 		if (tx->skb->len + FCS_LEN > tx->local->rts_threshold &&
@@ -788,7 +786,7 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 	/* Use CTS protection for unicast frames sent using extended rates if
 	 * there are associated non-ERP stations and RTS/CTS is not configured
 	 * for the frame. */
-	if (tx->local->hw.conf.phymode == MODE_IEEE80211G &&
+	if (mode->mode == MODE_IEEE80211G &&
 	    (tx->u.tx.rate->flags & IEEE80211_RATE_ERP) &&
 	    tx->u.tx.unicast &&
 	    tx->local->cts_protect_erp_frames &&
@@ -812,12 +810,12 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 
 		/* Use min(data rate, max base rate) as CTS/RTS rate */
 		rate = tx->u.tx.rate;
-		while (rate > tx->local->curr_rates &&
+		while (rate > mode->rates &&
 		       !(rate->flags & IEEE80211_RATE_BASIC))
 			rate--;
 
 		control->rts_cts_rate = rate->val;
-		control->rts_rateidx = (int)(rate - tx->local->curr_rates);
+		control->rts_rate = rate;
 	}
 
 	if (tx->sta) {
@@ -1164,7 +1162,7 @@ static int __ieee80211_tx(struct ieee802
 				return IEEE80211_TX_FRAG_AGAIN;
 			if (i == tx->u.tx.num_extra_frag) {
 				control->tx_rate = tx->u.tx.last_frag_hwrate;
-				control->rateidx = tx->u.tx.last_frag_rateidx;
+				control->rate = tx->u.tx.last_frag_rate;
 				if (tx->u.tx.probe_last_frag)
 					control->flags |=
 						IEEE80211_TXCTL_RATE_CTRL_PROBE;
@@ -1209,6 +1207,7 @@ static int ieee80211_tx(struct net_devic
 	__ieee80211_tx_prepare(&tx, skb, dev, control);
 	sta = tx.sta;
 	tx.u.tx.mgmt_interface = mgmt;
+	tx.u.tx.mode = local->hw.conf.mode;
 
 	for (handler = local->tx_handlers; *handler != NULL; handler++) {
 		res = (*handler)(&tx);
@@ -1281,7 +1280,7 @@ retry:
 		store->extra_frag = tx.u.tx.extra_frag;
 		store->num_extra_frag = tx.u.tx.num_extra_frag;
 		store->last_frag_hwrate = tx.u.tx.last_frag_hwrate;
-		store->last_frag_rateidx = tx.u.tx.last_frag_rateidx;
+		store->last_frag_rate = tx.u.tx.last_frag_rate;
 		store->last_frag_rate_ctrl_probe = tx.u.tx.probe_last_frag;
 	}
 	return 0;
@@ -1317,7 +1316,7 @@ static void ieee80211_tx_pending(unsigne
 		tx.u.tx.extra_frag = store->extra_frag;
 		tx.u.tx.num_extra_frag = store->num_extra_frag;
 		tx.u.tx.last_frag_hwrate = store->last_frag_hwrate;
-		tx.u.tx.last_frag_rateidx = store->last_frag_rateidx;
+		tx.u.tx.last_frag_rate = store->last_frag_rate;
 		tx.u.tx.probe_last_frag = store->last_frag_rate_ctrl_probe;
 		ret = __ieee80211_tx(local, store->skb, &tx);
 		if (ret) {
@@ -1778,7 +1777,7 @@ struct sk_buff * ieee80211_beacon_get(st
 
 	if (control) {
 		memset(&extra, 0, sizeof(extra));
-		extra.endidx = local->num_curr_rates;
+		extra.mode = local->oper_hw_mode;
 
 		rate = rate_control_get_rate(local, local->mdev, skb, &extra);
 		if (!rate) {
@@ -1815,7 +1814,7 @@ __le16 ieee80211_rts_duration(struct iee
 	int erp;
 	u16 dur;
 
-	rate = &(local->curr_rates[frame_txctl->rts_rateidx]);
+	rate = frame_txctl->rts_rate;
 	erp = !!(rate->flags & IEEE80211_RATE_ERP);
 
 	/* CTS duration */
@@ -1843,7 +1842,7 @@ __le16 ieee80211_ctstoself_duration(stru
 	int erp;
 	u16 dur;
 
-	rate = &(local->curr_rates[frame_txctl->rts_rateidx]);
+	rate = frame_txctl->rts_rate;
 	erp = !!(rate->flags & IEEE80211_RATE_ERP);
 
 	/* Data frame duration */
@@ -2027,6 +2026,8 @@ int ieee80211_hw_config(struct ieee80211
 	local->hw.conf.freq = chan->freq;
 	local->hw.conf.phymode = mode->mode;
 	local->hw.conf.antenna_max = chan->antenna_max;
+	local->hw.conf.chan = chan;
+	local->hw.conf.mode = mode;
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "HW CONFIG: channel=%d freq=%d "
@@ -2037,12 +2038,6 @@ int ieee80211_hw_config(struct ieee80211
 	if (local->ops->config)
 		ret = local->ops->config(local_to_hw(local), &local->hw.conf);
 
-	if (local->curr_rates != mode->rates)
-		rate_control_clear(local);
-	local->curr_rates = mode->rates;
-	local->num_curr_rates = mode->num_rates;
-	ieee80211_prepare_rates(local);
-
 	return ret;
 }
 
@@ -3893,6 +3888,7 @@ static ieee80211_txrx_result
 ieee80211_tx_h_load_stats(struct ieee80211_txrx_data *tx)
 {
 	struct ieee80211_local *local = tx->local;
+	struct ieee80211_hw_mode *mode = tx->u.tx.mode;
 	struct sk_buff *skb = tx->skb;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	u32 load = 0, hdrtime;
@@ -3906,10 +3902,10 @@ ieee80211_tx_h_load_stats(struct ieee802
 	/* 1 bit at 1 Mbit/s takes 1 usec; in channel_use values,
 	 * 1 usec = 1/8 * (1080 / 10) = 13.5 */
 
-	if (local->hw.conf.phymode == MODE_IEEE80211A ||
-	    local->hw.conf.phymode == MODE_ATHEROS_TURBO ||
-	    local->hw.conf.phymode == MODE_ATHEROS_TURBOG ||
-	    (local->hw.conf.phymode == MODE_IEEE80211G &&
+	if (mode->mode == MODE_IEEE80211A ||
+	    mode->mode == MODE_ATHEROS_TURBO ||
+	    mode->mode == MODE_ATHEROS_TURBOG ||
+	    (mode->mode == MODE_IEEE80211G &&
 	     tx->u.tx.rate->flags & IEEE80211_RATE_ERP))
 		hdrtime = CHAN_UTIL_HDR_SHORT;
 	else
@@ -3954,17 +3950,18 @@ ieee80211_rx_h_load_stats(struct ieee802
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	u32 load = 0, hdrtime;
 	struct ieee80211_rate *rate;
+	struct ieee80211_hw_mode *mode = local->hw.conf.mode;
 	int i;
 
 	/* Estimate total channel use caused by this frame */
 
-	if (unlikely(local->num_curr_rates < 0))
+	if (unlikely(mode->num_rates < 0))
 		return TXRX_CONTINUE;
 
-	rate = &local->curr_rates[0];
-	for (i = 0; i < local->num_curr_rates; i++) {
-		if (local->curr_rates[i].val == rx->u.rx.status->rate) {
-			rate = &local->curr_rates[i];
+	rate = &mode->rates[0];
+	for (i = 0; i < mode->num_rates; i++) {
+		if (mode->rates[i].val == rx->u.rx.status->rate) {
+			rate = &mode->rates[i];
 			break;
 		}
 	}
@@ -3972,10 +3969,10 @@ ieee80211_rx_h_load_stats(struct ieee802
 	/* 1 bit at 1 Mbit/s takes 1 usec; in channel_use values,
 	 * 1 usec = 1/8 * (1080 / 10) = 13.5 */
 
-	if (local->hw.conf.phymode == MODE_IEEE80211A ||
-	    local->hw.conf.phymode == MODE_ATHEROS_TURBO ||
-	    local->hw.conf.phymode == MODE_ATHEROS_TURBOG ||
-	    (local->hw.conf.phymode == MODE_IEEE80211G &&
+	if (mode->mode == MODE_IEEE80211A ||
+	    mode->mode == MODE_ATHEROS_TURBO ||
+	    mode->mode == MODE_ATHEROS_TURBOG ||
+	    (mode->mode == MODE_IEEE80211G &&
 	     rate->flags & IEEE80211_RATE_ERP))
 		hdrtime = CHAN_UTIL_HDR_SHORT;
 	else
@@ -4739,13 +4736,13 @@ int ieee80211_register_hwmode(struct iee
 		rate->rate_inv = CHAN_UTIL_RATE_LCM / rate->rate;
 	}
 
-	if (!local->curr_rates) {
+	if (!local->oper_hw_mode) {
 		/* Default to this mode */
 		local->hw.conf.phymode = mode->mode;
 		local->oper_hw_mode = local->scan_hw_mode = mode;
 		local->oper_channel = local->scan_channel = &mode->channels[0];
-		local->curr_rates = mode->rates;
-		local->num_curr_rates = mode->num_rates;
+		local->hw.conf.mode = local->oper_hw_mode;
+		local->hw.conf.chan = local->oper_channel;
 		ieee80211_prepare_rates(local);
 	}
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9df8ef0..1eb4f49 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -123,12 +123,12 @@ struct ieee80211_txrx_data {
 			unsigned int ps_buffered:1;
 			unsigned int short_preamble:1;
 			unsigned int probe_last_frag:1;
+			struct ieee80211_hw_mode *mode;
 			struct ieee80211_rate *rate;
 			/* use this rate (if set) for last fragment; rate can
 			 * be set to lower rate for the first fragments, e.g.,
 			 * when using CTS protection with IEEE 802.11g. */
 			struct ieee80211_rate *last_frag_rate;
-			int last_frag_rateidx;
 			int last_frag_hwrate;
 			int mgmt_interface;
 
@@ -171,6 +171,7 @@ struct ieee80211_tx_stored_packet {
 	struct sk_buff **extra_frag;
 	int last_frag_rateidx;
 	int last_frag_hwrate;
+	struct ieee80211_rate *last_frag_rate;
 	unsigned int last_frag_rate_ctrl_probe:1;
 };
 
@@ -396,10 +397,6 @@ struct ieee80211_local {
 	int iff_allmultis, iff_promiscs;
 			/* number of interfaces with corresponding IFF_ flags */
 
-	/* Current rate table. This is a pointer to hw->modes structure. */
-	struct ieee80211_rate *curr_rates;
-	int num_curr_rates;
-
 	struct rate_control_ref *rate_ctrl;
 
 	int next_mode; /* MODE_IEEE80211*
diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index ae224c6..1cfc32b 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -269,6 +269,7 @@ static int ieee80211_ioctl_add_sta(struc
 	u32 rates;
 	int i, j;
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_hw_mode *mode;
 	int add_key_entry = 1;
 
 	/* Prevent a race with changing the rate control algorithm */
@@ -306,13 +307,14 @@ static int ieee80211_ioctl_add_sta(struc
 	sta->listen_interval = param->u.add_sta.listen_interval;
 
 	rates = 0;
+	mode = local->oper_hw_mode;
 	for (i = 0; i < sizeof(param->u.add_sta.supp_rates); i++) {
 		int rate = (param->u.add_sta.supp_rates[i] & 0x7f) * 5;
-		if (local->hw.conf.phymode == MODE_ATHEROS_TURBO ||
-		    local->hw.conf.phymode == MODE_ATHEROS_TURBOG)
+		if (mode->mode == MODE_ATHEROS_TURBO ||
+		    mode->mode == MODE_ATHEROS_TURBOG)
 			rate *= 2;
-		for (j = 0; j < local->num_curr_rates; j++) {
-			if (local->curr_rates[j].rate == rate)
+		for (j = 0; j < mode->num_rates; j++) {
+			if (mode->rates[j].rate == rate)
 				rates |= BIT(j);
 		}
 
@@ -405,6 +407,7 @@ static int ieee80211_ioctl_get_info_sta(
 					struct prism2_hostapd_param *param)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hw_mode *mode;
 	struct sta_info *sta;
 
 	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
@@ -417,7 +420,7 @@ static int ieee80211_ioctl_get_info_sta(
 		param->u.get_info_sta.tx_bytes = stats->tx_bytes;
 		/* go through all STAs and get STA with lowest max. rate */
 		param->u.get_info_sta.current_tx_rate =
-			local->curr_rates[sta_info_min_txrate_get(local)].rate;
+			sta_info_min_txrate_get(local);
 		return 0;
 	}
 
@@ -434,9 +437,10 @@ static int ieee80211_ioctl_get_info_sta(
 	param->u.get_info_sta.tx_bytes = sta->tx_bytes;
 	param->u.get_info_sta.channel_use = sta->channel_use;
 	param->u.get_info_sta.flags = sta->flags;
-	if (sta->txrate >= 0 && sta->txrate < local->num_curr_rates)
+	mode = local->oper_hw_mode;
+	if (sta->txrate >= 0 && sta->txrate < mode->num_rates)
 		param->u.get_info_sta.current_tx_rate =
-			local->curr_rates[sta->txrate].rate;
+			mode->rates[sta->txrate].rate;
 	param->u.get_info_sta.num_ps_buf_frames =
 		skb_queue_len(&sta->ps_tx_buf);
 	param->u.get_info_sta.tx_retry_failed = sta->tx_retry_failed;
@@ -1805,6 +1809,7 @@ int ieee80211_set_channel(struct ieee802
 {
 	struct ieee80211_hw_mode *mode;
 	int c, set = 0;
+	int ret = -EINVAL;
 
 	list_for_each_entry(mode, &local->modes_list, list) {
 		if (!(local->enabled_modes & (1 << mode->mode)))
@@ -1827,12 +1832,15 @@ int ieee80211_set_channel(struct ieee802
 
 	if (set) {
 		if (local->sta_scanning)
-			return 0;
+			ret = 0;
 		else
-			return ieee80211_hw_config(local);
+			ret = ieee80211_hw_config(local);
+
+		rate_control_clear(local);
+		ieee80211_prepare_rates(local);
 	}
 
-	return -EINVAL;
+	return ret;
 }
 
 static int ieee80211_ioctl_siwfreq(struct net_device *dev,
@@ -2283,6 +2291,7 @@ ieee80211_ioctl_force_unicast_rate(struc
 				   int rate)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hw_mode *mode;
 	int i;
 
 	if (sdata->type != IEEE80211_IF_TYPE_AP)
@@ -2293,8 +2302,9 @@ ieee80211_ioctl_force_unicast_rate(struc
 		return 0;
 	}
 
-	for (i = 0; i < local->num_curr_rates; i++) {
-		if (local->curr_rates[i].rate == rate) {
+	mode = local->oper_hw_mode;
+	for (i = 0; i < mode->num_rates; i++) {
+		if (mode->rates[i].rate == rate) {
 			sdata->u.ap.force_unicast_rateidx = i;
 			return 0;
 		}
@@ -2309,6 +2319,7 @@ ieee80211_ioctl_max_ratectrl_rate(struct
 				  int rate)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hw_mode *mode;
 	int i;
 
 	if (sdata->type != IEEE80211_IF_TYPE_AP)
@@ -2319,8 +2330,9 @@ ieee80211_ioctl_max_ratectrl_rate(struct
 		return 0;
 	}
 
-	for (i = 0; i < local->num_curr_rates; i++) {
-		if (local->curr_rates[i].rate == rate) {
+	mode = local->oper_hw_mode;
+	for (i = 0; i < mode->num_rates; i++) {
+		if (mode->rates[i].rate == rate) {
 			sdata->u.ap.max_ratectrl_rateidx = i;
 			return 0;
 		}
diff --git a/net/mac80211/ieee80211_rate.h b/net/mac80211/ieee80211_rate.h
index 3f51594..3bb09f2 100644
--- a/net/mac80211/ieee80211_rate.h
+++ b/net/mac80211/ieee80211_rate.h
@@ -26,11 +26,10 @@ struct rate_control_extra {
 	/* values from rate_control_get_rate() to the caller: */
 	struct ieee80211_rate *probe; /* probe with this rate, or NULL for no
 				       * probing */
-	int startidx, endidx, rateidx;
 	struct ieee80211_rate *nonerp;
-	int nonerp_idx;
 
 	/* parameters from the caller to rate_control_get_rate(): */
+	struct ieee80211_hw_mode *mode;
 	int mgmt_data; /* this is data frame that is used for management
 			* (e.g., IEEE 802.1X EAPOL) */
 	u16 ethertype;
diff --git a/net/mac80211/ieee80211_scan.c b/net/mac80211/ieee80211_scan.c
index f9b42d4..07f8d9a 100644
--- a/net/mac80211/ieee80211_scan.c
+++ b/net/mac80211/ieee80211_scan.c
@@ -326,7 +326,7 @@ void ieee80211_init_scan(struct ieee8021
 	local->scan.tx_control.key_idx = HW_KEY_IDX_INVALID;
 	local->scan.tx_control.flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
 	memset(&extra, 0, sizeof(extra));
-	extra.endidx = local->num_curr_rates;
+	extra.mode = local->hw.conf.mode;
 	local->scan.tx_control.tx_rate =
 		rate_control_get_rate(local, local->mdev,
 				      local->scan.skb, &extra)->val;
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 44646be..a264008 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -480,6 +480,7 @@ static void ieee80211_send_assoc(struct
 				 struct ieee80211_if_sta *ifsta)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hw_mode *mode;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos, *ies;
@@ -498,8 +499,9 @@ static void ieee80211_send_assoc(struct
 	}
 	skb_reserve(skb, local->hw.extra_tx_headroom);
 
+	mode = local->oper_hw_mode;
 	capab = ifsta->capab;
-	if (local->hw.conf.phymode == MODE_IEEE80211G) {
+	if (mode->mode == MODE_IEEE80211G) {
 		capab |= WLAN_CAPABILITY_SHORT_SLOT_TIME |
 			WLAN_CAPABILITY_SHORT_PREAMBLE;
 	}
@@ -541,26 +543,26 @@ static void ieee80211_send_assoc(struct
 	*pos++ = ifsta->ssid_len;
 	memcpy(pos, ifsta->ssid, ifsta->ssid_len);
 
-	len = local->num_curr_rates;
+	len = mode->num_rates;
 	if (len > 8)
 		len = 8;
 	pos = skb_put(skb, len + 2);
 	*pos++ = WLAN_EID_SUPP_RATES;
 	*pos++ = len;
 	for (i = 0; i < len; i++) {
-		int rate = local->curr_rates[i].rate;
-		if (local->hw.conf.phymode == MODE_ATHEROS_TURBO)
+		int rate = mode->rates[i].rate;
+		if (mode->mode == MODE_ATHEROS_TURBO)
 			rate /= 2;
 		*pos++ = (u8) (rate / 5);
 	}
 
-	if (local->num_curr_rates > len) {
-		pos = skb_put(skb, local->num_curr_rates - len + 2);
+	if (mode->num_rates > len) {
+		pos = skb_put(skb, mode->num_rates - len + 2);
 		*pos++ = WLAN_EID_EXT_SUPP_RATES;
-		*pos++ = local->num_curr_rates - len;
-		for (i = len; i < local->num_curr_rates; i++) {
-			int rate = local->curr_rates[i].rate;
-			if (local->hw.conf.phymode == MODE_ATHEROS_TURBO)
+		*pos++ = mode->num_rates - len;
+		for (i = len; i < mode->num_rates; i++) {
+			int rate = mode->rates[i].rate;
+			if (mode->mode == MODE_ATHEROS_TURBO)
 				rate /= 2;
 			*pos++ = (u8) (rate / 5);
 		}
@@ -771,6 +773,7 @@ static void ieee80211_send_probe_req(str
 				     u8 *ssid, size_t ssid_len)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hw_mode *mode;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos, *supp_rates, *esupp_rates = NULL;
@@ -804,8 +807,9 @@ static void ieee80211_send_probe_req(str
 	supp_rates = skb_put(skb, 2);
 	supp_rates[0] = WLAN_EID_SUPP_RATES;
 	supp_rates[1] = 0;
-	for (i = 0; i < local->num_curr_rates; i++) {
-		struct ieee80211_rate *rate = &local->curr_rates[i];
+	mode = local->oper_hw_mode;
+	for (i = 0; i < mode->num_rates; i++) {
+		struct ieee80211_rate *rate = &mode->rates[i];
 		if (!(rate->flags & IEEE80211_RATE_SUPPORTED))
 			continue;
 		if (esupp_rates) {
@@ -820,7 +824,7 @@ static void ieee80211_send_probe_req(str
 			pos = skb_put(skb, 1);
 			supp_rates[1]++;
 		}
-		if (local->hw.conf.phymode == MODE_ATHEROS_TURBO)
+		if (mode->mode == MODE_ATHEROS_TURBO)
 			*pos = rate->rate / 10;
 		else
 			*pos = rate->rate / 5;
@@ -1096,6 +1100,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 					 int reassoc)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hw_mode *mode;
 	struct sta_info *sta;
 	u32 rates;
 	u16 capab_info, status_code, aid;
@@ -1197,20 +1202,21 @@ static void ieee80211_rx_mgmt_assoc_resp
 	sta->assoc_ap = 1;
 
 	rates = 0;
+	mode = local->oper_hw_mode;
 	for (i = 0; i < elems.supp_rates_len; i++) {
 		int rate = (elems.supp_rates[i] & 0x7f) * 5;
-		if (local->hw.conf.phymode == MODE_ATHEROS_TURBO)
+		if (mode->mode == MODE_ATHEROS_TURBO)
 			rate *= 2;
-		for (j = 0; j < local->num_curr_rates; j++)
-			if (local->curr_rates[j].rate == rate)
+		for (j = 0; j < mode->num_rates; j++)
+			if (mode->rates[j].rate == rate)
 				rates |= BIT(j);
 	}
 	for (i = 0; i < elems.ext_supp_rates_len; i++) {
 		int rate = (elems.ext_supp_rates[i] & 0x7f) * 5;
-		if (local->hw.conf.phymode == MODE_ATHEROS_TURBO)
+		if (mode->mode == MODE_ATHEROS_TURBO)
 			rate *= 2;
-		for (j = 0; j < local->num_curr_rates; j++)
-			if (local->curr_rates[j].rate == rate)
+		for (j = 0; j < mode->num_rates; j++)
+			if (mode->rates[j].rate == rate)
 				rates |= BIT(j);
 	}
 	sta->supp_rates = rates;
@@ -2124,6 +2130,7 @@ static int ieee80211_sta_join_ibss(struc
 	struct ieee80211_mgmt *mgmt;
 	struct ieee80211_tx_control control;
 	struct ieee80211_rate *rate;
+	struct ieee80211_hw_mode *mode;
 	struct rate_control_extra extra;
 	u8 *pos;
 	struct ieee80211_sub_if_data *sdata;
@@ -2210,7 +2217,7 @@ static int ieee80211_sta_join_ibss(struc
 
 		memset(&control, 0, sizeof(control));
 		memset(&extra, 0, sizeof(extra));
-		extra.endidx = local->num_curr_rates;
+		extra.mode = local->oper_hw_mode;
 		rate = rate_control_get_rate(local, dev, skb, &extra);
 		if (!rate) {
 			printk(KERN_DEBUG "%s: Failed to determine TX rate "
@@ -2246,12 +2253,13 @@ static int ieee80211_sta_join_ibss(struc
 		}
 
 		rates = 0;
+		mode = local->oper_hw_mode;
 		for (i = 0; i < bss->supp_rates_len; i++) {
 			int bitrate = (bss->supp_rates[i] & 0x7f) * 5;
-			if (local->hw.conf.phymode == MODE_ATHEROS_TURBO)
+			if (mode->mode == MODE_ATHEROS_TURBO)
 				bitrate *= 2;
-			for (j = 0; j < local->num_curr_rates; j++)
-				if (local->curr_rates[j].rate == bitrate)
+			for (j = 0; j < mode->num_rates; j++)
+				if (mode->rates[j].rate == bitrate)
 					rates |= BIT(j);
 		}
 		ifsta->supp_rates_bits = rates;
@@ -2278,6 +2286,7 @@ static int ieee80211_sta_create_ibss(str
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sta_bss *bss;
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_hw_mode *mode;
 	u8 bssid[ETH_ALEN], *pos;
 	int i;
 
@@ -2303,6 +2312,7 @@ static int ieee80211_sta_create_ibss(str
 		return -ENOMEM;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	mode = local->oper_hw_mode;
 
 	if (local->hw.conf.beacon_int == 0)
 		local->hw.conf.beacon_int = 100;
@@ -2316,11 +2326,11 @@ static int ieee80211_sta_create_ibss(str
 		bss->capability |= WLAN_CAPABILITY_PRIVACY;
 	} else
 		sdata->drop_unencrypted = 0;
-	bss->supp_rates_len = local->num_curr_rates;
+	bss->supp_rates_len = mode->num_rates;
 	pos = bss->supp_rates;
-	for (i = 0; i < local->num_curr_rates; i++) {
-		int rate = local->curr_rates[i].rate;
-		if (local->hw.conf.phymode == MODE_ATHEROS_TURBO)
+	for (i = 0; i < mode->num_rates; i++) {
+		int rate = mode->rates[i].rate;
+		if (mode->mode == MODE_ATHEROS_TURBO)
 			rate /= 2;
 		*pos++ = (u8) (rate / 5);
 	}
diff --git a/net/mac80211/ieee80211_sysfs_sta.c b/net/mac80211/ieee80211_sysfs_sta.c
index e3a6d32..ae62bcf 100644
--- a/net/mac80211/ieee80211_sysfs_sta.c
+++ b/net/mac80211/ieee80211_sysfs_sta.c
@@ -40,10 +40,11 @@ static ssize_t show_sta_##name(const str
 static ssize_t show_sta_##name(const struct sta_info *sta, char *buf)	\
 {									\
 	struct ieee80211_local *local = wdev_priv(sta->dev->ieee80211_ptr);\
+	struct ieee80211_hw_mode *mode = local->oper_hw_mode;		\
 	return sprintf(buf, "%d\n",					\
 		       (sta->field >= 0 &&				\
-			sta->field < local->num_curr_rates) ?		\
-		       local->curr_rates[sta->field].rate : -1);	\
+			sta->field < mode->num_rates) ?			\
+		       mode->rates[sta->field].rate : -1);		\
 }
 
 #define __STA_ATTR(name)						\
diff --git a/net/mac80211/rc80211_simple.c b/net/mac80211/rc80211_simple.c
index 16bec51..1b5c82c 100644
--- a/net/mac80211/rc80211_simple.c
+++ b/net/mac80211/rc80211_simple.c
@@ -34,6 +34,7 @@ static void rate_control_rate_inc(struct
 				  struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_hw_mode *mode;
 	int i = sta->txrate;
 	int maxrate;
 
@@ -43,15 +44,16 @@ static void rate_control_rate_inc(struct
 		return;
 	}
 
+	mode = local->oper_hw_mode;
 	maxrate = sdata->bss ? sdata->bss->max_ratectrl_rateidx : -1;
 
-	if (i > local->num_curr_rates)
-		i = local->num_curr_rates - 2;
+	if (i > mode->num_rates)
+		i = mode->num_rates - 2;
 
-	while (i + 1 < local->num_curr_rates) {
+	while (i + 1 < mode->num_rates) {
 		i++;
 		if (sta->supp_rates & BIT(i) &&
-		    local->curr_rates[i].flags & IEEE80211_RATE_SUPPORTED &&
+		    mode->rates[i].flags & IEEE80211_RATE_SUPPORTED &&
 		    (maxrate < 0 || i <= maxrate)) {
 			sta->txrate = i;
 			break;
@@ -64,6 +66,7 @@ static void rate_control_rate_dec(struct
 				  struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_hw_mode *mode;
 	int i = sta->txrate;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
@@ -72,13 +75,14 @@ static void rate_control_rate_dec(struct
 		return;
 	}
 
-	if (i > local->num_curr_rates)
-		i = local->num_curr_rates;
+	mode = local->oper_hw_mode;
+	if (i > mode->num_rates)
+		i = mode->num_rates;
 
 	while (i > 0) {
 		i--;
 		if (sta->supp_rates & BIT(i) &&
-		    local->curr_rates[i].flags & IEEE80211_RATE_SUPPORTED) {
+		    mode->rates[i].flags & IEEE80211_RATE_SUPPORTED) {
 			sta->txrate = i;
 			break;
 		}
@@ -87,21 +91,21 @@ static void rate_control_rate_dec(struct
 
 
 static struct ieee80211_rate *
-rate_control_lowest_rate(struct ieee80211_local *local)
+rate_control_lowest_rate(struct ieee80211_local *local,
+			 struct ieee80211_hw_mode *mode)
 {
 	int i;
 
-	for (i = 0; i < local->num_curr_rates; i++) {
-		struct ieee80211_rate *rate = &local->curr_rates[i];
+	for (i = 0; i < mode->num_rates; i++) {
+		struct ieee80211_rate *rate = &mode->rates[i];
 
-		if (rate->flags & IEEE80211_RATE_SUPPORTED
-			)
+		if (rate->flags & IEEE80211_RATE_SUPPORTED)
 			return rate;
 	}
 
 	printk(KERN_DEBUG "rate_control_lowest_rate - no supported rates "
 	       "found\n");
-	return &local->curr_rates[0];
+	return &mode->rates[0];
 }
 
 
@@ -182,7 +186,7 @@ static void rate_control_simple_tx_statu
 		} else if (per_failed < local->rate_ctrl_num_up) {
 			rate_control_rate_inc(local, sta);
 		}
-		srctrl->tx_avg_rate_sum += local->curr_rates[sta->txrate].rate;
+		srctrl->tx_avg_rate_sum += status->control.rate->rate;
 		srctrl->tx_avg_rate_num++;
 		srctrl->tx_num_failures = 0;
 		srctrl->tx_num_xmit = 0;
@@ -220,6 +224,7 @@ rate_control_simple_get_rate(void *priv,
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_hw_mode *mode = extra->mode;
 	struct sta_info *sta;
 	int rateidx, nonerp_idx;
 	u16 fc;
@@ -232,13 +237,13 @@ rate_control_simple_get_rate(void *priv,
 		/* Send management frames and broadcast/multicast data using
 		 * lowest rate. */
 		/* TODO: this could probably be improved.. */
-		return rate_control_lowest_rate(local);
+		return rate_control_lowest_rate(local, mode);
 	}
 
 	sta = sta_info_get(local, hdr->addr1);
 
 	if (!sta)
-		return rate_control_lowest_rate(local);
+		return rate_control_lowest_rate(local, mode);
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1)
@@ -246,23 +251,21 @@ rate_control_simple_get_rate(void *priv,
 
 	rateidx = sta->txrate;
 
-	if (rateidx >= local->num_curr_rates)
-		rateidx = local->num_curr_rates - 1;
+	if (rateidx >= mode->num_rates)
+		rateidx = mode->num_rates - 1;
 
 	sta->last_txrate = rateidx;
 	nonerp_idx = rateidx;
 	while (nonerp_idx > 0 &&
-	       ((local->curr_rates[nonerp_idx].flags & IEEE80211_RATE_ERP) ||
-		!(local->curr_rates[nonerp_idx].flags &
-		  IEEE80211_RATE_SUPPORTED) ||
+	       ((mode->rates[nonerp_idx].flags & IEEE80211_RATE_ERP) ||
+		!(mode->rates[nonerp_idx].flags & IEEE80211_RATE_SUPPORTED) ||
 		!(sta->supp_rates & BIT(nonerp_idx))))
 		nonerp_idx--;
-	extra->nonerp_idx = nonerp_idx;
-	extra->nonerp = &local->curr_rates[extra->nonerp_idx];
+	extra->nonerp = &mode->rates[nonerp_idx];
 
 	sta_info_put(sta);
 
-	return &local->curr_rates[rateidx];
+	return &mode->rates[rateidx];
 }
 
 
@@ -270,15 +273,17 @@ static void rate_control_simple_rate_ini
 					  struct ieee80211_local *local,
 					  struct sta_info *sta)
 {
+	struct ieee80211_hw_mode *mode;
 	int i;
 	sta->txrate = 0;
+	mode = local->oper_hw_mode;
 	/* TODO: what is a good starting rate for STA? About middle? Maybe not
 	 * the lowest or the highest rate.. Could consider using RSSI from
 	 * previous packets? Need to have IEEE 802.1X auth succeed immediately
 	 * after assoc.. */
-	for (i = 0; i < local->num_curr_rates; i++) {
+	for (i = 0; i < mode->num_rates; i++) {
 		if ((sta->supp_rates & BIT(i)) &&
-		    (local->curr_rates[i].flags & IEEE80211_RATE_SUPPORTED))
+		    (mode->rates[i].flags & IEEE80211_RATE_SUPPORTED))
 			sta->txrate = i;
 	}
 }
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 09554aa..2e258cf 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -80,10 +80,12 @@ EXPORT_SYMBOL(sta_info_get);
 int sta_info_min_txrate_get(struct ieee80211_local *local)
 {
 	struct sta_info *sta;
+	struct ieee80211_hw_mode *mode;
 	int min_txrate = 9999999;
 	int i;
 
 	spin_lock_bh(&local->sta_lock);
+	mode = local->oper_hw_mode;
 	for (i = 0; i < STA_HASH_SIZE; i++) {
 		sta = local->sta_hash[i];
 		while (sta) {
@@ -96,7 +98,7 @@ int sta_info_min_txrate_get(struct ieee8
 	if (min_txrate == 9999999)
 		min_txrate = 0;
 
-	return min_txrate;
+	return mode->rates[min_txrate].rate;
 }
 
 

