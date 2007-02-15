Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:30119 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030735AbXBOTWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 14:22:35 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] d80211: Add software sequence support
Date: Thu, 15 Feb 2007 14:22:07 -0500
Cc: Ivo van Doorn <ivdoorn@gmail.com>, Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702141423.27823.IvDoorn@gmail.com> <1171557724.5220.30.camel@johannes.berg> <200702151402.48150.flamingice@sourmilk.net>
In-Reply-To: <200702151402.48150.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart19860224.2ORPJxixmg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702151422.12195.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart19860224.2ORPJxixmg
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 15 February 2007 14:02, Michael Wu wrote:
> If we're going to switch to a library approach, let's do it all at once. I
> don't want some features requiring flags to toggle and others requiring a
> function to call.
>
To be specific, I don't like the library approach when we can simply set a=
=20
flag and let the stack handle it. It may clutter the TX path, but it reduce=
s=20
complexity on the driver end. Also, this particular test can be moved from=
=20
the TX path to device registration with some changes to the way the TX=20
handlers are handled. I will need to check if there are other TX handlers=20
that would benefit from this to make it worthwhile. For things like=20
encryption, I think library functions or callbacks will really be needed to=
=20
do things right, but for software sequence numbers, I'd rather stick with a=
=20
simple flag to enable/disable it. It also allows us to report if a particul=
ar=20
device supports software sequence numbers which the use of a library functi=
on=20
would not specify so directly.

=2DMichael Wu

--nextPart19860224.2ORPJxixmg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF1LLkT3Oqt9AH4aERAnLyAJ9Ws9o9gSyYQclJ/NKY8HlPg/Q7lQCdGEHY
sZ7+wVPgoFmpWZZrWnBVNxw=
=sF5k
-----END PGP SIGNATURE-----

--nextPart19860224.2ORPJxixmg--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
