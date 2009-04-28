Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43014 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757861AbZD1VnO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2009 17:43:14 -0400
Subject: Re: 2.6.30-rc3: iwlagn probe timeouts (regression)
From: Johannes Berg <johannes@sipsolutions.net>
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <49F76DF2.5070704@gmail.com> (sfid-20090428_225846_755730_3AFA4A12)
References: <49F4F5B1.4020201@gmail.com> <1240852777.29221.6.camel@rc-desk>
	 <49F76DF2.5070704@gmail.com> (sfid-20090428_225846_755730_3AFA4A12)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-99LFL4bzdi94wsIWWbyk"
Date: Tue, 28 Apr 2009 23:42:39 +0200
Message-Id: <1240954959.593.5.camel@johannes.local> (sfid-20090428_234319_487972_6219E84E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-99LFL4bzdi94wsIWWbyk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-28 at 22:58 +0200, Niel Lambrechts wrote:

> >> Apr 27 01:33:43 linux-7vph kernel: wlan0: direct probe to AP
> >> 00:1d:92:1d:1e:8e timed out

(etc)
=20
> Okidoki, I've managed to bisect it:
>=20
> commit 47afbaf5af9454a7a1a64591e20cbfcc27ca67a8
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Tue Apr 7 15:22:28 2009 +0200
>=20
>     mac80211: correct wext transmit power handler

Ok, that's confusing. It doesn't even change any code that is normally
executed, at least not significantly since local->user_power_level is
usually 0; checking
	if (local->user_power_level)
vs. checking
	if (local->user_power_level >=3D 0)
shouldn't make a difference in that case (although I admit that I forgot
a few cases in that commit, will fix).

Can you please verify that the code behaves correctly if you revert just
this commit? Unless you're playing with "iwconfig wlan0 txpower .." I
don't see a reason for this to cause a problem.

johannes

--=-99LFL4bzdi94wsIWWbyk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ93hLAAoJEKVg1VMiehFY6BAP/ihl7mer3CF5k5DR0G+dRqlc
Uskg6pMWxz7rlHWp59tqqUWeNb0d4fAkkJzGgJgDhZwakgJ9aEHO1xKRmqUwC5ry
3UC3alM9jiSzCAHk/SAwcvsGO6hRe/DsNxQm86p/FOYL86eAgU/kTQMaH4SGoLZW
xE72QZBUxBOVIDmn5hWtWHPoXMPTHbGSlzgC6TaN3ubIdEwiJq6cNI5GtHOCzNEv
CFMY+ZFxMCISXHqz/IA1Oi8vzF6c6AE6zB4rEYGMiRHhkte5PGRRo3FZNsBXO/5C
tiWkAsZBD9m239hwbEQFbEFPzB2oLT412S+ioXAhBXpGfRfCj3kYP86gOsrUYOuG
lm3TT7TWWLJav5sS+zDHdcfJg7vmQdj6Mb4dIs560OrAuNFF27nL7Y8zMYcwoqKo
33bcTO32SgBR88K3dtLTg0vAIsD8+icWsETDactK/9EKrrHgVXTy+D4ubzt54M67
eiHThKZ7M1SBsolKjToh2yWjz0UiiG/M1azYQcB9HSVOSl0Gd9CucBkd7XkqPEV7
CKuN3F5JW9/8uGIoxODdteEW/GEIeyf44lebR2f6Hq9t/Q4iRqdNNZUNjGa0ZikV
AXOFRyR7J5fXxhmWJoLa+uMf2c7pJkzTOr3OxlAIVR3N8OchAt1hTkFHx94lh1la
Ds29TuYVMeJlkWRnuMae
=TscX
-----END PGP SIGNATURE-----

--=-99LFL4bzdi94wsIWWbyk--

