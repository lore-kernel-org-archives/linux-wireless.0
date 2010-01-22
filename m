Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45291 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab0AVO22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 09:28:28 -0500
Subject: Re: [RFC/RFT v2]: compat-wireless for 2.6.32.4 - multiqueue
 backport support
From: Johannes Berg <johannes@sipsolutions.net>
To: pat-lkml@erley.org
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	lrodriguez@atheros.com
In-Reply-To: <76acc753e1ea73bdffe1a9772f58bba2@127.0.0.1>
References: <20100121230600.GC8069@bombadil.infradead.org>
	 <1264152878.11396.82.camel@johannes.local>
	 <76acc753e1ea73bdffe1a9772f58bba2@127.0.0.1>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Hw//KtmwA/ChZsg5rnXK"
Date: Fri, 22 Jan 2010 15:27:54 +0100
Message-ID: <1264170474.11396.86.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Hw//KtmwA/ChZsg5rnXK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-01-22 at 09:14 -0500, pat-lkml@erley.org wrote:
> On Fri, 22 Jan 2010 10:34:38 +0100, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2010-01-21 at 18:06 -0500, Luis R. Rodriguez wrote:
> >=20
> >> +#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23))
> >> +static bool ieee80211_all_queues_stopped(struct ieee80211_hw *hw)
> >=20
> > You want "all queues started" :)
> >=20
> Are you certain of this?  I stared and stared trying to see what case
> the function would behave as a "started" check.  It loops through all=20
> queues, returning false if it finds any started queues.  If it makes
> it through all the queues and hasn't found a single started queue, it
> returns true (to indicate all queues are stopped). =20
>=20
> Or do you mean, as a second function?

No, I mean instead. The function is named correctly for what it does,
but it does the wrong thing for the logic where it is used.

johannes

--=-Hw//KtmwA/ChZsg5rnXK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLWbXmAAoJEODzc/N7+QmaNB4P/150UjtGrlD3UEHZlt51AMHG
5MKVI6wPl+IyxbvDfNtW8a+42RA6e3EBZpvr3nB+mfFi5Qc7axljNkXIcuEZCGZO
i/RmFllRLQQVCsJ670SZsZkaZt/PNAPNfhXtLuVmFtHHAjlL0aTEjkGpAXsiC5wn
Rp3LzqsiqCu4juZ51OvZqr0ElSt+8YO67gr3qWaQaQJbwrStx08n+TcgUJbC5dLY
L2NVPMcrUEIVY6mWspHmh7Ay5no97hZ+8axf5PRWD1MPTw7qEHl7unH38WTYjofc
wuvViru1RTYbSR5DLC1khdAABgvIXVN1DiBuZcRom79hwt7hoEvpaYgt5q2IaEXz
R2M7ejamGtElxmRDl6D6GanW7GuBLXpbhi6ZWcaLDyNQw4kqXahN+Ps9bXiIx3qf
Dpbp7COKDYLI4jle1Vr/cfK/cAUFPDcrQ9HJVNBCj0GBWtra3N/yY8JrMU3Uk7C1
AJev6+LWIFgZyBqNWHUIYvYLtZmvIEdDutpD2Pwq4HUHsbxTi0QXO02GsK/dk0Ch
e6Kd4ZD6ZQMwzJ2p+kulIrmtzCCuLLCe5tGBwLved8NNXhEerYqiIAV50jv5cAIb
WlhIcouTm3h2042CCi7aJGjHjjA83opnZwmky14AL+jZCUUfqtRIt4QmKdkz2STF
iQVqziAPNEaEJdkLMceN
=SUe1
-----END PGP SIGNATURE-----

--=-Hw//KtmwA/ChZsg5rnXK--

