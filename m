Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45894 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940099AbXFHIKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 04:10:40 -0400
Subject: Re: [PATCH -mm] mac80211: fix 1-bit bitfield to unsigned
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-wireless@vger.kernel.org, akpm <akpm@linux-foundation.org>,
	jbenc@suse.cz, flamingice@sourmilk.net, Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <20070606150254.de49d627.randy.dunlap@oracle.com>
References: <20070606150254.de49d627.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/Sim/ZQ6ZeT32LThNq+f"
Date: Fri, 08 Jun 2007 10:10:54 +0200
Message-Id: <1181290254.6533.11.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/Sim/ZQ6ZeT32LThNq+f
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Very interesting. We were wondering why the latest git tree doesn't show
tons of endianness warnings, but it appears that when sparse finds these
dubious bitfields it turns off all other warnings.

Zhu Yi, can you apply this patch to your tree and review your code and
the sparse output and stick le16_to_cpu()/le32_to_cpu() into the
appropriate places? A whole bunch of things there are endianness broken
and sparse probably only gives you an approximation of what errors there
are.

johannes

--=-/Sim/ZQ6ZeT32LThNq+f
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGaQ8O/ETPhpq3jKURAvGxAJ9V66fTj9fmRHKOuU+W2ovKniwobQCgoywn
NpdGL8hRxUTmFv9EH9xrips=
=Kv1u
-----END PGP SIGNATURE-----

--=-/Sim/ZQ6ZeT32LThNq+f--

