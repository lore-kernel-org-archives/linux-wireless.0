Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53013 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbYCSTpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:45:23 -0400
Subject: Re: [PATCH] mac80211: configure default wmm params correctly
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Koutny <vlado@work.ksp.sk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <47DFC762.10307@work.ksp.sk>
References: <47DFBA13.3060508@work.ksp.sk>
	 <1205846472.16475.46.camel@johannes.berg>  <47DFC762.10307@work.ksp.sk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5Yyhp+v9B0t3v37BPKwv"
Date: Tue, 18 Mar 2008 15:16:53 +0100
Message-Id: <1205849813.16475.48.camel@johannes.berg> (sfid-20080319_194723_521828_8C80B0D1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5Yyhp+v9B0t3v37BPKwv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >> +		/* IBSS uses different parameters for Beacon sending */
> >> +		qparam.cw_min++;
> >> +		qparam.cw_min *=3D 2;
> >> +		qparam.cw_min--;
> >> +		local->ops->conf_tx(local_to_hw(local),
> >> +				   IEEE80211_TX_QUEUE_BEACON, &qparam);
> >=20
> > And shouldn't we do that only for IBSS? I'm in favour of removing it
> > completely, however, since the beacon queue is a way to construct
> > hardware, not do things in software...
>=20
> Good question; I've just moved this part of code out of
> ieee80211_sta_set_ssid as that is not the best place for it. I don't
> object to removing that code completely; seems that noone uses
> IEEE80211_TX_QUEUE_BEACON anyway. On the other hand, it can be a good
> hint for those implementing beaconing on hw where it has to be set
> explicitly..

I disagree with the latter part, but let's just leave it for now, I
think my QoS patch (the one Ron is adopting) will kill it anyway.

johannes

--=-5Yyhp+v9B0t3v37BPKwv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9/O06Vg1VMiehFYAQLWcA/+MdDzbGqX51dLk8QfiE6ElVig2NGzQ16f
c2fFlJ2Iagr2EaWozXs2W96w4DmZYef4Tzmw8MjoH77+tsZIescOK0E/M4Zc5mbJ
qIk/KyGn1fTTvB/CpRcDPmKnMhLSI/Dx13TnlZbDCuQE8Ki7KjLcXGTZ3jLOP874
gjGcLiei6PdGD5dLFeAIgG7MQlHpxuY+PYA76XuYvTzVpixWpuWAePVEEp6TqfMe
L/6O5DUrJtVHGHnm0Z9tMXsi+QVdCIbX/bigN00pUQqZNnYy30LPOa9Z3GcQcGx6
9LSSyW1nVQ6wI/8x86oNSh3VWRuPKsSFZpg0pxjo39LUz7AHRpc1OovKcDnnI95I
KTF0QYZ2sypnDCVL9xb5aeTcWhdEFGPTqwE3KIH+/Mp2z4DKeJVi4Pkel00eW79C
wyOXAdoeZ9YdedHvGEKsrOjOgco4wfd7Zc859WThfzvwG+rRSPy+3UuX4uuRvHGf
1caW6r6DgiHgPuYIfDslYpJ1eNzVRfju/hTGsAWr6/ERoyax9C6IExwRMA6fCkDU
wM3Gy22xBYWxlBhJ4OGkAmYoyo89HNVlTwgXJ9YBv6fUq4JVWq7Cn1+E7r+dKODX
xmozy1UcQaadBWaUZ5v8+q8qk3e+/oNfmWVUZ2Mu61hA3E4Rj3qV6CpIj0/3a05A
u1aMEt0ieR4=
=G7eZ
-----END PGP SIGNATURE-----

--=-5Yyhp+v9B0t3v37BPKwv--

