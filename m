Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53232 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbZCHOZj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2009 10:25:39 -0400
Subject: Re: [PATCH] mac80211: Fix WMM ACM parsing and AC downgrade
	operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090308141703.GA10782@jm.kir.nu>
References: <20090305152346.GA30029@jm.kir.nu>
	 <1236515287.4205.11.camel@johannes.local>
	 <20090308141703.GA10782@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dZVHGO8QscFzvRUqXBZ0"
Date: Sun, 08 Mar 2009 15:25:33 +0100
Message-Id: <1236522333.4205.37.camel@johannes.local> (sfid-20090308_152541_839043_D6BA6253)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dZVHGO8QscFzvRUqXBZ0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-03-08 at 16:17 +0200, Jouni Malinen wrote:
> On Sun, Mar 08, 2009 at 01:28:07PM +0100, Johannes Berg wrote:
> > On Thu, 2009-03-05 at 17:23 +0200, Jouni Malinen wrote:
> >=20
> > > @@ -99,10 +99,13 @@ static u16 classify80211(struct ieee8021
> > >  	/* in case we are a client verify acm is not set for this ac */
> > >  	while (unlikely(local->wmm_acm & BIT(skb->priority))) {
> > >  		if (wme_downgrade_ac(skb)) {
> > > -			/* The old code would drop the packet in this
> > > -			 * case.
> > > +			/*
> > > +			 * This should not really happen. The AP has marked all
> > > +			 * lower ACs to require admission control which is not
> > > +			 * a reasonable configuration. Allow the frame to be
> > > +			 * transmitted using AC_BK as a workaround.
> > >  			 */
> > > -			return 0;
> > > +			break;
> >=20
> > It seems to me that return 0 here was incorrect, or wme_downgrade_ac
> > needs changes?
>=20
> Yes, this return 0 was incorrect and that's why I'm fixing it to not
> return 0 in this patch.. ;-)=20

Sorry, I meant correct. Why is it not correct? wme_downgrade_ac doesn't
modify the skb when it returns an error.

> In theory, the correct behavior would be to
> drop the frame if the AP is using mandatory admission control for all
> ACs, but in practice, it is probably better not to break the connection
> completely if the AP is misconfigured. The behavior after this patch is
> to downgrade the AC until one is found without ACM and if no such AC
> exists, use the lowest priority (AC_BK).

True. I'm just questioning that this really is what's happening with
this patch :)

johannes

--=-dZVHGO8QscFzvRUqXBZ0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJs9VbAAoJEKVg1VMiehFY6nkQAK0JswuivrH3kqsxcgZrJ6/c
P48TYCO0IdiSZ5pfydt134iyVlORe2bJQRRJzVEJdORYz4l/gWZt/wTGlAZitf9/
4AVgpXVktpqF9f/GAhsbrB5rY4X3+bH419XFn+cXHpzMbnQHk41vqM9gvvGLY8eZ
M9Wu2LmpEitJJ4KV+LeUVxkYRAkmhepchzgiHX9xxw3l1WvXbUqL1ZSoG0MBfDsz
ibhvgIw1vAewwGBgqh303BGZ8ou3gphHWi356uuZOVu6xoIH+kG/IZvRXhJsBDJo
GcEF2YnXIO688c8Q54eLGMpDtj65dgqRM9bkHmRcqJ+G3UBTqRJM6CqOMUyRtesk
dVEwhZS8+AmuYfH9QIKyV/JBVu+1HrPl6+ZgCaj6rg8ysZzuWK0bySM5Fu6JNNjw
51ZuZBvuyIGwz3g1d0DJCvrJRWiV6LV0DuRB76gSqOG/JPBQOlk3UL2A0IdNvCi+
IxiLg1rPOtdCDwqoK2IDpvDThGJwba47H2NEEB4qBFq8pwOgabcLRNqhF77w9Bc1
jFNyZrOFxOZgK6agfdNXVWaIBn/QinJV+mOvDvoE45vJV6r5jZch67LjYaNBnz/l
xPUtbGceZ7qLf3/0gC5xpc5YvWUW40KcmRC2+8pXuxMP0WSSBxzOtNvoxkGGkO/Y
jmEDD41+ZhZvZuHyljXY
=gHjc
-----END PGP SIGNATURE-----

--=-dZVHGO8QscFzvRUqXBZ0--

