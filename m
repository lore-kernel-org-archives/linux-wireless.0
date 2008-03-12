Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60697 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYCLOxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 10:53:55 -0400
Subject: Re: 2.6.24, mac80211 and b/g switching
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Koutny <vlado@work.ksp.sk>
Cc: "John W. Linville" <linville@tuxdriver.com>, mcgrof@gmail.com,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
In-Reply-To: <47D6B3BC.9010000@work.ksp.sk> (sfid-20080311_163109_016617_2F17F012)
References: <47D160E4.3040503@work.ksp.sk>
	 <1204909966.6387.31.camel@johannes.berg> <47D17EDF.4010100@work.ksp.sk>
	 <200803071916.28776.mb@bu3sch.de> <20080307193429.GA5561@tuxdriver.com>
	 <47D1A7AC.6010307@work.ksp.sk>  <47D6B3BC.9010000@work.ksp.sk>
	 (sfid-20080311_163109_016617_2F17F012)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-v2qY3X1A1I0IoAD3+Mpu"
Date: Wed, 12 Mar 2008 15:53:21 +0100
Message-Id: <1205333601.15910.6.camel@johannes.berg> (sfid-20080312_145400_969786_E093AF21)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-v2qY3X1A1I0IoAD3+Mpu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

> So I've opted for compat-wireless-2.6 way, and as my first concern was
> to see if cw_min is being set correctly I've immediately come across an
> issue here:
>=20
> conf_tx (called from ieee80211_sta_set_ssid) is being called before
> IEEE80211_SDATA_OPERATING_GMODE flag is set/cleared (which is done in
> ieee80211_rx_mgmt_assoc_resp). That means conf_tx will use cw_min
> parameters from previous association, so when you switch between B and G
> APs, you will end up with wrong cw_min.
>=20
> Shouldn't conf_tx better be called only/also after association finishes?
>  Or should the IEEE80211_SDATA_OPERATING_GMODE flag be set prior to
> auth/assoc based on previous beacon/probe response info?

Good question. I think it should probably be set once we have decided
which network we will associate with as, in theory, we could send out
management frames with RTS/CTS protection too.

johannes

--=-v2qY3X1A1I0IoAD3+Mpu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9fuYKVg1VMiehFYAQL+5hAAtnVDm8lmXAyk0ZvHNJEudNv+ztojYNN0
1ZgT6HeaS7rwLlvB6UcuyhEVGAYIvh+u0NH9OMCA71l/01+94+rncit2yo3RAQsK
NftseCrkgxVRGj6oeF7n+sG8Y5dOHRUVAFwUYDJDhWKKIGEgXoys8Q4NRQDfwcp6
ds/TaMXkSvYqOEZ8wn6Nhb74N3xNGFLCR5W+btf1LEldUllE5jwaZk5NX6+PVKpm
Bxz7w+cVxvqbciEAHH/VQqnqjoGsdQ3zRQ25jjBtINeODJZ97K7R+SCqnGyUIhTk
PJujWqQK/kW+ki5U7OxkYSshO/+JbzFzjH1YyfljUI9O4np9OubzQiNHcfjqu3LX
+lBjrwLWRCaw1SBSgnovwUm/13IqCYlnppB2IjDHczumZsZr8AklYp67/Y9MXS2f
X3Ki+lmWSzEnWjTUsNRMoUI8G4bthdayN5mqBuE1uIBmLbYkEEOqSgMa15OyJuLc
7bZw0V+DlwfSjGdXIAVE3Xkz3GJan7nXZO1rz4LRpfeRRIPxbfSWlzd1LYa43/Lg
jUxCoFnfvIqhrDZPoKGq3+iumMeAsnZira+JhZ7TW7uTlTFpeIxBjPsYxF5dLLt8
vw1VX6M/2GQN7wt4ZTuy+FYVnFPmU/IjibGTXW6qqGIe/i7IxXLHMXbvJrdHbIBx
HOCCMlfld0o=
=7xVB
-----END PGP SIGNATURE-----

--=-v2qY3X1A1I0IoAD3+Mpu--

