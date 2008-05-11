Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45568 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbYEKLtU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2008 07:49:20 -0400
Subject: Re: [PATCH 4/5] rt2x00: Convert rt2x00 to read control info from
	skb->cb
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200805111333.14214.IvDoorn@gmail.com> (sfid-20080511_132305_062541_1C8DAD85)
References: <200805101349.19481.IvDoorn@gmail.com>
	 <1210454412.12837.16.camel@johannes.berg>
	 <200805111113.53138.IvDoorn@gmail.com>
	 <200805111333.14214.IvDoorn@gmail.com>
	 (sfid-20080511_132305_062541_1C8DAD85)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ztFphizwPcEirf8rD6h3"
Date: Sun, 11 May 2008 13:49:05 +0200
Message-Id: <1210506545.3646.22.camel@johannes.berg> (sfid-20080511_134923_747781_D8110482)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ztFphizwPcEirf8rD6h3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-05-11 at 13:33 +0200, Ivo van Doorn wrote:
> On Sunday 11 May 2008, Ivo van Doorn wrote:
> > On Saturday 10 May 2008, Johannes Berg wrote:
> > >=20
> > > > +	/*
> > > > +	 * Don't automatically kick the beacon queue.
> > > > +	 */
> > > > +	tx_info->flags &=3D ~IEEE80211_TX_CTL_READY_FOR_TX;
> > > > =20
> > > >  	/*
> > > >  	 * Fill in skb descriptor
> > > >  	 */
> > > >  	skbdesc =3D get_skb_frame_desc(skb);
> > > >  	memset(skbdesc, 0, sizeof(*skbdesc));
> > > > -	skbdesc->flags |=3D FRAME_DESC_DRIVER_GENERATED;
> > >=20
> > > Could you live w/o that change? I'm pondering removing that flag agai=
n
> > > since it doesn't have any meaning any more with the fragmentation/bus=
y
> > > reschedule rewrite I'll do.
> >=20
> > Not a problem, I had already removed a few instances where I used that,
> > and will remove the remaining bits as well.
>=20
> Hmm, things could be much easier for rt2x00 if there was a mac80211 flag
> that would indicate if the tx_status should be called or not upon txdone.
>=20
> I used the IEEE80211_TX_CTL_READY_FOR_TX to make sure RTS and CTS frames
> were not reported to mac80211 when they were send, but would it perhaps b=
e
> better if I used the flag IEEE80211_TX_CTL_REQ_TX_STATUS for that?
> I remember that some time ago drivers weren't supposed to check for that
> flag, or at least not to determine if the tx_status should be called, but=
 has
> this changed and can the flag be used or should rt2x00 keep track of what
> should be reported and what not?

Yes, it probably would be better, but we haven't figured out useful
settings for that flag yet. I'm fine with unconditionally adding it to
all frames for now though.

johannes

--=-ztFphizwPcEirf8rD6h3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCbdMKVg1VMiehFYAQICeA/9FPuuA1vYgl59K4Q2G3oRKiahO86bWV/+
axRHeRWeqO8A8rE5OqwvLyexY1iS0FJn02bNCGBV4AcFDqHOKMJa/NHAU0BCIuE9
cc1TNtplaNRspe61sSjb9xNB9RLo9wsUKu7uCMu0u1dSTC4rbCnuX1JuUkyn3A7N
qkeczR53yffQZn9P/CT8z+6+uMKtJ/b+dzp1a1ASypHCG0aZ/Y3a3iaIW166Cgt5
Xd3gh0nkoaVHj0u1wm/uMI04B2wlKFqiBWucmeMcYS1akHFv1iLEWgjTxME9+Tm2
Egm1wLTw1PkU3583wC0eNgTU0Fbbq+nc6YgoZkLAlAXvEg6o6tJKJxr2CjTANp+Z
SK+ccPJQ5fR9xlSWOVQtTQhGwRUK5uym118uxtLzaWm4/9SPM/6+z+DSmw0MUE56
pgngN3Wjaqu4ZTr395QU5bvCzrg+SFcAK0Mk9rHw4Y5HtAYm9qYkG3kV5iMZZ1Nu
slp7mtWPE3ZDOQ8vZiyNI4AqE6Nukq+5hwTPuNAm5rR0qofVQn+I0FO5e1OUHk5+
ouK9PDMUqegDET53aZOcJrosJL1jkzsEMs+9u65G435VS5F7pbDU7dWnZ1w7Btd2
r+5r0JuakrWbxHIYE9gl82rCWuGI8sy1WRj2RWJA+DH7QqJN5vceLNRSphqNYk81
C9eatzNTmu8=
=rhMF
-----END PGP SIGNATURE-----

--=-ztFphizwPcEirf8rD6h3--

