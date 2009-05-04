Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38070 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbZEDSCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 14:02:43 -0400
Subject: Re: [PATCH] mac80211: report operating frequency rather than
 current
From: Johannes Berg <johannes@sipsolutions.net>
To: Richard Farina <sidhayn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <49FF2AE5.6040104@gmail.com>
References: <1241452330.8683.49.camel@johannes.local>
	 <49FF2AE5.6040104@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vrVBhOO5dakBFI5eSLe/"
Date: Mon, 04 May 2009 20:02:10 +0200
Message-Id: <1241460130.8683.85.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vrVBhOO5dakBFI5eSLe/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-04 at 13:50 -0400, Richard Farina wrote:
> Johannes Berg wrote:
> > It's not very helpful to see, in iwconfig, the current frequency
> > the card is tuned to if that frequency is currently somewhere
> > across the board because we're scanning. Since we keep track of
> > the frequency the user wants, display that instead.
> >
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> >  net/mac80211/wext.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > --- wireless-testing.orig/net/mac80211/wext.c	2009-05-04 17:41:53.00000=
0000 +0200
> > +++ wireless-testing/net/mac80211/wext.c	2009-05-04 17:42:02.000000000 =
+0200
> > @@ -185,7 +185,7 @@ static int ieee80211_ioctl_giwfreq(struc
> >  	if (sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC)
> >  		return cfg80211_ibss_wext_giwfreq(dev, info, freq, extra);
> > =20
> > -	freq->m =3D local->hw.conf.channel->center_freq;
> > +	freq->m =3D local->oper_channel->center_freq;
> >  	freq->e =3D 6;
> > =20
> >  	return 0;
> >
> >
> >  =20
> Nack.  People should see the hardware channel. If I set channel 6 and my=20
> wifi card is on channel 11 I need to see 11 not 6.  Doesn't make any=20
> sense to show some imaginary idealistic "I wish it was on channel 6"=20
> when the hardware is on channel 11.  Am I missing something here?

Umm, if _you_ set channel 11 then you _will_ see channel 11. It's just
that when it's scanning and happens to be on channel 132 instead of 11,
while you previously set 11, you will _after_ this patch see 11, not
132.

johannes

--=-vrVBhOO5dakBFI5eSLe/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/y2gAAoJEKVg1VMiehFYubIP/2WQBfUTyDJ6ZMefbF8YoZAA
xQ2E3RfABLruXpZTK3SOOuO9o2G8E4JAMCkD2TvzvTv85ohoucNRmV5rzKtGTvlc
aFiWnh58FIDOP2GaMQ3fVI3d5oklyMQpaGfBL4F2kc75YZWQzvOCHNmMAj6CjprX
sGqulxQDkRlDhPhjR3fP1VsW50ostHWyH4bh8LRQrZpFQtlP1pnlhcgeOz7t76k4
GAqlbSTysL0V4hMUkc4eZjnJq3RYjWH1YLtF1bfickmxxduPktt3woCE0GHA9WhS
NhyawnngmL6ohcd0z+A4Ls0NkcD9ETkIZtDDjkXiYWHtvGyIu4gmChTz/JQSY0c9
cMrZRu86VYK2+gEVNTcdfseXjtltn8XLcyqIx46wjYOeJ4dViFNWeOSaNSiilWlU
bwUFQFFInF2vKu2lFemVLt24IzxetoG1BTZxu1vbRxo1tQ+xsaRwPCRV2RRZr73k
SWMoR/RmZ9o44enFPOv3ZWxN0LUnr7IuBZjpHfCX5wswg7ELC4jZe+64wXfGkfJH
4CRZr1JL9Yc0nRPWWtCFlEAFTwxswlEjqSlVOcetV5i95zm+PnnblML8s0FOnjfE
8bXe8ILIx4sRpci5HeC0c7Hn9i+PjrNH7T9mc48wbVZYBm2uiEci6Mfn6htaYDA+
bcwG54vvV4vKI4h1Fvwv
=9b9K
-----END PGP SIGNATURE-----

--=-vrVBhOO5dakBFI5eSLe/--

