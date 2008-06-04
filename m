Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38519 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073AbYFDPpB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 11:45:01 -0400
Subject: Re: mac80211 ad-hoc mode problems
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <1212588799.13676.11.camel@localhost.localdomain>
References: <1212543664.4237.14.camel@localhost.localdomain>
	 (sfid-20080604_034126_005983_906C2124)  <1212570001.14371.16.camel@johannes.berg>
	 <1212588799.13676.11.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QhY5tOnwV3A1rc031Jtz"
Date: Wed, 04 Jun 2008 17:44:12 +0200
Message-Id: <1212594252.14371.36.camel@johannes.berg> (sfid-20080604_174507_071271_02BCFB7B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QhY5tOnwV3A1rc031Jtz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > > 4) Is the association expected to survive a up->down->up sequence?  I=
f
> > > not, then we should be sending NULL SIOCGIWAP event whenever dev_clos=
e()
> > > gets called.
> >=20
> > No, it's not, yes, we probably should send that event somewhere. Is it
> > ok to send the event while not associated?
>=20
> Yeah, there's no ordering or pairing guarantee for SIOCGIWAP events
> since there isn't an association transaction model with WEXT.

Yeah, true. You can either stick it right into ieee80211_stop, make a
new mlme-stop function that is called from there, or maybe do it when
the AP's sta_info struct is removed?

> > > 5) mac80211 requires the device to be down when changing modes.  That=
's
> > > fine; but requires a patch to wpa_supplicant to handle this.  This wo=
uld
> > > cause failures when switching AP that were different modes from NM.
> > > See:
> > >=20
> > > http://lists.shmoo.com/pipermail/hostap/2008-June/017894.html
> >=20
> > Don't understand. How can you switch to an IBSS AP? :)
>=20
> Sorry, when switching from BSS -> IBSS, like picking an IBSS from the
> NetworkManager menu while you're connected to an AP.  Or, creating a new
> IBSS while connected.

Ok, but that means you disconnect so you lose all configuration anyway.

> > It's probably fairly easy to remove this restriction because they all
> > use ieee80211_if_sta internally (sta, ibss, mesh) but since I don't car=
e
> > too much about IBSS and see mesh as being quite different, I have no
> > motivation to try (and test) this.
>=20
> I think it's fine to leave it as-is.  At least prism54 required the
> interface to be !IFF_UP while changing modes, and I think madwifi has
> required this too at some point.  This can be handled in the supplicant,
> Jouni and I have already worked out what should be done and I'm going to
> update the linked patch.

Sure. As far as I understand, even if mac80211 would change in the
future the patch Jouni asked for would then not down the interface.

johannes

--=-QhY5tOnwV3A1rc031Jtz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEa4S6Vg1VMiehFYAQKUoQ/9Eg9wtNmMBZk/TdbIl/TZny7AaUema66F
6Jttay1x5rw2gDRnJzntV74Sm2HISdt/f2q4eIAcRGsJDTRNbInha4kbZf0NCC3p
KsDBiwUfzbP3fngRrhptpMmaV1RJ00BIG8+5V+2jliJSAUNRsi9pY5mVMOHqmjam
blROojtlXDUbTnUG6XuIPuaUMpjVuZRvtath5YCRkoDRlrihzXoNGb9CjwHTMxDI
IqWv5ogHz/Wg/di0xdORoCMuWd316tV+lvwCmNOJjcd/nAami6LMChGpEoDzhBlH
qkWwm1Tz2TVdZuXiTYGinl9BldtK3k19eKkc9UqmShn+lhFulw1brsYU0KdcdUBn
erDDcABDV5LqwgxwjeCPrZnbPo32oAZ9tanFNJg0aGhPXp56mxMjbbFzU2KWK7Mf
stKghNO3bnNFlOD+p93nhHOWtxBeZYAUwgmMyGiQb24SWhM15GXdsbROL8za8HyQ
pWuK501Iw7skUIh1dFYSNkIPeWaRqgkEp9h16ivyX0l7UMVnsKtNDH6NLu2OMfvZ
aCODbrJA0bUrYOzdqZbsjHl8TH5Vov+iXthECCFGZ22/c98zPWOAoBLxI95KNo8K
i62+T2shyAV6NEWg++e3CbNZcyitIWhwYHH8ZqNsy8oRRa1BdWOntzlTeJ972hPc
7OHAMqcKUYo=
=a6eU
-----END PGP SIGNATURE-----

--=-QhY5tOnwV3A1rc031Jtz--

