Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37391 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbZHXUR2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 16:17:28 -0400
Subject: Re: Kernel Panic in __ieee80211_tx with p43usb as AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chr <chunkeey@web.de>, wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <4A92F2F5.6000909@lwfinger.net>
References: <4A92F2F5.6000909@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mEEFse5gcbgyaRu/a6fy"
Date: Mon, 24 Aug 2009 22:16:56 +0200
Message-Id: <1251145017.12661.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mEEFse5gcbgyaRu/a6fy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-08-24 at 15:07 -0500, Larry Finger wrote:

> All went well until I had a Windows Vista client connect to the
> network. As soon as I launched a browser, the kernel on the AP crashed.

Rather strange.

> The kernel in question is 2.6.31-rc7-Linus-00012-g3edf2fb from the
> mainline tree. I do not know the reported reason for the panic, as
> that scrolls off the screen. The traceback shows the error to be in
> __ieee80211_tx in this statement: ret =3D drv_tx(local, skb), which
> makes the problem be here:
>=20
> static inline int drv_tx(struct ieee80211_local *local, struct sk_buff
> *skb)
> {
>         return local->ops->tx(&local->hw, skb);
> }
>=20
> Are there any suggest changes that would let me debug this problem
> without crashing the kernel?

Are you sure it's right there, and not maybe in p54's tx routine which
gets called from here? I mean, the only reason I see for this particular
line of code to go wrong would be corruption of the "local",
"local->ops", or "local->ops->tx" pointers, which seems rather unlikely.

johannes

--=-mEEFse5gcbgyaRu/a6fy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKkvU0AAoJEODzc/N7+QmaOV0P/RvXhE/MKfQqIXw600gll3bH
5Li7A68rdAO6RYijmDxutpBcuGZts/jGZm1SdTaNdBK8Z4OWODgYN3AEGzZVXoNq
sFptb5LnAi/wsUx52nwEEffsnQKrfyuHVjWWsJEYmR1AYudOnrsE1dj2hrHfQUDW
NG2++CyJ0l6AcuvE/US1YIo5evoJyD4DlVPuAfc6pK7LcCDPUuFBrPsc5VNEw20q
zJutA8mLxgIy/qhKwhA4Ja0i233GZP1k0d34IsNXnAyn6westBxayOBU+fP47EBX
LwSEzR16oI715LU8YtURhTmCwlsAK4bj0HRnCcOcPtMoqnLcMtCcEnh+wfGq8iCr
YdvIvDv5rlRH73BJDpzUfxl/IJh4bPQt76RReJLzu5h8XxdcEy7aOWGEuZ8tvz/M
i2OlFhE+F0OBZZqLiufvL8MsAtvgz/53nc2CpfI5yRN476ciqr89qcmrblwXVyJu
1T/iXrx7WCQOqU6js4miBAwId8ibGYI2ygWYs1q2BZQeRfrl3SqIncyuAw6+bVvl
vjx/7wdNrqTbuf3+zBH0dJ1OIkFEfQnsPiHqp7lk3r0uKV+flIPr3ThvvfP40Yah
yRfVIQ+wXjcyko3bsoNjweC0N29Aa3KRcd8Z5vAQ8pKo1E9MMUs+S7O+GnHJ2Pjk
MsiQBJqcrB4edrluhyay
=8tD4
-----END PGP SIGNATURE-----

--=-mEEFse5gcbgyaRu/a6fy--

