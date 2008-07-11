Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57086 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbYGKKhv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jul 2008 06:37:51 -0400
Subject: mac80211 TID selection?
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomasw@gmail.com>, Jouni Malinen <j@w1.fi>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-j2D09ebSYP2SrvresgKu"
Date: Fri, 11 Jul 2008 12:08:46 +0200
Message-Id: <1215770927.3483.116.camel@johannes.berg> (sfid-20080711_123753_498121_AF6C6E72)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-j2D09ebSYP2SrvresgKu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Why is it that mac80211 determines the tid as

tid =3D skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;

?

Since the latter value is 0x7, that can only fill TIDs 0 through 7
instead of o through 15, shouldn't we be able to use the full space
somehow? Or if not, shouldn't we reduce tid_to_tx_q to have just 8
entries instead of 16?

johannes

--=-j2D09ebSYP2SrvresgKu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdzErAAoJEKVg1VMiehFYCVQP+wS6itPMjDKzuva3OGEx/yke
S31uwmo1R6nCObV+d4AMiusLA4mm+fbrgZBQiudV5NzfgDiHDGCQw/QSwcvz5q5E
dE+nhitT3s8xJs5KEd33kjJ6YYxUhEwSonDcLLSWrJIUQOsx8qbPPdXz7BuQQlBH
4REg2vybPADd7oEysXCPRhTFysrQzTtTFpjeObf+Bh8iKDJPJT75g/Btv9XWjgkk
k/gmh4juJUnnH2xm3eRdhwk01xJ+yof8vhoRdvL8wlmopHLDpaxebCiMwqkORqgy
Xeac4aNddAdRycIGjZpKs7hQ5SYKCXDanNL9fDgWpbevfu3t/pvnFEsIx/kw4gZa
0wo0F0MjLOPwUv1NUv2mLvpKAzWfB55VA14N0Ph5uZyF7xiHtvjIqT3xH8Cd15VO
Voqt65KBaOxGOCeYq645CcoW+naYPu20sz25o8ZaoA3bP71cJo6dQCzc8fW+XqKJ
6cL17OkmqSudtGUOGLTkMSEZK/6L65SbPio4i2fBt90aie4ti5Z+lnW5NxpiI+7Q
yUih2URwtCvmznxhfnIOGSpc9TcddTEo7MHNGF0fQ9IuKXNiw4HWkkId5C6eteKh
Ph3XQxt066FSbxbwJ/0xbx5yc2WymLowy2ufHV6nDUcTuxdLw1iTvHI/IxE5ZDOA
7Ghi0LHmTk5h6k/ZorD5
=+eGe
-----END PGP SIGNATURE-----

--=-j2D09ebSYP2SrvresgKu--

