Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43797 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbYHGP1M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 11:27:12 -0400
Subject: Re: [PATCH] p54: Fix regression due to commit b19fa1f
From: Johannes Berg <johannes@sipsolutions.net>
To: Chr <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>
In-Reply-To: <200808071727.19129.chunkeey@web.de>
References: <489af6ed.hkTX0XTOTIkENssK%Larry.Finger@lwfinger.net>
	 <1218115671.23048.174.camel@johannes.berg>
	 <200808071727.19129.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Jkdop/kX943bE4fmRsCy"
Date: Thu, 07 Aug 2008 17:26:36 +0200
Message-Id: <1218122796.3630.4.camel@johannes.berg> (sfid-20080807_172715_743520_D0344115)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Jkdop/kX943bE4fmRsCy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-07 at 17:27 +0200, Chr wrote:
> On Thursday 07 August 2008 15:27:51 Johannes Berg wrote:
> > > +			priv->tx_stats[le32_to_cpu(entry_data->frame_type - 4)].len--;
> >
> > Sorry for not catching this earlier, but this looks wrong, the -4 surel=
y
> > should be outside the endian conversion?
>=20
> likely... let's do the job properly for once and for all.
> --

> +			priv->tx_stats[entry_data->hw_queue - 4].len--;

> +	u8 hw_queue;

Ah, heh, so it's not a u32 field after all?

johannes

--=-Jkdop/kX943bE4fmRsCy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImxQoAAoJEKVg1VMiehFY1+8QAIRxVLi4iGJ0ALd7INnjCF4k
slTMbvWXYU53yoHpxpx9hOk673K0qtdjAOY/PmEck9rx7VzteAuNVO/UElQF/AYt
On6B+2cegUgQUs3FmpvnTtdHk1DPLA1reSb2vJbNlEj7LGvfxcfYKPcou6ME0lD/
vjPz22cSeSmVhgLGsgL0oTmaediTWpsPAgGEkywZz9rGxlFwNP0YVyBPme2lGaH/
9VlIzERJ9PRBvGOED1AAUYlMCJdKwoUQhUCQjBS/3GDPrq/YzomBZmSJMa+IqeRe
eM2VSJbcat/GxJmtpi9UR4I1nIiDx3qtVth95e9vuCcmR+GK7H9gmzxvSkqre0gL
BfiWbk6tSnMfNw3zKy4mVLvG0wDLh8sW5+UT5raECTghCu7fpXXvkKKfTO65QNsR
zQAHDe67oJ7xtcf/sff1oovEYeDddt8wc9wRpFkOKK4ilItxYyaMAtX5GRFir3pa
geDb6P4pRrFuInGcgLbv6V3HFUCquc5KCAFXj1eQgwx7SvuYloQZ2pWyGnv501xC
/ix2HAfhABQ5E4vFJRWJ/R72oPueXdWXvgFu3boZ9F7Un/4XomBlqwz2eN1hVSCQ
MKbchhCUV4ioq6Eta3dTyeqlTkFHwy3XcNRST5HY2rgaZ9Fe2Ab/TApNC1a3Nwlr
SmkWfe+mmVd9dBs160Yj
=KOLo
-----END PGP SIGNATURE-----

--=-Jkdop/kX943bE4fmRsCy--

