Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:11469 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754875AbXGaFYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 01:24:52 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] zd1211rw-mac80211: debug output for mac80211 ops
Date: Mon, 30 Jul 2007 22:22:58 -0700
Cc: Ulrich Kunitz <kune@deine-taler.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org,
	Jiri Benc <jbenc@suse.cz>
References: <20070730023128.99E927B409F@zog.reactivated.net> <20070730225205.GA17252@deine-taler.de> <200707310105.55863.mb@bu3sch.de>
In-Reply-To: <200707310105.55863.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart51562753.kE9pW7Ug5z";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200707302223.04696.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart51562753.kE9pW7Ug5z
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 30 July 2007 16:05, Michael Buesch wrote:
> I suggest you look at bcm43xx-mac80211.
> You will need to introduce refcounting for your monitor interfaces
> and I _really_ suggest to get rid of the zd_op_open() and zd_op_close()
> functions. Just include that in add/remove interface. You need
> to refcount your interfaces anyway.
>
Requiring refcounting for monitor interfaces is fairly dumb since mac80211=
=20
does the exact same refcounting. I haven't bothered to do it in any driver=
=20
ports yet for this reason. This part of the mac80211 driver api needs to be=
=20
fixed.

Also, I'm not entirely convinced that eliminating the open/close callbacks =
is=20
a good idea, which is why I continued to use them in the zd1211rw port.

=2DMichael Wu

--nextPart51562753.kE9pW7Ug5z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGrsc4T3Oqt9AH4aERAv6mAJ9jvyQgSTyfGkAjYgterU2//lagYQCeNGVO
cbkpfTJPtMAfXpAPO2TPsFc=
=GkiF
-----END PGP SIGNATURE-----

--nextPart51562753.kE9pW7Ug5z--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
