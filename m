Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46149 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbYCQNth (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 09:49:37 -0400
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request
	a Phase 2 key
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1ba2fa240803170636t6158c0a8vb180f71352208548@mail.gmail.com> (sfid-20080317_133616_002306_499F1E28)
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
	 <1205591906.15910.44.camel@johannes.berg>
	 <1ba2fa240803161721q5d01bve2292f99d3fe9eb8@mail.gmail.com>
	 <1205747912.1614.19.camel@johannes.berg>
	 <1ba2fa240803170320i4805e055ofebbbd9928a59354@mail.gmail.com>
	 <1205751455.1614.25.camel@johannes.berg>
	 <1ba2fa240803170540n2e6fb398p84abfb34e4124042@mail.gmail.com>
	 <1205758276.1614.45.camel@johannes.berg>
	 <1ba2fa240803170636t6158c0a8vb180f71352208548@mail.gmail.com>
	 (sfid-20080317_133616_002306_499F1E28)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZqhVG/2nmWrDdqlO23zB"
Date: Mon, 17 Mar 2008 14:49:18 +0100
Message-Id: <1205761758.1614.79.camel@johannes.berg> (sfid-20080317_134942_403112_6B12ADBB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZqhVG/2nmWrDdqlO23zB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  Huh ok. But how would the WEP legacy station be able to determine that=
?
>=20
> Legacy user get the key written on 'positit' yellow paper :).

Heh yeah.

> >  Or does it just try to use WEP and succeed? TBH, I was unaware that th=
is
> >  existed, this does make it a bit more of a problem than I thought then=
.
> >
>=20
> >  >
> >  > On second thought is that AP has only TX group key while STA has onl=
y
> >  > RX group key so I
> >  > m not seeing here any need for flag.
> >
> >  Hm, well, I didn't really want to require the driver to keep track of
> >  the current operating mode, so that's why I used 00:...:00 vs. FF:...:=
FF
> >  for the group keys.
>=20
> Isn't if on integer faster then comparing 6 bytes?

Probably. Does it matter though? Setting keys isn't going to be
performance critical in any way.

> >  Is that really done though? I mean, does wpa_supplicant not also use
> >  encodeext for WEP keys?
> >
> Unfortunately yes.

So that doesn't really help us either way, no?

> First of all we don't need 4 keys per station but for the whole
> system.=20

Not sure I understand this. You need pairwise (per-station) keys as well
as four default keys, no?

> Even in AP mode with multiple SSID meaning multiple security
> setting you cannot distinguish between networks in static WEP key
> setting so 4 is enough.

Not sure I get what you're thinking here.

> Beside that you need place holder for group key. They might be
> multiple groups key in case of multiple SSIDs in AP mode, iwlwifi
> doesn't support it in HW but in general it is possible.

Well, no, because we can add multiple keys with a zeroed MAC address,
since we have the local MAC address in there as well. Also, in an AP,
these are only used for TX so it doesn't matter since mac80211 does the
key selection completely on its own.

> We need a flag in set_key which says whether the WEP key is static or not=
.

Let's actually try to gather all the cases first.

Is this it?

 * TKIP/CCMP/WEP group or pairwise key
 * WEP legacy ('static') key

where the first is completely covered by what we have now and the
assumption is that if only WEP keys are present then it'll be a legacy
WEP key?

johannes

--=-ZqhVG/2nmWrDdqlO23zB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9523aVg1VMiehFYAQK3kw//RH9sT003bDSALkS/VE6NUMWFTvuF4QFn
yJrlzccnG8UgGvGtYT7kSMz8XLRGv8RscD1c6T7XiPk+InW1LTRUmFU2J4f5dj8m
ON96dFmAYjtbbAB3OgcPBtYdZmjFwx98lmIykAaSaW8i/LrwX79maOrWhCrVYsOY
VQRIqYul0VdJTB1rkEbPR0zb7/r/LHV/ieI8RcuLUM902D5wAr7yvY/NZjPgGQSI
rjaLY7B00vajhUQdE2YNsJbbzqAhTMy+2ImG26k/JeHlbxPVr+csDzWdAx7+/3U5
xqIk2fgKnAfQYhevaHrtOzn96UhtAc9OUaTnVaCRh+jXzQ36xJ7oe2J0GHH9Hm4D
0o6CZmQkPobevvD8F9t7JM/KJYZIrFcZVNO8jmyCBR/OiCfWEIn9bQYLY+9wyhDF
kVDWYwbMpLV/TlBPkj9ZkaGndtlzLICV8w04NXYdPpV8vgJNw9UEBpJdNkz7j+0h
p+4BfXWm/2N0nAf5tbdhRyNZyRlhWpj+xnQ1JNBARaHEGrHvnrQ5kLnr6BbtPnah
V/FqWbQFdhaxPnVpKCDYRo7FFAOvls8VHD6PFg5otW2/C6LrBNTkbuCt5/+2oa8K
88b9wV2FpezVDv1+IWUED0kB7slvSrnxpBlji4NsCov//bHUiUGAZXFx6P5trOJ4
ayzMSZvDPmA=
=IUq8
-----END PGP SIGNATURE-----

--=-ZqhVG/2nmWrDdqlO23zB--

