Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from haggis.pcug.org.au ([203.10.76.10]:41112 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752Ab3KFUlm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 15:41:42 -0500
Date: Thu, 7 Nov 2013 07:41:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: stefani@seibold.net, Gabor Juhos <juhosg@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Linux-Next <linux-next@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: wrong merge of rt2x00/rt2800pci.c in linux-next
Message-Id: <20131107074126.c1ce0eb0a4449d1f902d3a29@canb.auug.org.au> (sfid-20131106_214147_843981_6EFC33F5)
In-Reply-To: <527A86D6.1030807@hauke-m.de>
References: <527A86D6.1030807@hauke-m.de>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__7_Nov_2013_07_41_26_+1100__PMpOu=YIjWFOtJ1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Signature=_Thu__7_Nov_2013_07_41_26_+1100__PMpOu=YIjWFOtJ1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 06 Nov 2013 19:13:42 +0100 Hauke Mehrtens <hauke@hauke-m.de> wrote:
>
> I was looking at linux-next-20131106 and the conflict in
> drivers/net/wireless/rt2x00/rt2800pci.c was solved wrong. The function
> rt2800pci_txstatus_interrupt() was moved from rt2800pci.c to
> rt2800mmio_txstatus_interrupt() in rt2800mmio.c in commit
> 8d03e77218ff4bc59e4645438acbd3c5c7e0f654 , the change done in
> 3bbfe1d952cd4d2e29bfcb31f109b5d74d1aa847 should be done there.
>=20
> This should be added to the merge 749550cb657ae5fb896b3b33070ae48f37813d1=
3:

Thanks for that, I will add this as a merge fix patch today.

Andrew, 3bbfe1d952cd4d2e29bfcb31f109b5d74d1aa847 is "kfifo API type
safety" from your series.  I am not sure how that merge conflict got by
me - I have no memory of it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__7_Nov_2013_07_41_26_+1100__PMpOu=YIjWFOtJ1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSeql8AAoJEMDTa8Ir7ZwVB6wP/R3VVQYrf1OM6LbOGhH3Rxhd
NxIS5eoDeYdy2XXQ/wa1gOdg5h7K4mVBDODQpUWlciw12LQgbQ4cmTpiDcpZgZXV
FYr7+WEM/eunRfgRl+TOT+Gl4pVzU2dO1vXk2/DDlZ1ohg7DSiVxvBYgQNKhDrv8
wrrLwOcj1C4dtpy1B/CQXL30N4kTMXLrGAmAz5sKdWun2wN4uTgu53uOpfzFaYzs
wHqrv3ciOBj4N8D/rlABGqlxweLSFEzj3ps0wjbgNypoT24PO89TmJrb01tTI+aE
31ONwBV3Ej/3K7AnUv29eVRMdaCC7jMc0A9rkI+CqOK57Y3OLzjxFAo40ip5osAE
HNBKiUmN0S2g2Prxc+etqu67ppurs1hX49b4m1oLGtS6d2dJGTOgH9cmaif4YYjR
RO1Vfstm0bi8HNk8dqSnfvqSXS0WODY5yF7DrZr7G8UV/QZSGYWZBDEv1eS8v1d0
BWYErt4h7l6tZw/gDd+yXfyqLgbqivYztMOd+vy/G+VXuz/i81cXBcrXo3YyGbDf
Bazoa2AZX9iaXG0aBopJ+OXNcb+Oo0JkV4fmW3LXIKLAjkMLFr08ZiQGL1ZJUtMG
uJXVGnXei10VWP1Hnz6jxVVawgtmVWzFVwAaW/Sf/avazii+YHuu4s9ZAzKjGygD
p0e+yXacRWtMDSYDlFDM
=Mob/
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Nov_2013_07_41_26_+1100__PMpOu=YIjWFOtJ1--
