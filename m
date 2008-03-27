Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:58603 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbYC0ATg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 20:19:36 -0400
Date: Wed, 26 Mar 2008 17:19:09 -0700
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Bruno Randolf <bruno@thinktube.com>, ath5k-devel@lists.ath5k.org,
	jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, flamingice@sourmilk.net, jbenc@suse.cz,
	Ivan Seskar <Seskar@winlab.rutgers.edu>,
	Jean Tourrilhes <jt@hpl.hp.com>,
	Haris Kremo <harisk@winlab.rutgers.edu>
Subject: Re: [PATCH] mac80211: use hardware flags for signal/noise units
Message-ID: <20080327001909.GA17555@bougret.hpl.hp.com> (sfid-20080327_001941_018301_E5FDD24A)
Reply-To: jt@hpl.hp.com
References: <20080326123042.11233.80949.stgit@localhost> <43e72e890803261559keb944a1g48d93645db2f2e73@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <43e72e890803261559keb944a1g48d93645db2f2e73@mail.gmail.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 26, 2008 at 06:59:11PM -0400, Luis R. Rodriguez wrote:
> Jean a question or two for you below.
>=20
> OK I know I seemed happy with the original patch but after some
> thought I have some concerns. They are below.

	Hi there,

	I'm, currently on business trip. I'll try to answer the best I
can. Ping me again next week.
	Note that I did not define what went into mac80211.h, and I
disclaim any responsability from that.
	My idea is that the API should be based on real physical
measurable values as much as possible. The tradeoff is that those
values should also be useful, often raw values are useless.

> On Wed, Mar 26, 2008 at 8:30 AM, Bruno Randolf <bruno@thinktube.com> =
wrote:
>=20
> >  diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>=20
> >  @@ -697,6 +701,24 @@ enum ieee80211_tkip_key_type {
> >   * @IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE:
> >   *     Hardware is not capable of receiving frames with short prea=
mble on
> >   *     the 2.4 GHz band.
> >  + *
> >  + * @IEEE80211_HW_SIGNAL_DB:
> >  + *     Hardware gives signal values in dB, decibel difference fro=
m an
> >  + *     arbitrary, fixed reference. If possible please provide dBm=
 instead.
> >  + *
>=20
> Signal should given in either be in dBm or an unspecified value. Sinc=
e
> we have "unspecified" not sure why we would have the "db" value. Can
> you clarify what the difference between "unspecified" and "db" would
> be? I don't think it makes sense to refer to signal with a "db" value=
,
> unless we want "singal" here to be able to mean SNR.

	Having a absolute signal measurement is very interesting to
some applications. A signal in dBm tells you how "far" radio wise you
are from the AP, and you may use it for roaming. Also, if you want to
do localisation (triangulation) using RSSI, you need the signal in
dBm.
	SNR is useful, but less, and can be calculated using both the
signal and the noise value. That's why I did not include it in the WE
API. SNR could be used to pick the most appropriate bit rate for
example.
	The most common unit for the RSSI is dBm, but I see that IEEE
is using RCPTI. I personally don't like RCPTI because it's more
opaque, people are physically measuring dBm, and are having transmit,
gain and loss measured in dBs. That's why I think it's important that
the unit used for that value be dBm.
	Now, we would like all hardware to report RSSI in dBm, and get
done with it. However, some hardware (Atheros) can not do it, because
their RSSI hardware is uncalibrated. So, what do you do with those
hardware ? Reporting a "relative" signal strength is probably better
than nothing.
	Note that it could be uncalibrated in two way. One way is the
offset (like the Atheros), the other is the slope (older hardware). It
means that for some hardware, it does not even follow a dB
curve. Uncalibrated usually means that every instance of the hardware
is different and you can't have a global correction factor.
	For example, check the Aironet driver. The driver has a RSSI
correction table, for every raw RSSI value, the driver check in a
table to get the RSSI in dBm. The table is stored in the EPROM of the
card, and I believe specific to each card. The correction curve is not
even linear !
	For the Atheros, there is another issue, the offset changes
over time and is not constant for the card.
	Note also that many hardware are not truly calibrated, but
"sort of" calibrated (Orinoco, HostAP). Good measurement is expensive,
that's why most implementation do measurement on the cheap. It means
the value will be correct within some few percents for a large part
range. Up to now, we pretented that those devices report dBm
properly. That's why RCPTI talk of expected accuracy of measurement.

	So, in WE we have :
		o signal is RSSI in dBm, which is the most useful to apps.
		o if can't do dBm, do relative, which has no expectations.

	Now, back to your question.
	This additional value would be cases where only the offset is
uncalibrated and the slope is correct, like the Atheros. What it would
allow is to calculate SNR in dB, which a "unspec" would not allow. If
the offset is constant (as specified above, but not the case for
Atheros), you could compare different value over time and make a
difference in dB.
	Clearly, you have to think hard and define is the reference is
fixed (as stated above) or variable (Atheros). The fixed reference
could be more useful to apps, but I don't know how many HW would fit
that definition. The variable reference would accomodate the Atheros
nicely.
	Also, with respect to "sort of calibrated" device, you would
have to device if they are dBm or dB. What is the accuracy you expect.

	And of course, the main question to ask is, is this extra
functionality worth the additional complexity of the API, and the
potential confusion to users. I don't know, but for WE the answer was
no.

	Note also that you may need an agregate measure of how good
the link is, but that would be best generated by the stack itself. I
guess for most devices, the bitrate in use will tell you that kind of
information.

> >  + *
> >  + * @IEEE80211_HW_SIGNAL_UNSPEC:
> >  + *     Hardware can provide signal values but we don't know its u=
nits. To be
> >  + *     able to standardize between different devices we would lik=
e linear
> >  + *     values from 0-100. If possible please provide dB or dBm in=
stead.

	Note that for some hardware, you can not get liner values (see
above). Anyway, what does linear means, is it linear on a log/dBm
scale or on a power/mW scale ?
	This is exactly why I introduced avg_qual in WE.

> >  + * @IEEE80211_HW_SIGNAL_DBM:
> >  + *     Hardware gives signal values in dBm, decibel difference fr=
om
> >  + *     one milliwatt. This is the preferred method since it is st=
andardized
> >  + *     between different devices.
> >  + *
> >  + * @IEEE80211_HW_NOISE_DBM:
> >  + *     Hardware can provide noise floor values in units dBm, deci=
bel difference
> >  + *     from one milliwatt.

	Noise only defined in dBm ? Some older devices have noise in
"unspec". I also don't know what Atheros does here.

> >   */
> >   enum ieee80211_hw_flags {
> >         IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE           =3D 1<<0,
> >  @@ -704,6 +726,10 @@ enum ieee80211_hw_flags {
> >         IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING        =3D 1<<2,
> >         IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE          =3D 1<<3,
> >         IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE      =3D 1<<4,
> >  +       IEEE80211_HW_SIGNAL_UNSPEC                      =3D 1<<5,
> >  +       IEEE80211_HW_SIGNAL_DB                          =3D 1<<6,
> >  +       IEEE80211_HW_SIGNAL_DBM                         =3D 1<<7,
> >  +       IEEE80211_HW_NOISE_DBM                          =3D 1<<8,
> >   };
> >
> >   /**
>=20
> <-- snip -->
>=20
> >  diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee802=
11_ioctl.c
> >  index 5af23d3..731ecd2 100644
> >  --- a/net/mac80211/ieee80211_ioctl.c
> >  +++ b/net/mac80211/ieee80211_ioctl.c
> >  @@ -158,12 +158,20 @@ static int ieee80211_ioctl_giwrange(struct n=
et_device *dev,
> >         range->num_encoding_sizes =3D 2;
> >         range->max_encoding_tokens =3D NUM_DEFAULT_KEYS;
> >
> >  -       range->max_qual.qual =3D local->hw.max_signal;
> >  -       range->max_qual.level =3D local->hw.max_rssi;
> >  -       range->max_qual.noise =3D local->hw.max_noise;
> >  +       range->max_qual.level =3D 0;
> >  +       if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
> >  +               range->max_qual.level =3D 100;
> >  +       else if  (local->hw.flags & IEEE80211_HW_SIGNAL_DB)
> >  +                /* this is pretty arbitrary but the range of most=
 drivers */
> >  +                range->max_qual.level =3D 64;
> >  +       else if  (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
> >  +               range->max_qual.level =3D -110;
> >  +
> >  +       range->max_qual.noise =3D -110;
> >  +       range->max_qual.qual =3D 100;
> >         range->max_qual.updated =3D local->wstats_flags;
>=20
> I'm pretty perplexed by the original intention of Wireless Extensions
> max_qual. The documentation we have for this states:
>=20
>         /* Quality of link & SNR stuff */
>         /* Quality range (link, level, noise)
>          * If the quality is absolute, it will be in the range [0 ; m=
ax_qual],
>          * if the quality is dBm, it will be in the range [max_qual ;=
 0].
>          * Don't forget that we use 8 bit arithmetics... */
>         struct iw_quality       max_qual;       /* Quality of the lin=
k */
>=20
> max_qual is a struct though, iw_quality which is:
>=20
> /*
>  *      Quality of the link
>  */
> struct  iw_quality
> {
>         __u8            qual;           /* link quality (%retries, SN=
R,
>                                            %missed beacons or better.=
=2E.) */
>         __u8            level;          /* signal level (dBm) */
>         __u8            noise;          /* noise level (dBm) */
>         __u8            updated;        /* Flags to know if updated *=
/
> };
>=20
> Jean, if range->max_qual.level is set to -110 does this mean signal
> level can be set only from -110 up to 0 ? Is max_qual.level supposed
> to be the weakest signal possibly detected?

	Yes. This is what make most sense.
	Remember we also have "avg_qual".
	The idea is that if we want to graphically represent the value
on a graph, we need to know the bounds. Think about a
thermometer. Most thermometers show a range of temperature from -20C
to +100C.
	Usually, level and noise will have the same range [-110;0],
and qual will have its own range [0-100] or whatever.

> Also, technically the noise should change depending on the channel ba=
ndwidth.
>=20
> IEEE-802.11  Channel bandwidth
> 802.11a        20MHz
> 802.11b        22MHz
> 802.11g        20MHz (except when operating in 802.11b rates)
> 802.11n        20MHz, 40MHz (except when operating in 802.11b rates)
>=20
> Applying the noise power formula:
>=20
> Pn =3D kTB
>=20
> where:
>=20
> k is Boltzmann's constant, 1.38*10^-23 J/K
> T is the temperature in Kelvin (room temperature, 290 K)
> B is the system bandwidth, in Hz
>=20
> Note: Watt =3D J/s
>=20
> For a 1 Hz bandwidth and at 290 K:
>=20
> Pn =3D 1.38 * 10-23 J/K * 290 K * 1 Hz
> Pn =3D 4.00200 * 10^-21 JHz
> Pn =3D 4.00200 * 10^-21 J/s
> Pn =3D 4.00200 * 10^-21 W
> Pn =3D 4.00200 =D7 10-18 mW
>=20
> To convert to Bell, we do log (foo), to deciBell we do 10 * log (foo)
> so: (dBm =3D=3D dBmW)
>=20
> Pn =3D 10 * log (4.00200 * 10^-18) dBm
> Pn =3D ~-173.97722915699807401277 dBm
> Pn =3D ~-174 dBm
>=20
> Now applying the same noise power formula, Pn =3D kTB, and knowing
> already -174dBm applies for each 1 Hz we can compute the power noise
> for each differing bandwidth for 802.11:
>=20
> Pn =3D -174 dBm / Hz + 10 * log (Bandwidth)
>=20
> mcgrof@monster:~$ calc
> C-style arbitrary precision calculator (version 2.12.1.13)
> Calc is open software. For license details type:  help copyright
> [Type "exit" to exit, or "help" for help.]
>=20
>=20
> ; -174 + (10 * log(20 * 10^6))
>         ~-100.98970004336018804794
> ; -174 + (10 * log(22 * 10^6))
>         ~-100.57577319177793764041
> ; -174 + (10 * log(40 * 10^6))
>         ~-97.97940008672037609579
>=20
> So I don't see why noise power should be -110, instead how about
> having it set to -101 dBm for 20 MHz and 22 MHz channel bandwidth and
> -98 dBm for 40 MHz channel bandwidth when used? If we want to be even
> more exact we can take into consideration the noise from the amplifie=
r
> chain for the hardware when known; for example for Atheros it seems t=
o
> be known to be 5dBm [1] so the noise for Atheros hardware should
> change to -96 dBm.

	Remember, what we care most here is to give a range so that
graphical applications know the bound of the value. We don't need to
be absolutely accurate here. Think about the thermometer example.
	Now, what you are talking is the channel noise. Receiver noise
is different, as the receiver chain adds its own noise. Then, if you
use DS (1 MB/s) or other complex modulation, you can have a processing
gain which lower the noise floor. When I looked at the Orinoco at
1Mb/s, I believe the -110 dBm was correct, but I may have got it
wrong.
	I think it would be wise to use a value that change as little
as possible, so that the various applications can cache it (well, they
will do it anyway).
	But yeah, please use whatever value make sense and give good
result in userspace applications.

> [1] http://madwifi.org/wiki/UserDocs/RSSI
>=20
>   Luis

	Regards,

	Jean
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
