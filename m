Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56783 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbYLDVUm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 16:20:42 -0500
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Henning Rogge <rogge@fgan.de>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Henning Rogge <hrogge@googlemail.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
In-Reply-To: <20081204211201.GL5970@tesla>
References: <200811252131.30161.hrogge@googlemail.com>
	 <200812022146.12363.hrogge@googlemail.com> <20081203014430.GH9351@tesla>
	 <200812031131.34936.rogge@fgan.de> <1228422387.5692.45.camel@johannes.berg>
	 <20081204211201.GL5970@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-C75PlMJBl92IdW8f6FPR"
Date: Thu, 04 Dec 2008 22:20:35 +0100
Message-Id: <1228425635.5692.49.camel@johannes.berg> (sfid-20081204_222047_404259_8B2C15EC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-C75PlMJBl92IdW8f6FPR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-04 at 13:12 -0800, Luis R. Rodriguez wrote:

> > Please remove the RX bitrate for now, the drivers are not currently
> > reporting HT information appropriately.
>=20
> It seems that's the case for ath9k, at least Jouni had pointed out to me.

They cannot, we don't even have that in the API.

> > then we also don't need the values for the number of streams since thos=
e
> > are perfect multiples (1x, 2x, 3x, 4x for up to 4 streams).
>=20
> Well if you have the MCS index and HT mode you get the # of streams. Not
> sure I understood the perfect multiple stuff.

Right, but you don't need to store a bitrate for MCS 0, 8, 16 and 24,
the latter three can just use the first multiplied by 2, 3 and 4
respectively.

> > Just had another idea. Since we'll end up duplicating these for TX and
> > RX (ultimately we'll need RX_BITRATE_40_MHZ/MCS/SGI etc too) we should
> > actually do this differently:
> >=20
> >  1) define NL80211_STA_INFO_RATE,
> >  2) define NL80211_RATE_INFO_BITRATE/40/MCS/SGI
> >=20
> > and then nest the bitrate information into the STA_INFO_RATE, just like
> > station flags are nested etc. That way the RATE_INFO things could also
> > be used elsewhere.
>=20
> So we'll have to add an enum then too to distinguish which rate this is
> for.

No, we know that based on what "container" attribute it's contained in,
in netlink.

> > >   * Used by the driver to indicate which info in &struct station_info
> > >   * it has filled in during get_station() or dump_station().
> > > + * Signal strength is only available if driver supports dBm signal
> > > + * strength.
> >=20
> > That comment is wrong here since cfg80211 drivers are expected to fill
> > this correctly. This comment is about _mac80211_ drivers and thus
> > inappropriate in cfg80211.h.
>=20
> adm8211 is a cfg80211 driver and does not report dBm. So it seems we
> currently allow cfg80211 drivers to *not* fill this in properly.
> The RTL drivers are some others ones as well as zd1211rw but it seems
> we'll be able to correct zd1211rw.

adm8211 is a mac80211 driver, and mac80211 doesn't fill this information
because of that, I think that's an important distinction. If you feel
this needs to be noted explicitly (it should be obvious since cfg80211
defines it in dBm and the driver cannot give such values) then please
add it to the documentation about the signal HW flags.

johannes

--=-C75PlMJBl92IdW8f6FPR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJOEmgAAoJEKVg1VMiehFYNJIQAK7vMM2Mg5AzaVsqnUjMRI4J
oTAohLIeRz7Mj/aNoYMAQM/5U4XywRQgLZ2FDjitOsbXr7xP6Qu3HZGTSqv+KkAN
Bl/aqEFssvY14L1ACpRO7/j8GfIvucem/8omkii42wav6R0ss3QRcg9O4ZroJFTX
r/whGYdgiWVeDhebTcTnmu3ebRSxY0rdSRryKI2SD8vckCO99ogbbAs7CwvIf0r7
a0yN4eclrqAJMNoYhhT1+CnFVMTVTY3DYJOSj+Redjx3QHBZBAQWcMz7xbPi1NPC
8USkmJJ87n0D0N+GCv+sm850Px9f6aRcoCu3k1ycWuP9iQfDZPyUB/2HLzThCrfV
lxu4ANCwE6LHzfULxZRfydr7w+uG3szNN6xQxB0QKq3e67Vr2CoijDDTYbanSewB
we7HYPgxJoFDskqd7UuA1BwNBJlq5z+VSuvwtI3tGVmX9+FrSk/XlC3/upozq7eO
KL7H5TmXVcSdhxfUwPwu/bKM0mIZndxcqt3IWWOimuKiQJIQawQTiq2dUEigNeuS
kRlqqGNXZPDrNxpn9/SHKPPohC3jKCqtLZtdi59M8Ar/o6x9npKsXBdlef0BV9XP
M3x2hA6XtRhWUf8jNKhE9S704roqjXMSIaFiBsCKa/vkzoex2PjpVu1w5YE2iJU2
LEolqHg6/w4PSlN1rBRp
=YVIl
-----END PGP SIGNATURE-----

--=-C75PlMJBl92IdW8f6FPR--

