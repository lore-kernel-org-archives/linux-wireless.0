Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37349 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681AbYEFSnt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 14:43:49 -0400
Subject: Re: [PATCH] mac80211: Add RTNL version of
	ieee80211_iterate_active_interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <200805061943.31902.IvDoorn@gmail.com> (sfid-20080506_193516_026933_8BC79A41)
References: <200805061943.31902.IvDoorn@gmail.com>
	 (sfid-20080506_193516_026933_8BC79A41)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DK1Gsr6O2GQb1Mdc+P4l"
Date: Tue, 06 May 2008 20:43:05 +0200
Message-Id: <1210099386.3914.21.camel@johannes.berg> (sfid-20080506_204300_495867_33D2A0F8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DK1Gsr6O2GQb1Mdc+P4l
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	 * requested configurations, make sure to use
> +	 * the _rtnl version since the regular version
> +	 * requires atomic context.

That's a bit misleading, the regular version requires that the callback
is atomic :)

> +	 */
> +	rtnl_lock();
> +	ieee80211_iterate_active_interfaces_rtnl(rt2x00dev->hw,
> +						 rt2x00lib_intf_scheduled_iter,
> +						 rt2x00dev);
> +	rtnl_unlock();

>  /**
> + * ieee80211_iterate_active_interfaces_rtnl - iterate active interfaces
> + *
> + * This function iterates over the interfaces associated with a given
> + * hardware that are currently active and calls the callback for them.
> + * This function allows the iterator function to sleep, the caller is
> + * responsible for proper locking mechanisms to prevent concurrency.

That description seems misleading. Also, since the mac80211 internal
list management could possibly change (I don't see it changing but who
knows), I think I'd prefer if this function acquired the rtnl itself
didn't have rtnl in the name. Can't think of a good name right now,
maybe rename the other one to _atomic?

johannes

--=-DK1Gsr6O2GQb1Mdc+P4l
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCCmuKVg1VMiehFYAQJ1LxAAmmUoJW944sWFMIBhqg+SVZhvAZYWOV7L
tYLFOhf9z219ZhxdDj5x/SA0kBN4wTVhvfz0YYYbieeMS3T7mCDD7L8dphZ0JbnI
CcQvETLjHClXzzXPGAdlLmbKEr8eS3bhntvdYGWsUo+/EVHaBTuCRjfagJ6pXkAU
V3DEjN4amfzODIO4R9DAmwFW3c9jCRdMNpgTZ4wOQECOjrXyaWjIV33vMWTdv7mE
NEAba3Ld+VK8Kor7osHI8z0ebpVqAorqJs9Q3DM2YzsuexB2GHk9qmKaoMsbCkR4
wXP89C5LW+nW2RGFDJY2aen5CElX/Pui5mh5zW/RlH+Hqtr8RKLU25QXe8c/3a6C
ql78nHXJtYQwJXIr2MDGLlyJGVSME5uufPkUDgB1oCA+e8xPmccSjOMJ4tAi13py
clj17yy7LBmDtQkf6nwoZYlfzvgssAjCwz8/e9gx5OVyh3Vw/vlxyRprSKft3K+5
+VpW/ktKDpFx+Sf+vSIXgjqCK2CsF3MprIAy1XGNSC9YaEOZAyZwD6uh1DRbt0cs
g7Cb0m8K8A2tpwDnpx0BNa4/alDwpLxNiJxk0s4f+V3wJ8fFiNwYUL/ynPn1UGNU
bLxLbvySMGTglqOlHv3djHIKIT+8mM88YXRC5FSUUBUOQaQunNAOByfjFQxO3hGN
/UyxhUKSd6U=
=vjL/
-----END PGP SIGNATURE-----

--=-DK1Gsr6O2GQb1Mdc+P4l--

