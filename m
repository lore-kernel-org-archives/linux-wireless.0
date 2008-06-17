Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34902 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbYFQIvd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 04:51:33 -0400
Subject: Re: Management frame protection and packet injection from hostapd
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080617073227.GA4974@jm.kir.nu>
References: <20080616143308.GB18479@jm.kir.nu>
	 <1213627991.3803.38.camel@johannes.berg> <20080616153421.GC18479@jm.kir.nu>
	 <1213634684.3803.43.camel@johannes.berg>
	 <1213634868.3803.45.camel@johannes.berg>  <20080617073227.GA4974@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cR8OTKUPg5Chavjavid1"
Date: Tue, 17 Jun 2008 10:50:38 +0200
Message-Id: <1213692638.3803.70.camel@johannes.berg> (sfid-20080617_105136_783860_9B054E69)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cR8OTKUPg5Chavjavid1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I did.. I added another set of functions for default management key and
> did not remember to call the removal function from
> ieee80211_free_keys(). However, adding that call did not change
> anything.

Ok.

> It looks like we end up trying to remove the netdev directory in debugfs
> before removing the default key symlinks. Consequently, debugfs_remove()
> fails since there is still a file in the directory. This is what happens
> when removing the monitor interface:
>=20
> cfg.c: ieee80211_del_iface() ->
> iface.c: ieee80211_if_remove() ->
> iface.c: __ieee80211_if_del() ->
> debugfs_netdev.c: ieee80211_debugfs_remove_netdev()
>     [too early; symlink still there]
> unregister_netdevice(dev) -> [dev->uninit]
> iface.c: ieee80211_if_reinit() ->
> key.c: ieee80211_free_keys() ->
> debugfs_key.c: ieee80211_debugfs_key_remove_default()
>=20
>=20
> Any idea how to fix this?=20

Hmm, no, no idea at all. To be honest, I don't fully understand
interface lifetime rules and I think many of those functions are
probably misnamed. I.e. why is the _reinit function assigned to the
->uninit callback? Much of that either comes from the original
Devicescape code or what Jiri did to it, and I never bothered to clean
it up.

> Why is ieee80211_debugfs_remove_netdev() call
> in __ieee80211_if_del()?=20

I don't really know. Probably because that's where Jiri had the sysfs
code I converted to debugfs ;)

> Could it be moved into ieee80211_if_reinit(),
> so that it would happen only after the ieee80211_free_keys() call?=20

That's well possible, I guess you'd have to try.

> Since
> ieee80211_if_reinit() is called from other places, too, it might be
> cleaner to define a new dev->uninit function that is a wrapper for call
> to ieee80211_if_reinit() followed by call to
> ieee80211_debugfs_remove_netdev().. However, since ieee80211_if_reinit()
> calls ieee80211_if_sdata_deinit(), it might be necessary to call
> ieee80211_debugfs_remove_netdev() before this call (or from it?); I did
> not yet look into details of what would be the required order for these.

I really don't know either. If you feel motivated to clean up the
interface handling I'd appreciate it.

johannes

--=-cR8OTKUPg5Chavjavid1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIV3rbAAoJEKVg1VMiehFY0hYP/jGeXh0vE4yeE70ohY5k/vjX
thUpI6InLWKLvx+wA63LHMzjPRg9mpfTtwBUIxszq+fEAyCmBMrNTIqZaxgjOsPB
xGTocQv1uDhLqXrx6bltmDmPwLf0vyuXwy9NVfyxz/ohkOsha0J6uElSt+MNGovp
AdT6On9x60iJ0cFlkUhZJfS3zivJrAN6MmQ7aKYXXT7DCoPChbpwdSSE9zDjktJf
jtuvaqIKZvo9ylQgMiqIWh6dJ8432T+og7MVvL7qIedHLMLPHbY+X1/+glY+WvrO
rq1HZSsJEgPiqNEz8em1WGeWu1oJKnrqFFwp3P3sS/EZB9tBHQjwX1A4V5oWldpX
4Wkueans3osmn/g/oBDel5G55yeWJreP4v/c/DZAGxP0rEuvfPNPb2cZryn5UECw
y4XoTFIfdnkI32VIB5FQIjay0+HEJV6tFy0XcyVgDEp7eqHkL+MEuh1WjM1yCLIQ
dkSnpI7s+DgrjICBFWhNB6udyQo1aoY2X4PHBrTuod8Rcj5khQg0U/ZzSPbVsp41
K7MYQKMlTVAMxyTnHWrRgZlBYtvTZEXMYczVK3NQVROY0+ZGUFuWQDrSSAJw5y+R
VVhBC4z85Ipjcr8Yk9Fl5X7SdYs4eZ+kkqXodZGt8zK94OEuWZHwBPnfe/78GtC3
O069v64ni9NCWTC0eX4A
=NVxz
-----END PGP SIGNATURE-----

--=-cR8OTKUPg5Chavjavid1--

