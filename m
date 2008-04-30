Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56293 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672AbYD3OUZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 10:20:25 -0400
Subject: Re: [RFC] WARNING: at net/mac80211/ieee80211_rate.h:159
	rate_lowest_index()
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Koutny <vlado@work.ksp.sk>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48174652.6080909@work.ksp.sk> (sfid-20080429_180141_582175_8C7B6399)
References: <48174652.6080909@work.ksp.sk>
	 (sfid-20080429_180141_582175_8C7B6399)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PFD2j0IKPRx7EHeGfMym"
Date: Wed, 30 Apr 2008 16:20:15 +0200
Message-Id: <1209565215.18659.26.camel@johannes.berg> (sfid-20080430_162017_586248_D00379B8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PFD2j0IKPRx7EHeGfMym
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> because sdata->u.sta.supp_rates_bits is set only when we actually
> join an ibss, which is not the case in this scenario; so we assign
> zero here. Then, the code in rate_control_pid_rate_init() calls
> rate_lowest_index() for some reason, and since no supported rate is
> found, this warning is issued.
>=20
>=20
> The question is how sta->supp_rates should be initialized:
>=20
> - we could initialize it to our sta's rates, but then we could
>   probably transmit to a station at unsupported rate
>=20
> - add new ibss station only on received beacon, not on a data frame;
>   currently, beacons are ignored for this purpose (they just update
>   the bss list later on)
>=20
> - something else (like 1Mbps only)?
>=20
> As soon as we do sta_join_ibss(), this warning won't happen again.
>=20
>=20
> Note that once we have sta entry (in our ibss), we will update its
> supported rates based on beacons it sends (in rx_bss_info()).
>=20
> Any thoughts?

I don't know. I don't use IBSS nor am I intimately familiar with the
specs for it.

johannes

--=-PFD2j0IKPRx7EHeGfMym
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBiAHqVg1VMiehFYAQLR9A/9EXX2K7CXcnThxd9JGSVe31HS42HvrXSH
cnvowErynHwTKOjo08OmMXrm/z85d7y82pdNA+spdessIUlRbqkVY+Cj+6tnnMNB
B4qokmPlmEHO5/HdUaFX06rKxZ4DFWcMj/NLD7s/Eplf6xE0h2iwXXUnvEYupgZ6
5Iz6KG28HUMJODMJ7PbXabzZ95orpjcs1G4bJoZa14l1QIvonhN0HIfXE18ZvTfz
G+lNjg+X16pp9d5qYY+DUfxCgyi9NURN23y4eFqN27JDJTUkeBrVmQ+2rRyzmoPx
2EPNaGWKJ0hxPldsAgZSeGJSIIZFWKINwwep3BEsl+WF+YzLKN5YBLctQ5pEkq/I
kniLoUeNsyDIvephCIsx9KH/wx5Dbi+0xG3KuGiNgsVT6ehFljG22/s7cSMzNHgg
V3TgwL8lsiT6wdT8A84ixfcMlKksDPwhJj/6qhxwMdOWL7qglFdnfcXdiHcYVV+C
anKsumX/IaC4amTSNHqvScP172f7qXUXT1m4Q9T25CeBZ/z0+JQpff10q0ukczN7
pSsQS1WUZpJnFtnUKVjU2rvFWrr69pHxhb1GkH8Y2I5OKNkJZsX3OcDwJk8V1sY2
U6KsVm93UPzV7s8Ek7niqPHfDXt6htJJIE6ChahBjXkjhmztJxW5ZKnivitrB1eM
j86ZTElcuvU=
=J0Rd
-----END PGP SIGNATURE-----

--=-PFD2j0IKPRx7EHeGfMym--

