Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48363 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223AbXHTL0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 07:26:55 -0400
Subject: Re: Lock problem with latest b43 patches
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	wireless <linux-wireless@vger.kernel.org>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
In-Reply-To: <46C7CACC.2000000@lwfinger.net>
References: <46C7CACC.2000000@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yzscJd9m0Gt/aia1SRYz"
Date: Mon, 20 Aug 2007 13:26:42 +0200
Message-Id: <1187609202.6090.93.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yzscJd9m0Gt/aia1SRYz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-08-18 at 23:45 -0500, Larry Finger wrote:

> -> #1 (&inode->i_mutex){--..}:
>         [<ffffffff80252d52>] __lock_acquire+0xad4/0xcf0
>         [<ffffffff803fe515>] mutex_lock+0x2a/0x2e
>         [<ffffffff80252ff3>] lock_acquire+0x85/0xa9
>         [<ffffffff803fe515>] mutex_lock+0x2a/0x2e
>         [<ffffffff803fe34a>] __mutex_lock_slowpath+0xef/0x290
>         [<ffffffff803fe515>] mutex_lock+0x2a/0x2e
>         [<ffffffff88600d7d>] nfs_revalidate_mapping+0x6d/0xac [nfs]
>         [<ffffffff885fe7e1>] nfs_file_mmap+0x4d/0x65 [nfs]

Are you running on NFS? This is a bit weird but not related to wireless
at all, seems to be dnotify/NFS interaction.

johannes

--=-yzscJd9m0Gt/aia1SRYz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGyXpy/ETPhpq3jKURAkNAAJ4iME2bhNXEJQ3cr/HwAVqTd5y0lwCgkfOm
jNI8Hqf2mBghPsLoUZM5HGM=
=i8Cd
-----END PGP SIGNATURE-----

--=-yzscJd9m0Gt/aia1SRYz--

