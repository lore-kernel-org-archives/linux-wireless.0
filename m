Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52805 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422925AbXCWODB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 10:03:01 -0400
Subject: Re: [PATCH 0/4] Try #5: Radiotap on Monitor Mode interfaces for rx  and tx
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: andy@warmcat.com, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200703221858.09200.flamingice@sourmilk.net>
References: <20070320103955.600509703@warmcat.com>
	 <1174500637.3944.9.camel@johannes.berg>
	 <200703221858.09200.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-W63mrsjQkqWbgoJVZhUU"
Date: Fri, 23 Mar 2007 15:01:34 +0100
Message-Id: <1174658494.3366.24.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-W63mrsjQkqWbgoJVZhUU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-22 at 18:58 -0400, Michael Wu wrote:

> Note that my patch predates the suggestion that IFF_PROMISC be used to tu=
rn on=20
> monitor mode on the hardware. (2006-12-18) I merely updated it so that=20
> monitor interfaces output radiotap whether or not the driver supports.

Right.

> This patch series is not meant to replace the management interface.=20

I know. However, ultimately something that will grow out of this patch
series will replace the management interface, otherwise this just adds
redundant API.

> 1. Make it easy to flip monitor mode on and off in drivers and support yo=
ur=20
> IFF_PROMISC suggestion.
> 2. Make the use of radiotap by drivers configurable independently of moni=
tor=20
> mode.
> 3. Report the result of a TX through monitor interfaces after=20
> ieee80211_tx_status is called. This requires new radiotap definitions.
> 4. Move things like radar detection and the rest of ieee80211_msg_* to=20
> cfg/nl80211 if they are necessary.
> 5. Port hostap and wpa_supplicant to the new interface. Will require some=
 fun=20
> with packet filtering..
> 6. Kill the mgmt interface once and for all.
>=20
> We don't need to replace the mgmt interface at once however. Addressing t=
he=20
> first two issues should be sufficient to merge the radiotap RX/TX patches=
.=20
> After that, 3-6 can be done one by one.

Those are all good points, and 1 isn't even required for just this
injection stuff that Andy is after, but I don't like adding this API
without having a clear plan of how it can replace the management
interface. One of the things you haven't convinced me of is that you
will be able to convince the BSD people to add new radiotap definitions
that we need. Also, if we can't have a good way to know exactly and
easily which frame we have when we see one on ACK (the cookie thing
about mapping injected frames to status updates) then I don't see how
this can possibly replace the management interface.

johannes

--=-W63mrsjQkqWbgoJVZhUU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGA92+/ETPhpq3jKURAiYxAKCu/IUEZ6FvE+koHYx+GO3t8WzFyQCfRIcW
ma8fMFTvpMx0vb8kLEQX9Pc=
=hhJr
-----END PGP SIGNATURE-----

--=-W63mrsjQkqWbgoJVZhUU--

