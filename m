Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:11337 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755016AbXEAR11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2007 13:27:27 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: d80211: How does TX flow control work?
Date: Tue, 1 May 2007 13:01:19 -0400
Cc: Jan Kiszka <jan.kiszka@web.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Ivo Van Doorn <ivdoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <459A5945.80909@web.de> <46374C4C.50106@web.de> <20070501172513.2519f64b@logostar.upir.cz>
In-Reply-To: <20070501172513.2519f64b@logostar.upir.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart22232050.dsHoSG8H8D";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705011301.24478.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart22232050.dsHoSG8H8D
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 01 May 2007 11:25, Jiri Benc wrote:
> On Tue, 01 May 2007 16:18:52 +0200, Jan Kiszka wrote:
> > Already tried this lethal command? Works "fine" here...
> >
> > #tc qdisc del dev wmaster0 root
>
> I cannot reproduce it too.
>
I can reproduce it. I thought qdiscs couldn't be changed without taking the=
=20
interface down first.. which is not true. It merely waits for things to qui=
et=20
down before swapping out the qdisc.

Some code in ieee80211_master_start_xmit probably will be needed to correct=
ly=20
handle things if the ieee80211 qdisc isn't installed. I don't see an easy w=
ay=20
to prevent things from working all the time if the qdisc is removed.

=2DMichael Wu

--nextPart22232050.dsHoSG8H8D
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGN3JkT3Oqt9AH4aERAhIzAJ4nsJco4YVRyDWZ8Sha7kFvl86JnwCcCorT
720+yUCktQF8eWZ+qc1Mlyw=
=JqoN
-----END PGP SIGNATURE-----

--nextPart22232050.dsHoSG8H8D--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
