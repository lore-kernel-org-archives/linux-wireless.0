Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39603 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968785AbXFHIVU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 04:21:20 -0400
Subject: Re: [PATCH -mm] mac80211: fix 1-bit bitfield to unsigned
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-wireless@vger.kernel.org, akpm <akpm@linux-foundation.org>,
	jbenc@suse.cz, flamingice@sourmilk.net, Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <1181290254.6533.11.camel@johannes.berg>
References: <20070606150254.de49d627.randy.dunlap@oracle.com>
	 <1181290254.6533.11.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-paRMEoO2uUUzr45Ur96U"
Date: Fri, 08 Jun 2007 10:21:36 +0200
Message-Id: <1181290896.6533.16.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-paRMEoO2uUUzr45Ur96U
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-06-08 at 10:10 +0200, Johannes Berg wrote:
> Very interesting. We were wondering why the latest git tree doesn't show
> tons of endianness warnings, but it appears that when sparse finds these
> dubious bitfields it turns off all other warnings.
>=20
> Zhu Yi, can you apply this patch to your tree and review your code and
> the sparse output and stick le16_to_cpu()/le32_to_cpu() into the
> appropriate places? A whole bunch of things there are endianness broken
> and sparse probably only gives you an approximation of what errors there
> are.

Oh, forgot to mention you need to run
make C=3D2 CHECKFLAGS=3D"-D__CHECK_ENDIAN__" M=3Dnet/mac80211/

(if you weren't aware already.)

johannes

--=-paRMEoO2uUUzr45Ur96U
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGaRGQ/ETPhpq3jKURArUTAJ4zL4cUsq7Ua165kLJLnu4+YAoqNgCgsod3
A245WUKgLmTyyPL0FdyMOTQ=
=Awlt
-----END PGP SIGNATURE-----

--=-paRMEoO2uUUzr45Ur96U--

