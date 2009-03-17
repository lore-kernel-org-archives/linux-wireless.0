Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54656 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbZCQHqM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 03:46:12 -0400
Subject: Re: [rfc] Implement ath9k mesh point operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Pat Erley <pat-lkml@erley.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org, andrey@cozybit.com,
	Andrey Yurovsky <andrey@cozybit.com>, brian@cozybit.com,
	javier@cozybit.com, colin@cozybit.com
In-Reply-To: <49BED464.2010904@erley.org> (sfid-20090316_233631_951441_68D057DC)
References: <49BED464.2010904@erley.org>
	 (sfid-20090316_233631_951441_68D057DC)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4Y4A7/vhbYSAZRyhTx7m"
Date: Tue, 17 Mar 2009 08:46:07 +0100
Message-Id: <1237275967.18086.6.camel@johannes.local> (sfid-20090317_084615_412503_03757B61)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4Y4A7/vhbYSAZRyhTx7m
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-16 at 18:36 -0400, Pat Erley wrote:

> Currently, you need to trigger a scan on the mesh point interface to
> enable beaconing.  This is the same behavior the ath5k, rt2500usb and=20
> rt61pci drivers exhibit.  Is this a mac80211 design flaw, or something
> in all of these drivers?

It's mac80211. We never call ieee80211_if_config() when we enable a mesh
interface, and thus conf.enable_beacon with
IEEE80211_IFCC_BEACON_ENABLED isn't ever set correctly.

johannes

--=-4Y4A7/vhbYSAZRyhTx7m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJv1U9AAoJEKVg1VMiehFYHW8P/3ywxvhi6J6vf1ZuG73NiSVi
KUhwqJNRDROVlSooLoFMNmGPPP2ZX6PS/P7Oh3xOmFBmtMgAl7KWpJG4ZhP1hiog
LkLOkGkEmlTT43Ra6tYLXQbPQNYW8SYeo7x3v5yuynLl1Wx1q05m1swdwqhI7vl/
B1Q26Oqyrs8abMNBLsj+HFLkVMWlUp+/ktmvVxcqhcJJ2GKeFXZSjeXRd2o8xlZk
Wj9nnIAwEXmmJ2DM8PN1RXuTB6UkloFF50Hgh35DcYhshyx+cfbUZApg3/TXt1wp
en8ipqJlxAQ/ahQk+/PdzzxKOPjCxSjqxqRAn5lyblD/GF9wWkKI9XLriNtsK5Wj
huDCofulTs4cjZ8MZajwWXeHeVq0ncMeAsEaC5Y+VS1Vgtkf4tUI6Kd+3N7nJNqO
1xHq+ViNsGAeXLMkRQG+b2MhJDJyod1TU0IJkF4ArqGSJRnBjBIL9CQ1W2HAj5Mh
4YTMlFdyRS3WH+V5gBKTMeaqQ6/DzIFIlYGIpP/D8sgtDw0NXJ+eJ50ExvskmpF0
1z/9TMlglT1jQLxFClk+R21i67dQgNNx1UHzRN/FBI3Lg1bMA0V6eT9jqKXb7E+u
IindZ7uaMta4fvh5H3VCmvzRdMiraTWA9qE0CWR5bPSDYH3KeFCarh6j59GXYjmR
g0AeMfbpPSQEe54A8X1R
=MvdM
-----END PGP SIGNATURE-----

--=-4Y4A7/vhbYSAZRyhTx7m--

