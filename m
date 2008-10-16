Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53552 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbYJPPrO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2008 11:47:14 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1KqV4C-0004B4-M9
	for linux-wireless@vger.kernel.org; Thu, 16 Oct 2008 17:47:12 +0200
Subject: mac80211 tx races
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-y75WRellxU3BEBnJs9io"
Date: Thu, 16 Oct 2008 17:47:05 +0200
Message-Id: <1224172025.735.76.camel@johannes.berg> (sfid-20081016_174717_843720_3AD2E70C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-y75WRellxU3BEBnJs9io
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

So... we've made things multi-queue aware, but that totally killed
synchronisation, now a lot of things are racy in mac80211.

Here's an incomplete list:

 * local->total_ps_buffered
 * stuff in rate control algorithms
 * various stuff in sta struct

How do we want to handle that?

johannes

--=-y75WRellxU3BEBnJs9io
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI92H1AAoJEKVg1VMiehFYSy0QALq4cRT6cKsFIN8PdPFzKp4U
ZJ7XJ/f12NVYy/1pguthg1BiifthmLKMAfMDgDJZp9u9nKN4sTGlSW29DEOP3tR4
bGzZCEnsZg9dFsv6bbAf/5c9tdZn0Z0WF63duNtKUg0/2mTx89rKJDKgFBmdwVP6
6YWNOwEAO3qAc0g7tnxNv/0bgwgnGpudJ+B65dVzUUC5kugTkgktUQifDzupM4RD
1YhcRqPAlTaoD3S/U9TUWCktt0JS4SAqZAUVzi8EqiMrzy/F6BpXqTCcboMwWGBb
nWgIi1HLTUO2C6mIB1OdGvugNpYsOyfweGl+9sayPKCH/yspdPrX4HqOAibUrxt7
FGYrNzrfKmF/g+MsBuubAzYckgmr8LFkg2PWVl7SFqqpFshpfh26oZCgeMfC0CfB
ksPMjpprjQJg4qm+jIOkhlfYtPVIhwvb8mHkXbj/3lMYComN9vQ4p5KlmTLSWEff
99tJ2HQFMpEJASgpdDhtxXecpjEb8KAx24YQQ6NUgNsYsyRJy1h5b50wsqfK/TzL
BpA+zrAO1zdCDPoJ2qQrtyOQZB+J/DbBcsOrNtVb6ymTwyD826pTtQI5TJp4ZqFF
tfSczfJTp6ojVjNSHZ77f6/iLnAZS4G//qniCPRv0xIlI6Jo4XpVF33JzMeEJyfd
FuVlzwtsC8ZewOozjQig
=kIb2
-----END PGP SIGNATURE-----

--=-y75WRellxU3BEBnJs9io--

