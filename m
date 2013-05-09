Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:45571 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab3EITq2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 15:46:28 -0400
Date: Thu, 9 May 2013 21:46:20 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH 2/8] mac80211: fix various components for the new 5 and
 10 MHz widths
Message-ID: <20130509194620.GA24307@pandem0nium> (sfid-20130509_214631_972367_DC87BF56)
References: <1368123036-22721-1-git-send-email-a>
 <1368123036-22721-3-git-send-email-a>
 <518BEB88.5090600@openwrt.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
In-Reply-To: <518BEB88.5090600@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Felix,

On Thu, May 09, 2013 at 08:31:36PM +0200, Felix Fietkau wrote:
> On 2013-05-09 8:10 PM, a@pandem0nium wrote:
> > From: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> >=20
> > This is a collection of minor fixes:
> >  * don't allow HT IEs in IBSS for 5/10 MHz
> >  * don't allow HT IEs in Mesh for 5/10 MHz
> >  * consider 5 and 10 MHz channels when downgrading
> >  * don't try HT rates for 5 and 10 MHz channels when selecting rates
> Why? HT rates work with 5/10 MHz just fine.

Hm, to be honest I did not try - IEEE 802.11-2012 only mentions 5 and
10 MHz channels in section 18 (OFDM PHY) according with timing and other
parameters, but nothing like this (as far as I see) is mentioned in
Section 20 (High Throughput PHY).

On the other hand, it appears that AR9xxx based chipsets also support
2.4 GHz rates (DSSS, ERP-OFDM), so I can imagine also HT rates can
be supported as well.

The question is, how would we handle that? Allow HT IEs also for 5 and
10 MHz, and behave like it would be a 20 MHz channel? Are there any
other WiFi chipsets which support 5/10 MHz, should we consider them
(maybe they don't support that)? And what do others think about deviate
=66rom standard? Personally, I don't mind, it would be cool to use HT rates
on these bandwidths too. :)

Cheers,
	Simon

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlGL/QwACgkQrzg/fFk7axZe4wCg0YCBqPNQ02TbKpf5lHYUiYGo
oaQAn3J50xKJGgBrNwSvSFpq6Ssu6HxO
=dGq9
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
