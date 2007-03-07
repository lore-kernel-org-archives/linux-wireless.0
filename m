Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:51622 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965511AbXCGOLH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2007 09:11:07 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Andy Green <andy@warmcat.com>
Subject: Re: Packetspammer and iwlwifi fragility
Date: Wed, 7 Mar 2007 09:10:15 -0500
Cc: linux-wireless@vger.kernel.org
References: <45EEB892.6040201@warmcat.com>
In-Reply-To: <45EEB892.6040201@warmcat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1304219.mXQjKltbL5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703070910.20242.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1304219.mXQjKltbL5
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 07 March 2007 08:05, Andy Green wrote:
> Also notice that packets cannot be sent by packetspammer until the
> interface is brought up, which I guess is reasonable enough, but also I
> found not until the interface was associated with a WPA network, which
> is a problem if the plan is to use the injection action to do the work
> of association in userspace.
>
There is a hostap/prism2 sub-ioctl to enable userspace mlme mode, which sho=
uld=20
fix that issue. Look around in ieee80211_ioctl.c for=20
PRISM2_IOCTL_PRISM2_PARAM, ieee80211_ioctl_prism2_param, and=20
PRISM2_PARAM_USER_SPACE_MLME for hints. These sub-ioctls are, of course,=20
quite evil and need to be replaced, but it's a little better than hacking=20
mac80211 to start with user_space_mlme enabled by default.

=2DMichael Wu

--nextPart1304219.mXQjKltbL5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF7sfMT3Oqt9AH4aERAmVsAJ0QvjCZAnJvpf4YcYvvasRtD/8imACgwgt3
Gw/46k51ykYBRk8rX21nc7M=
=awhu
-----END PGP SIGNATURE-----

--nextPart1304219.mXQjKltbL5--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
