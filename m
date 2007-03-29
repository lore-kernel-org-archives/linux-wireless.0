Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:48616 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbXC2Ipd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 04:45:33 -0400
Message-ID: <460B7CAA.4020604@web.de>
Date: Thu, 29 Mar 2007 10:45:30 +0200
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jiri Benc <jbenc@suse.cz>, Ivo Van Doorn <ivdoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: d80211: How does TX flow control work?
References: <459A5945.80909@web.de>	 <20070103185203.2754e059@griffin.suse.cz>	<459BF179.6000906@web.de>	 <20070103191853.4f440b8b@griffin.suse.cz> <459BFB05.9040608@web.de>	 <45A03825.9080807@web.de>  <45A2A728.1070404@web.de> <1175029130.5151.6.camel@johannes.berg>
In-Reply-To: <1175029130.5151.6.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig48D0320CABB87E558548BC1B"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig48D0320CABB87E558548BC1B
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Johannes Berg wrote:
>> The actual problem was meanwhile identified: shorewall happened to
>> overwrite the queueing discipline of wmaster0 with pfifo_fast. I found=

>> the magic knob to tell shorewall to no longer do this (at least until =
I
>> want to manage traffic control that way...), but I still wonder if it =
is
>> an acceptable situation. Currently, the user can intentionally or
>> accidentally screw up the stack this way.
>=20
> I don't seem to be able to do that:
>=20
> # tc qdisc change dev wmaster0 pfifo
> RTNETLINK answers: Invalid argument
>=20
> # tc qdisc replace dev wmaster0 pfifo
> RTNETLINK answers: Invalid argument
>=20
> what exactly does shorewall do?
>=20

Don't recall... need to re-test... lacking time. :(

Just one note: I observed this on a 2.6.19 kernel - in case there is a
difference to the latest.

Jan



--------------enig48D0320CABB87E558548BC1B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGC3yqniDOoMHTA+kRAqesAJ9MaVvYAEXdO1QDkG5/30mbO8HRkQCfWLE9
b85HqNF2vVutucymxafU1zQ=
=YgrF
-----END PGP SIGNATURE-----

--------------enig48D0320CABB87E558548BC1B--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
