Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55501 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbXL1NZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2007 08:25:54 -0500
Subject: Re: [PATCH 3/8 v3] mac80211: A-MPDU Rx adding basic functionality
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <11985948451654-git-send-email-ron.rindjunsky@intel.com>
References: <11985948383801-git-send-email-ron.rindjunsky@intel.com>
	 <11985948451654-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AB9DhvAHuIM/9DfQFXzq"
Date: Fri, 28 Dec 2007 14:25:40 +0100
Message-Id: <1198848340.4103.111.camel@johannes.berg> (sfid-20071228_132557_285192_8B310E8E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AB9DhvAHuIM/9DfQFXzq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	list_for_each_entry(sta, &local->sta_list, list) {
> +		for (i =3D 0; i <  STA_TID_NUM; i++)
> +			ieee80211_sta_stop_rx_ba_session(sta->dev, sta->addr,
> +						i, WLAN_BACK_RECIPIENT,
> +						WLAN_REASON_QSTA_LEAVE_QBSS);
> +	}

This needs something like

if (sta->dev =3D=3D dev)

but I don't really care whether it's in this or a subsequent patch since
we don't have drivers supporting multi-STA operation.

johannes

--=-AB9DhvAHuIM/9DfQFXzq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3T5U6Vg1VMiehFYAQIlUw//Um/2sv3UIXaxcrB7C6jXRONFXUoo7AWa
M99DCLBJ1OGMTwxF8kHfYtaRTkLk1ZJfECuVZpKHxyGc3n9mNbSZ4Y6hPCpnGABq
KdZFzDYSX2ZCJxhg345YgEahQsp7Q8kkiqoHVxK04Tmnz3XOjIHt3sPKV+vYIVee
3+9PcI49w9m9lc3SMUA5bf/YhyvlH1TOgJY2bOAtKFRdTApkjDmarcsXAaCLXKim
1/O2Rg/y0FS2ldft2P1UUjoNsg8NvKEVeIRZCsNLpzuuPOHU3VnC3Qw9probhzPq
s+JDNbFq6hNzdLoF8QZ/zu1ScJFeTruk9YwHtCp6cT+ovPZHP8S1uFWT0uE85H2l
XQGktb+Jxw2PRRcF2aW6roiVMSu6W0kVlyYhZNTk2gxoYb7BJ9dm11g/GEDCybsR
JcIEtIjo02iBdMhZcvu3MgjvVx9+JNX0nfnghj9HgWXAYkMbh2P7mlDMIoQw8a+m
Wg1KUETOOhAejCX1Zw5wvqQ/JnzZdIKkonGnF2QrAnOoYjc0hHbZSXsB1kbp4Uyn
t2qqAIafJ0FCyzSjvPFodvhS8tI9A0LW1BBkAa46JPKi22K4I0/3BW3R3iyK22n2
OWnGQSCeIogJFcZ0m7qSQxAhBp4Wil+QJd7XT8J+3x0/mlzfTi9piu77DWonD9AA
zEsyL6hiY8o=
=KC3k
-----END PGP SIGNATURE-----

--=-AB9DhvAHuIM/9DfQFXzq--

