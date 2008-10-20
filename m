Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54346 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYJTHJw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 03:09:52 -0400
Subject: Re: [PATCH v3] mac80211/drivers: rewrite the rate control API
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <1224486368.24677.184.camel@debian.sh.intel.com>
References: <1223996147.10113.33.camel@johannes.berg>
	 (sfid-20081014_165703_092655_BE6BA58D) <1224052607.3027.20.camel@johannes.berg>
	 <1224484940.24677.169.camel@debian.sh.intel.com>
	 <1224485319.18024.9.camel@johannes.berg>
	 <1224486368.24677.184.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MPSxTtUnf2YXN36HePD7"
Date: Mon, 20 Oct 2008 09:09:47 +0200
Message-Id: <1224486587.18024.25.camel@johannes.berg> (sfid-20081020_090955_907499_1350EEA4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MPSxTtUnf2YXN36HePD7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 15:06 +0800, Zhu Yi wrote:

> > > > +       info->status.rates[0].count =3D tx_resp->failure_frame + 1;
> > >=20
> > > This is useless. And it is even confusable with the later count++.
> >=20
> > In what way useless? We've changed the semantics and made "count" be th=
e
> > "transmit count" rather than the "# of retries", so it has to be one
> > more. Or was there a bug in the previous understanding? Wouldn't
> > surprise me, and we can fix the bug here.
>=20
> I understand the +1 here. But you set the [0].count anyway in the later
> for loop. So setting it here (out of the for loop) is useless.

Oh, ok. I didn't see that.

> I have to look at documents for more details. AFAIK, the uCode handles
> the multi rates retries.=20

Yes, I know that much, but can you tell us how exactly?

> The driver passes the starting rate and how
> many retries for each rates to uCode. Since the uCode is possible to
> retry more rates than IEEE80211_TX_MAX_RATES, the info->status.rates[]
> might not be accurate all the time.=20

It would be good to actually report as accurate as possible (up to
MAX_RATES) the retries the firmware will have done. We're going to
export that information to userland in radiotap too.

johannes

--=-MPSxTtUnf2YXN36HePD7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/C63AAoJEKVg1VMiehFYS7EP/2X4Y+W/FtT7WJInBJ3EE92+
WkM1afQExmBGCEX6HH1ysc5P/jN3PaWSpRxYhiR9wkMN7dh5pjPFJt0fxdkCMI6w
fC34cDWsbFfeAGeUaHike31DvgBvOT4trBHV0WeuYKrpPjYUUeNC7N3FcbmOBmpq
pl9vYPSZaz5xCNT8Anvqwun//PVotVbccAuR31+0OHIGrs2e2I8W3XmOo7hrSxml
ewvoKCkW5xueLDj+7fdmqjUC+0ek8iTuDl0L/xn2+9mR9aaKKLTRGcoywYOUh2qz
6oI2Gpz10/Wgo1H1o+UPn4E/ptDHpSc5cMiY1rTeD/0P3aVbnxzTSIh1L5/BrjX5
5t2Wet+yib3lAfYMs3wH3EBmG53YqIXL1sRXWXtZnN/3OuZ71MsNxQ1K4GXY84Cs
Vh2G7uigL/4Doh1jBo/nPNu+04yk5YWQUhoj4p05e9ERpK9QRYYRXHyaEJJ43+rZ
qqQQqNn12rzQlrU7xkL6IrZtQYLoGW7iF2NJy7t/fSXJqF/ipjWqWc8LBkCl48ZA
YT+ndQ+nOH5GdGCt7Chqn3ieK/Ta4PbBsjEJ8FOQ/yoofRd5ga4WDveIWao0+cQz
7yV/HoPmbHAikXwmZAvG5vwWd/GlpktoaoCzV0IyNanCvOt7Y9pbcA2R6lJuDpD1
EygT5+1rUSgKybVJjgvY
=qmae
-----END PGP SIGNATURE-----

--=-MPSxTtUnf2YXN36HePD7--

