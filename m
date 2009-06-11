Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54651 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758507AbZFKKJV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 06:09:21 -0400
Subject: Re: [RFT 2/3] ath9k: port to cfg80211 rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <mcgrof@gmail.com>
In-Reply-To: <20090611095949.GD10126@vasanth-laptop>
References: <20090602111027.460530075@sipsolutions.net>
	 <20090602111112.191915040@sipsolutions.net>
	 <20090610132015.GA10126@vasanth-laptop>
	 <1244644712.26814.6.camel@johannes.local>
	 <20090611065203.GC10126@vasanth-laptop>
	 <1244714262.4706.7.camel@johannes.local>
	 <20090611095949.GD10126@vasanth-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sx1kLrP+7jlfMV4eNy5L"
Date: Thu, 11 Jun 2009 12:10:03 +0200
Message-Id: <1244715003.4706.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sx1kLrP+7jlfMV4eNy5L
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-11 at 15:29 +0530, Vasanthakumar Thiagarajan wrote:
> On Thu, Jun 11, 2009 at 03:27:41PM +0530, Johannes Berg wrote:
> >=20
> > Well, the thing is that currently ath_start_rfkill_poll() will never be
> > called until you try bringing the interface up, afaict?
>=20
> right.

But that's undesirable, especially if for some reason we already know
it's in rfkill, we really want to know about the rfkill state even when
the interface is down so userspace can properly react to it and not even
give the user the option of bringing the interfaces up.

Hence my suggestion of moving the start_polling().

johannes

--=-sx1kLrP+7jlfMV4eNy5L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKMNf4AAoJEODzc/N7+QmaWZkQAInkjp6BdJFQAOd/Mq5aw838
xXPT/e5cSH+UwlGXbAS3E0UYG3BV/aHeRR5B1AaYNxu0Vu5S0DudD7ieLF8qvHyH
k6sJEpbZCIp6OFM9kROlutfq4vQelu1ZKEUNAfCvyvUaHxuJ4iARlZWtpVqCDUuI
b3ihUZi9eQgceYtmq8cf5gRuz1hMdNBDynp8uIFIQeDR8QDqF1OJqVbgVs503nDQ
BDzZLROYlYs9mXeoCXgNIa3A5tXxZmc6Ww3iqEzS851v3SBjBDriSrYytWpKjFW1
3/9Z7KhtjNxiWCEudHIFe6XZGYesVHhjm2i6Dzfm7t0Kf7AKwYplzOqY3nHLvSP3
A7x7Rw7B8juh3/YQVHtXy/qc7jDGtUXdkiTs/TLnOigmN/jLV1fHCnnEDMF5xsVr
unhHRlgs9NurX81Q3kiy8fUH2K9CslvdQQuI20qj2x9KWAtp3VSvW01VuzmBqABc
t0vvEGhcppYRav3+Twb7z4UNO2cHrcrCpuH3VnpWES6lWXBen2mkaV16seNGuvbT
6d7hxrGV75UWeqR/HH8zX3b9997UPzfcz7o1J27trF+jkZ+5If+3yqzMVpnKCHqQ
5g6BielONw5mg48vVVcPcSpzUwXDoxUI8rHGBzjzVnsThSNPvBOrmKD43R/hFNAy
yvJhLqtCX8kM33+wdp7L
=87uR
-----END PGP SIGNATURE-----

--=-sx1kLrP+7jlfMV4eNy5L--

