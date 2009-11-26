Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48451 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbZKZSNC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 13:13:02 -0500
Subject: Re: [PATCH 06/12] wl1251: fix payload alignment
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <877htd9v5a.fsf@purkki.valot.fi>
References: <20091126150141.917.35278.stgit@tikku>
	 <20091126150904.917.8182.stgit@tikku>  <877htd9v5a.fsf@purkki.valot.fi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZcF8sCFddABMWem4fgLl"
Date: Thu, 26 Nov 2009 19:13:03 +0100
Message-ID: <1259259183.24540.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZcF8sCFddABMWem4fgLl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-11-26 at 17:13 +0200, Kalle Valo wrote:
> Kalle Valo <kalle.valo@iki.fi> writes:
>=20
> > mac80211 complained that in some cases IP payload was not aligned, this
> > happens if the 802.11 header is not aligned with four. In that case we =
have
> > to move entire packet to make the payload properly aligned.

Eh, turn off the debugging option ...

> > +	if (ieee80211_hdrlen(*fc) & 0x3) {
> > +		from =3D skb->data;
> > +		to =3D skb_push(skb, 2);
> > +		memmove(to, from, skb->len);
> > +		fc =3D (u16 *) skb->data;
> > +	}
>=20
> I would like to get comments about this. Is memmove() the right way to
> do this?

mac80211 takes care of this for you, after warning :)

The point of the warning is to make developers aware that alignment by
firmware will be better. If you can't put the packet into the right
place directly from the device, don't bother, the memmove is done by
mac80211.

johannes


--=-ZcF8sCFddABMWem4fgLl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLDsUsAAoJEODzc/N7+QmaHtUQALAbRdJEP86g8f9thLnDW2Al
s31G+89eaWQfSjN7TYUyoG5qGK9ZN9Q7aFO5IsyJ+Xke0D7DjwYyVPB9ysQPKivc
2blS3xBBDcB5mbwOofSqnqXum9jcVepuGjWPx3NuWL93ZR8BUx9XqAnHfFjxaTFx
s4TiXjYvHXT15irWUTXIUHeupHNtCkY41UU/VgpmgXt0A7mu4vcVoD7SFpzrWLTS
QN49VF3wZzk8pwX3V1urAEEW4HfAboDyOxwmFH3XMMPRqkcwUACpbQrFibsIBG4m
X5HRiUhch7AW0Va5GmeqIau7IYQvMCS7WXtDYuEt3mohoOyv3at/misDj4xmMbbb
tTBzoLb0Frq9nDysEumsDWeIO6bWWAmqy2qBYsQEGSAq4I4O07vIjgbD2kGlmmeH
6aiWf7QUFLnquqW/ZLYbCkNbU6na2NHMq+DuYb6Wx86IvwiP2cOQiX9Wja6lXHpG
lu+OtnhJwZBqOjEf0oWajml6Dzpfyv79CFZMTDM38YOWgX4nm4FVzaXm33zuBSVG
nCDf2UCDNj4pGoxo36pTgoL4Voi5IWlHbwKqMX13N1AGsaCpLYTCdP3fJ2W4GbIP
k5wl0f8raph/TcQoD3nTcD6OzNipvjVYi+oiCWo/4grl4cpgX+a718q9WfRIIlyq
5hYrFqDxGgEYaU2afEm9
=o5ct
-----END PGP SIGNATURE-----

--=-ZcF8sCFddABMWem4fgLl--

