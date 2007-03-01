Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:61690 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965407AbXCARBa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2007 12:01:30 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH 1/5] d80211: Remove curr_rates and fix related concurrency issues
Date: Thu, 1 Mar 2007 12:00:18 -0500
Cc: linux-wireless@vger.kernel.org
References: <20070228203943.11473.95222.stgit@magic.sourmilk.net>
In-Reply-To: <20070228203943.11473.95222.stgit@magic.sourmilk.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1575554.dMhgZd1mQa";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703011200.23036.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1575554.dMhgZd1mQa
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 28 February 2007 15:39, Michael Wu wrote:
> diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
> index 577dbe3..bbdf928 100644
> --- a/net/mac80211/ieee80211.c
> +++ b/net/mac80211/ieee80211.c
> @@ -136,16 +136,16 @@ static int rate_list_match(const int *ra
>  void ieee80211_prepare_rates(struct ieee80211_local *local)
>  {
>  	int i;
> +	struct ieee80211_hw_mode *mode =3D local->oper_hw_mode;
>
Ehh, this isn't quite right and may break things on ABG devices.

=2D-

d80211: Remove curr_rates and fix related concurrency issues

=46rom: Michael Wu <flamingice@sourmilk.net>

This switches the code from curr_rates and num_curr_rates to directly using
the mode and converts portions of the code to use pointers to rates instead
of indices to refer to rates. Two new fields are introduced in struct
ieee80211_conf which may replace the channel/frequency/channel_val/phymode
fields in the future. The rate control is now cleared only when the
operating channel is changed.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 include/net/mac80211.h             |    7 ++
 net/mac80211/ieee80211.c           |  101 +++++++++++++++++---------------=
=2D---
 net/mac80211/ieee80211_i.h         |   10 +---
 net/mac80211/ieee80211_ioctl.c     |   52 +++++++++++--------
 net/mac80211/ieee80211_rate.h      |    3 -
 net/mac80211/ieee80211_scan.c      |    2 -
 net/mac80211/ieee80211_sta.c       |   64 +++++++++++++----------
 net/mac80211/ieee80211_sysfs_sta.c |    5 +-
 net/mac80211/rc80211_simple.c      |   57 +++++++++++---------
 net/mac80211/sta_info.c            |    4 +
 10 files changed, 166 insertions(+), 139 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c5257d2..394b0fd 100644
=2D-- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -209,8 +209,9 @@ struct ieee80211_tx_control {
 	u8 sw_retry_attempt;	/* number of times hw has tried to
 				 * transmit frame (not incl. hw retries) */
=20
=2D	int rateidx;		/* internal 80211.o rateidx */
=2D	int rts_rateidx;	/* internal 80211.o rateidx for RTS/CTS */
+	struct ieee80211_rate *rate;		/* internal 80211.o rate */
+	struct ieee80211_rate *rts_rate;	/* internal 80211.o rate
+						 * for RTS/CTS */
 	int alt_retry_rate; /* retry rate for the last retries, given as the
 			     * hw specific value for the rate (from
 			     * struct ieee80211_rate). To be used to limit
@@ -272,6 +273,8 @@ struct ieee80211_conf {
 	int channel_val;		/* hw specific value for the channel */
=20
 	int phymode;			/* MODE_IEEE80211A, .. */
+	struct ieee80211_channel *chan;
+	struct ieee80211_hw_mode *mode;
 	unsigned int regulatory_domain;
 	int radio_enabled;
=20
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 577dbe3..5f050fd 100644
=2D-- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -133,19 +133,19 @@ static int rate_list_match(const int *ra
 }
=20
=20
=2Dvoid ieee80211_prepare_rates(struct ieee80211_local *local)
+void ieee80211_prepare_rates(struct ieee80211_local *local,
+			     struct ieee80211_hw_mode *mode)
 {
 	int i;
=20
=2D	for (i =3D 0; i < local->num_curr_rates; i++) {
=2D		struct ieee80211_rate *rate =3D &local->curr_rates[i];
+	for (i =3D 0; i < mode->num_rates; i++) {
+		struct ieee80211_rate *rate =3D &mode->rates[i];
=20
 		rate->flags &=3D ~(IEEE80211_RATE_SUPPORTED |
 				 IEEE80211_RATE_BASIC);
=20
=2D		if (local->supp_rates[local->hw.conf.phymode]) {
=2D			if (!rate_list_match(local->supp_rates
=2D					     [local->hw.conf.phymode],
+		if (local->supp_rates[mode->mode]) {
+			if (!rate_list_match(local->supp_rates[mode->mode],
 					     rate->rate))
 				continue;
 		}
@@ -154,12 +154,11 @@ void ieee80211_prepare_rates(struct ieee
=20
 		/* Use configured basic rate set if it is available. If not,
 		 * use defaults that are sane for most cases. */
=2D		if (local->basic_rates[local->hw.conf.phymode]) {
=2D			if (rate_list_match(local->basic_rates
=2D					    [local->hw.conf.phymode],
+		if (local->basic_rates[mode->mode]) {
+			if (rate_list_match(local->basic_rates[mode->mode],
 					    rate->rate))
 				rate->flags |=3D IEEE80211_RATE_BASIC;
=2D		} else switch (local->hw.conf.phymode) {
+		} else switch (mode->mode) {
 		case MODE_IEEE80211A:
 			if (rate->rate =3D=3D 60 || rate->rate =3D=3D 120 ||
 			    rate->rate =3D=3D 240)
@@ -182,7 +181,7 @@ void ieee80211_prepare_rates(struct ieee
 		}
=20
 		/* Set ERP and MANDATORY flags based on phymode */
=2D		switch (local->hw.conf.phymode) {
+		switch (mode->mode) {
 		case MODE_IEEE80211A:
 			if (rate->rate =3D=3D 60 || rate->rate =3D=3D 120 ||
 			    rate->rate =3D=3D 240)
@@ -358,11 +357,10 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 	struct rate_control_extra extra;
=20
 	memset(&extra, 0, sizeof(extra));
+	extra.mode =3D tx->u.tx.mode;
 	extra.mgmt_data =3D tx->sdata &&
 		tx->sdata->type =3D=3D IEEE80211_IF_TYPE_MGMT;
 	extra.ethertype =3D tx->ethertype;
=2D	extra.startidx  =3D 0;
=2D	extra.endidx    =3D tx->local->num_curr_rates;
=20
 	tx->u.tx.rate =3D rate_control_get_rate(tx->local, tx->dev, tx->skb,
 					      &extra);
@@ -376,20 +374,18 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 	}
 	if (!tx->u.tx.rate)
 		return TXRX_DROP;
=2D	if (tx->local->hw.conf.phymode =3D=3D MODE_IEEE80211G &&
+	if (tx->u.tx.mode->mode =3D=3D MODE_IEEE80211G &&
 	    tx->local->cts_protect_erp_frames && tx->fragmented &&
 	    extra.nonerp) {
 		tx->u.tx.last_frag_rate =3D tx->u.tx.rate;
=2D		tx->u.tx.last_frag_rateidx =3D extra.rateidx;
 		tx->u.tx.probe_last_frag =3D extra.probe ? 1 : 0;
=20
 		tx->u.tx.rate =3D extra.nonerp;
=2D		tx->u.tx.control->rateidx =3D extra.nonerp_idx;
+		tx->u.tx.control->rate =3D extra.nonerp;
 		tx->u.tx.control->flags &=3D ~IEEE80211_TXCTL_RATE_CTRL_PROBE;
 	} else {
 		tx->u.tx.last_frag_rate =3D tx->u.tx.rate;
=2D		tx->u.tx.last_frag_rateidx =3D extra.rateidx;
=2D		tx->u.tx.control->rateidx =3D extra.rateidx;
+		tx->u.tx.control->rate =3D tx->u.tx.rate;
 	}
 	tx->u.tx.control->tx_rate =3D tx->u.tx.rate->val;
 	if ((tx->u.tx.rate->flags & IEEE80211_RATE_PREAMBLE2) &&
@@ -657,6 +653,7 @@ static u16 ieee80211_duration(struct iee
 	int rate, mrate, erp, dur, i;
 	struct ieee80211_rate *txrate =3D tx->u.tx.rate;
 	struct ieee80211_local *local =3D tx->local;
+	struct ieee80211_hw_mode *mode =3D tx->u.tx.mode;
=20
 	erp =3D txrate->flags & IEEE80211_RATE_ERP;
=20
@@ -715,8 +712,8 @@ static u16 ieee80211_duration(struct iee
 	 */
 	rate =3D -1;
 	mrate =3D 10; /* use 1 Mbps if everything fails */
=2D	for (i =3D 0; i < local->num_curr_rates; i++) {
=2D		struct ieee80211_rate *r =3D &local->curr_rates[i];
+	for (i =3D 0; i < mode->num_rates; i++) {
+		struct ieee80211_rate *r =3D &mode->rates[i];
 		if (r->rate > txrate->rate)
 			break;
=20
@@ -762,6 +759,7 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *) tx->skb->data;
 	u16 dur;
 	struct ieee80211_tx_control *control =3D tx->u.tx.control;
+	struct ieee80211_hw_mode *mode =3D tx->u.tx.mode;
=20
 	if (!is_multicast_ether_addr(hdr->addr1)) {
 		if (tx->skb->len + FCS_LEN > tx->local->rts_threshold &&
@@ -788,7 +786,7 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 	/* Use CTS protection for unicast frames sent using extended rates if
 	 * there are associated non-ERP stations and RTS/CTS is not configured
 	 * for the frame. */
=2D	if (tx->local->hw.conf.phymode =3D=3D MODE_IEEE80211G &&
+	if (mode->mode =3D=3D MODE_IEEE80211G &&
 	    (tx->u.tx.rate->flags & IEEE80211_RATE_ERP) &&
 	    tx->u.tx.unicast &&
 	    tx->local->cts_protect_erp_frames &&
@@ -812,12 +810,12 @@ ieee80211_tx_h_misc(struct ieee80211_txr
=20
 		/* Use min(data rate, max base rate) as CTS/RTS rate */
 		rate =3D tx->u.tx.rate;
=2D		while (rate > tx->local->curr_rates &&
+		while (rate > mode->rates &&
 		       !(rate->flags & IEEE80211_RATE_BASIC))
 			rate--;
=20
 		control->rts_cts_rate =3D rate->val;
=2D		control->rts_rateidx =3D (int)(rate - tx->local->curr_rates);
+		control->rts_rate =3D rate;
 	}
=20
 	if (tx->sta) {
@@ -1164,7 +1162,7 @@ static int __ieee80211_tx(struct ieee802
 				return IEEE80211_TX_FRAG_AGAIN;
 			if (i =3D=3D tx->u.tx.num_extra_frag) {
 				control->tx_rate =3D tx->u.tx.last_frag_hwrate;
=2D				control->rateidx =3D tx->u.tx.last_frag_rateidx;
+				control->rate =3D tx->u.tx.last_frag_rate;
 				if (tx->u.tx.probe_last_frag)
 					control->flags |=3D
 						IEEE80211_TXCTL_RATE_CTRL_PROBE;
@@ -1209,6 +1207,7 @@ static int ieee80211_tx(struct net_devic
 	__ieee80211_tx_prepare(&tx, skb, dev, control);
 	sta =3D tx.sta;
 	tx.u.tx.mgmt_interface =3D mgmt;
+	tx.u.tx.mode =3D local->hw.conf.mode;
=20
 	for (handler =3D local->tx_handlers; *handler !=3D NULL; handler++) {
 		res =3D (*handler)(&tx);
@@ -1281,7 +1280,7 @@ retry:
 		store->extra_frag =3D tx.u.tx.extra_frag;
 		store->num_extra_frag =3D tx.u.tx.num_extra_frag;
 		store->last_frag_hwrate =3D tx.u.tx.last_frag_hwrate;
=2D		store->last_frag_rateidx =3D tx.u.tx.last_frag_rateidx;
+		store->last_frag_rate =3D tx.u.tx.last_frag_rate;
 		store->last_frag_rate_ctrl_probe =3D tx.u.tx.probe_last_frag;
 	}
 	return 0;
@@ -1317,7 +1316,7 @@ static void ieee80211_tx_pending(unsigne
 		tx.u.tx.extra_frag =3D store->extra_frag;
 		tx.u.tx.num_extra_frag =3D store->num_extra_frag;
 		tx.u.tx.last_frag_hwrate =3D store->last_frag_hwrate;
=2D		tx.u.tx.last_frag_rateidx =3D store->last_frag_rateidx;
+		tx.u.tx.last_frag_rate =3D store->last_frag_rate;
 		tx.u.tx.probe_last_frag =3D store->last_frag_rate_ctrl_probe;
 		ret =3D __ieee80211_tx(local, store->skb, &tx);
 		if (ret) {
@@ -1778,7 +1777,7 @@ struct sk_buff * ieee80211_beacon_get(st
=20
 	if (control) {
 		memset(&extra, 0, sizeof(extra));
=2D		extra.endidx =3D local->num_curr_rates;
+		extra.mode =3D local->oper_hw_mode;
=20
 		rate =3D rate_control_get_rate(local, local->mdev, skb, &extra);
 		if (!rate) {
@@ -1815,7 +1814,7 @@ __le16 ieee80211_rts_duration(struct iee
 	int erp;
 	u16 dur;
=20
=2D	rate =3D &(local->curr_rates[frame_txctl->rts_rateidx]);
+	rate =3D frame_txctl->rts_rate;
 	erp =3D !!(rate->flags & IEEE80211_RATE_ERP);
=20
 	/* CTS duration */
@@ -1843,7 +1842,7 @@ __le16 ieee80211_ctstoself_duration(stru
 	int erp;
 	u16 dur;
=20
=2D	rate =3D &(local->curr_rates[frame_txctl->rts_rateidx]);
+	rate =3D frame_txctl->rts_rate;
 	erp =3D !!(rate->flags & IEEE80211_RATE_ERP);
=20
 	/* Data frame duration */
@@ -2027,6 +2026,8 @@ int ieee80211_hw_config(struct ieee80211
 	local->hw.conf.freq =3D chan->freq;
 	local->hw.conf.phymode =3D mode->mode;
 	local->hw.conf.antenna_max =3D chan->antenna_max;
+	local->hw.conf.chan =3D chan;
+	local->hw.conf.mode =3D mode;
=20
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "HW CONFIG: channel=3D%d freq=3D%d "
@@ -2037,12 +2038,6 @@ int ieee80211_hw_config(struct ieee80211
 	if (local->ops->config)
 		ret =3D local->ops->config(local_to_hw(local), &local->hw.conf);
=20
=2D	if (local->curr_rates !=3D mode->rates)
=2D		rate_control_clear(local);
=2D	local->curr_rates =3D mode->rates;
=2D	local->num_curr_rates =3D mode->num_rates;
=2D	ieee80211_prepare_rates(local);
=2D
 	return ret;
 }
=20
@@ -3893,6 +3888,7 @@ static ieee80211_txrx_result
 ieee80211_tx_h_load_stats(struct ieee80211_txrx_data *tx)
 {
 	struct ieee80211_local *local =3D tx->local;
+	struct ieee80211_hw_mode *mode =3D tx->u.tx.mode;
 	struct sk_buff *skb =3D tx->skb;
 	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *) skb->data;
 	u32 load =3D 0, hdrtime;
@@ -3906,10 +3902,10 @@ ieee80211_tx_h_load_stats(struct ieee802
 	/* 1 bit at 1 Mbit/s takes 1 usec; in channel_use values,
 	 * 1 usec =3D 1/8 * (1080 / 10) =3D 13.5 */
=20
=2D	if (local->hw.conf.phymode =3D=3D MODE_IEEE80211A ||
=2D	    local->hw.conf.phymode =3D=3D MODE_ATHEROS_TURBO ||
=2D	    local->hw.conf.phymode =3D=3D MODE_ATHEROS_TURBOG ||
=2D	    (local->hw.conf.phymode =3D=3D MODE_IEEE80211G &&
+	if (mode->mode =3D=3D MODE_IEEE80211A ||
+	    mode->mode =3D=3D MODE_ATHEROS_TURBO ||
+	    mode->mode =3D=3D MODE_ATHEROS_TURBOG ||
+	    (mode->mode =3D=3D MODE_IEEE80211G &&
 	     tx->u.tx.rate->flags & IEEE80211_RATE_ERP))
 		hdrtime =3D CHAN_UTIL_HDR_SHORT;
 	else
@@ -3954,17 +3950,18 @@ ieee80211_rx_h_load_stats(struct ieee802
 	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *) skb->data;
 	u32 load =3D 0, hdrtime;
 	struct ieee80211_rate *rate;
+	struct ieee80211_hw_mode *mode =3D local->hw.conf.mode;
 	int i;
=20
 	/* Estimate total channel use caused by this frame */
=20
=2D	if (unlikely(local->num_curr_rates < 0))
+	if (unlikely(mode->num_rates < 0))
 		return TXRX_CONTINUE;
=20
=2D	rate =3D &local->curr_rates[0];
=2D	for (i =3D 0; i < local->num_curr_rates; i++) {
=2D		if (local->curr_rates[i].val =3D=3D rx->u.rx.status->rate) {
=2D			rate =3D &local->curr_rates[i];
+	rate =3D &mode->rates[0];
+	for (i =3D 0; i < mode->num_rates; i++) {
+		if (mode->rates[i].val =3D=3D rx->u.rx.status->rate) {
+			rate =3D &mode->rates[i];
 			break;
 		}
 	}
@@ -3972,10 +3969,10 @@ ieee80211_rx_h_load_stats(struct ieee802
 	/* 1 bit at 1 Mbit/s takes 1 usec; in channel_use values,
 	 * 1 usec =3D 1/8 * (1080 / 10) =3D 13.5 */
=20
=2D	if (local->hw.conf.phymode =3D=3D MODE_IEEE80211A ||
=2D	    local->hw.conf.phymode =3D=3D MODE_ATHEROS_TURBO ||
=2D	    local->hw.conf.phymode =3D=3D MODE_ATHEROS_TURBOG ||
=2D	    (local->hw.conf.phymode =3D=3D MODE_IEEE80211G &&
+	if (mode->mode =3D=3D MODE_IEEE80211A ||
+	    mode->mode =3D=3D MODE_ATHEROS_TURBO ||
+	    mode->mode =3D=3D MODE_ATHEROS_TURBOG ||
+	    (mode->mode =3D=3D MODE_IEEE80211G &&
 	     rate->flags & IEEE80211_RATE_ERP))
 		hdrtime =3D CHAN_UTIL_HDR_SHORT;
 	else
@@ -4738,15 +4735,15 @@ int ieee80211_register_hwmode(struct iee
 		rate =3D &(mode->rates[i]);
 		rate->rate_inv =3D CHAN_UTIL_RATE_LCM / rate->rate;
 	}
+	ieee80211_prepare_rates(local, mode);
=20
=2D	if (!local->curr_rates) {
+	if (!local->oper_hw_mode) {
 		/* Default to this mode */
 		local->hw.conf.phymode =3D mode->mode;
 		local->oper_hw_mode =3D local->scan_hw_mode =3D mode;
 		local->oper_channel =3D local->scan_channel =3D &mode->channels[0];
=2D		local->curr_rates =3D mode->rates;
=2D		local->num_curr_rates =3D mode->num_rates;
=2D		ieee80211_prepare_rates(local);
+		local->hw.conf.mode =3D local->oper_hw_mode;
+		local->hw.conf.chan =3D local->oper_channel;
 	}
=20
 	ieee80211_init_client(local->mdev);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9df8ef0..6709965 100644
=2D-- a/net/mac80211/ieee80211_i.h
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
=2D			int last_frag_rateidx;
 			int last_frag_hwrate;
 			int mgmt_interface;
=20
@@ -171,6 +171,7 @@ struct ieee80211_tx_stored_packet {
 	struct sk_buff **extra_frag;
 	int last_frag_rateidx;
 	int last_frag_hwrate;
+	struct ieee80211_rate *last_frag_rate;
 	unsigned int last_frag_rate_ctrl_probe:1;
 };
=20
@@ -396,10 +397,6 @@ struct ieee80211_local {
 	int iff_allmultis, iff_promiscs;
 			/* number of interfaces with corresponding IFF_ flags */
=20
=2D	/* Current rate table. This is a pointer to hw->modes structure. */
=2D	struct ieee80211_rate *curr_rates;
=2D	int num_curr_rates;
=2D
 	struct rate_control_ref *rate_ctrl;
=20
 	int next_mode; /* MODE_IEEE80211*
@@ -614,7 +611,8 @@ void ieee80211_key_free(struct ieee80211
 void ieee80211_key_release(struct kobject *kobj);
 void ieee80211_rx_mgmt(struct ieee80211_local *local, struct sk_buff *skb,
 		       struct ieee80211_rx_status *status, u32 msg_type);
=2Dvoid ieee80211_prepare_rates(struct ieee80211_local *local);
+void ieee80211_prepare_rates(struct ieee80211_local *local,
+			     struct ieee80211_hw_mode *mode);
 void ieee80211_tx_set_iswep(struct ieee80211_txrx_data *tx);
 int ieee80211_if_update_wds(struct net_device *dev, u8 *remote_addr);
 void ieee80211_if_setup(struct net_device *dev);
diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index ae224c6..0ebeef3 100644
=2D-- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -269,6 +269,7 @@ static int ieee80211_ioctl_add_sta(struc
 	u32 rates;
 	int i, j;
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_hw_mode *mode;
 	int add_key_entry =3D 1;
=20
 	/* Prevent a race with changing the rate control algorithm */
@@ -306,13 +307,14 @@ static int ieee80211_ioctl_add_sta(struc
 	sta->listen_interval =3D param->u.add_sta.listen_interval;
=20
 	rates =3D 0;
+	mode =3D local->oper_hw_mode;
 	for (i =3D 0; i < sizeof(param->u.add_sta.supp_rates); i++) {
 		int rate =3D (param->u.add_sta.supp_rates[i] & 0x7f) * 5;
=2D		if (local->hw.conf.phymode =3D=3D MODE_ATHEROS_TURBO ||
=2D		    local->hw.conf.phymode =3D=3D MODE_ATHEROS_TURBOG)
+		if (mode->mode =3D=3D MODE_ATHEROS_TURBO ||
+		    mode->mode =3D=3D MODE_ATHEROS_TURBOG)
 			rate *=3D 2;
=2D		for (j =3D 0; j < local->num_curr_rates; j++) {
=2D			if (local->curr_rates[j].rate =3D=3D rate)
+		for (j =3D 0; j < mode->num_rates; j++) {
+			if (mode->rates[j].rate =3D=3D rate)
 				rates |=3D BIT(j);
 		}
=20
@@ -405,6 +407,7 @@ static int ieee80211_ioctl_get_info_sta(
 					struct prism2_hostapd_param *param)
 {
 	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hw_mode *mode;
 	struct sta_info *sta;
=20
 	if (param->sta_addr[0] =3D=3D 0xff && param->sta_addr[1] =3D=3D 0xff &&
@@ -417,7 +420,7 @@ static int ieee80211_ioctl_get_info_sta(
 		param->u.get_info_sta.tx_bytes =3D stats->tx_bytes;
 		/* go through all STAs and get STA with lowest max. rate */
 		param->u.get_info_sta.current_tx_rate =3D
=2D			local->curr_rates[sta_info_min_txrate_get(local)].rate;
+			sta_info_min_txrate_get(local);
 		return 0;
 	}
=20
@@ -434,9 +437,10 @@ static int ieee80211_ioctl_get_info_sta(
 	param->u.get_info_sta.tx_bytes =3D sta->tx_bytes;
 	param->u.get_info_sta.channel_use =3D sta->channel_use;
 	param->u.get_info_sta.flags =3D sta->flags;
=2D	if (sta->txrate >=3D 0 && sta->txrate < local->num_curr_rates)
+	mode =3D local->oper_hw_mode;
+	if (sta->txrate >=3D 0 && sta->txrate < mode->num_rates)
 		param->u.get_info_sta.current_tx_rate =3D
=2D			local->curr_rates[sta->txrate].rate;
+			mode->rates[sta->txrate].rate;
 	param->u.get_info_sta.num_ps_buf_frames =3D
 		skb_queue_len(&sta->ps_tx_buf);
 	param->u.get_info_sta.tx_retry_failed =3D sta->tx_retry_failed;
@@ -936,6 +940,7 @@ static int ieee80211_ioctl_set_rate_sets
 	u16 *pos =3D (u16 *) param->u.set_rate_sets.data;
 	int left =3D param_len - ((u8 *) pos - (u8 *) param);
 	int i, mode, num_supp, num_basic, *supp, *basic, *prev;
+	struct ieee80211_hw_mode *hw_mode;
=20
 	mode =3D param->u.set_rate_sets.mode;
 	num_supp =3D param->u.set_rate_sets.num_supported_rates;
@@ -983,12 +988,12 @@ static int ieee80211_ioctl_set_rate_sets
 	local->basic_rates[mode] =3D basic;
 	kfree(prev);
=20
=2D	if (mode =3D=3D local->hw.conf.phymode) {
=2D		/* TODO: should update STA TX rates and remove STAs if they
=2D		 * do not have any remaining supported rates after the change
=2D		 */
=2D		ieee80211_prepare_rates(local);
=2D	}
+	/* TODO: should update STA TX rates and remove STAs if they
+	 * do not have any remaining supported rates after the change
+	 */
+	list_for_each_entry(hw_mode, &local->modes_list, list)
+		if (hw_mode->mode =3D=3D mode)
+			ieee80211_prepare_rates(local, hw_mode);
=20
 	return 0;
 }
@@ -1805,6 +1810,7 @@ int ieee80211_set_channel(struct ieee802
 {
 	struct ieee80211_hw_mode *mode;
 	int c, set =3D 0;
+	int ret =3D -EINVAL;
=20
 	list_for_each_entry(mode, &local->modes_list, list) {
 		if (!(local->enabled_modes & (1 << mode->mode)))
@@ -1827,12 +1833,14 @@ int ieee80211_set_channel(struct ieee802
=20
 	if (set) {
 		if (local->sta_scanning)
=2D			return 0;
+			ret =3D 0;
 		else
=2D			return ieee80211_hw_config(local);
+			ret =3D ieee80211_hw_config(local);
+
+		rate_control_clear(local);
 	}
=20
=2D	return -EINVAL;
+	return ret;
 }
=20
 static int ieee80211_ioctl_siwfreq(struct net_device *dev,
@@ -2283,6 +2291,7 @@ ieee80211_ioctl_force_unicast_rate(struc
 				   int rate)
 {
 	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hw_mode *mode;
 	int i;
=20
 	if (sdata->type !=3D IEEE80211_IF_TYPE_AP)
@@ -2293,8 +2302,9 @@ ieee80211_ioctl_force_unicast_rate(struc
 		return 0;
 	}
=20
=2D	for (i =3D 0; i < local->num_curr_rates; i++) {
=2D		if (local->curr_rates[i].rate =3D=3D rate) {
+	mode =3D local->oper_hw_mode;
+	for (i =3D 0; i < mode->num_rates; i++) {
+		if (mode->rates[i].rate =3D=3D rate) {
 			sdata->u.ap.force_unicast_rateidx =3D i;
 			return 0;
 		}
@@ -2309,6 +2319,7 @@ ieee80211_ioctl_max_ratectrl_rate(struct
 				  int rate)
 {
 	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hw_mode *mode;
 	int i;
=20
 	if (sdata->type !=3D IEEE80211_IF_TYPE_AP)
@@ -2319,8 +2330,9 @@ ieee80211_ioctl_max_ratectrl_rate(struct
 		return 0;
 	}
=20
=2D	for (i =3D 0; i < local->num_curr_rates; i++) {
=2D		if (local->curr_rates[i].rate =3D=3D rate) {
+	mode =3D local->oper_hw_mode;
+	for (i =3D 0; i < mode->num_rates; i++) {
+		if (mode->rates[i].rate =3D=3D rate) {
 			sdata->u.ap.max_ratectrl_rateidx =3D i;
 			return 0;
 		}
diff --git a/net/mac80211/ieee80211_rate.h b/net/mac80211/ieee80211_rate.h
index 3f51594..3bb09f2 100644
=2D-- a/net/mac80211/ieee80211_rate.h
+++ b/net/mac80211/ieee80211_rate.h
@@ -26,11 +26,10 @@ struct rate_control_extra {
 	/* values from rate_control_get_rate() to the caller: */
 	struct ieee80211_rate *probe; /* probe with this rate, or NULL for no
 				       * probing */
=2D	int startidx, endidx, rateidx;
 	struct ieee80211_rate *nonerp;
=2D	int nonerp_idx;
=20
 	/* parameters from the caller to rate_control_get_rate(): */
+	struct ieee80211_hw_mode *mode;
 	int mgmt_data; /* this is data frame that is used for management
 			* (e.g., IEEE 802.1X EAPOL) */
 	u16 ethertype;
diff --git a/net/mac80211/ieee80211_scan.c b/net/mac80211/ieee80211_scan.c
index f9b42d4..07f8d9a 100644
=2D-- a/net/mac80211/ieee80211_scan.c
+++ b/net/mac80211/ieee80211_scan.c
@@ -326,7 +326,7 @@ void ieee80211_init_scan(struct ieee8021
 	local->scan.tx_control.key_idx =3D HW_KEY_IDX_INVALID;
 	local->scan.tx_control.flags |=3D IEEE80211_TXCTL_DO_NOT_ENCRYPT;
 	memset(&extra, 0, sizeof(extra));
=2D	extra.endidx =3D local->num_curr_rates;
+	extra.mode =3D local->hw.conf.mode;
 	local->scan.tx_control.tx_rate =3D
 		rate_control_get_rate(local, local->mdev,
 				      local->scan.skb, &extra)->val;
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 44646be..a264008 100644
=2D-- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -480,6 +480,7 @@ static void ieee80211_send_assoc(struct
 				 struct ieee80211_if_sta *ifsta)
 {
 	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hw_mode *mode;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos, *ies;
@@ -498,8 +499,9 @@ static void ieee80211_send_assoc(struct
 	}
 	skb_reserve(skb, local->hw.extra_tx_headroom);
=20
+	mode =3D local->oper_hw_mode;
 	capab =3D ifsta->capab;
=2D	if (local->hw.conf.phymode =3D=3D MODE_IEEE80211G) {
+	if (mode->mode =3D=3D MODE_IEEE80211G) {
 		capab |=3D WLAN_CAPABILITY_SHORT_SLOT_TIME |
 			WLAN_CAPABILITY_SHORT_PREAMBLE;
 	}
@@ -541,26 +543,26 @@ static void ieee80211_send_assoc(struct
 	*pos++ =3D ifsta->ssid_len;
 	memcpy(pos, ifsta->ssid, ifsta->ssid_len);
=20
=2D	len =3D local->num_curr_rates;
+	len =3D mode->num_rates;
 	if (len > 8)
 		len =3D 8;
 	pos =3D skb_put(skb, len + 2);
 	*pos++ =3D WLAN_EID_SUPP_RATES;
 	*pos++ =3D len;
 	for (i =3D 0; i < len; i++) {
=2D		int rate =3D local->curr_rates[i].rate;
=2D		if (local->hw.conf.phymode =3D=3D MODE_ATHEROS_TURBO)
+		int rate =3D mode->rates[i].rate;
+		if (mode->mode =3D=3D MODE_ATHEROS_TURBO)
 			rate /=3D 2;
 		*pos++ =3D (u8) (rate / 5);
 	}
=20
=2D	if (local->num_curr_rates > len) {
=2D		pos =3D skb_put(skb, local->num_curr_rates - len + 2);
+	if (mode->num_rates > len) {
+		pos =3D skb_put(skb, mode->num_rates - len + 2);
 		*pos++ =3D WLAN_EID_EXT_SUPP_RATES;
=2D		*pos++ =3D local->num_curr_rates - len;
=2D		for (i =3D len; i < local->num_curr_rates; i++) {
=2D			int rate =3D local->curr_rates[i].rate;
=2D			if (local->hw.conf.phymode =3D=3D MODE_ATHEROS_TURBO)
+		*pos++ =3D mode->num_rates - len;
+		for (i =3D len; i < mode->num_rates; i++) {
+			int rate =3D mode->rates[i].rate;
+			if (mode->mode =3D=3D MODE_ATHEROS_TURBO)
 				rate /=3D 2;
 			*pos++ =3D (u8) (rate / 5);
 		}
@@ -771,6 +773,7 @@ static void ieee80211_send_probe_req(str
 				     u8 *ssid, size_t ssid_len)
 {
 	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hw_mode *mode;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos, *supp_rates, *esupp_rates =3D NULL;
@@ -804,8 +807,9 @@ static void ieee80211_send_probe_req(str
 	supp_rates =3D skb_put(skb, 2);
 	supp_rates[0] =3D WLAN_EID_SUPP_RATES;
 	supp_rates[1] =3D 0;
=2D	for (i =3D 0; i < local->num_curr_rates; i++) {
=2D		struct ieee80211_rate *rate =3D &local->curr_rates[i];
+	mode =3D local->oper_hw_mode;
+	for (i =3D 0; i < mode->num_rates; i++) {
+		struct ieee80211_rate *rate =3D &mode->rates[i];
 		if (!(rate->flags & IEEE80211_RATE_SUPPORTED))
 			continue;
 		if (esupp_rates) {
@@ -820,7 +824,7 @@ static void ieee80211_send_probe_req(str
 			pos =3D skb_put(skb, 1);
 			supp_rates[1]++;
 		}
=2D		if (local->hw.conf.phymode =3D=3D MODE_ATHEROS_TURBO)
+		if (mode->mode =3D=3D MODE_ATHEROS_TURBO)
 			*pos =3D rate->rate / 10;
 		else
 			*pos =3D rate->rate / 5;
@@ -1096,6 +1100,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 					 int reassoc)
 {
 	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hw_mode *mode;
 	struct sta_info *sta;
 	u32 rates;
 	u16 capab_info, status_code, aid;
@@ -1197,20 +1202,21 @@ static void ieee80211_rx_mgmt_assoc_resp
 	sta->assoc_ap =3D 1;
=20
 	rates =3D 0;
+	mode =3D local->oper_hw_mode;
 	for (i =3D 0; i < elems.supp_rates_len; i++) {
 		int rate =3D (elems.supp_rates[i] & 0x7f) * 5;
=2D		if (local->hw.conf.phymode =3D=3D MODE_ATHEROS_TURBO)
+		if (mode->mode =3D=3D MODE_ATHEROS_TURBO)
 			rate *=3D 2;
=2D		for (j =3D 0; j < local->num_curr_rates; j++)
=2D			if (local->curr_rates[j].rate =3D=3D rate)
+		for (j =3D 0; j < mode->num_rates; j++)
+			if (mode->rates[j].rate =3D=3D rate)
 				rates |=3D BIT(j);
 	}
 	for (i =3D 0; i < elems.ext_supp_rates_len; i++) {
 		int rate =3D (elems.ext_supp_rates[i] & 0x7f) * 5;
=2D		if (local->hw.conf.phymode =3D=3D MODE_ATHEROS_TURBO)
+		if (mode->mode =3D=3D MODE_ATHEROS_TURBO)
 			rate *=3D 2;
=2D		for (j =3D 0; j < local->num_curr_rates; j++)
=2D			if (local->curr_rates[j].rate =3D=3D rate)
+		for (j =3D 0; j < mode->num_rates; j++)
+			if (mode->rates[j].rate =3D=3D rate)
 				rates |=3D BIT(j);
 	}
 	sta->supp_rates =3D rates;
@@ -2124,6 +2130,7 @@ static int ieee80211_sta_join_ibss(struc
 	struct ieee80211_mgmt *mgmt;
 	struct ieee80211_tx_control control;
 	struct ieee80211_rate *rate;
+	struct ieee80211_hw_mode *mode;
 	struct rate_control_extra extra;
 	u8 *pos;
 	struct ieee80211_sub_if_data *sdata;
@@ -2210,7 +2217,7 @@ static int ieee80211_sta_join_ibss(struc
=20
 		memset(&control, 0, sizeof(control));
 		memset(&extra, 0, sizeof(extra));
=2D		extra.endidx =3D local->num_curr_rates;
+		extra.mode =3D local->oper_hw_mode;
 		rate =3D rate_control_get_rate(local, dev, skb, &extra);
 		if (!rate) {
 			printk(KERN_DEBUG "%s: Failed to determine TX rate "
@@ -2246,12 +2253,13 @@ static int ieee80211_sta_join_ibss(struc
 		}
=20
 		rates =3D 0;
+		mode =3D local->oper_hw_mode;
 		for (i =3D 0; i < bss->supp_rates_len; i++) {
 			int bitrate =3D (bss->supp_rates[i] & 0x7f) * 5;
=2D			if (local->hw.conf.phymode =3D=3D MODE_ATHEROS_TURBO)
+			if (mode->mode =3D=3D MODE_ATHEROS_TURBO)
 				bitrate *=3D 2;
=2D			for (j =3D 0; j < local->num_curr_rates; j++)
=2D				if (local->curr_rates[j].rate =3D=3D bitrate)
+			for (j =3D 0; j < mode->num_rates; j++)
+				if (mode->rates[j].rate =3D=3D bitrate)
 					rates |=3D BIT(j);
 		}
 		ifsta->supp_rates_bits =3D rates;
@@ -2278,6 +2286,7 @@ static int ieee80211_sta_create_ibss(str
 	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sta_bss *bss;
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_hw_mode *mode;
 	u8 bssid[ETH_ALEN], *pos;
 	int i;
=20
@@ -2303,6 +2312,7 @@ static int ieee80211_sta_create_ibss(str
 		return -ENOMEM;
=20
 	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+	mode =3D local->oper_hw_mode;
=20
 	if (local->hw.conf.beacon_int =3D=3D 0)
 		local->hw.conf.beacon_int =3D 100;
@@ -2316,11 +2326,11 @@ static int ieee80211_sta_create_ibss(str
 		bss->capability |=3D WLAN_CAPABILITY_PRIVACY;
 	} else
 		sdata->drop_unencrypted =3D 0;
=2D	bss->supp_rates_len =3D local->num_curr_rates;
+	bss->supp_rates_len =3D mode->num_rates;
 	pos =3D bss->supp_rates;
=2D	for (i =3D 0; i < local->num_curr_rates; i++) {
=2D		int rate =3D local->curr_rates[i].rate;
=2D		if (local->hw.conf.phymode =3D=3D MODE_ATHEROS_TURBO)
+	for (i =3D 0; i < mode->num_rates; i++) {
+		int rate =3D mode->rates[i].rate;
+		if (mode->mode =3D=3D MODE_ATHEROS_TURBO)
 			rate /=3D 2;
 		*pos++ =3D (u8) (rate / 5);
 	}
diff --git a/net/mac80211/ieee80211_sysfs_sta.c b/net/mac80211/ieee80211_sy=
sfs_sta.c
index e3a6d32..ae62bcf 100644
=2D-- a/net/mac80211/ieee80211_sysfs_sta.c
+++ b/net/mac80211/ieee80211_sysfs_sta.c
@@ -40,10 +40,11 @@ static ssize_t show_sta_##name(const str
 static ssize_t show_sta_##name(const struct sta_info *sta, char *buf)	\
 {									\
 	struct ieee80211_local *local =3D wdev_priv(sta->dev->ieee80211_ptr);\
+	struct ieee80211_hw_mode *mode =3D local->oper_hw_mode;		\
 	return sprintf(buf, "%d\n",					\
 		       (sta->field >=3D 0 &&				\
=2D			sta->field < local->num_curr_rates) ?		\
=2D		       local->curr_rates[sta->field].rate : -1);	\
+			sta->field < mode->num_rates) ?			\
+		       mode->rates[sta->field].rate : -1);		\
 }
=20
 #define __STA_ATTR(name)						\
diff --git a/net/mac80211/rc80211_simple.c b/net/mac80211/rc80211_simple.c
index 16bec51..1b5c82c 100644
=2D-- a/net/mac80211/rc80211_simple.c
+++ b/net/mac80211/rc80211_simple.c
@@ -34,6 +34,7 @@ static void rate_control_rate_inc(struct
 				  struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_hw_mode *mode;
 	int i =3D sta->txrate;
 	int maxrate;
=20
@@ -43,15 +44,16 @@ static void rate_control_rate_inc(struct
 		return;
 	}
=20
+	mode =3D local->oper_hw_mode;
 	maxrate =3D sdata->bss ? sdata->bss->max_ratectrl_rateidx : -1;
=20
=2D	if (i > local->num_curr_rates)
=2D		i =3D local->num_curr_rates - 2;
+	if (i > mode->num_rates)
+		i =3D mode->num_rates - 2;
=20
=2D	while (i + 1 < local->num_curr_rates) {
+	while (i + 1 < mode->num_rates) {
 		i++;
 		if (sta->supp_rates & BIT(i) &&
=2D		    local->curr_rates[i].flags & IEEE80211_RATE_SUPPORTED &&
+		    mode->rates[i].flags & IEEE80211_RATE_SUPPORTED &&
 		    (maxrate < 0 || i <=3D maxrate)) {
 			sta->txrate =3D i;
 			break;
@@ -64,6 +66,7 @@ static void rate_control_rate_dec(struct
 				  struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_hw_mode *mode;
 	int i =3D sta->txrate;
=20
 	sdata =3D IEEE80211_DEV_TO_SUB_IF(sta->dev);
@@ -72,13 +75,14 @@ static void rate_control_rate_dec(struct
 		return;
 	}
=20
=2D	if (i > local->num_curr_rates)
=2D		i =3D local->num_curr_rates;
+	mode =3D local->oper_hw_mode;
+	if (i > mode->num_rates)
+		i =3D mode->num_rates;
=20
 	while (i > 0) {
 		i--;
 		if (sta->supp_rates & BIT(i) &&
=2D		    local->curr_rates[i].flags & IEEE80211_RATE_SUPPORTED) {
+		    mode->rates[i].flags & IEEE80211_RATE_SUPPORTED) {
 			sta->txrate =3D i;
 			break;
 		}
@@ -87,21 +91,21 @@ static void rate_control_rate_dec(struct
=20
=20
 static struct ieee80211_rate *
=2Drate_control_lowest_rate(struct ieee80211_local *local)
+rate_control_lowest_rate(struct ieee80211_local *local,
+			 struct ieee80211_hw_mode *mode)
 {
 	int i;
=20
=2D	for (i =3D 0; i < local->num_curr_rates; i++) {
=2D		struct ieee80211_rate *rate =3D &local->curr_rates[i];
+	for (i =3D 0; i < mode->num_rates; i++) {
+		struct ieee80211_rate *rate =3D &mode->rates[i];
=20
=2D		if (rate->flags & IEEE80211_RATE_SUPPORTED
=2D			)
+		if (rate->flags & IEEE80211_RATE_SUPPORTED)
 			return rate;
 	}
=20
 	printk(KERN_DEBUG "rate_control_lowest_rate - no supported rates "
 	       "found\n");
=2D	return &local->curr_rates[0];
+	return &mode->rates[0];
 }
=20
=20
@@ -182,7 +186,7 @@ static void rate_control_simple_tx_statu
 		} else if (per_failed < local->rate_ctrl_num_up) {
 			rate_control_rate_inc(local, sta);
 		}
=2D		srctrl->tx_avg_rate_sum +=3D local->curr_rates[sta->txrate].rate;
+		srctrl->tx_avg_rate_sum +=3D status->control.rate->rate;
 		srctrl->tx_avg_rate_num++;
 		srctrl->tx_num_failures =3D 0;
 		srctrl->tx_num_xmit =3D 0;
@@ -220,6 +224,7 @@ rate_control_simple_get_rate(void *priv,
 	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_hw_mode *mode =3D extra->mode;
 	struct sta_info *sta;
 	int rateidx, nonerp_idx;
 	u16 fc;
@@ -232,13 +237,13 @@ rate_control_simple_get_rate(void *priv,
 		/* Send management frames and broadcast/multicast data using
 		 * lowest rate. */
 		/* TODO: this could probably be improved.. */
=2D		return rate_control_lowest_rate(local);
+		return rate_control_lowest_rate(local, mode);
 	}
=20
 	sta =3D sta_info_get(local, hdr->addr1);
=20
 	if (!sta)
=2D		return rate_control_lowest_rate(local);
+		return rate_control_lowest_rate(local, mode);
=20
 	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1)
@@ -246,23 +251,21 @@ rate_control_simple_get_rate(void *priv,
=20
 	rateidx =3D sta->txrate;
=20
=2D	if (rateidx >=3D local->num_curr_rates)
=2D		rateidx =3D local->num_curr_rates - 1;
+	if (rateidx >=3D mode->num_rates)
+		rateidx =3D mode->num_rates - 1;
=20
 	sta->last_txrate =3D rateidx;
 	nonerp_idx =3D rateidx;
 	while (nonerp_idx > 0 &&
=2D	       ((local->curr_rates[nonerp_idx].flags & IEEE80211_RATE_ERP) ||
=2D		!(local->curr_rates[nonerp_idx].flags &
=2D		  IEEE80211_RATE_SUPPORTED) ||
+	       ((mode->rates[nonerp_idx].flags & IEEE80211_RATE_ERP) ||
+		!(mode->rates[nonerp_idx].flags & IEEE80211_RATE_SUPPORTED) ||
 		!(sta->supp_rates & BIT(nonerp_idx))))
 		nonerp_idx--;
=2D	extra->nonerp_idx =3D nonerp_idx;
=2D	extra->nonerp =3D &local->curr_rates[extra->nonerp_idx];
+	extra->nonerp =3D &mode->rates[nonerp_idx];
=20
 	sta_info_put(sta);
=20
=2D	return &local->curr_rates[rateidx];
+	return &mode->rates[rateidx];
 }
=20
=20
@@ -270,15 +273,17 @@ static void rate_control_simple_rate_ini
 					  struct ieee80211_local *local,
 					  struct sta_info *sta)
 {
+	struct ieee80211_hw_mode *mode;
 	int i;
 	sta->txrate =3D 0;
+	mode =3D local->oper_hw_mode;
 	/* TODO: what is a good starting rate for STA? About middle? Maybe not
 	 * the lowest or the highest rate.. Could consider using RSSI from
 	 * previous packets? Need to have IEEE 802.1X auth succeed immediately
 	 * after assoc.. */
=2D	for (i =3D 0; i < local->num_curr_rates; i++) {
+	for (i =3D 0; i < mode->num_rates; i++) {
 		if ((sta->supp_rates & BIT(i)) &&
=2D		    (local->curr_rates[i].flags & IEEE80211_RATE_SUPPORTED))
+		    (mode->rates[i].flags & IEEE80211_RATE_SUPPORTED))
 			sta->txrate =3D i;
 	}
 }
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 09554aa..2e258cf 100644
=2D-- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -80,10 +80,12 @@ EXPORT_SYMBOL(sta_info_get);
 int sta_info_min_txrate_get(struct ieee80211_local *local)
 {
 	struct sta_info *sta;
+	struct ieee80211_hw_mode *mode;
 	int min_txrate =3D 9999999;
 	int i;
=20
 	spin_lock_bh(&local->sta_lock);
+	mode =3D local->oper_hw_mode;
 	for (i =3D 0; i < STA_HASH_SIZE; i++) {
 		sta =3D local->sta_hash[i];
 		while (sta) {
@@ -96,7 +98,7 @@ int sta_info_min_txrate_get(struct ieee8
 	if (min_txrate =3D=3D 9999999)
 		min_txrate =3D 0;
=20
=2D	return min_txrate;
+	return mode->rates[min_txrate].rate;
 }
=20
=20

--nextPart1575554.dMhgZd1mQa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF5wamT3Oqt9AH4aERAoJpAJwP4S3F+9Wn1O8vseY4EjVivgc2UgCdFo+t
x4ZhxVAGyYoMUYnADGf/FDk=
=/Pa9
-----END PGP SIGNATURE-----

--nextPart1575554.dMhgZd1mQa--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
