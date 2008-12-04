Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailguard.fgan.de ([128.7.3.5]:48178 "EHLO mailguard.fgan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517AbYLDJtC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 04:49:02 -0500
From: Henning Rogge <rogge@fgan.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
Date: Thu, 4 Dec 2008 10:48:48 +0100
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Henning Rogge <hrogge@googlemail.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
References: <200811252131.30161.hrogge@googlemail.com> <200812031131.34936.rogge@fgan.de> <1228380472.3197.5.camel@Friederike-PC.hoffi>
In-Reply-To: <1228380472.3197.5.camel@Friederike-PC.hoffi>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2154070.qjI3HfYJOV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812041048.56327.rogge@fgan.de> (sfid-20081204_104929_597517_2DB6AD52)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2154070.qjI3HfYJOV
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Thursday 04 December 2008 09:47:52 schrieb Johannes Berg:
> On Wed, 2008-12-03 at 11:31 +0100, Henning Rogge wrote:
> > What do you think about the idea to export the 802.11n transmission rate
> > through the old WExt interface, so iwconfig will show the correct rate
> > too ? But for this the "mcs to bitrate" tables would have to be moved to
> > some other file, so wext.c can access them too (which one ?).
>
> No, that can't possibly work right, sorry.
I think it would work for reading the bitrate with WExt, but not for settin=
g=20
the bitrate.

> > + * @NL80211_STA_INFO_SIGNAL: signal strength of last received package
> > (u8, dBm)
>
> s8? should be signed, no?
Yes, it should be signed, but nl80211 does not support signed values. Shall=
 I=20
document it as signed but use the unsigned macros to transmit it through=20
nl80211 to userspace (not sure about it) ?

> > + * @NL80211_STA_INFO_RX_BITRATE: bitrate of last received unicast pack=
et
> > + *  (u16, 100 kbit/s)
>
> I don't really like this. I know we cannot report the real information
> yet because we don't even have the driver/mac80211 api but let's add rx
> rate reporting when we have the HT information too.
I'm not sure I understand your problem.

We have the mcs number from the driver, we have the the 20/40 Mhz flag and =
we=20
have to 400/800ns guard interval flag. That should be everything we need.

> > + * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate (u16, 100
> > kbit/s) + * @NL80211_STA_INFO_TX_BITRATE_40_MHZ: dual channel
> > transmission (flag) + * @NL80211_STA_INFO_TX_BITRATE_MCS: 802.11n MCS
> > index of tx rate (u8) + * @NL80211_STA_INFO_TX_BITRATE_SHORT_GI: 802.11n
> > with 400ns GI, 800ns + *  otherwise, should be ignored if TX_BITRATE_MCS
> > is not set (flag)
>
> I'm not sure I like the bitrate being used as prefix and final name, can
> we have maybe TXRATE_ as prefix and use TXRATE_RATE, TXRATE_40, ...?
Like this ?

NL80211_STA_INFO_TXRATE_RATE
NL80211_STA_INFO_TXRATE_40_MHZ
NL80211_STA_INFO_TXRATE_MCS
NL80211_STA_INFO_TXRATE_SHORT_GI

> > +/* bitrate of 802.11n ht20 connections with 800ns guard interval in
> > 100kbit/s */
> > +const u16 ieee80211n_ht20_gi800[] =3D {
> > +    65, 130, 195, 260, 390, 520, 585, 650,
> > +    130, 260, 390, 520, 780, 1040, 1170, 1300,
> > +    195, 390, 585, 780, 1170, 1560, 1755, 1950,
> > +    260, 520, 780, 1040, 1560, 2080, 2340, 2600
> > +};
> > +
> > +/* bitrate of 802.11n ht20 connections with 400ns guard interval
> > + * in 100kbit/s per spatial stream */
> > +const u16 ieee80211n_ht20_gi400[] =3D {
> > +    72, 144, 217, 289, 433, 578, 650, 722,
> > +    144, 289, 433, 578, 867, 1156, 1300, 1440,
> > +    217, 433, 650, 867, 1300, 1733, 1950, 2167,
> > +    289, 578, 867, 1157, 1733, 2311, 2600, 2889
> > +};
> > +
> > +/* bitrate of 802.11n ht40 connections with 800ns guard interval
> > + * in 100kbit/s per spatial stream */
> > +const u16 ieee80211n_ht40_gi800[] =3D {
> > +    135, 270, 405, 540, 810, 1080, 1215, 1350,
> > +    270, 540, 810, 1080, 1620, 2160, 2430, 2700,
> > +    405, 810, 1215, 1620, 2430, 3240, 3645, 4050,
> > +    540, 1080, 1620, 2160, 3240, 4320, 4860, 5400
> > +};
> > +
> > +/* bitrate of 802.11n ht40 connections with 400ns guard interval
> > + * in 100kbit/s per spatial stream */
> > +const u16 ieee80211n_ht40_gi400[] =3D {
> > +    150, 300, 450, 600, 900, 1200, 1350, 1500,
> > +    300, 600, 900, 1200, 1800, 2400, 2700, 3000,
> > +    450, 900, 1350, 1800, 2700, 3600, 4050, 4500,
> > +    600, 1200, 1800, 2400, 3600, 4800, 5400, 6000
> > +};
>
> I definitely don't like this, ick, please put that into userspace.
Is there some kind of userspace library I could put this function into ?
Every userspace programm using nl80211 will need this translation function,=
 so=20
it would be bad to put it into the iw command.

> > +	sinfo->rx_bitrate =3D sta->last_rxrate_unicast;
> > +
> > +	sinfo->tx_bitrate_flags =3D sta->last_tx_rate.flags &
> > +	    (IEEE80211_TX_RC_MCS |
> > +	     IEEE80211_TX_RC_40_MHZ_WIDTH |
> > +	     IEEE80211_TX_RC_SHORT_GI);
>
> That looks very odd. Are you sure it's using the same rate flags? And if
> it is, that's wrong, because cfg80211 must not rely on mac80211 flags.
I just store them in the flags field and translate them into NL80211 flags=
=20
later. They never leave the kernel.

But I can add a new enum for this. Maybe this way ?

enum station_info_txrate_flags {
    STATION_INFO_TXFLAGS_MCS,
    STATION_INFO_TXFLAGS_40_MHZ,
    STATION_INFO_TXFLAGS_SHORT_GI
};

> > +	if (!(sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)) {
> > +		struct ieee80211_supported_band *sband;
> > +		sband =3D
> > sta->local->hw.wiphy->bands[sta->local->hw.conf.channel->band];
> > +		sinfo->tx_bitrate =3D sband->bitrates[sta->last_tx_rate.idx].bitrate;
> > +		sinfo->tx_bitrate_mcs =3D 0;
> I don't think you should initialise mcs here.
I didn't liked to keep it uninitialized, but I can just delete the line.

> Some places also need work on the coding style.
Maybe you can give me an example, I'm still trying to learn the coding styl=
e=20
for this group.

Henning

*************************************************
Diplom Informatiker Henning Rogge
=46orschungsgesellschaft f=FCr
Angewandte Naturwissenschaften e. V. (FGAN)=20
Neuenahrer Str. 20, 53343 Wachtberg, Germany
Tel.: 0049 (0)228 9435-961
=46ax: 0049 (0)228 9435-685
E-Mail: rogge@fgan.de
Web: www.fgan.de
************************************************
Sitz der Gesellschaft: Bonn
Registergericht: Amtsgericht Bonn VR 2530
Vorstand: Dr. rer. nat. Ralf Dornhaus (Vors.), Prof. Dr. Joachim Ender=20
(Stellv.)


--nextPart2154070.qjI3HfYJOV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk3p4EACgkQRIfGfFXsz+D1PwCfbXqlDiKz+dSTXLLQ9NIMfBbK
tWUAnjXG0E9wR4lHZCI/2wP0OUl7hGk7
=iSTF
-----END PGP SIGNATURE-----

--nextPart2154070.qjI3HfYJOV--
