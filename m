Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49728 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbXHOKtP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 06:49:15 -0400
Subject: Re: [PATCH] hostapd: don't reference ieee80211_msg_sta_not_assoc  if it's unused anyway
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070815034019.GJ1415@jm.kir.nu>
References: <1186781881.17351.15.camel@johannes.berg>
	 <20070815034019.GJ1415@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IaI4EqQseCYu25NOIkDI"
Date: Wed, 15 Aug 2007 12:48:44 +0200
Message-Id: <1187174924.3998.11.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IaI4EqQseCYu25NOIkDI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-14 at 20:40 -0700, Jouni Malinen wrote:
> On Fri, Aug 10, 2007 at 11:38:01PM +0200, Johannes Berg wrote:
> > Hostapd doesn't do anything about such frames. Kernel no longer sends
> > them and the constant was removed, so let's not reference it any longer=
..
>=20
> This is not good.. We should really make sure that deauth/disassoc is
> sent out at proper time to avoid clients getting stuck believing that
> they are associated.

I know we should, but I regard this as a bit of a chicken and egg
problem. Right now, hostapd doesn't care, but the kernel sends those
notifications. So I could remove it from the kernel without anybody ever
noticing.

> Why does the kernel no longer send this notification? The current
> wireless-dev.git seems to have this still in use and as such, I have not
> applied this change into hostapd and would rather not apply it either,
> i.e., if there is some need for getting rid of
> ieee80211_msg_sta_not_assoc, I would like to see it being done by
> providing similar functionality by some other means, not by just
> removing this.

The reason for removing all the ieee80211_msg_* constants is that I'd
really love to be able to get rid of the prism2 header hack in there. By
removing it from both sides I've only slightly extended the TODO from
"fix this in hostapd" to "add API to the kernel and use it in hostapd"
which I thought appropriate.

johannes

--=-IaI4EqQseCYu25NOIkDI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwtoL/ETPhpq3jKURAmLJAJwL4t1KrNHMDjP5ubEJU5LsT1TlHACgiT7N
aAEjjW68cPTOn0NYkW4v2Vs=
=gNlf
-----END PGP SIGNATURE-----

--=-IaI4EqQseCYu25NOIkDI--

