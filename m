Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35899 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbZKQLcL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 06:32:11 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1NAMIB-00087u-Oj
	for linux-wireless@vger.kernel.org; Tue, 17 Nov 2009 12:32:15 +0100
Subject: ar9170 resume warning
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ASeG7ijBqGaVZP3sqZ1l"
Date: Tue, 17 Nov 2009 11:03:54 +0100
Message-ID: <1258452235.3682.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ASeG7ijBqGaVZP3sqZ1l
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Every time I resume with ar9170 unplugged, after hibernating with ar9170
plugged in, I get this trace:

[ 1617.300683] WARNING: at net/mac80211/main.c:93 ieee80211_configure_filte=
r+0x26b/0x270 [mac80211]()
[ 1617.308163] Hardware name: MacBook5,1
[ 1617.315741] Modules linked in: ...
[ 1617.363458] Pid: 8285, comm: s2disk Not tainted 2.6.32-rc7-wl-42932-gb64=
8d86-dirty #108
[ 1617.373892] Call Trace:
[ 1617.395153]  [<ffffffff8104f53b>] warn_slowpath_common+0x7b/0xd0
[ 1617.405990]  [<ffffffff8104f5a4>] warn_slowpath_null+0x14/0x20
[ 1617.416740]  [<ffffffffa01b4acb>] ieee80211_configure_filter+0x26b/0x270=
 [mac80211]
[ 1617.427635]  [<ffffffffa01d16ae>] ieee80211_reconfig+0x3ce/0x670 [mac802=
11]
[ 1617.461216]  [<ffffffffa01c707a>] ieee80211_resume+0x1a/0x30 [mac80211]
[ 1617.472670]  [<ffffffffa016690a>] wiphy_resume+0x7a/0xa0 [cfg80211]
[ 1617.484066]  [<ffffffff812f794f>] device_resume+0x17f/0x1a0
[ 1617.495381]  [<ffffffff812f7d35>] dpm_resume+0xd5/0x170
[ 1617.506774]  [<ffffffff812f81fa>] dpm_resume_end+0x2a/0x40
[ 1617.518058]  [<ffffffff8109a643>] hibernation_snapshot+0xc3/0x130
...


Should ar9170 unregister the hardware as it resumes and finds it gone?
Or is there something preventing doing that?

johannes

--=-ASeG7ijBqGaVZP3sqZ1l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLAnUGAAoJEODzc/N7+QmaUb8P/jsMTegOCRavD/6IIT8PtGz1
jrkFN/iB3EMgMPa70JHgzogXxVLK0RirOnvHGLbN49tmUE7cIaJydMKDkosz9Hfu
nMs+o50qFK80ZKr3Alwmz4WHziXQMDx69DdJeYGzCNKKi/ztRyHfI5R70p3DQ3RZ
DVagPIa1HaDFLk7bve8oK7dC7bcFqKI5oQreToRZtcxlti1ypVKtUyssXK4rqxHG
MbJ3h76ximMPaJQsGkCJmtnLnJh+hjs4Q6SYpsMdwICLL/HzKppbo2lq4T3mYDp9
yvcTMp6bALbR9LvJYXOVlrYl/P2S8nBfifsJjCaderlrf96338mGXiY2Qqeg6tmX
p/26xKqcN6QmNxoIiDYh379MnYdk2yXZXQ29MtdK2+8mCx0KOBXp093hHm/ib5fZ
awLPMpgNDHXxCuUsCNVWKqfe6A3BzA265Dm0xVxkysWjtwN2THhQYkdeeTBTjCYJ
+Z6YcwaV62CJvA5Blti2IqjqR6Gp9kGUdZMVFAMd/dl52JVhSn5Ri0PQTLDDR7IQ
UnV1o0wt4cxrVlBL+MaHnsHqE8l9F74kx7X1A33SrsvuWyYx1xZGoOfh6IooUzxT
2uXsaTki6PBJHkYIQtkVyXpT+jG8dcZnJlBFKJFr/mp+BYwFphC4nVi5xPQrlkGI
4ccK+qt2VfEjhS+haTW0
=bhu+
-----END PGP SIGNATURE-----

--=-ASeG7ijBqGaVZP3sqZ1l--

