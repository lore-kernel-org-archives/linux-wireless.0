Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58537 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965504AbXCATEv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2007 14:04:51 -0500
Subject: Re: [PATCH] mac80211: move PHY things to debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <45E72174.9060104@warmcat.com>
References: <1172774065.3381.3.camel@johannes.berg>
	 <45E72174.9060104@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gF+USl22gK1SigLLF2nl"
Date: Thu, 01 Mar 2007 20:04:26 +0100
Message-Id: <1172775866.3381.7.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gF+USl22gK1SigLLF2nl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-01 at 18:54 +0000, Andy Green wrote:

> Gah I was using /sys/class/ieee80211/phy<n>/device/net:<ifname> to=20
> discover which physical device owns which interfaces... if there isn't a=20
> better/official way from userspace can this maybe stay in /sys?

That's already gone anyway in recent kernels anyway and the net: stuff
is broken currently.

When Greg fixes sysfs, the real way would be to follow the symlink
in /sys/class/net/ieee80211/ which links to (for
example) /sys/devices/pci0001:10/0001:10:12.0/ssb06:01/phy6, then go
back up one level and enumerate all net: objects in it.

Or, if you start from a netdev, you can see the phy80211 symlink.

johannes

--=-gF+USl22gK1SigLLF2nl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5yO6/ETPhpq3jKURAn8UAKCvAFTRntvUevdHgdJucPOoQk6nRQCeOoU5
T7oWBUToPrceUTxqk8D6JVc=
=2NPU
-----END PGP SIGNATURE-----

--=-gF+USl22gK1SigLLF2nl--

