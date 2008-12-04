Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60238 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbYLDNCp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 08:02:45 -0500
To: Henning Rogge <rogge@fgan.de>
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
MIME-Version: 1.0
Date: Thu, 04 Dec 2008 14:02:38 +0100
From: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Henning Rogge <hrogge@googlemail.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>, nbd@openwrt.org
In-Reply-To: <200812041048.56327.rogge@fgan.de>
References: <200811252131.30161.hrogge@googlemail.com> <200812031131.34936.rogge@fgan.de> <1228380472.3197.5.camel@Friederike-PC.hoffi> <200812041048.56327.rogge@fgan.de>
Message-ID: <0793064daccbbcc7940b7a63f670d9e1@localhost>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



>> No, that can't possibly work right, sorry.

> I think it would work for reading the bitrate with WExt, but not for
> setting the bitrate.

Yes, that might work, but would be quite inconsistent, IMHO.

>> > + * @NL80211_STA_INFO_SIGNAL: signal strength of last received package
>> > (u8, dBm)
>>
>> s8? should be signed, no?
> Yes, it should be signed, but nl80211 does not support signed values.
> Shall I 
> document it as signed but use the unsigned macros to transmit it through 
> nl80211 to userspace (not sure about it) ?

Yes, please document as signed.

>> > + * @NL80211_STA_INFO_RX_BITRATE: bitrate of last received unicast
> packet
>> > + *  (u16, 100 kbit/s)
>>
>> I don't really like this. I know we cannot report the real information
>> yet because we don't even have the driver/mac80211 api but let's add rx
>> rate reporting when we have the HT information too.

> I'm not sure I understand your problem.

> We have the mcs number from the driver, we have the the 20/40 Mhz flag
and
> we 
> have to 400/800ns guard interval flag. That should be everything we need.

I don't think we have MCS number, where did you see it? And we don't have
the 20/40, GI etc. either, afaict. Remember this is RX.

>> > + * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate (u16, 100
>> > kbit/s) + * @NL80211_STA_INFO_TX_BITRATE_40_MHZ: dual channel
>> > transmission (flag) + * @NL80211_STA_INFO_TX_BITRATE_MCS: 802.11n MCS
>> > index of tx rate (u8) + * @NL80211_STA_INFO_TX_BITRATE_SHORT_GI:
> 802.11n
>> > with 400ns GI, 800ns + *  otherwise, should be ignored if
> TX_BITRATE_MCS
>> > is not set (flag)
>>
>> I'm not sure I like the bitrate being used as prefix and final name, can
>> we have maybe TXRATE_ as prefix and use TXRATE_RATE, TXRATE_40, ...?
> Like this ?
> 
> NL80211_STA_INFO_TXRATE_RATE
> NL80211_STA_INFO_TXRATE_40_MHZ
> NL80211_STA_INFO_TXRATE_MCS
> NL80211_STA_INFO_TXRATE_SHORT_GI

Yeah, much better.


>> I definitely don't like this, ick, please put that into userspace.
> Is there some kind of userspace library I could put this function into ?
> Every userspace programm using nl80211 will need this translation
> function, so it would be bad to put it into the iw command.

Why would that be bad? Most programs using nl80211 won't care, and this is
fixed information, not something that changes.

>> > +	sinfo->rx_bitrate = sta->last_rxrate_unicast;
>> > +
>> > +	sinfo->tx_bitrate_flags = sta->last_tx_rate.flags &
>> > +	    (IEEE80211_TX_RC_MCS |
>> > +	     IEEE80211_TX_RC_40_MHZ_WIDTH |
>> > +	     IEEE80211_TX_RC_SHORT_GI);
>>
>> That looks very odd. Are you sure it's using the same rate flags? And if
>> it is, that's wrong, because cfg80211 must not rely on mac80211 flags.
> I just store them in the flags field and translate them into NL80211
flags
> 
> later. They never leave the kernel.
> 
> But I can add a new enum for this. Maybe this way ?
> 
> enum station_info_txrate_flags {
>     STATION_INFO_TXFLAGS_MCS,
>     STATION_INFO_TXFLAGS_40_MHZ,
>     STATION_INFO_TXFLAGS_SHORT_GI
> };

Yes, that would be better, and that needs to be defined in cfg80211.

>> > +	if (!(sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)) {
>> > +		struct ieee80211_supported_band *sband;
>> > +		sband =
>> > sta->local->hw.wiphy->bands[sta->local->hw.conf.channel->band];
>> > +		sinfo->tx_bitrate = sband->bitrates[sta->last_tx_rate.idx].bitrate;
>> > +		sinfo->tx_bitrate_mcs = 0;
>> I don't think you should initialise mcs here.

> I didn't liked to keep it uninitialized, but I can just delete the line.

But it won't be used anyway, so imho it's easier to understand if you
remove it.

>> Some places also need work on the coding style.

> Maybe you can give me an example, I'm still trying to learn the coding
> style for this group.

You can find stuff on that in the Documentation/ directory.

johannes

PS: Sent from new webmail, apologies for the previous johannes@localhost,
let me know if this is ok!
