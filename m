Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38221 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbXJYNkJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 09:40:09 -0400
Subject: Re: [PATCH 1/2] mac80211: [RFC] adding bss_config to low level
	driver ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindzonski <rindjon@googlemail.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	flamingice@sourmilk.net
In-Reply-To: <c85cb4470710250259y2e35294cmb6131abc7327389@mail.gmail.com> (sfid-20071025_105951_202449_12E2BDE6)
References: <11932213323451-git-send-email-ron.rindjunsky@intel.com>
	 <11932213374183-git-send-email-ron.rindjunsky@intel.com>
	 <1193227218.4510.31.camel@johannes.berg>
	 <c85cb4470710250259y2e35294cmb6131abc7327389@mail.gmail.com>
	 (sfid-20071025_105951_202449_12E2BDE6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1opvdPFNPtp33AgNhS9l"
Date: Thu, 25 Oct 2007 15:41:23 +0200
Message-Id: <1193319683.14136.6.camel@johannes.berg> (sfid-20071025_144015_282477_D8CDFE5E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1opvdPFNPtp33AgNhS9l
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-10-25 at 11:59 +0200, Ron Rindzonski wrote:

> there are cases (erp reset for example) that values are sent to the low l=
evel
> driver even if there is no change from previous state, so "verify" is
> for telling the driver: "hey, check this value to see if it's the one
> configured in HW, and if not change it to delivered value"
> in fact i had difficulty finding a suitable word describing this. any
> suggestions will
> be more then welcome...

Ok that makes sense. OTOH, couldn't we simply compare to the state in
the structure and if it differs set the changed flag? Then we could name
it CHANGED_*?

> > Seeing that you already used 5 of 8 bits and we're likely to increase
> > this in the future, I'd go with a u32 here. Also, have you attempted to
> > make all fields 'valid' all the time and if so, why is there no
> > 'changed' bitmap passed to the callback?
> >
>=20
> right, i'll change it to u32.
> i believe that if i'll just follow the current flows the struct will
> always be valid as it will follow every change occurs in the mac80211,
> so i'll add the "valid" only if i see it is really needed.
> for the "changed" use - please see above 'changed/verify" naming dilemma.

Ok, in that case I'd still put the "changed" or "verify" into a
parameter since it's not part of the structure really, only part of
passing the structure to the driver.

> > I don't understand the last sentence here. Can you elaborate? Is it
> > meant as a note for mac80211 hackers? If so, wouldn't it be more
> > appropriate to add it to the function that calls this? Also, you didn't
> > add the if_id which will even break Intel's driver once multi-MAC
> > support is added...
> >
>=20
> if_id will be added, thanks.
> my initial thought was that no BSS configuration is possible without
> association first to establish this BSS, but coming to think about it
> AP flows can be different - config the driver even with no association
> first. i'll remove this line, and inspect my code accordingly.

Alright, thanks.

> > > @@ -276,6 +276,7 @@ struct ieee80211_if_sta {
> > >       u32 supp_rates_bits;
> > >
> > >       int wmm_last_param_set;
> > > +     struct ieee80211_bss_data bss_data;
> >
> > Are you sure this will work properly? The same stuff must also be used
> > for AP mode, when hostapd decides to change things, no?
> >
>=20
> i see your point. do you think that sub_if_data will be more suitable?

Yeah, I think so. It takes up space anyway since we need to add it to AP
and that is, afaik, the largest structure in that union.

johannes

--=-1opvdPFNPtp33AgNhS9l
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyCdAqVg1VMiehFYAQI2eg/8D25hVrk8B4LyjKdleWmuK4egTTfUYykk
ilUcwaUi6PBxCyuxvmW6IeZ8o9hpTxjijWjP9xmiEvRIWMbUFwdZq/ige7yynrHE
v2ezl4hVEJ6xCKdD7CjlH81ioMJz3B6NtkR5BVU5hF5I+0Q3sdGpn0sIeXfRoHCf
1ksByHaEHNQ/DTEARNeJiFL/2L2FAWeXqMgn69560Fo8e6M3H4JFyHRg75vq3G+f
sg+I1u5JB/tHWQc5AJE+JkVY39v8Y++1Wx58rPML7VlUew3Rg8emTpfSDsVPvR8U
TtT744iOhkH+yUID6u7xcOlNuoAXiNK6tA0Nw3ldP1KEI/RViiI4gGTmKMJzYV93
fnnsfujDSSfLsanXpyiEfQs2EN5xdsDU5qEOXjuCAH4RBfNFrMl4EHEkaAdUvFW9
C8PzQBH7RY8+j/sQFVCGYUCf0rnBVaCXRmtokLqtyb9wY+vXrm5kAZSB5LwMOUMO
gP6Ac1dKpxkl29a6Xj4dg/qTmMArKkvfZrv3A1JMDRZoDsUmRZiix87ECxxKF2Dj
UGof1J11ZgNuyrC0d38VcHPcULJ4jplFMZKfnfd+x79pd8HmpInnebNJX83rooTO
bVVXRgZ59EOWk3vZuQmzKTSKmQH65usbMzebDhbhyMo9DCRoMkHHbh6l52mc3iO1
eApjeOVBW8Y=
=cf0P
-----END PGP SIGNATURE-----

--=-1opvdPFNPtp33AgNhS9l--

