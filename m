Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55421 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbZLAMyU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 07:54:20 -0500
Subject: Re: cfg80211: questions regarding cfg80211_ibss_joined()
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200912011347.38068.holgerschurig@gmail.com>
References: <200912011347.38068.holgerschurig@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9cCogaoorWn9aFJBw5VS"
Date: Tue, 01 Dec 2009 13:54:24 +0100
Message-ID: <1259672064.32171.76.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9cCogaoorWn9aFJBw5VS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-01 at 13:47 +0100, Holger Schurig wrote:
> Hi !
>=20
> I'm currently adding IBSS to libertas+cfg80211. Now I'd like
> to get some clarifications:
>=20
> a) when I create a new IBSS and i get a successful response to
>    the CMD_802_11_AD_HOC_START firmware command, I need to tell
>    this to cfg80211 somehow.
>=20
>    cfg80211_ibss_joined() seems appropriate, but "iw event"
>    doesn't show anything. Is this a short-coming or an indication
>    of an error on my side?  Also, "iw wlan info" or "iw wlan link"
>    doesn't show me anything at all.

Are you running into the WARN_ON(!bss)?

> b) the docs to cfg80211_ibss_joined() says that I need to call
>    cfg80211_inform_bss() "with the locally generated beacon". I don't
>    have any idea which beacon my firmware generates, so I guess I
>    need to fake some beacon data. Correct?  Which IEs should I add?

As close to what your firmware is generating as you can get ...

> c) cfg80211_inform_bss() has a field "signal". However, when I
>    ask my firmware to start beacon, then I don't really have any
>    signal level. If I add "0", then "iw wlan0 scan dump" shows me
>    this as a signal:
>=20
>    BSS 02:24:54:25:0f:24 (on wlan0)
>         freq: 2412
>         beacon interval: 100
>         capability: IBSS (0x0002)
>         signal: 0.00 dBm
>         last seen: 6184 ms ago

Eep. Yeah that seems like a bug, I guess for an IBSS we shouldn't be
adding the signal attribute at all.

> d) And finally, for "u64 timestamp", is it okay to just submit
>    a zero here?

Probably shouldn't be added for an IBSS either in nl80211.

johannes

--=-9cCogaoorWn9aFJBw5VS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLFRH7AAoJEODzc/N7+QmaiDUP/RPPHbI8xnE9h7x7WM74QExk
ll1ZU6SVC0b5Iy/5MUuYExahii9X2VqGV9ytbjZcDXEvsKWJofxsUDiPCf32Vcbt
Mw+YpSozQZhUCis3ZNdR2CDLO1DEwxeuGcCNKQg83i2tGmKp5qgSRiSRcqnqArgI
Le5x/eSc90w5rnNIQtdd49lfxX8IhFJrZ3xdsWQ0CfeDdcKM/oPWOgPUGWegEKhM
l+9+wWVJdKg6bxkEUbCmYkT44Fi2YGODVoAWnNPQ5GAh8oLEeMGJZllXsYAJaowO
aV/PGVxcC+G1K1eywWw9wXYXneKJSEU7HOjrmBzV4+CCMH0dbkbtmMSyX6nlP+5c
VjNgGRoYv1vJNNSqJ1ikdKEIvx/kDhH1Haek5QNIegIR4K6q+NM5rH/ON/+ld2FJ
qIiUtHuYqV/j6OE02sMnHpWrq0jnv3ZSB/7XBFWnheabGGcyiaPcO42nIQt5G2DP
y5HFm1IoU6dfykafHR4tq0xIASW2HIUKh8qKS6fmVFbL+F77VLQO06ZNDMjO6Kn5
8FaF0lx0nu6UXRE77cSKt5a/rsDNwDn1XBu7UPMaAWDz4mqvrhgj8w6lsgvYwqkO
GSAjEgbcHStziGgKW+jR4GrvP4oByKx3h1yws0KmaV4zCx7Et76/4vhf9vvIv4NF
SjOYI++3ldc0to3OPU+n
=QYvc
-----END PGP SIGNATURE-----

--=-9cCogaoorWn9aFJBw5VS--

