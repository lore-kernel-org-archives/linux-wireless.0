Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45194 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbZBLKYh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 05:24:37 -0500
Subject: Re: soft-safe -> soft-unsafe lock order detected
From: Johannes Berg <johannes@sipsolutions.net>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1234433807.16004.88.camel@johannes.local> (sfid-20090212_111736_123131_223B74EE)
References: <4991AC67.90104@openwrt.org>
	 (sfid-20090210_173417_726855_7504F887)  <1234433807.16004.88.camel@johannes.local>
	 (sfid-20090212_111736_123131_223B74EE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Q/pXpQtw2SH2VWjiKfoJ"
Date: Thu, 12 Feb 2009 11:24:06 +0100
Message-Id: <1234434246.16004.90.camel@johannes.local> (sfid-20090212_112441_463797_1D72571A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Q/pXpQtw2SH2VWjiKfoJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-12 at 11:16 +0100, Johannes Berg wrote:
> > to a soft-irq-unsafe lock:
> >  (todo_lock){--..}
> > ... which became soft-irq-unsafe at:
> > ...  [<800b2248>] __lock_acquire+0x624/0x844
> >   [<800b24c4>] lock_acquire+0x5c/0x84
> >   [<8006b8c4>] _spin_lock+0x34/0x48
> >   [<c0206d9c>] ieee80211_set_default_key+0x4b8/0x4f0 [mac80211]
>=20
> That seems to be incorrect. ieee80211_set_default_key will have
> _irqsave-locked the key lock, so the todo lock is here always locked in
> an irq-excluded section.
>=20
> The lock is, however, possibly used that way in ieee80211_key_link,
> which can be fixed easily and we can remove the todo lock too.

Not true, but the todo_lock should be made to _irqsave in some places,
it seems.

johannes

--=-Q/pXpQtw2SH2VWjiKfoJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJk/jDAAoJEKVg1VMiehFY97AP/3XnVr42i3AnK22yy4uJ8UGq
laMtQxGLX7kVKoSF4qRPIdp0hFOpFizLXTxgs5Htbzxo15p8Iiw17aRcmPyHlgH1
9l3lRa+ovV9dR9HgfpWf0288ZwoiZWdzXaywL5JBA3WTJDT7l5EvCrm2RnnZExkS
26YGxIuM43ff18p8HO1uSTB+ek0QuxUjdYO860tvp4X4pWuK+LNYY6Y9115b/TNX
5Z29K+L3sK4XAlIkqmw9RHe7bEhTkTg2M/4TjbVJChHvEY+pEH5ikMmmYVVywU5L
8F1IDU59liGCnnykQOn40cC0Lpj5gKHvcW0bqEbhT1UwUFX0oCP+aMeQuABF2dyF
uJlhIR+1pIdmgPmR+8+WH11avpz6Wh3E8YFM0u/S+AzoHl0WZRQcV+gSwHQ+JpU7
SHc7aAlwQiDnVJnWSrPVKtG7S7sBlXwIpS7oc/sJUDolAaGaedH1Al8o6nMUc9PP
NGtENCs8qpuCPNg/Ig9+7e1FheVdJQ0zDyggFwPpFi09MvGCd0ktpl7RevDFmY+E
XM60bQfiJGsvWjE8GEVBoAtOROyUHd5ZNLK3tsWSGbVsEheoaEk3fgWSkqNFBLJ7
D/Q+wzuQFXo6v894M4QZMk+2qTXx0CfKodYP9UmTNYgnKoxamRrYM7rpf3bvzDiw
XqGzBMWqN1KnXmRzlcKl
=5U5y
-----END PGP SIGNATURE-----

--=-Q/pXpQtw2SH2VWjiKfoJ--

