Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab0ESRex (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 13:34:53 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	by mx2.suse.de (Postfix) with ESMTP id 32BD789FC6
	for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 19:34:52 +0200 (CEST)
Date: Wed, 19 May 2010 19:29:44 +0200
From: Kurt Garloff <kurt@garloff.de>
To: linux-wireless@vger.kernel.org
Subject: WLAN Regulatory Domain Germany
Message-ID: <20100519172944.GB32757@tpkurt2.garloff.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

studying the three documents

WLAN 5GHz (Vfg. 7/2010)
http://www.bundesnetzagentur.de/cae/servlet/contentblob/38216/publicationFi=
le/6579/WLAN5GHzVfg7_2010_28042010pdf.pdf

WLAN 2.4GHz (Vfg. 89/2003)
http://www.bundesnetzagentur.de/cae/servlet/contentblob/38214/publicationFi=
le/2557/FundstelleId313pdf.pdf

Frequenznutzungsplan
http://www.bundesnetzagentur.de/cae/servlet/contentblob/38448/publicationFi=
le/2659/Frequenznutzungsplan2008_Id17448pdf.pdf

I think the data in db.txt is slightly inaccurate.

Find below my suggested entry into db.txt.
Suggested changes:
* Updated references (they restructured their webserver/CMS it seems)
* Split 5150 -- 5350 range into two
  - the first range does not require DFS
* 5470 -- 5725 does not have a NO-OUTDOOR requirement
  - (and 500mW translates to 27db, not 26db AFAICT)

Sidenote: The values include lowering txpower by a factor of 2 (3db)
 for non TPC devices -- the wording in Vfg. 7/2010 does NOT require
 this for 5150 -- 5250; so we could actually use 200mW/23db there. As=20
 this is out of line with the neighbour countries, I have sticked with
 the conservative value of 100mW here.

What is the process for checking the correctness and getting the crda DB=20
updated?

8<------------------------------------------------------------------------

# Data from "Frequenznutzungsplan" (as published in April 2008), downloaded=
 from=20
# http://www.bundesnetzagentur.de/cae/servlet/contentblob/38448/publication=
File/2659/Frequenznutzungsplan2008_Id17448pdf.pdf
# For the 5GHz range also see=20
# http://www.bundesnetzagentur.de/cae/servlet/contentblob/38216/publication=
File/6579/WLAN5GHzVfg7_2010_28042010pdf.pdf
# The values have been reduced by a factor of 2 (3db) for non TPC devcies
# (in other words: devices with TPC can use twice the tx power of this tabl=
e).

country DE:
	# entries 279004 and 280006
	(2400 - 2483.5 @ 40), (N/A, 100 mW)
	# entry 303005
	(5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
	# entries 304002 and 305002
	(5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
	# entries 308002, 309001 and 310003
	(5470 - 5725 @ 40), (N/A, 500 mW), DFS

8<------------------------------------------------------------------------

(Or in db, as displayed by iw reg get)
country DE:
        (2400 - 2483 @ 40), (N/A, 20)
	(5150 - 5250 @ 40), (N/A, 20), NO-OUTDOOR
        (5250 - 5350 @ 40), (N/A, 20), NO-OUTDOOR, DFS
        (5470 - 5725 @ 40), (N/A, 27), DFS

PS: I'm not subscribed, please copy responses to me.

Best,
--=20
Kurt Garloff                   <kurt@garloff.de>        [Private, Koeln]
Linux: VP OPS PartnerEng       <garloff@suse.de>            [Novell Inc]

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFL9CAIxmLh6hyYd04RAtTrAKDRg3K3DPpBFLRHUIdzmx3X1FYn1ACgtL0z
bX7NaGoP/1o2SO1t7bGQGAA=
=ex+F
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--
