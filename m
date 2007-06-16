Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:14009 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752396AbXFPSac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2007 14:30:32 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Take 2] mac80211 IEEE802.11e/WMM code cleanup
Date: Sat, 16 Jun 2007 11:29:09 -0700
Cc: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	David Lamparter <lists@diac24.net>
References: <20070611085950.GA5540@mail.intel.com> <200706140935.50779.flamingice@sourmilk.net> <1181996855.9058.39.camel@johannes.berg>
In-Reply-To: <1181996855.9058.39.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1306404.1KBao7qKOS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706161129.13782.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1306404.1KBao7qKOS
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 16 June 2007 05:27, Johannes Berg wrote:
> No, it's not unnecessary. In London, we said that we wanted the
> (userspace) MLME to be controllable via nl80211 from userspace.
I think that decision was made without much consideration to the=20
implementation details. I thought it was a good idea then, but passing=20
messages from userspace to the kernel and then to userspace again is really=
 a=20
waste of time. NetworkManager already uses wpa_supplicant to avoid all the=
=20
nasty details of dealing with wireless configuration, so why not keep using=
=20
it for everything instead of hiding wpa_supplicant behind nl80211? This is=
=20
more simple and direct and allows the kernel to expose exactly what the=20
hardware/kernel can do. Userspace won't have to change much and nl80211 won=
't=20
have to support every possible thing a userspace MLME would want.

=2DMichael Wu

--nextPart1306404.1KBao7qKOS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGdCv5T3Oqt9AH4aERAg+gAKCmP6wC+XapqduJfspSOxXXf3XUVwCfUWij
siC9IrRA1/SgOByHMij1NVs=
=UP9r
-----END PGP SIGNATURE-----

--nextPart1306404.1KBao7qKOS--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
