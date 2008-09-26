Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42755 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304AbYIZOwK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 10:52:10 -0400
Subject: Re: [PATCH] wireless: consolidate on a single escape_essid
	implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <1222427323.10563.109.camel@johannes.berg> (sfid-20080926_130854_961383_6611B713)
References: <1222294536-24367-1-git-send-email-linville@tuxdriver.com>
	 <20080924232453.GG9187@tesla> <20080924233234.GE3639@tuxdriver.com>
	 <200809250834.07781.hs4233@mail.mn-solutions.de>
	 (sfid-20080925_083440_223989_866F07A7)  <1222332205.10563.26.camel@johannes.berg>
	 <1222361863.14444.18.camel@localhost.localdomain>
	 <1222427323.10563.109.camel@johannes.berg>
	 (sfid-20080926_130854_961383_6611B713)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SxzyvfwsZkb4j8y7Wwch"
Date: Fri, 26 Sep 2008 16:51:53 +0200
Message-Id: <1222440713.3798.0.camel@johannes.berg> (sfid-20080926_165216_874164_1B70A2AC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SxzyvfwsZkb4j8y7Wwch
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-26 at 13:08 +0200, Johannes Berg wrote:

> > 2) common GIWSCAN processing function that takes a list of common BSS
> > structures that the driver stores internally.  The common BSS structure
> > would have a "void *driver_data" pointer in which the driver could keep
> > driver-specific data items, but the driver would be responsible for
> > setting all available information in the common BSS structure when the
> > firmware provides scan results.  lib80211 provides common allocation,
> > deallocation, bss entry aging, ref/unref, and free-list fetching.
>=20
> I had something like this option 2 in mind when I wrote my patch, can
> you take a look at it? The only thing missing now is
> quality/signal/noise handling. Here's the most recent version:
>=20
> http://johannes.sipsolutions.net/patches/kernel/all/2008-09-26-11%3a08/02=
0-cfg80211-scan.patch

That version no longer applies; some rejects you can ignore safely
though for purposes of this thread, but here's a new version anyway:

http://johannes.sipsolutions.net/patches/kernel/all/2008-09-26-13%3a11/008-=
cfg80211-scan.patch

johannes

--=-SxzyvfwsZkb4j8y7Wwch
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI3PcDAAoJEKVg1VMiehFY3ZAQALrmA37EhfObW3nPUYICW3MV
orZtpKipPc39UStxwgecOEKrKXBav+vvcBYBJ+lwWnor1OFuPL+qNkmrg7HEMk77
mBrpZc9GqbMR40OdreI//CpR+Dr1h00A5rTuXHc0Bn6IUPura2VnjYsarTt1UYEc
nNGZRmSLv2hItEOWdDRFRVquI7TBRbHa1raVAjrckTkxmt/gPIfemL7gXyjbwm9W
UVyeLjdByTmhfPP7+wlMtbfNiFeIBb9aRKQBRJ9fOb28It5/CDFCvmH7Jq4yXwM8
uoDwIzIBZCACaB2l+pinbEvCMNTEFUpXNwRiNeJxh+TH8HL0OmI7W9B5JdP6aSvz
DM1ClRqzU758ChAj/2TF3hZWAk7Jspsgz5pRkpGMXrukHktjnTx3CVf9MsVzKOas
DfsrRdMxjnb8m3IU3cnxTQ3IHow27pCjk/EBV/cbzt1lteer7vpHKCu6xt8a2VeS
+7SFj0lTbnngzR7bDl2cek193pbiY1QSlgFaN2Obg194tQeX0E1DAN069A+6K4US
y+LLr9GApNT4o8GmwhwTflcegm6Lr0UGv3Fy8jsMhVpRuNZDxUxwD5CYyxqEk+2r
03qdPHHW/RcgkSl3DL/WtX6n4ok41SJaSLmACU4e64UrGfEuN9iaez8AstngeTYh
uOj9wBeRTaWjPOgYHjsQ
=axI9
-----END PGP SIGNATURE-----

--=-SxzyvfwsZkb4j8y7Wwch--

