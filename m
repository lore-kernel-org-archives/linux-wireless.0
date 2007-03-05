Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server8.tchmachines.com ([216.180.241.250]:36207 "EHLO
	server8.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbXCEDLK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2007 22:11:10 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Andy Green <andy@warmcat.com>
Subject: Re: Question about PRISM2 header rate field
Date: Sun, 4 Mar 2007 22:10:48 -0500
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <45EA9E39.6080706@warmcat.com> <1173053744.6131.40.camel@johannes.berg> <45EB6C3B.2060408@warmcat.com>
In-Reply-To: <45EB6C3B.2060408@warmcat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2565829.DxGrpCBJtl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703042210.52534.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2565829.DxGrpCBJtl
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 04 March 2007 20:02, Andy Green wrote:
> How about for injection on the Management interface, it expects to find
> a PRISM2 header prepended to the ieee80211 one and the payload, in
> exactly the same format as is delivered by Monitor Mode?  The PRISM2
> capture header structure has a bunch of fields for things like rate and
> antenna selection already.  This has the satisfying aspect that you can
> literally replay the whole Monitor Mode packet capture down the
> Management Interface and get it to go out at the same rate.
>
Isn't this what aircrack does? I think many other drivers that support fram=
e=20
injection do it in a similar way (TX AVS frame on monitor interface), and=20
this is also the way I prefer the frame injection interface. It does have t=
he=20
nice property of being able to directly replay captured traffic as you=20
mentioned. Just note that AVS/prism2 is planned to be removed in favor of=20
radiotap which is more extensible. Radiotap should also work for frame=20
injection, though it isn't as easy as using a fixed length header format.

Note that modifying the management interface to do this is possible, but it=
=20
would break hostap (and probably wpa_supplicant w/ MLME). Doing packet=20
injection on monitor interfaces instead is safer in that regard.

=2DMichael Wu

--nextPart2565829.DxGrpCBJtl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF64o8T3Oqt9AH4aERAiLpAKCPS5GPoSZqZHECxjoIQ42OoDt9QQCfSH9D
Z7VmrNeldxrwDL+0Nc5pjNQ=
=iTC9
-----END PGP SIGNATURE-----

--nextPart2565829.DxGrpCBJtl--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
