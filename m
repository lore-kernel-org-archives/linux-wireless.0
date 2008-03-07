Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:34919 "EHLO element.ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980AbYCGQng (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2008 11:43:36 -0500
Received: from 92-60-53-2.rev.bonet.sk ([92.60.53.2] helo=[192.168.1.2])
	by element.ksp.sk with esmtpa (Exim 4.69)
	(envelope-from <vlado@work.ksp.sk>)
	id 1JXec8-0005zW-I2
	for linux-wireless@vger.kernel.org; Fri, 07 Mar 2008 16:36:04 +0100
Message-ID: <47D160E4.3040503@work.ksp.sk> (sfid-20080307_165126_594708_1A6A8040)
Date: Fri, 07 Mar 2008 16:36:04 +0100
From: Vladimir Koutny <vlado@work.ksp.sk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: 2.6.24, mac80211 and b/g switching
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig86CEE8EECC190AA8F3DC28A5"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig86CEE8EECC190AA8F3DC28A5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

I'm writing a driver using mac80211 under 2.6.24.x kernels (some custom
hw, and very small chance of using anything newer than 2.6.24.x), and it
seems that switching between 11b and 11g in mac80211 doesn't work at all.=


I'm registering 2 hwmodes - MODE_IEEE80211B and MODE_IEEE80211G; only
STA mode (no ap, no ad-hoc (yet)).

Depending on the order of hwmodes registration, mac80211 sticks to
either b or g mode, with several implications:
 - unable to set all g-rates when connected to g-AP in MODE_IEEE80211B
 - able to set g-rates when connected to b-AP in MODE_IEEE80211G
 - wrong cw_min set via conf_tx (the code which sets this looks fine,
   just the phymode is not set correctly)

It doesn't matter if I set the phymode to b or g for received frames,
the behaviour is always the same.

I did some tests with iwl3945 (and rt2500usb, but that wasn't able to
associate), under 2.6.24.3 and 2.6.25-rc4; the same behaviour as for my
driver. Non-mac80211 drivers (like ipw3945 on somewhat older kernel)
behave as one would expect.

I didn't do a test with latest dev tree; based on list traffic quite a
lot is happening here, so maybe this is fixed already. However, chance
of being able to move to anything more recent than 2.6.25-rc is very
close to zero :(

Is this a known issue? (I didn't manage to find anything in ml archives
so far) Or any hints on how to solve this?

Thanks,
  Vlado


--------------enig86CEE8EECC190AA8F3DC28A5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH0WDke5Z0y47EufgRAlUFAJ45LSuQV9XwiUGqWWKku8OokhtipACggaGB
Lzt8jPvMlz/NJpCwsQkIJUY=
=XsaV
-----END PGP SIGNATURE-----

--------------enig86CEE8EECC190AA8F3DC28A5--
