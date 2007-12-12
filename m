Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53742 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbXLLSJe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 13:09:34 -0500
Subject: Re: [PATCH] try 2: mac80211: Fix swapped parameters to
	ieee80211_set_channel()
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Lunn <andrew@lunn.ch>
Cc: flamingice@sourmilk.net, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <20071212180204.GP31218@lunn.ch>
References: <20071212153158.GB16947@lunn.ch>
	 <1197481426.6558.138.camel@johannes.berg>  <20071212180204.GP31218@lunn.ch>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LvCgloeT1fw6G8xjK9mC"
Date: Wed, 12 Dec 2007 19:09:29 +0100
Message-Id: <1197482969.6558.149.camel@johannes.berg> (sfid-20071212_180937_711926_82CF467E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LvCgloeT1fw6G8xjK9mC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-12-12 at 19:02 +0100, Andrew Lunn wrote:
> > Good catch, but please resubmit with tabs as indentation and CC John
> as
> > he gets to apply patches. Or I can send it on if you wish.
>=20
> OK. Here it is with tabs, and with CC to John Linville

Except now you have a bad patch description. Keep in mind that the patch
will most likely be applied with automatic tools :)

I'll leave it up to John whether he wants a new one.

> Signed-off-by Andrew lunn <andrew@lunn.ch>

Acked-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>=20
>=20
> diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioct=
l.c
> index 7027eed..50d4a46 100644
> --- a/net/mac80211/ieee80211_ioctl.c
> +++ b/net/mac80211/ieee80211_ioctl.c
> @@ -344,7 +344,7 @@ static int ieee80211_ioctl_siwfreq(struct net_device =
*dev,
>                                         IEEE80211_STA_AUTO_CHANNEL_SEL;
>                         return 0;
>                 } else
> -                       return ieee80211_set_channel(local, freq->m, -1);
> +                       return ieee80211_set_channel(local, -1, freq->m);
>         } else {
>                 int i, div =3D 1000000;
>                 for (i =3D 0; i < freq->e; i++)
>=20

--=-LvCgloeT1fw6G8xjK9mC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2Aj16Vg1VMiehFYAQKJuA/7BdSbRjiqikJNGHJ6OJu95km14DDV39FQ
hW2AAmTlsdZUYEuk5z2vlIW8ZI3ryaBq61BAcnV9lPfdlUh+l2sisWCotjM1il06
2wGHJj+gmeYvYMEnWAwbB/Nak5qlNTeVgos88vVmPEx2rkdQWluL9HMyXR4Wk0Id
Gwym5yNfL4q73DTfDwy/OPDArJVadwxv+Djgsu2N5oef9iHsmR+UcoTMF64PgarF
2BzVKu5Csnywxyaei1GMl+tzWtVDE8AZr69rCaRYNpE9rsrv3jtyKfyQ1Z1zgAOK
tV1cvgXTXz7srf74Xnse/e5ysNQO2uf2Mg9i93tXfg/RQQv615Vymeznxry9FLjE
4DTGBh8DknPCs9JEMQlf9kOCgh9nRB0mTEhcdRnt3AV4txQ/Ko93LMvUJSYIaTXr
5Nqujexhaur2PGhlmW0Rv2XQI5xWwqOSGPhZOTqsz7qnwrBTs2Zx0dWOC+hwWmQZ
pn/AlF1T2mhf9f0+Y1HyaRsGLbs8syEp09T7wBeDcoSWPYnRA+rdLrKNupXiijSx
m96ehkXdqmp1hCXIVGGjtpdGrq3yxL9bUm5/vfydKjVG2clXvi9spsOIP0aDr6Ti
7+huQP61ksQ3ZbUpYBJLed/6zW53kXAcjrduKnsZY9lkvpkdOrO+c59ZkXx4v0Ql
OIxnTXmFGdo=
=4+//
-----END PGP SIGNATURE-----

--=-LvCgloeT1fw6G8xjK9mC--

