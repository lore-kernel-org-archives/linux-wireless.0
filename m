Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38646 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbZIXSXd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 14:23:33 -0400
Subject: Re: 2.6.31-git wireless broken
From: Johannes Berg <johannes@sipsolutions.net>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-wireless@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0909241859020.25022@sister.anvils>
References: <Pine.LNX.4.64.0909241737390.20846@sister.anvils>
	 <1253813740.3868.324.camel@johannes.local>
	 <Pine.LNX.4.64.0909241859020.25022@sister.anvils>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-aIlvxhFiQiAmFetrWaVF"
Date: Thu, 24 Sep 2009 20:23:34 +0200
Message-Id: <1253816614.3868.406.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aIlvxhFiQiAmFetrWaVF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-24 at 19:14 +0100, Hugh Dickins wrote:

> I've been working under the belief that it's WPA encrypted.
>=20
> > If it's open, can you try this patch?
>=20
> But I could try the patch, in case I've been fooled.
>=20
> > http://johannes.sipsolutions.net/patches/kernel/all/2009-09-24-17%3a32/=
010-cfg80211-fix-wpas-open.patch
>=20
> However, all the trees I'm working with (Linus latest, or the bisect
> result, or a week old mmotm) have cfg80211_mgd_wext_connect saying:
>=20
> 	if (!netif_running(wdev->netdev))
> 		return 0;
>=20
> 	wdev->wext.connect.ie =3D wdev->wext.ie;
> 	wdev->wext.connect.ie_len =3D wdev->wext.ie_len;
> 	wdev->wext.connect.privacy =3D wdev->wext.default_key !=3D -1;
>=20
> 	if (wdev->wext.keys) {
> 		wdev->wext.keys->def =3D wdev->wext.default_key;
> 		wdev->wext.keys->defmgmt =3D wdev->wext.default_mgmt_key;
> 	}
>=20
> 	if (!wdev->wext.connect.ssid_len)
> 		return 0;
>=20
> which is not consistent with the fix your patch is making.

Ah. That patch isn't in yet I guess. I wonder if that could still be an
issue though. Maybe you can try that patch along with this one:

http://git.kernel.org/?p=3Dlinux/kernel/git/linville/wireless-testing.git;a=
=3Dcommitdiff_plain;h=3D55a00b83339f25d2979b85ab6e2151390327db80;hp=3Dcfa53=
f1e753ed709f0a483fa8bd16bc7d08d402d

Anyhow, I'm grasping at straws -- can you tell me more about the failure
mode, and possibly enable CONFIG_MAC80211_DEBUG_MENU and
CONFIG_MAC80211_VERBOSE_DEBUG?

johannes

--=-aIlvxhFiQiAmFetrWaVF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKu7kiAAoJEODzc/N7+QmaZUkP/3JCoVNb0ddyyWi/r21d6i9K
UpK8MLnTDC2Qj743rKGzsUnTg0mdZoq1b9j76EMF6rHHff1QQHHyz8cJ5sln13kG
gSyOih19nAlRfQ55Wnvo/msBoQ7fNzyaJ1sOJ0+4zLuqhQtwQvHRkwomxpa8vhob
R9k37983ZME34ycWw6xnd3VvWKfZxdLcvQ3xfSJgj+6OeKZ4Au8rlbdnloWCDCOd
eiyxlYJb9ONr47eIj/77FHQpgfDC6uNHVeclhizzEymxQEl25x0Dc5D2VP4xGyDy
iZcmGMWIF9b+/BcIJwkAmft5/GOGLsWqgTJ9lXynLXR3E4p0gYXpzhoQUCzbWLB0
wiy2cbPalpKBQPnIedMXX8+HhzFKSrYP6aRrgL3Zw7CiyM/72ZUV1spaXt7y8rxC
+ZnVqSOt/3RyfivZOowdJhtWRABvpVIXjX2Cn2UcB6khHfaGrAfsYIdW/FvZIU4x
NPhCioDx/vpwdTv5qmnrnq/WEpkeZNLJHVql2Y/HGCzd6G3AgMK4mixNqubjdfXO
Zm2Cy7a0xM6+VoL+OxQVorxRsPy8YKp3uukJt6y6dibhvtpJ1a84Uc2VoIz5CtyS
cJDJgOUS3L8mHp5Ck9GsTl8JtEoQeuo3LaWKxRXZlbUO/EJXcaGXuYtSrb9qeBGh
ial2L3CKkThE5lXHYh0o
=FDN1
-----END PGP SIGNATURE-----

--=-aIlvxhFiQiAmFetrWaVF--

