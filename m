Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39369 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbZGaQnh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 12:43:37 -0400
Subject: Re: [PATCH] cfg80211: fix regression on beacon world roaming
 feature
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
In-Reply-To: <43e72e890907310932u4510fc6fwc0c3dab598036041@mail.gmail.com>
References: <1249001028-15110-1-git-send-email-lrodriguez@atheros.com>
	 <1249026324.29587.15.camel@johannes.local>
	 <43e72e890907310849l3487b8a2p52302f6662a26f95@mail.gmail.com>
	 <1249055782.20312.19.camel@johannes.local>
	 <43e72e890907310903k65be4480j3279253281f2935e@mail.gmail.com>
	 <1249056713.25587.6.camel@johannes.local>
	 <43e72e890907310932u4510fc6fwc0c3dab598036041@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-cZaDLjv+8+aCEZGJ8U1C"
Date: Fri, 31 Jul 2009 18:43:31 +0200
Message-Id: <1249058611.6549.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cZaDLjv+8+aCEZGJ8U1C
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-31 at 09:32 -0700, Luis R. Rodriguez wrote:

> Its not that simple. Consider the fact we build our own custom
> regulatory domain and stuff what is intended for each one of them. The
> _orig stuff is set upon channel registration so it is correct that
> we'd have to avoid setting the channel flags prior to wiphy
> registration. How you do that is left up to implementation. Since
> cfg80211 will set the channel *_orig params based on
> wiphy_registration() you're only option is to either prevent your
> wiphy being registered with the flags set or to reset the channel
> flags on the reg_notifier(). The later seems like the way to go but we
> currently do not call the reg_notifier() upon beacon hints -- we
> currently only call the reg_notifier() upon regulatory domain changes
> and upon wiphy registration. My point is both of these options require
> considerable changes for 2.6.31.

Aha. So the problem really is that we don't have a reg notifier on
updates due to beacons.

> > and set them in ath_reg_apply_beaconing_flags and
> > ath_reg_apply_active_scan_flags, changing the polarity?
> >
> > I mean, right now you tell cfg80211 you don't support it,
> > and then try
> > to support it anyhow.
>=20
> Not sure I follow, support what? The reg_notifier() is there for
> regulatory domain changes, we didn't call it upon beacon hints. We
> can, and I agree its the right approach, but not for 2.6.31.

I'm thinking more in terms of iwlwifi here, for all intents and purposes
it doesn't support beaconing on channel N, so it only supports NO_IBSS
on that channel. Which is what it puts into flags before registration.

> > Instead, you could tell cfg80211 you _do_ support
> > it, and then not support them depending on the notifier? It seems like
> > that should work and not break cfg80211's assumption that you can never
> > ever support _more_ than registration flags (orig_flags).
>=20
> I'm not following at all, orig_flags do not tell cfg80211 the channel
> flags the device supports. Most devices set flag to 0 upon wiphy
> registration and therefore cfg80211 sets orig_flags to 0 as well
> during wiphy registration.

Well ok, "supports" is a bad word since we're talking about
restrictions. But for iwlwifi the orig_flags _do_ tell cfg80211 the
channel restrictions that the device _requires_.

Your devices, however, do not _strictly_ _require_ those channel flags,
they just require them for compliance. Unlike iwlwifi which crashes when
you don't do it right :)

So I think we're in agreement -- the proper solution would be to call
the reg notifier on beacon hints too. What we do for .31 I can't say I
really care, how much work do you think this would be? It doesn't seem
all _that_ bad, at least for core changes?

johannes

--=-cZaDLjv+8+aCEZGJ8U1C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcx8vAAoJEODzc/N7+QmasnQQAM2mRtxA0UdDW09IU2g46swY
ftrtXIfFZe6X5Mg0rbuDYG2PwFG7kYt+U4p8U7iHv09yK46fdkJnYCc7XYq1OKze
3QF7VcRiIDrJXOlSutZINUDARCGFevMeqY5GZ7Q6Gy2mw5lju8Cl02O7ZTT2wI42
we4nMPftQWra7BkGqka2TCvioEmNEJFnegqFdZ0ZgN4FN3n1Ra+KsKTtS68W3T6l
JFWTrVSM42T6K+ocPMh8WM6sj7/CgSpWvKXtRuGeKkkd2vCuaF3hPEulGoCi3f9g
abIile981mt27pzyQdY563IhGAAsF/YXFIvMKbt/nrU/hYBaQEv54nuazb0MeXqg
sHpTGXfBe6fiH2ZtcpSod2CF0xvq0hVYJjWQhoHVsS6FfBXLeUDs7fxZzCLi4MA7
HNboU8a9Ls/uFzNWFPJFesrkcpJSQPX8u0u3ZT4ciW2arRFQrWrQ2J/vrzVdHhS6
e7FpuVZnFjt32I4xvEIqCYqnopj5qwpeSwkorN4rWVmkdFxoXfGwlg1nfHBHG3vb
dYbBSa8hGZhwy13Pay15Jz4Hj/sghfVE+tNDjr7j7LPasVrVBYfy7JYM9tZQgS22
3KYeHJbTso8zQKMll8tmjPg1XPUFCK/VcMbMZ63dSjo68AvuSV9QH0vrGgWTPmwu
W5aa17uSV3Ns0iyYujAg
=FS0d
-----END PGP SIGNATURE-----

--=-cZaDLjv+8+aCEZGJ8U1C--

