Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33250 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbXJXJJe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2007 05:09:34 -0400
Subject: Re: [RFC] mac80211: no missing key complaint if frame may not be
	for us
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net
In-Reply-To: <1193175981828-git-send-email-linville@tuxdriver.com> (sfid-20071023_230945_570294_0AD8EAEA)
References: <1193175981828-git-send-email-linville@tuxdriver.com>
	 (sfid-20071023_230945_570294_0AD8EAEA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jLPEArdGXjsWQeHqQVlU"
Date: Wed, 24 Oct 2007 11:00:55 +0200
Message-Id: <1193216455.5715.2.camel@johannes.berg> (sfid-20071024_100937_763211_3A0D3EB2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jLPEArdGXjsWQeHqQVlU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-23 at 17:46 -0400, John W. Linville wrote:

> +		/* if there are multiple SSIDs on this BSSID, the frame may
> +		   not be for us anyway; so, check that either the frame is
> +		   unicast or that we are not in managed mode before
> +		   complaining about a missing key */
> +		if ((!is_multicast_ether_addr(hdr->addr1) ||
> +		     rx->sdata->type !=3D IEEE80211_IF_TYPE_STA) &&
> +		    net_ratelimit())

I think this and the other patch looks good, though I'm not entirely
sure about the !STA test yet. I suppose though !STA means that we're in
some way an AP and then we're the only one sending real multicast
traffic.

Is it worth keeping this message at all?

johannes

--=-jLPEArdGXjsWQeHqQVlU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARx8JxqVg1VMiehFYAQK8bQ//YLdJ/Jp0WL/R9FCqq1+XznginkIzVujD
SMIR8Dabiv2qTKvtOsNU8pLFhn5uTlNY0y1soSoOyLZREpeFpVnPKLj6mYn87gT7
OYwvU0/uS98w0quHAGq43JzjzGbpv2kNZdOKnr88dgkcjK4hIZE9G0Ry+ksqW5B4
TmyoEHbo2KRx65Z5FO+gXV01iCbW3174KicX3rP7FCXiGts/6zkUU8y67dhw2TIP
+5sAS1UF9GeVX33IUFlGqGHdZqyXk6gwIUoEghAdogNOpOIe6EaJY3LPLu879CLl
5l36/YGX1MsZ2Z5wfvYYT3HO4PQTP4KZd62q/TI5gaHL/nUIyDfxG9s/UCBGc96f
qcZ2EygCuaCvQasGD9i3mnEtZOHvk/EkNdwMIG0znKWQDyVg1gqCiXWNdqMLJXBp
SQRYds8guFw0NM1GkVPpWqYzKOjIhieI7xJPZ8U30TGzSQSN1h64qdHi0lHTDlyh
P42MimZhCUVEu4/QlMaeKIhulRPcy51MmG1VgXHemiOzZuoVDK+fWVnLHTHX4dDP
9/h0Pj8Zc8a1Uc8Kfovszjm4M9P/nsLc6xKftF8kFthF8F/wIIXHl65yj5iUtLaG
SvXPb+P0DAKtywUirXp+3M97fRWekF44q419tNrhn4er19qlC5grBeiNzEzTrmAt
NkXxjWj0sS8=
=n7Xy
-----END PGP SIGNATURE-----

--=-jLPEArdGXjsWQeHqQVlU--

