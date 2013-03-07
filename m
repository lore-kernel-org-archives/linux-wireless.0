Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:39094 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab3CGPbH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 10:31:07 -0500
Date: Thu, 7 Mar 2013 16:31:00 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de,
	johannes@sipsolutions.net,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Question regarding minstrel(_ht) and retry limits
Message-ID: <20130307153100.GA30608@pandem0nium> (sfid-20130307_163118_201511_3D8D53D5)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello list,

as you might be aware, it is possible to set short and long retry limits
to specify how often a frame should be retransmitted before getting dropped.

However, it appears that minstrel completely ignores any retry limit, and it is
also not applied later in the code path. I've hacked minstrel_ht a little bit
to apply the retry limits in minstrel_get_rate() before returning the rates
(i.e. just cutting retries at the end from the struct ieee80211_tx_rate array).

This worked for me, but is probably not clean either and might disturb minstrel
operation. Also minstrel uses much more retries than default retry limits
(short: 7, long: 4), so this patch might introduce behaviour changes.

What is your opinion on this? Can we get it properly supported? Does it hurt
to just use the first $retry_limit retries, and cut the rest at other rates
at the end?

Cheers,
	Simon

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlE4srQACgkQrzg/fFk7axYGbwCeP67dEnjIBesWcNGeiYDEscmT
LsAAniH2517p4lgGd5VKt4bKp4PF2G+L
=Ok0J
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
