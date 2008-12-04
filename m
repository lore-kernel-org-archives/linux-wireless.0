Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:55957 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832AbYLDVMF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 16:12:05 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 04 Dec 2008 13:12:05 -0800
Date: Thu, 4 Dec 2008 13:12:01 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Henning Rogge <rogge@fgan.de>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Henning Rogge <hrogge@googlemail.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
Message-ID: <20081204211201.GL5970@tesla> (sfid-20081204_221209_818963_B4C38297)
References: <200811252131.30161.hrogge@googlemail.com> <200812022146.12363.hrogge@googlemail.com> <20081203014430.GH9351@tesla> <200812031131.34936.rogge@fgan.de> <1228422387.5692.45.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1228422387.5692.45.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 04, 2008 at 12:26:27PM -0800, Johannes Berg wrote:
> On Wed, 2008-12-03 at 11:31 +0100, Henning Rogge wrote:
> 
> > Changes since v3:
> > - added rx_bitrate to station info and sta_info
> > - remember bitrate of last received unicast packet to this station
> 
> Please remove the RX bitrate for now, the drivers are not currently
> reporting HT information appropriately.

It seems that's the case for ath9k, at least Jouni had pointed out to me.

> > - decode 802.11n MCS index for nl80211
> >   (maybe this should be ported to WEXT too ?)
> 
> I don't like all the tables in the kernel, please move those to
> userspace. If we used more accurate values (these rates are fractional)

So the rate stuff in the 11n wiki page is rounded up, so yeah it would
technically be a bit off so its technically better to let us figure it
out in userspace.. sorry about that Henning... And Johannes also pointed
out to me we actually do have duplicate rates, I failed to catch them.

> then we also don't need the values for the number of streams since those
> are perfect multiples (1x, 2x, 3x, 4x for up to 4 streams).

Well if you have the MCS index and HT mode you get the # of streams. Not
sure I understood the perfect multiple stuff.

> > Changes since v4:
> > - added tx_bitrate_flags adn tx_bitrate_mcs field to station info
> > - added flags for 40Mhz and small guard interval to NL80211 station info
> > - added mcs field to NL80211 station info
> > 
> > The IEEE80211_TX_RC_40_MHZ_WIDTH flag in nl80211 should work for 802.11g 
> > "turbomodes"
> 
> I don't think we should ever go there. But that's just me maybe.

I don't think we want to support this either and I doubt bug reports
for it would get attention from us.

> > + * @NL80211_STA_INFO_SIGNAL: signal strength of last received package (u8, 
> > dBm)
> > + * @NL80211_STA_INFO_RX_BITRATE: bitrate of last received unicast packet
> > + *  (u16, 100 kbit/s)
> > + * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate (u16, 100 kbit/s)
> > + * @NL80211_STA_INFO_TX_BITRATE_40_MHZ: dual channel transmission (flag)
> > + * @NL80211_STA_INFO_TX_BITRATE_MCS: 802.11n MCS index of tx rate (u8)
> > + * @NL80211_STA_INFO_TX_BITRATE_SHORT_GI: 802.11n with 400ns GI, 800ns
> > + *  otherwise, should be ignored if TX_BITRATE_MCS is not set (flag)
> >   */
> >  enum nl80211_sta_info {
> >  	__NL80211_STA_INFO_INVALID,
> > @@ -413,6 +421,12 @@ enum nl80211_sta_info {
> >  	NL80211_STA_INFO_LLID,
> >  	NL80211_STA_INFO_PLID,
> >  	NL80211_STA_INFO_PLINK_STATE,
> > +	NL80211_STA_INFO_SIGNAL,
> > +	NL80211_STA_INFO_RX_BITRATE,
> > +	NL80211_STA_INFO_TX_BITRATE,
> > +	NL80211_STA_INFO_TX_BITRATE_40_MHZ,
> > +	NL80211_STA_INFO_TX_BITRATE_MCS,
> > +	NL80211_STA_INFO_TX_BITRATE_SHORT_GI,
> 
> Just had another idea. Since we'll end up duplicating these for TX and
> RX (ultimately we'll need RX_BITRATE_40_MHZ/MCS/SGI etc too) we should
> actually do this differently:
> 
>  1) define NL80211_STA_INFO_RATE,
>  2) define NL80211_RATE_INFO_BITRATE/40/MCS/SGI
> 
> and then nest the bitrate information into the STA_INFO_RATE, just like
> station flags are nested etc. That way the RATE_INFO things could also
> be used elsewhere.

So we'll have to add an enum then too to distinguish which rate this is
for.

> >   * Used by the driver to indicate which info in &struct station_info
> >   * it has filled in during get_station() or dump_station().
> > + * Signal strength is only available if driver supports dBm signal
> > + * strength.
> 
> That comment is wrong here since cfg80211 drivers are expected to fill
> this correctly. This comment is about _mac80211_ drivers and thus
> inappropriate in cfg80211.h.

adm8211 is a cfg80211 driver and does not report dBm. So it seems we
currently allow cfg80211 drivers to *not* fill this in properly.
The RTL drivers are some others ones as well as zd1211rw but it seems
we'll be able to correct zd1211rw.

  Luis
