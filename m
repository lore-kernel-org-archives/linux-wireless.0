Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:44820 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754619AbXIWRt2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Sep 2007 13:49:28 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: zd1211 config operation problem
Date: Sun, 23 Sep 2007 13:48:25 -0400
Cc: Ulrich Kunitz <kune@deine-taler.de>, Daniel Drake <dsd@gentoo.org>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <200709231648.17107.mb@bu3sch.de>
In-Reply-To: <200709231648.17107.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6544900.21FOUjh9l4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200709231348.30055.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart6544900.21FOUjh9l4
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 23 September 2007 10:48, Michael Buesch wrote:
> The zd1211 driver has a bug in the ieee80211 config callback.
> It currently unconditionally calls the set_channel() function,
> whether the device is running or not. This causes a failed
> bus access, if we set some config while the device is down.
> The driver must check if the device is running before setting
> any config on it (usb->initialized?).
Hm, that sounds pretty terrible. mac80211 should check if the device was=20
started before trying to run any configure callbacks.

=2DMichael Wu

--nextPart6544900.21FOUjh9l4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBG9qbuT3Oqt9AH4aERArUpAJ9pYv84hs+ZxMinjhsxVQIvEL6mMgCeNsUN
rYpzOtT8Y7m1ZR8V7W2yrCM=
=GkiO
-----END PGP SIGNATURE-----

--nextPart6544900.21FOUjh9l4--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
