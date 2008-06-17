Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52418 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266AbYFQS2t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 14:28:49 -0400
Subject: Re: [RFC PATCH 4/7] 802.11w: Use BIP (AES-128-CMAC)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080617181050.GD4974@jm.kir.nu>
References: <20080617154008.883383150@localhost>
	 <20080617155920.329586297@localhost>
	 <1213722347.3803.89.camel@johannes.berg>  <20080617181050.GD4974@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VZNGxZOG6PSNGyDQZZO/"
Date: Tue, 17 Jun 2008 20:27:57 +0200
Message-Id: <1213727277.3803.105.camel@johannes.berg> (sfid-20080617_202851_738565_67C638F7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VZNGxZOG6PSNGyDQZZO/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-06-17 at 21:10 +0300, Jouni Malinen wrote:
> On Tue, Jun 17, 2008 at 07:05:47PM +0200, Johannes Berg wrote:
>=20
> > > @@ -603,30 +605,38 @@ static int nl80211_set_key(struct sk_buf
> > > -	if (key_idx > 3)
> > > +	if (key_idx > 5)
> > >  		return -EINVAL;
>=20
> > > -	if (!info->attrs[NL80211_ATTR_KEY_DEFAULT])
> > > +	if (!info->attrs[NL80211_ATTR_KEY_DEFAULT] &&
> > > +	    !info->attrs[NL80211_ATTR_KEY_DEFAULT_MGMT])
>=20
> > I think this should probably check the key index depending on the type,
> > i.e. only permit 4 and 5 for mgmt and 0-3 for data keys.
>=20
> Yes, I started doing that, but did not cover all places yet. It's
> somewhat unclear to me where this type of validation should live, i.e.,
> what piece of code should know that key indexes 4 and 5 are used for
> IGTK at this point taken into account that the index could actually be
> 0..65535.. Anyway, it may be safer to do it here than to trust on other
> places being able to handle odd indexes for data frame TX key index.

I tend to think cfg80211 should do it since I don't see a reasonable use
for it when the specs/drafts don't specify anything else. I think this
is part of the mistake WEXT made with requiring the drivers to check the
input sanity everywhere and duplicating that code into all drivers etc.

johannes

--=-VZNGxZOG6PSNGyDQZZO/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWAIpAAoJEKVg1VMiehFYegsP/jOfKAwyTWQ/Nte5btFVDw8V
TNYnqaZcnyfFNboyhNrwrN5CQtpSBf5ewzXJjMEhpD5cm0cAkpYnf9L9VAtuVzhf
BvWz+U7y3lCrJcpkp1qWzvyfUHVCM5H6Fv4tMKMYF3WEXC2z/F67Bs3s9g4dzQPn
q/2qLutqYaThl46fJ77nfEk3euKmJfRMR5kNIZHzPwa8vTw/mVOh5fSr3SnPWVIs
kMDuwW+vN4nfNc5apCI8qwjQu4/8voO7fV3Sq64PMuIA7TqtKvpQLsPlHRD20Cal
IGZE4qIwdp55GSCOplQeos/Phc9LfkNkV+taln9Vnb1vSQbkkLmRailIg0aaZ6Xr
gt5Z1G7HFJxeQJoZeOmJt/4iUO2hhdlzT5w9EBGQZd2b9HLtBEiCAortsJpA+Wxi
t8IkGj4QY1aQRtnHZT9yD4y2ZMadVo3n7+IjymhO11mlq6n88lN72oqdaFr4wFfe
Dexpw3Voevmoqkd6mBGn9nuMGLTSiCvPqRuBwzK351WHmOSVtRsoQZF8w60vf+7L
8WG6oXgKRXJJINo4PFld6J0VgWqfqMaXBK3SCMEKVqM5OSuuGii+svqFq6IW3pW+
ZET8rby/qSzcmb2Qmbq2uyxKrqGKrj2nAVgwFFqcrlA6QFvFDw//JBusXfnkIli7
vfk9byPctf1X715Cs1Bc
=jlZD
-----END PGP SIGNATURE-----

--=-VZNGxZOG6PSNGyDQZZO/--

