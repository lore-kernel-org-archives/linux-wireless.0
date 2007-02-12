Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:37064 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932944AbXBLEaE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Feb 2007 23:30:04 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] d80211: Fix wireless statistics reporting
Date: Sun, 11 Feb 2007 23:29:15 -0500
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <200702112209.46093.flamingice@sourmilk.net> <1171253350.27742.17.camel@dv>
In-Reply-To: <1171253350.27742.17.camel@dv>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1489636.qNMvYl8yur";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702112329.21901.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1489636.qNMvYl8yur
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 11 February 2007 23:09, Pavel Roskin wrote:
> > -	int signal;
> > +	int signal; /* used as qual in statistics reporting */
>
> I'm sorry but that the thing I have always hated about wireless
> extensions.  Such tricks make the API context sensitive and loaded with
> assumptions.
>
Ok, but I was merely clarifying the current situation. That problem has alw=
ays=20
been there since the patch for statistics reporting went in.

> I understand d80211 still has to interact with Wireless Extensions, but
> let's not make things even worse.
I'm making things better. Statistics reporting is pretty bad right now in=20
d80211 with drivers reporting bogus values when they don't know, and=20
statistics reporting of different d80211 drivers interacting with each othe=
r=20
when multiple devices are plugged in. This patch attempts to fix the worst=
=20
issues while attempting to avoid regressions. Feel free to follow up with=20
another patch to make statistics reporting perfect.

=2DMichael Wu

--nextPart1489636.qNMvYl8yur
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFz+0hT3Oqt9AH4aERAif4AJ93ghrCj63IB72CakiJOrVSfyrYVwCggNSJ
cI+QgKO1iSrdjBvygFcCCAM=
=lsOv
-----END PGP SIGNATURE-----

--nextPart1489636.qNMvYl8yur--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
