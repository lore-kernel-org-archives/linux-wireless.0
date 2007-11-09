Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38196 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbXKIMhz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 07:37:55 -0500
Subject: Re: [RFC] b43: fix multi MAC address hardware crypto support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <1194605606.4793.94.camel@johannes.berg> (sfid-20071109_121118_199355_3D5C7183)
References: <1194572631.4793.64.camel@johannes.berg>
	 <1194605606.4793.94.camel@johannes.berg>
	 (sfid-20071109_121118_199355_3D5C7183)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4lmWyT5E3DRVQh+hTZG0"
Date: Fri, 09 Nov 2007 13:39:12 +0100
Message-Id: <1194611952.4793.109.camel@johannes.berg> (sfid-20071109_123758_974628_F6ADABBF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4lmWyT5E3DRVQh+hTZG0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +static void b43_op_sta_notify(struct ieee80211_hw *hw, int if_id,
> +			      enum sta_notify_cmd cmd, const u8 *addr)
> +{
> +	struct b43_wl *wl =3D hw_to_b43_wl(hw);
> +	struct b43_wldev *dev;
> +	unsigned long flags;
> +	int sta_keys_start, i;
> +	DECLARE_MAC_BUF(mbuf);
> +
> +	/*
> +	 * NB: This function relies (for correctness) on the fact that
> +	 *     sta_notify() is always called before set_key() for any
> +	 *     given station.
> +	 */
> +
> +	/*
> +	 * For now, don't add back a STA to the RX key matching
> +	 * when it is removed from the second virtual interface.
> +	 */
> +	if (cmd !=3D STA_NOTIFY_ADD)
> +		return;
> +
> +	mutex_lock(&wl->mutex);

Hm. this is atomic, can't lock the mutex.

johannes

--=-4lmWyT5E3DRVQh+hTZG0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzRU76Vg1VMiehFYAQK6RBAAlI3AotRaFDZYuxNnJYUIB03i9NEYopAe
7gndQ4K+AA0eNAgp6VzlZgiih72NZsfNVStkrY5yLX4LOfOeDWuEbce7m7zHCQbq
5pHt0NgfKLCgDuSj5LRh3Xw3rmuc0aryxauO3bo5xucD4x0s+U+zYb4SdIPVAnNl
6fVkF8Twt+rwKh+zQEkONYnmggaMdtzCwKrkd9c1lbjGxxT6kmWfJxuKOdaU4ReM
M0HxmQ86zZWBwD9fwZxog4o3bLJ9nFK9vTObQtrKDDWO6RpN421aT5DPpeNRnwOD
hThLPBAKYp5TpSo4Qo04iOEthQHs7iQBqeUo5Cq7wzqCJSxTAGkV1Ln2IOR2TJkR
wm3G3bLnC7HVv62vKGPL2CVMIhOAy3rfHUj9BmgTaZ+W5ufnOv2XnTPewFOkB6YG
HMMw9Xsqu1zE4vqp7ok6NHs+GUkyfhVbYrBNnD1P9Y3og6pkt853aZlcmUeDU8k5
FHQKVgBK8qRAzx1GupF+tTwNCWQTC5uLQ2czRIuLuLN4QzSRUAOVYczU7AgbHpFQ
CeGFuNVOymHwcoBo47LHwS0AWgomM3UnEw+qtVr0sjQ2LJejbieYksad5d1I6LGl
uWb2l6/zqYIXOusJhd4xvdhD0o2KzxE3fBsdxkbDlf8KZ+uTVgp/egakytHY2C5F
Byr4bC0q2Zc=
=Y9wi
-----END PGP SIGNATURE-----

--=-4lmWyT5E3DRVQh+hTZG0--

