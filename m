Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47538 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034AbXHQKKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 06:10:17 -0400
Subject: Re: [PATCH v2] hostapd: remove vlan stuff
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070816012239.GQ1415@jm.kir.nu>
References: <1187131269.31200.3.camel@johannes.berg>
	 <1187180689.3998.41.camel@johannes.berg>  <20070816012239.GQ1415@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yqhDwPrvdXXoFU+/Y7ie"
Date: Fri, 17 Aug 2007 00:39:10 +0200
Message-Id: <1187303950.23489.84.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yqhDwPrvdXXoFU+/Y7ie
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-15 at 18:22 -0700, Jouni Malinen wrote:

> This doesn't sound like a good idea. How would macvlan-based alternative
> solve the problem of having different group keys for each VLAN?

This is actually more complicated than it seems.

Currently, we have this code doing key selection:

        if (rx->sdata->type =3D=3D IEEE80211_IF_TYPE_STA)
                always_sta_key =3D 0;
        else
                always_sta_key =3D 1;

        if (rx->sta && rx->sta->key && always_sta_key) {
                rx->key =3D rx->sta->key;

which means that we'll always use the per-sta key unless that sta
doesn't have one configured (can that happen?!). And if we do have a sta
key, then we don't handle multicast/broadcast frames correctly as I've
just confirmed in the "meaningless TKIP messages" thread.

Reading 802.11, it seems that there are basically the following keys we
need to know about at this level:
 * PTKs
 * GTKs
 * STKs

For the purposes of mac80211, however, PTKs and STKs should be identical
as far as I can tell, they are just STA keys, used to send and receive
unicast frames to/from that STA.

Hence, the way I see it, initially key selection should simply work as
follows:
 (1) if the frame is unicast and there is a key for the sending STA,
     use it; it will be a PTK or STK
 (2) otherwise, use the key based on the key index, in an IBSS take into
     account the transmitter; the found key will be a GTK or WEP key

based on that, I don't understand what ieee80211_rx_h_load_key is doing;
is there a scenario where this selection doesn't work?

I'll try to come up with a fix first that also makes dynamic WEP work,
stay tuned.

Now, anyhow, this thread was about VLANs, so it appears that what we'll
have to do is modify the code to take into account VLAN group keys.

johannes

--=-yqhDwPrvdXXoFU+/Y7ie
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxNIO/ETPhpq3jKURAqobAJ42/0MFlCLu278u12tQ/L6X+UiNjACgk8Yk
5Jn+tq4yp7UUHQY+ylZo7WM=
=89fj
-----END PGP SIGNATURE-----

--=-yqhDwPrvdXXoFU+/Y7ie--

