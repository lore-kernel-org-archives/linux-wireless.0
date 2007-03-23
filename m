Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57299 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbXCWUPo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:15:44 -0400
Subject: Re: [PATCH v2] mac80211: Prevent unregistering of unregistered hw
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>, Linville@poseidon.net,
	John <linville@tuxdriver.com>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200703232021.26462.IvDoorn@gmail.com>
References: <200703232021.26462.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oAau58vGRZwqioLw4YrF"
Date: Fri, 23 Mar 2007 21:14:28 +0100
Message-Id: <1174680868.4470.8.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oAau58vGRZwqioLw4YrF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-03-23 at 20:21 +0100, Ivo van Doorn wrote:

> diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
> index 577dbe3..e7a613d 100644
> --- a/net/mac80211/ieee80211.c
> +++ b/net/mac80211/ieee80211.c
> @@ -4765,6 +4765,9 @@ void ieee80211_unregister_hw(struct ieee80211_hw *h=
w)
>  	/* TODO: skb_queue should be empty here, no need to do anything? */
> =20
>  	rtnl_lock();
> +
> +	BUG_ON(local->reg_state !=3D IEEE80211_DEV_REGISTERED);
> +

Hm. Maybe that's better since then there's no race like in my patch. Use
this one instead of mine please. But it does kill the system pretty
badly if you BUG_ON with rtnl held :)

johannes

--=-oAau58vGRZwqioLw4YrF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGBDUk/ETPhpq3jKURAmfYAJ4wRDq1KKQFhDxj9mJcoPn4ALbTRQCdEim2
wj6tBw1zPeExjgj8ok//mbo=
=ihPH
-----END PGP SIGNATURE-----

--=-oAau58vGRZwqioLw4YrF--

