Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40735 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740Ab0BFNiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2010 08:38:16 -0500
Subject: Re: [RFC 2/2] cfg80211: scan for missing BSS on connect completion
From: Johannes Berg <johannes@sipsolutions.net>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org, holgerschurig@gmail.com,
	sameo@linux.intel.com, dcbw@redhat.com
In-Reply-To: <1265462416-7547-3-git-send-email-kilroyd@googlemail.com>
References: <1265462416-7547-1-git-send-email-kilroyd@googlemail.com>
	 <1265462416-7547-3-git-send-email-kilroyd@googlemail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KuV0kEzQMg/cevuhOIuE"
Date: Sat, 06 Feb 2010 14:38:14 +0100
Message-ID: <1265463494.4041.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KuV0kEzQMg/cevuhOIuE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-02-06 at 13:20 +0000, David Kilroy wrote:

> +	if (wdev->conn2) {
> +		struct cfg80211_bss *bss;
> +
> +		bss =3D cfg80211_get_bss(wdev->wiphy, NULL, wdev->conn2->bssid,
> +				       wdev->ssid, wdev->ssid_len,
> +				       WLAN_CAPABILITY_ESS,
> +				       WLAN_CAPABILITY_ESS);
> +
> +		if (WARN_ON(!bss))
> +			wdev->sme_state =3D CFG80211_SME_IDLE;

Can that case happen "legitimately", say the AP crashes right after you
connect, possibly due to the connection?

Even if not, this will leave the driver in a different state than the
state machine here, which we should clean up regardless I think.

johannes

--=-KuV0kEzQMg/cevuhOIuE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLbXDCAAoJEODzc/N7+QmaW4YQAMgQUrPDL4PsKPQ0t0QeEoo7
xZtaM9HtrPoj7D2ZuhR4BgIORLCUdM8QBngras29IzS2LA4p5qPi4ElBs4SXzs9l
FxpXaYQ9ZH+1LQ7d0vv/F6c+rcE0Mdj9hrHR2rSJWPu3mHOlCyGdF6zQuy8mps6V
iQZj+BkZxBZpwmaFfyI9RRZJaPW6vFvKxmAowbho1Oy4BwxtxfKam6owYBxy5yF7
DUGrGmJZRaZCN4CpGX70AR7eZwp5xnIEWkOzV38CkJCTEou52mKxkAqsoqwT4nn8
5Q7tGC5Yec0HP1O87A0xodC72UPszAdViHwJxu6JygXjjPkwwxM5PfR/YV03hJnW
L1B6t4XPZMo/c1nshUlG/YB5YBoLwxopM5f/3V6Z3bxH9EY7Q57hoyHxVCYlCHm5
faUOvRIteROpADKLBWSZ9DZ0n2LyT9g8Vf8d2uSL2DLdNri6S6w1j2+CP0L2hKQk
K+NSchOhUPS2cgUNJijmBZ3SqxJ7DzSUn2oxCYr7L99nl4v1sv73KP2UHHG2btRO
v6kT8+/IAZrcbgk78yH4c3PBkeaKTXla7TLA4bTdc3Td6nhIZCJIAPnhM1R5Kfj8
1GlIUKqp14JsEFFidr+kJ2VZ55nN/pnMVSxoNx3eOqQPpDnksjS/Gm83kdz9gq05
mGFUP+ERAbzrXr7orp+2
=40O9
-----END PGP SIGNATURE-----

--=-KuV0kEzQMg/cevuhOIuE--

