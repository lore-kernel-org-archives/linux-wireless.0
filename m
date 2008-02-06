Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41991 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbYBGKfC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 05:35:02 -0500
Subject: Re: [PATCH] mac80211: enable IBSS merging
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <bruno@thinktube.com>
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net, jbenc@suse.cz
In-Reply-To: <20080206024957.22838.82194.stgit@one>
References: <1202209693.4395.29.camel@johannes.berg>
	 <20080206024957.22838.82194.stgit@one>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qcFxK7bCh5MV0Eg07SpE"
Date: Thu, 07 Feb 2008 00:52:35 +0100
Message-Id: <1202341955.9965.26.camel@johannes.berg> (sfid-20080207_103509_964358_4FBF3AF0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qcFxK7bCh5MV0Eg07SpE
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Looks fine, one last question:

> +		if (mactime <=3D timestamp) {
> +			if (CONFIG_MAC80211_IBSS_DEBUG || net_ratelimit())
> +				printk(KERN_DEBUG "%s: beacon TSF higher than "
> +				       "local TSF - IBSS merge with BSSID %s\n",
> +				       dev->name, print_mac(mac, mgmt->bssid));

I'd rewrite that as timestamp >=3D mactime and rename the two variables
(maybe beacon_timestamp and phy_timestamp or so?), but that's not too
important. However, in any case "<=3D" seems wrong, shouldn't we only
merge when it's actually higher? If your hardware/firmware has synced
properly and the PHY delay is accounted for properly etc. then every
beacon from the own BSS will fulfil the =3D=3D part of the condition, no?

Also, the beacon timestamp is defined as follows:

        A STA sending a beacon shall set the value of the beacon=E2=80=99s
        timestamp so that it equals the value of the STA=E2=80=99s TSF time=
r at
        the time that the data symbol containing the first bit of the
        timestamp is transmitted to the PHY plus the transmitting STA=E2=80=
=99s
        delays through its local PHY from the MAC-PHY interface to its
        interface with the WM [e.g., antenna, light-emitting diode (LED)
        emission surface].

(IEEE 802.11 11.1.2)

Since we define the RX timestamp to be when the first data symbol of the
frame hits the PHY, we here have to take into account the offset between
the two, at 1 MBit that's 192 (=3D24 bytes * 8 usecs/byte) usecs earlier
than the beacon timestamp.

On the other hand, you're unlikely to hit that window, but I suppose it
warrants at least a comment.

johannes

--=-qcFxK7bCh5MV0Eg07SpE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6pIQaVg1VMiehFYAQLXiQ//f2YweAB7hS0ogzyNNy81J70K08zeQ2Ba
ZlNr/gHBhtXm1ZEVNALseFec3Cw6vF/TmkwnLmtk3azV7t921+ipcbkK4xkmxrx0
vwo71ABWRB0McRAOzfa+7BE4GGRlLo+yvtPtP1pK7S6DWTE3SKBmNQfu/ZKd0B0L
RPAwSaj+fniahhgurTqEaxudGb6T1yrY4sxX5q9tk7mp0jFzo00uzP7Qq+6GrQds
v1hopwNFlKKkdc9S2oIKebINAoI9Gwr1uFFteJsNMaPfcZPdpin8JS9fkwYXzmyo
0nYpPh9Uh+RtxymvevOfz32hR1gZLgaX+gvSU30K+ZtEpO/ym1Ra9yyi3MI9hM6q
oVe5pd6UD/fdklGvPcaxEl9b+A29LPbFSJbjrNsxLrGNGxJcd5bjTUZo1VLjQaRy
uX8ILaSn+7Q7Xh20GboAxYfsr73Zxk0cYGYFiKH+Cffn004xbo1kFtxTOCjrIKsr
ilE2rA+Nk8jBgL0/8b0xipROs8xaGrNBvROrsaxyoInv2mXliRg4t13XgXBmQLRp
uH0MV5PkwaFdcqlwxlWVFP8hRKEk+fezdMqcshEc9rB00HyGlnK/Hx1OXRK9XmFL
Sb6jEzrClHuJKedLZVRZ+JmyH7VqqumvtE0Qu1Y+z+bgtGFSOMmaZL9do8Od6hrk
Zr+FLxy/MP8=
=6hxG
-----END PGP SIGNATURE-----

--=-qcFxK7bCh5MV0Eg07SpE--

