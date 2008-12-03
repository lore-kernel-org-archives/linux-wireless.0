Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60522 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238AbYLCBoc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 20:44:32 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 17:44:32 -0800
Date: Tue, 2 Dec 2008 17:44:30 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Henning Rogge <hrogge@googlemail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Henning Rogge <rogge@fgan.de>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
Message-ID: <20081203014430.GH9351@tesla> (sfid-20081203_024459_213328_71076EDF)
References: <200811252131.30161.hrogge@googlemail.com> <200812021425.44488.rogge@fgan.de> <20081202202919.GC9351@tesla> <200812022146.12363.hrogge@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <200812022146.12363.hrogge@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 02, 2008 at 12:46:06PM -0800, Henning Rogge wrote:
> > > @@ -404,6 +404,10 @@ enum nl80211_sta_flags {
> > >   * @NL80211_STA_INFO_TX_BYTES: total transmitted bytes (u32, to =
this
> > > station) * @__NL80211_STA_INFO_AFTER_LAST: internal
> > >   * @NL80211_STA_INFO_MAX: highest possible station info attribut=
e
> > > + * @NL80211_STA_INFO_SIGNAL: signal strength of last received pa=
ckage
> > > (u8, dBm)
> > Shouldn't this be s8?
> I did not find macros for nl80211 to add signed values... so its just=
 "say=20
> it's signed, but use the unsigned macro" ? If yes I will change the=20
> documentation.

Ah no, nevermind me, netlink doesn't have singed values.

> > > diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> > > index 1d57835..cdf9433 100644
> > > --- a/include/net/cfg80211.h
> > > +++ b/include/net/cfg80211.h
> > > @@ -167,6 +167,9 @@ struct station_parameters {
> > >   * @STATION_INFO_LLID: @llid filled
> > >   * @STATION_INFO_PLID: @plid filled
> > >   * @STATION_INFO_PLINK_STATE: @plink_state filled
> > > + * @STATION_INFO_SIGNAL: @signal filled
> >
> > Can you extend this to indicate drivers which enable this must
> > pass the singal in dBm (IEEE80211_HW_SIGNAL_DBM for mac80211 driver=
s)
> > as that is what cfg80211 expects?
> The flag is only set if the driver sets the IEEE80211_HW_SIGNAL_DBM f=
lag.
> cfg.c:
> +=A0=A0=A0=A0=A0=A0=A0if (sta->local->hw.flags & IEEE80211_HW_SIGNAL_=
DBM) {
> +=A0=A0=A0=A0=A0=A0=A0 =A0sinfo->filled |=3D STATION_INFO_SIGNAL;
> +=A0=A0=A0=A0=A0=A0=A0 =A0sinfo->signal =3D sta->last_signal;
> +=A0=A0=A0=A0=A0=A0=A0}
>=20
> But it might be better to explain this in the documentation.

Right.

> > This is important as mac80211 drivers not using IEEE80211_HW_SIGNAL=
_DBM
> > will luck out of getting signal reports. This means these drivers w=
on't
> > get signal reports right now:
> I know... (did search for the HW_SIGNAL flags in the drivers)
>=20
> > I guess this is the iffy part... I'll see if zd1211rw can somehow u=
se
> > dBm though.
> That would be good I think.
>=20
> > Awesome stuff, now come to think of it, perhaps its best we let
> > userspace do the calculation and we just give it the last RX/TX
> > guard interval and the MCS index? Technically speaking it seems
> > we don't have duplicate rates though so a reverse map is possible
> > but it seems useful to just provide the information directly.
>  the problem of this approach would be that every userspace calculati=
on would=20
> have to do this calculation on it's own.

True..

> Whats about transmitting "basic=20
> datarate"

What's that?

> , "number of spatial streams"

No need for this one, the HT mode (ht20 or ht40) and MCS index would
give us that.

> and "flags" (short/long GI, 20/40 Mhz  width) to userspace ?

Well... see below.

> This way it would be just a multiplication to get the=20
> total bandwith, but it still can easily be reverse mapped into MCS wi=
th some=20
> arithmetics.

I believe to get the throughput you need a lot more info than this, hen=
ce
why the table is so big and why you have array index for each MCS index
for each HT mode and guard interval.

So... what if we pass the throughput as you have it but also pass the
other stuff (flags, and MCS index) just so all userspace apps that
want to get last TX/RX guard interval, HT20/HT40, and MCS index
doesn't have to have a funky reverse map to get the flags and MCS index=
?

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
