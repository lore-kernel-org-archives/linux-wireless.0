Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:36311 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755243AbXEJRdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 13:33:50 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH V3] mac80211: Add support for SIOCGIWRATE ioctl to provide rate information
Date: Thu, 10 May 2007 13:32:58 -0400
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <463a8a92.jFmmjY4cDnfJeisJ%Larry.Finger@lwfinger.net> <200705101156.12588.flamingice@sourmilk.net> <46434AB4.1070807@lwfinger.net>
In-Reply-To: <46434AB4.1070807@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1936169.qvJbfaYS6z";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705101333.03257.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1936169.qvJbfaYS6z
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 10 May 2007 12:39, Larry Finger wrote:
> Why is txrate in the sta_info structure an int? I think it should be a
> small, positive integer. Would it not be better as a u8, or a u16 if you
> think a larger range is needed?
>
u8 is probably fine, but then last_txrate and last_nonerp_idx should be=20
changed to u8 too plus all the stuff referring to the rate indexes.

But there's more interesting things to do, like implementing siwrate so we =
can=20
get rid of the corresponding prism2 ioctl.

=2DMichael Wu

--nextPart1936169.qvJbfaYS6z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGQ1dPT3Oqt9AH4aERApsRAKCZ1x4rKitJt1vktmH83vitN7pqJwCfUPxS
rasSl1stQovkErWAzh4Bx+o=
=9M5k
-----END PGP SIGNATURE-----

--nextPart1936169.qvJbfaYS6z--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
