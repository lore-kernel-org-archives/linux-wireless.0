Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:61854 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755224AbXIEOZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2007 10:25:50 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC 2/2] mac80211: revamp interface and filter configuration
Date: Wed, 5 Sep 2007 10:23:35 -0400
Cc: Ulrich Kunitz <kune@deine-taler.de>, Daniel Drake <dsd@gentoo.org>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
References: <20070821161845.165557000@sipsolutions.net> <20070905051626.GA12198@deine-taler.de> <1188991396.9942.97.camel@johannes.berg>
In-Reply-To: <1188991396.9942.97.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4131860.B08ULbqmYi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200709051023.48927.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4131860.B08ULbqmYi
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 05 September 2007 07:23, Johannes Berg wrote:
> > I prefer to do option (1) because it wouldn't require adding
> > additional fields to our private structure beside the work_struct
> > for the workqueue function, it is simple to implement and it would
> > not throw away any packets. Are there any side effects that I have
> > overlooked?
>
> I think Michael says it's currently buggy if called outside of ->tx().
>
That's just a general rule of thumb. configure_filter holds the tx lock so=
=20
it's actually safe to do that there. In other cases, it can be buggy (some =
tx=20
code can get stuck) and racy (frames can get enqueued after stopping the=20
queues). The first can be fixed in mac80211, but the second can't be. For=20
most cases, stopping the hardware queue(s) should be done instead and=20
possibly flushing the queue or waiting for it to empty, if you're trying to=
=20
adjust the radio.

=2DMichael Wu

--nextPart4131860.B08ULbqmYi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBG3rv0T3Oqt9AH4aERAv7yAJwLbR6sAkobfn2VOcPDQf0yrP6ZcACgrcS2
rceAICIYlBXCzY2W/iEtK8k=
=weCs
-----END PGP SIGNATURE-----

--nextPart4131860.B08ULbqmYi--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
