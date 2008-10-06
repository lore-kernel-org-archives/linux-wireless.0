Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54865 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbYJFM3b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 08:29:31 -0400
Subject: Re: iwl5000 oopses with Linus's tree
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1217937364.3603.37.camel@johannes.berg> (sfid-20080805_135654_962503_852A6EC4)
References: <1217937364.3603.37.camel@johannes.berg>
	 (sfid-20080805_135654_962503_852A6EC4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AUC0JMIfugzyZHLoL2C7"
Date: Mon, 06 Oct 2008 14:29:02 +0200
Message-Id: <1223296142.15196.4.camel@johannes.berg> (sfid-20081006_142934_904611_D23135ED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AUC0JMIfugzyZHLoL2C7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-08-05 at 13:56 +0200, Johannes Berg wrote:
> Regardless of whether it is enabled or not, this shouldn't happen:
>=20
> [  373.387834] iwl4965: uCode did not respond OK.
> [  373.387959] iwl4965: Error wrong command queue 0 command id 0x1
> [  373.388032] ------------[ cut here ]------------
> [  373.388058] kernel BUG at drivers/net/wireless/iwlwifi/iwl-tx.c:1163!
> [  373.388102] Oops: Exception in kernel mode, sig: 5 [#1]
>=20
> This is kernel 2.6.27-rc1-00504-g2b12a4c-dirty

I just found another thing that seems critical to this issue (I now am
using kernel 2.6.27-rc6-wl-01382-g0bea1f7-dirty):

It goes away completely when I use 4K-pages instead of 64K-pages.

johannes

--=-AUC0JMIfugzyZHLoL2C7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6gSLAAoJEKVg1VMiehFYb7YQAKMTjTWgVJurAPbZ/Chit8tD
7wX5NBan/F9YDDHYXKLpeA1LWIp7AB+crh6mKrGjEVSLCGkSW62MdHPY25h2lI22
0xFTXFwl2p5FRRlAmoPc47DMauIKXMh+AAIOb9zRiHJ05ct4J8RS00t4vTrfNFHd
nfDfDE34piKEVcBqYrOSR3mNBEJE8SIEeyMtuw02giMKtgGTNMtoMwesugvsHh+S
aWgjR7v2dP3ISeFVIIv1St8po7SZGff+TzeZ87l+owSZ7beRWNEzSM5dAdwt5h8V
vvuiA9xmh7FFJ0D1rKa6/vSPMPtub0XC/8+ySjzDqfviELEVT5SY8dn8bEKNz65H
NHBM+bvGrP5MROsAvwtOhO5zJb+qYuSHiawJqeBbktJuatpa2cRclwpDsV5mEg/P
q+QmSHN0v0UCaHVnZA3saW8c1tV8UR0WcZFyw2b2eWpFRTgFekuND4q0foLTFSG0
VFgQJry18hXFzeG+ExA7/PQELEMGoCfPuL2bMAALdVkQkcKMqUKGuq3OPMm1No8v
xW0Ye8eReipPSirvVZZj9QUzk9GPiucOgQsGgJB+ULAoOlEkQvAiz3qoDwnTP+bI
6Eq3xKs6YuCYtshoTtzcPoUeVLfxBwW525JzzcS1QSVDj9pHwLQu6SXfHlxWu6E6
TGg8eNqTx2scBvx8292y
=uqgt
-----END PGP SIGNATURE-----

--=-AUC0JMIfugzyZHLoL2C7--

