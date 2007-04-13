Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:25567 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030886AbXDMXVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2007 19:21:18 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] mac80211: Report correct wireless statistics
Date: Fri, 13 Apr 2007 19:18:20 -0400
Cc: Dan Williams <dcbw@redhat.com>,
	John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
References: <461877ea.cyxM3SSnr6WhYkjX%Larry.Finger@lwfinger.net> <200704091902.14301.flamingice@sourmilk.net> <461AE160.6060404@lwfinger.net>
In-Reply-To: <461AE160.6060404@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9807661.MWb1Iz70VB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704131918.24758.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart9807661.MWb1Iz70VB
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 09 April 2007 20:59, Larry Finger wrote:
> I changed signal to qual and (r)ssi to level. Once these changes were mad=
e,
> iwconfig gives me the following:
>
> Link Quality=3D57/100  Signal level=3D-37 dBm  Noise level=3D-70 dBm
>
> The patch is pretty large and touches a lot of files, but if one is to be
> able to bisect around it, it has to be a single commit. As the patch
> entitled "[PATCH] bcm43xx-mac80211: Fix error in initiallizing max RSSI a=
nd
> max signal" has been accepted into Michael Buesch's tree, I have assumed
> that it is already included.
>
I would prefer having the bcm43xx-mac80211 fix and the renaming separated i=
nto=20
two patches.

Also, why wasn't max_rssi changed to max_level? I'm not so sure about doing=
=20
s/rssi/level/, however. s/rssi/signal/ sounds better to me. (which makes it=
=20
sound similar to your other patch, except rssi is eliminated because one=20
variable needs to do RSSI/dBm and the other needs to be more general than=20
just another RSSI statistic)

The change from "rssi=3D%d" to "level=3D%d" looks wrong to me. If any users=
pace=20
app is parsing that info, that breaks it. Then again, that information is=20
actually redundant since we report IWEVQUAL earlier so it should just be=20
removed. I'll post a patch.

Thanks,
=2DMichael Wu

--nextPart9807661.MWb1Iz70VB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGIA/AT3Oqt9AH4aERAtCGAJ9kYhp7mdu115NOPeg3Dqjlz7b4WwCeMiOt
CZvTFGXKENHdqcETXdFBjck=
=xKtN
-----END PGP SIGNATURE-----

--nextPart9807661.MWb1Iz70VB--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
