Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:38262 "EHLO element.ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbYCKQbE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 12:31:04 -0400
Message-ID: <47D6B3BC.9010000@work.ksp.sk> (sfid-20080311_163109_016617_2F17F012)
Date: Tue, 11 Mar 2008 17:30:52 +0100
From: Vladimir Koutny <vlado@work.ksp.sk>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>, mcgrof@gmail.com
CC: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: 2.6.24, mac80211 and b/g switching
References: <47D160E4.3040503@work.ksp.sk> <1204909966.6387.31.camel@johannes.berg> <47D17EDF.4010100@work.ksp.sk> <200803071916.28776.mb@bu3sch.de> <20080307193429.GA5561@tuxdriver.com> <47D1A7AC.6010307@work.ksp.sk>
In-Reply-To: <47D1A7AC.6010307@work.ksp.sk>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7E96957C80205BB34505B2CB"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7E96957C80205BB34505B2CB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

> Ok, thanks for this info, I might change my plans then. I'll try this
> way first, or (if that fails) the compat-wireless-2.6 path suggested by=

> Luis.

So I've opted for compat-wireless-2.6 way, and as my first concern was
to see if cw_min is being set correctly I've immediately come across an
issue here:

conf_tx (called from ieee80211_sta_set_ssid) is being called before
IEEE80211_SDATA_OPERATING_GMODE flag is set/cleared (which is done in
ieee80211_rx_mgmt_assoc_resp). That means conf_tx will use cw_min
parameters from previous association, so when you switch between B and G
APs, you will end up with wrong cw_min.

Shouldn't conf_tx better be called only/also after association finishes?
 Or should the IEEE80211_SDATA_OPERATING_GMODE flag be set prior to
auth/assoc based on previous beacon/probe response info?

Regards,
 Vlado


--------------enig7E96957C80205BB34505B2CB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH1rO8e5Z0y47EufgRAujXAJ9rCSDr2tIjcfiHvVuf6ZbFRrQrgQCfVm54
KNsyb8+pMHp3HQnncqjdp8I=
=anBE
-----END PGP SIGNATURE-----

--------------enig7E96957C80205BB34505B2CB--
