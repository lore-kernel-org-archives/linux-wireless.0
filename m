Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:35431 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751239AbXLEFsa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 00:48:30 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: don't use interface indizes
Date: Wed, 5 Dec 2007 00:57:15 -0500
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Zhu Yi <yi.zhu@intel.com>, Daniel Drake <dsd@gentoo.org>,
	Yanbo Li <dreamfly281@gmail.com>
References: <1196782831.10274.12.camel@johannes.berg>
In-Reply-To: <1196782831.10274.12.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3710021.bDftaFxQSg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200712050057.19819.flamingice@sourmilk.net> (sfid-20071205_054836_531604_92C0D5A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3710021.bDftaFxQSg
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 04 December 2007 10:40:30 Johannes Berg wrote:
> This patch gets rid of the if_id stuff all over in favour of a new
> virtual-interface structure "struct mac80211_vif".
That's a pretty terrible name. mac80211 is not a valid prefix to be used in=
=20
the codebase, at least not for structures and functions. Everything else us=
es=20
ieee80211 so use of mac80211 is not acceptable, especially for driver facin=
g=20
API. (the use of that prefix in event.c isn't right either.. need to fix=20
that)

Leaving it to the driver to allocate the private space isn't too great eith=
er.=20
Something like a char subif_priv[] at the end of ieee80211_sub_if_data and =
a=20
way to specify the length of the private area will be more useful to driver=
s=20
which wish to use the per-subif private space by avoiding extra allocation=
=20
and allocation failure handling and also for drivers which don't, by=20
eliminating the overhead of storing an unused pointer. It is also more=20
consistent with the other apis that allocate ieee80211_hw and net_device.

> Only compile-tested the driver changes, sanity checks required.
>
There you go. ;)

=2DMichael Wu

--nextPart3710021.bDftaFxQSg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHVj2/T3Oqt9AH4aERApMWAKCcBfmhc6lVVjsnj3Y0NBDHF53sHgCgrApA
tJeLqCW09SAGeC8ajOckOBI=
=onZ2
-----END PGP SIGNATURE-----

--nextPart3710021.bDftaFxQSg--
