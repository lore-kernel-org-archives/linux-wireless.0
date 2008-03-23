Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42511 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbYCWWQx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Mar 2008 18:16:53 -0400
Subject: Re: [PATCH] mac80211: trigger ieee80211_sta_work after opening
	interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Jan Niehusmann <jan@gondor.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <20080323192355.GA5773@x61s.gondor.com>
References: <20080323192355.GA5773@x61s.gondor.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nOdsBPcAlRt/o3Ha3dJH"
Date: Sun, 23 Mar 2008 23:16:35 +0100
Message-Id: <1206310595.16475.190.camel@johannes.berg> (sfid-20080323_221704_399354_5C61192B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nOdsBPcAlRt/o3Ha3dJH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sun, 2008-03-23 at 20:23 +0100, Jan Niehusmann wrote:
> ieee80211_sta_work is disabled while network interface
> is down. Therefore, if you configure wireless parameters
> before bringing the interface up, these configurations are
> not yet effective and association fails.
>=20
> A workaround from userspace is calling a command like
> 'iwconfig wlan0 ap any' after the interface is brought up.
>=20
> To fix this behaviour, trigger execution of ieee80211_sta_work from
> ieee80211_open when in STA or IBSS mode.

What happens with this patch when you haven't set any configuration
items before bringing the interface up? We want it to do nothing, if
that behaviour is kept the patch should be fine.

johannes

--=-nOdsBPcAlRt/o3Ha3dJH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+bWwqVg1VMiehFYAQKCzQ/8D/XwxThpjvpGZY9iDamOXczNO3+4b278
GbIRSvP2pJphV8L4lKeZ5+HpG7bvBpSMGoSIGIjzG12nqA4g5BCgjml+oKuntHdo
wYrq2F02MQVOMU26vAQF+FUJAzdh2rwFPCl64asyxQLPP7mnPwJgpsDYDnTpE5Mf
HnF7xbJaVxhzSYm+ct5pqrNN9iHaW4OM1EIT9JVYE/NE0TCtN29JNYnsFol8s4FB
p73JLjg/Uyj69oLJM/ZtAnHUzo/9BKi/94AzEsAC1hzAJYLDKYK/rOrltcYSVyOo
vGgtdlyyoGj2KMHFgMiM0h0KZIUTKWQyffwm9OCEND+5F7AZ36iEad5nxnHsmgoH
n27plreK6f4yPUqRDMozoAHNquI57nZjUimroir6eMvIOIbZyoGukGST2YRBc/Yk
MBwhW+xx0cBQCt4xSCop5BKJzLIedSn4Qq5XsclNH9+EWiqHgfA4ImMcujkOfIhp
zWsYuPsVwkp5dENdUxl5tcZpBkDBe1/Q6u2QR58KD4FQwo1U7dhWo4X4seaeBKGf
RGBFL5ta7SgnqbaP2PDJKv8ZfP8AQUaHKCyBxfGMXWs6fOOKJDMriMPIkmF7xraB
Uz/wWH05hr3Q4sJGKX6E7oW/QegSiv1xY+BubEH1mx3CwLBaJ3Cwww3WJOm0Waku
Id92z6PEi1c=
=QRhw
-----END PGP SIGNATURE-----

--=-nOdsBPcAlRt/o3Ha3dJH--

