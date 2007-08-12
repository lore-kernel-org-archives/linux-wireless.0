Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58363 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970364AbXHMItd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 04:49:33 -0400
Received: from [131.234.209.34] (helo=[131.234.237.45])
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1IKVc9-0007O2-Ko
	for linux-wireless@vger.kernel.org; Mon, 13 Aug 2007 09:49:30 +0100
Subject: retry count?
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xsKS+AOzGR9HPX221HIq"
Date: Sun, 12 Aug 2007 12:20:07 +0200
Message-Id: <1186914007.5363.9.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xsKS+AOzGR9HPX221HIq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

struct ieee80211_tx_status contains "retry_count" and I just noticed
that bcm43xx sets it to -1 if the frame was acked right away. Should it
be -1 in that case or should it be 0? A comment indicating either way
would be good. If it should be -1, then I suppose the radiotap tx status
needs to be fixed, it defines data_retries as a u8 so can't really be
less than 0.

johannes

--=-xsKS+AOzGR9HPX221HIq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGvt7X/ETPhpq3jKURAhLuAJ9qgR+QJyAXtt7j2LaJQk/LANIiYQCgk0+E
4W/S7VSfm4b+Us7yAufGtHI=
=3ccC
-----END PGP SIGNATURE-----

--=-xsKS+AOzGR9HPX221HIq--

