Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35187 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141AbZELWQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 18:16:17 -0400
Subject: Re: [PATCH] mac80211: make noack test available
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <69e28c910905121513t5436ec52u47d0c49657000090@mail.gmail.com>
References: <1242158740.14227.12.camel@johannes.local>
	 <69e28c910905121513t5436ec52u47d0c49657000090@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-XFZg47LNfjN6WnYdfHjv"
Date: Wed, 13 May 2009 00:15:45 +0200
Message-Id: <1242166545.14227.13.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XFZg47LNfjN6WnYdfHjv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-13 at 00:13 +0200, G=C3=A1bor Stefanik wrote:
> On Tue, May 12, 2009 at 10:05 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > There's this internal wifi_wme_noack_test variable that
> > we use to set the QoS control if set. For one, it is
> > unlikely that it is set. Secondly, if set it needs to
> > influence the IEEE80211_TX_CTL_NO_ACK TX control flag,
> > and finally we should also be able to set it at all, so
> > make it available in debugfs.
> >
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> >  net/mac80211/debugfs.c     |   38 ++++++++++++++++++++++++++++++++++++=
++
> >  net/mac80211/ieee80211_i.h |    1 +
> >  net/mac80211/tx.c          |    5 ++++-
> >  net/mac80211/wme.c         |    2 +-
> >  4 files changed, 44 insertions(+), 2 deletions(-)
> >
> > --- wireless-testing.orig/net/mac80211/tx.c     2009-05-12 21:44:01.000=
000000 +0200
> > +++ wireless-testing/net/mac80211/tx.c  2009-05-12 22:03:26.000000000 +=
0200
> > @@ -1087,7 +1087,10 @@ __ieee80211_tx_prepare(struct ieee80211_
> >                info->flags |=3D IEEE80211_TX_CTL_NO_ACK;
> >        } else {
> >                tx->flags |=3D IEEE80211_TX_UNICAST;
> > -               info->flags &=3D ~IEEE80211_TX_CTL_NO_ACK;
> > +               if (unlikely(local->wifi_wme_noack_test))
> > +                       info->flags |=3D IEEE80211_TX_CTL_NO_ACK;
> > +               else
> > +                       info->flags &=3D ~IEEE80211_TX_CTL_NO_ACK;
> >        }
>=20
> While you are at it, why not clean up this code completely?=20

Because I'm lazy.

> IMHO the
> unset-bit operations are useless, given that both TX_UNICAST and
> TX_CTL_NO_ACK are initialized to zero at the beginning of
> __ieee80211_tx_prepare.=20

Probably. But it works, why change it :)

> This also makes it possible to set
> TX_CTL_NO_ACK in a TX handler, which is IMO much nicer (not to mention
> that it significantly simplifies the work needed to support Radiotap's
> TX flags once they land).

That seems to serve only you ;)

> (BTW should we implement the already-stable parts of TX flags now, or
> is it a better idea to wait till it is final?)

Wait until it's final please.

johannes

--=-XFZg47LNfjN6WnYdfHjv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCfUKAAoJEODzc/N7+QmaglQP/iq9hy8EwQXc/1V1UfrrMPMc
U+qro6PpwplB+i7Cx8VrvQapESYkhiDBY74YbKxzwfqIHHm+JEXZtWoeZOza1cua
fkqp8Cot8xyrnqh6aCMA7gthU7CY7Wjh9JNjMlwfDcYNyTy3gNhwJNntf7M5MziL
ijvvM6enEPzhq13f+6FvdExmFwuKGhJcvNJAd+bP43RpJ6A/QevxyDsg2GLLB/6Y
tkEA0SemLshvkoA0OnJkSn2qMa2at0dAWJj3FdKbR9BmGQyDDu5RXzQUdCQfLuiP
W8slTx88yFakNBNmkfjd+FopGVixTyqmdaVPxKhKgBFozqyF7Vsbun2mvfJI39GL
ycthBuGBq6RRZ8JQ7GNgrNgpDMgiGNcCu69YMP3Dpd0YfnfWTcvev+AYPjYXap6g
h1YloiMJcfSeF884iyZ+zxVy7le55qTLhUqO57t2CG9RM4wmn/MGFAOOnoZoFK3c
a7C+Rgi9FVxcH9QS8i5Zzz7QyaUL3Rf+rYMcysgb/Na9gvhoSz8q1eRHcRh0ZDkC
xErmHPWBe9I+rLufzpaSONOiU09J6sHOHTpWZ9QUoxnKXqbliKItQ2N4ii87gxEg
kJrMixddoaC4l4Yw8y9xwBxGE+eesifiTr9ZVI7zpIkhxOknXWgLLTCjoVqOzdjL
0v6JGMtRhrq4arlNIPZh
=FslY
-----END PGP SIGNATURE-----

--=-XFZg47LNfjN6WnYdfHjv--

