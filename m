Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33649 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936962AbXFHHDt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 03:03:49 -0400
Subject: Re: IEEE802.11e/WMM TS management and DLS support
From: Johannes Berg <johannes@sipsolutions.net>
To: yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <20070606082152.GA28639@mail.intel.com>
References: <20070606082152.GA28639@mail.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tu1XF2CDfVX3pMYobNqX"
Date: Wed, 06 Jun 2007 22:00:59 +0200
Message-Id: <1181160060.3398.35.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tu1XF2CDfVX3pMYobNqX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-06-06 at 16:21 +0800, Zhu Yi wrote:

> This is a patch series for IEEE802.11e/WMM support against
> linux-2.6.22-rc4.

Great :)

What I'm missing though is a sane userspace interface. Having all the
information in debugfs is great, but I don't think debugfs should be
writable here. Could you define this in terms of nl80211/cfg80211? I'm
not sure what exactly would be required.

Also, can you explain how you plan to use this? I don't think that users
will want to manually use the interfaces to add a direct link etc.
Hence, it has to be done automatically. What do we base the decision on?
If we're sending a whole bunch of data to another STA do we
automatically try to negotiate DLS? If so, do we do that in the kernel?
Or do we have enough information to do that in userspace?

Essentially I see two choices:
 1) we do it in the kernel, and do it automagically somehow
 2) we do it in userspace in some daemon

In the first case, somehow I'm missing how the kernel is supposed to
make the decision that it wants to use a direct link. But in case 2),
why do we need the kernel to send all these management frames? Couldn't
we just have some API to tell the kernel that we have negotiated a
direct link (yes, it'd require the injection patches, but that work is
available)?

johannes

--=-tu1XF2CDfVX3pMYobNqX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGZxJ6/ETPhpq3jKURAiKFAJwPdJO0RTxGbj8uTtTfdfc/nHddKACaAl/N
Mfpm2UIEjL5jU4RYcSKLzvY=
=aSKa
-----END PGP SIGNATURE-----

--=-tu1XF2CDfVX3pMYobNqX--

