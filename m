Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:19977 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932629AbXBSUsu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 15:48:50 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] d80211: Allow drivers to configure default regulatory domain
Date: Mon, 19 Feb 2007 15:48:26 -0500
Cc: linux-wireless@vger.kernel.org
References: <200702180031.38710.flamingice@sourmilk.net> <20070219204938.29520759@griffin.suse.cz>
In-Reply-To: <20070219204938.29520759@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1177660.SbyWoKT2F0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702191548.30357.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1177660.SbyWoKT2F0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 19 February 2007 14:49, Jiri Benc wrote:
> How is a driver supposed to handle this? By walking through the channel
> list and based on some value obtained from its EEPROM (or firmware or
> whatever) set appropriate flags? That sounds like a need for duplicate
> code in drivers. Shouldn't the stack accept a regdomain code (defined
> as an enum of integers or so) instead?
>
Region codes are not standardized though many devices these days tend towar=
ds=20
using atheros' codes. Of course, you can make a d80211 specific region code=
=20
enum and map hardware region codes to those region codes and this would wor=
k=20
well for most hardware out there.. except for ipw3945. So, this patch would=
=20
allow the ipw3945 to do its own funny thing while everyone else uses a=20
library to setup the channels.

=2DMichael Wu

--nextPart1177660.SbyWoKT2F0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF2g0eT3Oqt9AH4aERAsklAJwLi1+DxwB3BNMyxYyNV+tbvOPhJACgqlub
fRqpMaca7nzPvD1eYu8s0Eo=
=F56K
-----END PGP SIGNATURE-----

--nextPart1177660.SbyWoKT2F0--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
