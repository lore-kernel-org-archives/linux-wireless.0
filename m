Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46160 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYCIUeV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 16:34:21 -0400
Subject: Re: [RFC] mac80211: handling Qdisc issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	Michael Wu <flamingice@sourmilk.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <c85cb4470803090443v3748a986vfc909c984369a4a7@mail.gmail.com> (sfid-20080309_114343_064052_1ED56F11)
References: <1204822307-5111-1-git-send-email-ron.rindjunsky@intel.com>
	 <200803061902.33865.IvDoorn@gmail.com>
	 <1204826767.25502.135.camel@johannes.berg>
	 <200803061927.09891.IvDoorn@gmail.com>
	 <1204829243.25502.137.camel@johannes.berg>
	 <c85cb4470803090443v3748a986vfc909c984369a4a7@mail.gmail.com>
	 (sfid-20080309_114343_064052_1ED56F11)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dvM4aVtIHVHP9lAKX26N"
Date: Sun, 09 Mar 2008 21:33:38 +0100
Message-Id: <1205094818.6387.46.camel@johannes.berg> (sfid-20080309_203436_614621_088AA6DC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dvM4aVtIHVHP9lAKX26N
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> John, Johannes, what will be the preferred way to continue? it seems
> that Ivo and Michael agree that the adjustments needed can be inserted
> quite fast. would you like to re-base and merge the current RFC as a
> patch and fix things on top of it, or to merge all the fixes and push
> it at once?

I'd like to take a look at it first, though if you tested it and it
works we can just as well put it into -testing, it can't really be worse
than what we have now.

What I'd like to do though is just make mac80211 depend on
NETDEVICES_MULTIQUEUE (or select it if possible?) so we don't have to
bother with all the ifdefs. OTOH that'll totally break compat so Luis?

johannes

--=-dvM4aVtIHVHP9lAKX26N
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9RJoaVg1VMiehFYAQJdmQ/+J5LL8kHE9IZgBqRPW56zKVLU2Jriu4+M
SCm4qilC86d57sNuov4gW2XToykhAPP9Rmrr/BRqxDU82U+HPprYvjBZM9lCUM0u
I//igKIcGrQP9f2secs5nRLTxnhCeAdzmWQbasCQw3CKYyQvNVKVCKj6ZrWdzgY0
CvzYUcp/NfV9yebWZ4/xhWXXLgy+faQMkQGtREKB7KZQ7xJNwnf78JT53IXfdqC+
UY9Ze7+kC+FNd0B+nTAcXdn5K1AuJhfTHQOo+0SUjlsxX8rfvRLqS87D46bzk6Vr
QtP96ygt69WwsXrgqz2hXuXx9yJPyFbnbGlA3tzgYmZE6URrx8MnRwB9RlOdoYWq
L9c/VZ4KLk3+eOBJF2oKDa4Y/6Sb16ME2/8HA58ZstJGbfXDHCSVTA0K+RnzdPFh
vnEv+h2VDto3bkPLkRDjUchMAmA+UBan27x7ZagqDFFXt0Y87REzFAmsOoKJ4lFD
iKe4Nppm22c26S0Y+2o7Lf0DimSpkWeJmZ2QT82Z5GRzN741jUjezdzIcZDC1A1c
rCGcKx5NzwXq6e7+bWY4eSZoHZQrfLFMKPkYQRX11wlqtEt4MR2uUquqsQ7yKhUx
OKuMb5LK4O2NCcz+k6aUnStsd+AtKVi6Cr9JMn4rVJYeRCqE/z3GUZDEj9aciYc5
uvmftDJKU34=
=WUlQ
-----END PGP SIGNATURE-----

--=-dvM4aVtIHVHP9lAKX26N--

