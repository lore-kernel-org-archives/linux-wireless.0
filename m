Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39790 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbYBUTZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 14:25:00 -0500
Subject: blockack sessions vs. sta removal
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cP0Sne/AeBuiAXEoMv9r"
Date: Thu, 21 Feb 2008 15:20:16 +0100
Message-Id: <1203603616.4462.5.camel@johannes.berg> (sfid-20080221_192509_998057_70427FE2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cP0Sne/AeBuiAXEoMv9r
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ron,

I was looking through some kernel oops with removing a driver
(unregister_hw()) while an AP is active and noticed that we don't clean
up, i.e. call ieee80211_sta_stop_rx_ba_session(), when a sta structure
is deleted. I think that's a bug.

Also, the code in ieee80211_stop() that iterates the sta_list should
have some locking, no?

I really need to work on cleaning up the sta info code, it really is a
huge mess.

johannes

--=-cP0Sne/AeBuiAXEoMv9r
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR72In6Vg1VMiehFYAQIWbxAAsqdkpe4c8mVWMWava/lDkLNTkaw/N073
uQjqY41zDeaNIGyETQJItiQ2yRMQdLHLoNYC0iMjD9A/kBp/X7lb7Exhgt2XkpCS
OQU0Pu6FjQ3/BcCXbMfcBOFS16a21ZBM77V20SyqYibWqDhvZuPp2fRRaTJTaI5N
i0ivnDJNBpRJPrmTckKZYj3YQ9FlDCFrLbvsAwVJa92eH5bwANsgyLJf4HPInFCs
O/9KqbD62quhkK3zwHFGf8FB+5aCK4FYuglySkdlDDtxr1uQh4h7Cp0moDAPRsVe
s7FAQ/p5IOUFUSHD6XPIUc/Wj2hVT3EEl1f62WhW17xXegjxhw4rWXZaEb8Wfnne
z7ZuhOrv/KCGYyfIhoD3vSvtTPB3i+CQuJrkF1NWDC1K8YCAd2ikaThs26ZTh8md
wwraUTET5ILDQCNf6CRzZsJm8EEjnSBN5HSCdspAFwWdyse9m/n4w26ApSmRfv+E
JHLRWekSPzce3+kswHcNuIBkBH3+gdor3yC9TfLzR7y/r44cJJcAZbhlEmNl0tqC
hszoMFFRzhyhFNzDLZNd1Po4zkOW3AfuVzwtPpRoxHH8gLSuFtDXG3HBfnH1QUzB
ufLCweVaT6S6sJLy/E09MxeY+gK6h9oFTHw5QiLwfz9uzxgTh8/jU2NnqgEnLwzY
rCnrqFSHJCE=
=d9AF
-----END PGP SIGNATURE-----

--=-cP0Sne/AeBuiAXEoMv9r--

