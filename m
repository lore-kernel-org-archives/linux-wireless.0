Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:35911 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422995AbXDXS26 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2007 14:28:58 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Andy Green <andy@warmcat.com>
Subject: Re: [PATCH 03/13] mac80211: fix virtual interface related locking
Date: Tue, 24 Apr 2007 14:24:56 -0400
Cc: linux-wireless@vger.kernel.org
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net> <200704231722.07280.flamingice@sourmilk.net> <462E47D0.8030800@warmcat.com>
In-Reply-To: <462E47D0.8030800@warmcat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart16586894.RspPzIOW70";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704241425.01152.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart16586894.RspPzIOW70
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 24 April 2007 14:09, Andy Green wrote:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ INFO: possible recursive locking detected ]
> 2.6.21-rc7 #11
> ---------------------------------------------
> ip/2600 is trying to acquire lock:
>   (&dev->_xmit_lock){-+..}, at: [<e09199c5>]
> ieee80211_set_multicast_list+0x46/0x167 [mac80211]
>
> but task is already holding lock:
>   (&dev->_xmit_lock){-+..}, at: [<c05abc05>] dev_mc_upload+0x14/0x3c
>
This is fine, though it would be nice if we can shut the warning off. Virtu=
al=20
interfaces can try to take the xmit lock of the master device, but the mast=
er=20
device will never try to take the xmit lock of the virtual interfaces and=20
especially not while holding its own xmit lock.

=2DMichael Wu

--nextPart16586894.RspPzIOW70
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGLkt9T3Oqt9AH4aERAsjVAJwOi2PMD5DYdTrbXasjyCPvvSit5QCgx4/d
iJc6TOkMLiNKykyqDDRtNiE=
=2A/y
-----END PGP SIGNATURE-----

--nextPart16586894.RspPzIOW70--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
