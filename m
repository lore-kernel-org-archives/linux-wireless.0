Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50433 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYI2Lw3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 07:52:29 -0400
Subject: Re: NL80211_CMD_GET_WIPHY reply doesn't fit into nl message buffer
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
In-Reply-To: <48E0BE3B.7030204@gmail.com> (sfid-20080929_133839_921679_18457E97)
References: <48E0A65A.2060102@gmail.com>
	 <1222682480.7064.16.camel@johannes.berg> <20080929102021.GE10429@jm.kir.nu>
	 <1222683923.7064.18.camel@johannes.berg> <48E0BE3B.7030204@gmail.com>
	 (sfid-20080929_133839_921679_18457E97)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IXjjxpQxW1kIeAafYCTI"
Date: Mon, 29 Sep 2008 13:52:22 +0200
Message-Id: <1222689142.7064.24.camel@johannes.berg> (sfid-20080929_135233_382487_DFD72D14)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IXjjxpQxW1kIeAafYCTI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-29 at 13:38 +0200, Jiri Slaby wrote:
> On 09/29/2008 12:25 PM, Johannes Berg wrote:
> > Jiri, can you tell me what happens with iw? iw phy phy0 info or
> > something.
>=20
> [iw from v0.9.5-1-ged69ad9]
> # ./iw phy phy0 info
> command failed: No buffer space available (-105)
>=20
> as expected :). It depends only on how nl80211_send_wiphy() is written (t=
he msg
> doesn't fit into NLMSG_GOODSIZE).

Yes, I just wanted to confirm that the code there fails. I'm hunting a
strange bug in the hostapd code now, but other than that my patch (plus
a bunch of fixes) appears to work and reduce code size.

johannes

--=-IXjjxpQxW1kIeAafYCTI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI4MFzAAoJEKVg1VMiehFYF5wP/0QzxqZyvDI5QoJ2lgi8w2e/
fjemlUbrrONHXot/DDg0B5YEoe1o0Gnsrnft5RyyHXGBMtBYL0NJwUCwyTtqapDw
Seo+wkOho+9JZD4cc98+qNQdgp0qfjADNQiKB6/gZCII0YyCz+jCNuEYdDjJT/+v
LJ5BhUTArCYCuZCRlmIu9wMAxxNEnr5S6x6Zulzh0uexrBnkYDNdMBADHM6maFxC
IJiXyWLCUJAMxl4h/Ak4GsKk+nos0v3zHCaI9WMTo2LQkcvZx3TSyMxhXfRmJZ0Z
ovrW2JjpV8jEbiD9TAdTM7nq02K8luJ1nnedOnvofjrsul4mwzC60PQ0OZy6NFj/
3M9io1+5gKM9sYVhR9E9i9aM0dKD70dU7Ch+aPV5jxgAdQfn6gC23UrjFLAwqbrD
jrOEDWSfiU+QneHVhgZ52xyX8EKJ0B2i7fuQYpyu7gIBPZ5PYv7L/TxPTsUSVvsP
3IZJbRspcpxGEd60CNpHlDiWXDGdhZzVoudAcyijpxV5NHVjo+kib15qFW9ZTvSR
ouoczgOKO3fWUXiTznAxnHNCwNSHDwUQ6ntmw+932BGlvFbRCK0UZegMB4ZZffwY
Fps1AGkA6FwGQDa9/XB+/8iKgNOKyhFZpFWzwMdsV0YQ3Jd/ERpFu0QiPx0n+Hlc
SAbY9eg0Hj920jBW1gGK
=Akll
-----END PGP SIGNATURE-----

--=-IXjjxpQxW1kIeAafYCTI--

