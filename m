Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39523 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760727AbYFZUTL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 16:19:11 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1KBxvx-0006KC-MI
	for linux-wireless@vger.kernel.org; Thu, 26 Jun 2008 22:19:09 +0200
Subject: basic rate set / response frame rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JxEWCrixOzwcolDn5GQl"
Date: Thu, 26 Jun 2008 22:18:30 +0200
Message-Id: <1214511510.3783.44.camel@johannes.berg> (sfid-20080626_221917_390875_934D72E9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JxEWCrixOzwcolDn5GQl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

How does hardware currently handle the control response (ACK/CTS) frame
rate? In 802.11 clause 9.6 talks about this, and we implement basic rate
handling in mac80211 to calculate the control response duration, but we
never tell drivers what bitrate to transmit control response frames at.

I suspect this is broken in all drivers (except maybe iwlwifi which
probably does it all in firmware.) The problem then is that if the AP
has basic rates higher than your firmware/hardware default, the control
response takes too long and the NAV isn't updated correctly in other
STAs.

How should we fix this?

The most straight-forward way would be to include a map of rate -> basic
rate into ieee80211_bss_conf, but that isn't easy because the size of
the map isn't known.

Another way would be to just give the driver the basic rate set, but
that means it has to calculate the mapping itself, subject to all the
rules in 802.11 clause 9.6.

Therefore, I prefer the former way, or giving the driver a function to
call for each rate=EF=BB=BF on bss_info_changed to calculate the mapping.

johannes

--=-JxEWCrixOzwcolDn5GQl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIY/mRAAoJEKVg1VMiehFYuI8P/RAjiQMrAMGYFQxxC75QQeDe
IBtgCpmab0eMnfbvCcvYMh0NC/O/tsTiJDNgRm/nujXbLRQ/uYcknP1IVIB8S4i/
/nY3U1WfAriPh2wSL2LKZ2JvnkFZqpGdS0CIZI9gInrc/t0zFzFZgfgQaggY2Ge9
CM2Pkp7QBYovBA1M4RwUyAv/TdUbi0t1DOIafmfOyLqFlGC+nL5P1c/8luR1Qfpe
A+g/y+Xfh0H5pz9UmN1gF9ryIrVAPu460ad7gVPTYGD4DMmsjTdmD9KTOxaXiDxT
1ZBD68BkYl6QnSoZDfGdWcLhZiBveanJLVC3MSZ3iDypaMKbFm5gVd8vQRjk8UpC
qDWqcS8dYaaWcGC1AFTuArwCeNXod/FJV8Xa1OgdGiSXYAJIHsE9rbJv9VT/cBjy
6Qrud+49XhwV1RmsQ9NBpVd5d6tl/ccHCMZ5pcPYI6bsN59gikiUV0dhnq4cQUlm
HL0Vqodqb4aoezoHEbwBWIdBPX02/8buo4BDbpoKsg/h40SpXp96Rw0kp/Qel7jE
+xYKZakmBoG/r+2TFgkHdKUT7AwtKfcsGpBH0bVR3r1MhVU0ZGJqCSoNL1QGHgE+
z+nLl6kPSerSuolfXk9cAzEXxRQNErgfCeZxar4/Zw5Llvn2yGtWzgCHLIicAFFl
RnvrUmUHhdoUH73LeOhA
=wgQb
-----END PGP SIGNATURE-----

--=-JxEWCrixOzwcolDn5GQl--

