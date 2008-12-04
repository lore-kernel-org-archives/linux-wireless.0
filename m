Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38382 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbYLDIss (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 03:48:48 -0500
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <rogge@fgan.de>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Henning Rogge <hrogge@googlemail.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
In-Reply-To: <200812031131.34936.rogge@fgan.de> (sfid-20081203_113144_858816_75A3A646)
References: <200811252131.30161.hrogge@googlemail.com>
	 <200812022146.12363.hrogge@googlemail.com> <20081203014430.GH9351@tesla>
	 <200812031131.34936.rogge@fgan.de> (sfid-20081203_113144_858816_75A3A646)
Content-Type: text/plain
Date: Thu, 04 Dec 2008 09:47:52 +0100
Message-Id: <1228380472.3197.5.camel@Friederike-PC.hoffi> (sfid-20081204_094852_279343_606FB589)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-12-03 at 11:31 +0100, Henning Rogge wrote:

> What do you think about the idea to export the 802.11n transmission rate 
> through the old WExt interface, so iwconfig will show the correct rate too ? 
> But for this the "mcs to bitrate" tables would have to be moved to some other 
> file, so wext.c can access them too (which one ?).

No, that can't possibly work right, sorry.

> + * @NL80211_STA_INFO_SIGNAL: signal strength of last received package (u8, 
> dBm)

s8? should be signed, no?

> + * @NL80211_STA_INFO_RX_BITRATE: bitrate of last received unicast packet
> + *  (u16, 100 kbit/s)

I don't really like this. I know we cannot report the real information
yet because we don't even have the driver/mac80211 api but let's add rx
rate reporting when we have the HT information too.

> + * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate (u16, 100 kbit/s)
> + * @NL80211_STA_INFO_TX_BITRATE_40_MHZ: dual channel transmission (flag)
> + * @NL80211_STA_INFO_TX_BITRATE_MCS: 802.11n MCS index of tx rate (u8)
> + * @NL80211_STA_INFO_TX_BITRATE_SHORT_GI: 802.11n with 400ns GI, 800ns
> + *  otherwise, should be ignored if TX_BITRATE_MCS is not set (flag)

I'm not sure I like the bitrate being used as prefix and final name, can
we have maybe TXRATE_ as prefix and use TXRATE_RATE, TXRATE_40, ...?

> +/* bitrate of 802.11n ht20 connections with 800ns guard interval in 100kbit/s 
> */
> +const u16 ieee80211n_ht20_gi800[] = {
> +    65, 130, 195, 260, 390, 520, 585, 650,
> +    130, 260, 390, 520, 780, 1040, 1170, 1300,
> +    195, 390, 585, 780, 1170, 1560, 1755, 1950,
> +    260, 520, 780, 1040, 1560, 2080, 2340, 2600
> +};
> +
> +/* bitrate of 802.11n ht20 connections with 400ns guard interval
> + * in 100kbit/s per spatial stream */
> +const u16 ieee80211n_ht20_gi400[] = {
> +    72, 144, 217, 289, 433, 578, 650, 722,
> +    144, 289, 433, 578, 867, 1156, 1300, 1440,
> +    217, 433, 650, 867, 1300, 1733, 1950, 2167,
> +    289, 578, 867, 1157, 1733, 2311, 2600, 2889
> +};
> +
> +/* bitrate of 802.11n ht40 connections with 800ns guard interval
> + * in 100kbit/s per spatial stream */
> +const u16 ieee80211n_ht40_gi800[] = {
> +    135, 270, 405, 540, 810, 1080, 1215, 1350,
> +    270, 540, 810, 1080, 1620, 2160, 2430, 2700,
> +    405, 810, 1215, 1620, 2430, 3240, 3645, 4050,
> +    540, 1080, 1620, 2160, 3240, 4320, 4860, 5400
> +};
> +
> +/* bitrate of 802.11n ht40 connections with 400ns guard interval
> + * in 100kbit/s per spatial stream */
> +const u16 ieee80211n_ht40_gi400[] = {
> +    150, 300, 450, 600, 900, 1200, 1350, 1500,
> +    300, 600, 900, 1200, 1800, 2400, 2700, 3000,
> +    450, 900, 1350, 1800, 2700, 3600, 4050, 4500,
> +    600, 1200, 1800, 2400, 3600, 4800, 5400, 6000
> +};

I definitely don't like this, ick, please put that into userspace.

> +	if (sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) {
> +		sinfo->filled |= STATION_INFO_SIGNAL;
> +		sinfo->signal = sta->last_signal;
> +	}

Good plan to report only when dBm are available, I like that.

> +	sinfo->rx_bitrate = sta->last_rxrate_unicast;
> +
> +	sinfo->tx_bitrate_flags = sta->last_tx_rate.flags &
> +	    (IEEE80211_TX_RC_MCS |
> +	     IEEE80211_TX_RC_40_MHZ_WIDTH |
> +	     IEEE80211_TX_RC_SHORT_GI);

That looks very odd. Are you sure it's using the same rate flags? And if
it is, that's wrong, because cfg80211 must not rely on mac80211 flags.

> +	if (!(sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)) {
> +		struct ieee80211_supported_band *sband;
> +		sband = sta->local->hw.wiphy->bands[sta->local->hw.conf.channel->band];
> +		sinfo->tx_bitrate = sband->bitrates[sta->last_tx_rate.idx].bitrate;
> +		sinfo->tx_bitrate_mcs = 0;

I don't think you should initialise mcs here.

Some places also need work on the coding style.

johannes

