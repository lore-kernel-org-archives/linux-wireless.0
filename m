Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34324 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932338Ab0EYPTK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 11:19:10 -0400
Date: Tue, 25 May 2010 17:14:29 +0200
From: Kurt Garloff <garloff@suse.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: WLAN Regulatory Domain Germany
Message-ID: <20100525151429.GC6342@tpkurt2.garloff.de>
References: <20100519172944.GB32757@tpkurt2.garloff.de> <1274690246.3743.20.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TYecfFk8j8mZq+dy"
In-Reply-To: <1274690246.3743.20.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--TYecfFk8j8mZq+dy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Johannes,

On Mon, May 24, 2010 at 10:37:26AM +0200, Johannes Berg wrote:
> > 8<---------------------------------------------------------------------=
---
> >=20
> > # Data from "Frequenznutzungsplan" (as published in April 2008), downlo=
aded from=20
> > # http://www.bundesnetzagentur.de/cae/servlet/contentblob/38448/publica=
tionFile/2659/Frequenznutzungsplan2008_Id17448pdf.pdf
> > # For the 5GHz range also see=20
> > # http://www.bundesnetzagentur.de/cae/servlet/contentblob/38216/publica=
tionFile/6579/WLAN5GHzVfg7_2010_28042010pdf.pdf
> > # The values have been reduced by a factor of 2 (3db) for non TPC devci=
es
> > # (in other words: devices with TPC can use twice the tx power of this =
table).
> >=20
> > country DE:
> > 	# entries 279004 and 280006
> > 	(2400 - 2483.5 @ 40), (N/A, 100 mW)
> > 	# entry 303005
> > 	(5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
> > 	# entries 304002 and 305002
> > 	(5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
> > 	# entries 308002, 309001 and 310003
> > 	(5470 - 5725 @ 40), (N/A, 500 mW), DFS
>=20
> I haven't verified the entries in the Frequenznutzungsplan itself, but
> according to the second document this seems fine. I think there ought to
> be a comment in the db.txt file indicating the rationale for using 100mW
> rather than 200mW.
                                                                           =
                  =20
OK, new suggestion.

8<------------------------------------------------------------------------ =
                  =20

# Data from "Frequenznutzungsplan" (as published in April 2008), downloaded=
 from
# http://www.bundesnetzagentur.de/cae/servlet/contentblob/38448/publication=
File/2659/Frequenznutzungsplan2008_Id17448pdf.pdf
# For the 5GHz range also see
# http://www.bundesnetzagentur.de/cae/servlet/contentblob/38216/publication=
File/6579/WLAN5GHzVfg7_2010_28042010pdf.pdf
# The values have been reduced by a factor of 2 (3db) for non TPC devices
# (in other words: devices with TPC can use twice the tx power of this tabl=
e).
# Note that the docs do not require TPC for 5150--5250; the reduction to
# 100mW thus is not strictly required -- however the conservative 100mW
# limit is used here as the non-interference with radar and satellite
# apps relies on the attenuation by the building walls only in the
# absence of DFS; the neighbour countries have 100mW limit here as well.

country DE:
	# entries 279004 and 280006
=A0 =A0 =A0 =A0(2400 - 2483.5 @ 40), (N/A, 100 mW)
=A0 =A0 =A0 =A0# entry 303005
=A0 =A0 =A0 =A0(5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
=A0 =A0 =A0 =A0# entries 304002 and 305002
=A0 =A0 =A0 =A0(5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
=A0 =A0 =A0 =A0# entries 308002, 309001 and 310003
=A0 =A0 =A0 =A0(5470 - 5725 @ 40), (N/A, 500 mW), DFS

8<------------------------------------------------------------------------

Can we actually put several entries covering the same frequency range?
Then we could put 200mW for DFS and 100mW for non-DFS.
This would also address the next issue you raise ...

> Also note that there are different requirements depending on the channel
> bandwidth, which will eventually come up in Linux too. But I think for
> that we need the new database format for that ... yet another thing to
> do before we can support 5/10 MHz channels.

Indeed. For 5150 -- 5350, the spectral power density may not exceed
10mW/MHz (and overall emitted power in the range per device not 200mW);
this gives a limit of 200mW for 20MHz channels or 100mW if no TPC is=20
used for 5250 -- 5350. (For 5470--5725 use 5x those values.)
I'm not aware of WLAN devices with narrower channels yet, but if they=20
come into existence, we'd have to reflect it somehow ...

Best,
--=20
Kurt Garloff, VP OPS Partner Engineering -- Novell Inc.

--TYecfFk8j8mZq+dy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFL++lVxmLh6hyYd04RAvvKAKCvNEy/VKVeE6mcwJetuNbbS1zE1gCgk1RJ
+GmeQrX+VUrAC1BM28vzad4=
=x5Mv
-----END PGP SIGNATURE-----

--TYecfFk8j8mZq+dy--
