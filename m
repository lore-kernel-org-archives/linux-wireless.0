Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49713 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbYDURRs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 13:17:48 -0400
Subject: Re: [PATCH 4/9] rt2x00: Use rt2x00 queue numbering
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	rt2400-devel@lists.sourceforge.net
In-Reply-To: <200804211900.47216.IvDoorn@gmail.com> (sfid-20080421_190104_533995_4AAFC473)
References: <200804211858.46659.IvDoorn@gmail.com>
	 <200804211900.47216.IvDoorn@gmail.com>
	 (sfid-20080421_190104_533995_4AAFC473)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Nvx3D4syb6Pf3umZ9kpZ"
Date: Mon, 21 Apr 2008 19:17:12 +0200
Message-Id: <1208798232.26186.121.camel@johannes.berg> (sfid-20080421_191838_915797_F7D3F856)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Nvx3D4syb6Pf3umZ9kpZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ivo,

On Mon, 2008-04-21 at 19:00 +0200, Ivo van Doorn wrote:
> Use the rt2x00 queue enumeration as much as possible,
> removing the usage of the mac80211 queue numbering
> wherever it is possible.
>=20
> This makes it easier for mac80211 to change it queue
> identification scheme without having to deal with
> big changes in the rt2x00 code.

Cool, thanks a lot. One small note:

> +static inline enum data_queue_qid mac80211_queue_to_qid(unsigned int que=
ue)
> +{
> +	/* Regular TX queues are mapped directly */
> +	if (queue < NUM_TX_DATA_QUEUES)
> +		return queue;
> +	else if (queue =3D=3D IEEE80211_TX_QUEUE_BEACON)
> +		return QID_BEACON;
> +	else if (queue =3D=3D IEEE80211_TX_QUEUE_AFTER_BEACON)
> +		return QID_ATIM;
> +	return QID_OTHER;

Are you actually using TX_QUEUE_AFTER_BEACON? That queue number is a
historical accident (imho) and not used, we actually use the
IEEE80211_TXCTL_SEND_AFTER_DTIM tx control flag.

Also, with the QoS patch, those queue numbers should finally go away and
mac80211 will not pass anything but the data queues, hence, this small
inline would probably be reduced to "return queue;" by the patch.

johannes

--=-Nvx3D4syb6Pf3umZ9kpZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAzMF6Vg1VMiehFYAQIL4Q//RG6jhkGxAnQvl/NbolP9pL1Rd4AdL4J5
I6ustpd+/sUHnzHwKQNXkrwBHjuu6loSGhxK5g2PX2NU29sDFrXNbrw/K4rVlEDu
lEXIJntwexCrYFXCHzLQ8xBJWGC7lcWrFiC4/Bnnyba0DJDH/0gcwhq1d7zAJmyk
qWBsxkNN+kKHbo69fIokozkqg6b436eHDspgzoouj88dwU/r79vEpmax8VrKQqm/
X7Gev51weWgu4+AIKQwc5tY5btDkFp6OZsP47Y83CdeTNrjkqYu2OWiC+qKvrLu9
Xy2DaFIsnPO4PGVKcQui4Atjeo5WC1mFosFo7wGzmmUz2CenNIb0yrzm1HnX6fyk
07wWVmIrqNZrTrxK70g93ysYrWidcXssEgELGfC+KL6FFlZ6B7dfzKTNNhaTNN/M
9ef3WWynyHCQ3UoPcudO2NoRNvrWT2+QBf0Vpn896DqTAXNOAG4fKRqNLyMCk5z8
Gzr/hmbxKVTDgTSX03/Ba6E4DY8NfvyGcmxXv1BHh1GAIG5INifXMO2LAFIw46L1
ZkEpHyfJMUddCJrV0+yE89wDyeaK/BKchAXgm2Rn+W3kniBNmCBfFINbe8o5RfNw
nOoC/AYt5NvyUgVcqsyQyf4cpW30PmsQEois1QkIVGxiqSwfxzg4SNgfNK+0MNRE
8Oi2/vQ2Y/E=
=UzK3
-----END PGP SIGNATURE-----

--=-Nvx3D4syb6Pf3umZ9kpZ--

