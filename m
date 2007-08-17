Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49894 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758077AbXHQKMr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 06:12:47 -0400
Subject: Re: [PATCH v2] hostapd: remove vlan stuff
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070817030649.GB1415@jm.kir.nu>
References: <1187131269.31200.3.camel@johannes.berg>
	 <1187180689.3998.41.camel@johannes.berg> <20070816012239.GQ1415@jm.kir.nu>
	 <1187270414.5141.42.camel@johannes.berg>  <20070817030649.GB1415@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-61EDpwQJh1vkPoAxwug4"
Date: Fri, 17 Aug 2007 12:12:18 +0200
Message-Id: <1187345538.23489.140.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-61EDpwQJh1vkPoAxwug4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-16 at 20:06 -0700, Jouni Malinen wrote:

> That would break the broadcast domain and if someone really want that,
> they could create a VLAN per STA..

Yeah, I was a bit confused here.

>  The purpose of using different group
> keys per VLAN is to allow each VLAN to have a separate broadcast domain,
> i.e., all broadcast packets to STAs bound to this VLAN are available to
> all STAs in this VLAN (and only to them).

Right.

> Since in 802.11 BSS networks, broadcast frames are only sent by the AP,
> hw acceleration can be made to work fine with this kind of
> configuration.

True.

> As far as the clients are concerned, they don't even know
> about the existance of different VLANs and group keys and as such, this
> looks a standard AP to them. As far as the AP is concerned, it will need
> to have support for using multiple keys with hwaccel and way of indexing
> them with each transmitted frame. Taken into account how support for
> hwaccel to unicast frames is implemented, this is quite a simple
> extension to that.

True as well, however, have you considered IBSS networks? As far as I
can tell, there you are actually able to put STAs into VLANs as well,
but you need to use per-VLAN group keys for receiving too.

johannes

--=-61EDpwQJh1vkPoAxwug4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxXSC/ETPhpq3jKURAsE1AJ9jhBsFnEaFCmQIj+HePgdT8BFYMQCgq59A
m4IwbrT0hntaMjfxdsQxmCs=
=WikA
-----END PGP SIGNATURE-----

--=-61EDpwQJh1vkPoAxwug4--

