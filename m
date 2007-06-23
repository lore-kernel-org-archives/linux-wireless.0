Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39214 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbXFWHHH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2007 03:07:07 -0400
Subject: Re: [WIP] mac80211: kill mgmt interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070621133556.GJ5361@jm.kir.nu>
References: <1182418939.10821.8.camel@johannes.berg>
	 <20070621133556.GJ5361@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xoBXodsRMV5TUidPrcH5"
Date: Sat, 23 Jun 2007 09:08:26 +0200
Message-Id: <1182582506.21939.112.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xoBXodsRMV5TUidPrcH5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-06-21 at 06:35 -0700, Jouni Malinen wrote:

> I don't really see need for getting rid of the management interface, but
> if there is consensus on doing that,

I think the ugliest point is that you need to do voodoo to conjure it :)

>  we would need to have another way
> of being able to receive and transmit management frames and data frames
> from/to user space in a way that provides at least following
> functionality:
> - transmit management frames at high priority
> - control whether transmitted frames will be encrypted or not
> - get callback to report TX status for unicast frames (whether the
>   receiver sent control::ack for the frame)
> - receive management frames

> - delivery of notifications to user space for Michael MIC errors and
>   other similar events

That all seems doable with some patches adding to the patches I had
posted before the one we're discussing.

> - receive data frames EAPOL/etc. ethertypes in decrypted form

This looks like a show-stopper.

Also the fact that then we don't need to add at least the flag "monitor
without leaving power save" which is fairly problematic to define
API-wise.

Plus Jiri's point that having a second interface open [1] is still ugly.
I don't even disagree, but until now I didn't have a better reason to
repudiate the monitor mode idea. I suppose that actually working in this
area made us all see the issues better (you've listed exactly the issues
but I had to extract those points from the code).

johannes

[1] and network manager hates that, it'll take the first opportunity it
has to convert monitor interfaces back to managed mode, at least if
they're alphabetically before the managed mode interface

--=-xoBXodsRMV5TUidPrcH5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGfMbq/ETPhpq3jKURAsdnAJ4+X7eE+AfPzl03AGj/fe9gf+HPpACeNZpT
brb0iNdDBSHp+Kj15rguMrU=
=DMOO
-----END PGP SIGNATURE-----

--=-xoBXodsRMV5TUidPrcH5--

