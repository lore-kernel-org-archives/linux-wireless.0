Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40718 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYHCI5f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 04:57:35 -0400
Subject: Re: [PATCH 5/8] rfkill: add WARN_ON and BUG_ON paranoia
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200808031007.48877.IvDoorn@gmail.com> (sfid-20080803_094427_981847_2C6CB62D)
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br>
	 <1217700664-20792-6-git-send-email-hmh@hmh.eng.br>
	 <200808031007.48877.IvDoorn@gmail.com>
	 (sfid-20080803_094427_981847_2C6CB62D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PW+l+rUluuP8qusQitan"
Date: Sun, 03 Aug 2008 10:57:25 +0200
Message-Id: <1217753845.4721.1.camel@johannes.berg> (sfid-20080803_105741_544158_E93821F8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PW+l+rUluuP8qusQitan
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-08-03 at 10:07 +0200, Ivo van Doorn wrote:

> > diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> > index ea872e5..d5f95cb 100644
> > --- a/net/rfkill/rfkill.c
> > +++ b/net/rfkill/rfkill.c
> > @@ -76,6 +76,7 @@ static BLOCKING_NOTIFIER_HEAD(rfkill_notifier_list);
> >   */
> >  int register_rfkill_notifier(struct notifier_block *nb)
> >  {
> > +	BUG_ON(!nb);
>=20
> Probably better:
>=20
> 	if (unlikely(!nb) {
> 		BUG()
> 		return -EINVAL;
> 	}

Heh, not really, in fact, it will most likely not even compile to any
different code. Did you mean

if (WARN_ON(!nb))
	return -EINVAL;

maybe?

BUG() never returns. Same for all the other places you pointed out.

johannes

--=-PW+l+rUluuP8qusQitan
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIlXLxAAoJEKVg1VMiehFYlo8P/Ao4bmh2aPcjKVOXNKHHK8pi
zNcy3irdV8tk/kHsiL99wF22Ti0pvtOkVTPay9XvHfmJeUde/WSHkNk/gtdFrAlL
u4amViPGZ8E5BOHo9jNNvzb8MZqVmznf22AONsDLmA4OgmCr8LRXKEbMSjXheTSs
lcUD8pgfbPi5diVOyMGPy8iWr0id/yL0/Isyf3fsk4968TV/B+pOGX19eVSaHKR0
JjuAR2vlA3aAuxvB1syXKNYN284wQaUuWFdopZkmKkqUjR2PdYh+rgtpEj5sJje6
tDs46a6KpQiGE+85J2wcrmCWsxNwZGFIYaRTIl3xrfbRwKnuWDh3c9gFnp+w4mab
KgZiCcTM9OkboSo+oO6DZi4PvU6CF90FOFXkPGtXe9STRNCb+U3DF8/fruZKHW59
Ern17tzSYXDYJl1hRKN6Ew1fr50RjKqMIq9akwUx8Pyn5SfvwmQ1b9IEDIPrdfFX
mKDzUBGLTV+N+FIs4epLwAE+vRphtrdl81o6xBZfK4seYAH3x1Gdrn55eTaiqPbs
ZfUAfpwLl0xaq/tL8V+ZY7KBCeOaB/yqculyZQTIqcvLddRXfFlzfKk25CYiEHfA
AzBqIsUpMMngwiSob4+RdeGCBR8UFGzywifsY47HL+kRJAcCzYHBt2ZoZHYB7+xd
8w8V8+ybn+xt2RZXl5cD
=Kgju
-----END PGP SIGNATURE-----

--=-PW+l+rUluuP8qusQitan--

