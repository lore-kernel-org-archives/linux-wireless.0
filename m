Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EA141D232;
	Mon,  3 Aug 2026 14:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785765858; cv=none; b=eqnZ/cjoTj873TCLTPn6CFD/2GGhFzemYtnGoHfjfiiro1kjBtunDG6MgJRrOr/DEKPH3W+RzLmvUPjGGX0qoXgyW1NjPf8XRnYgK3EUyLSYwosg1rU1QtHuSMZ8NahJCkGMAdeUTXqOl6PRlsTqjAn86SyaitrkvzH1jR8NZl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785765858; c=relaxed/simple;
	bh=moVMPtfnnAD43VhQTEFyf5+tTnZ7ih3vD5goqDQ9m50=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=h/io2gRnA8xAq2TG2H5Of79FBt64piOOUR9ZIlMqd1K/PB/W4gu6FICKgfJgrlYHZPknN8goFC1zRvzmbgpZD9GtS6pKQcZaekCpdz4Jz7HTbQeQssAHuaiTPPbwLyQZc81jCY/0xeitLN/Niqy40kr7iY6KVvRdL+jkFRvqeBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jdl2FPqQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jdl2FPqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E981F000E9;
	Mon,  3 Aug 2026 14:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785765857;
	bh=wMOv2f0DwATQu8k6kCKqXxS8kQWn1h8HoFnotBLeZqk=;
	h=Date:From:To:Cc:Subject;
	b=Jdl2FPqQULEPcZcla1pG9K7/XSdDQiVg+HmG4BX4cg5TN6/Cn+DPnUZDkB6zyta50
	 0RKI4LZm21kSNt+6qce7GFhihztwrcrT5rJrxFlHDXUxixsVWJQ/lyjPvV41pysqTu
	 2PEDX6PtGgcVwyyNKDzJbL1uOvJXj5RNzIkfP6GNZaC7g1wqH2dIcRsqvwDhUArYzI
	 /e8pNQZVDnrZ6HsV7GSh5VJnjWvSX7YA2Xy+V4XYjxGldY2gWX5OK0svAVfGbPFxEi
	 thrXRmklOXkSs//zNT6Bc06tlrw8eyOKPSuTLJwZm9nwMZApfMjimuPZJsExTilUjR
	 gPWgo8EFlxYtA==
Date: Mon, 3 Aug 2026 15:04:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wireless <linux-wireless@vger.kernel.org>
Cc: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Ping-Ke Shih <pkshih@realtek.com>, Will Deacon <will@kernel.org>,
	Yicong Yang <yang.yicong@picoheart.com>
Subject: linux-next: manual merge of the wireless-next tree with the arm64
 tree
Message-ID: <anCf3WnRSrf3VD7I@sirena.org.uk>
Mail-Followup-To: Johannes Berg <johannes@sipsolutions.net>,
	Wireless <linux-wireless@vger.kernel.org>,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Ping-Ke Shih <pkshih@realtek.com>, Will Deacon <will@kernel.org>,
	Yicong Yang <yang.yicong@picoheart.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="b0B81MGmHuKCT2kA"
Content-Disposition: inline


--b0B81MGmHuKCT2kA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the wireless-next tree got a conflict in:

  include/linux/pci_ids.h

between commit:

  cf65b4d765b5f ("perf/dwc_pcie: Add support for Picoheart vendor devices")

=66rom the arm64 tree and commit:

  888b1934642b7 ("PCI: Move Spacemit vendor and device IDs to linux/pci_ids=
=2Eh")

=66rom the wireless-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc include/linux/pci_ids.h
index b0aad3af268b6,d6f26cacc8e35..0000000000000
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@@ -2640,8 -2640,10 +2640,12 @@@
  #define PCI_VENDOR_ID_SUNIX		0x1fd4
  #define PCI_DEVICE_ID_SUNIX_1999	0x1999
 =20
+ #define PCI_VENDOR_ID_SPACEMIT		0x201f
+ #define PCI_DEVICE_ID_SPACEMIT_K1	0x0001
+ #define PCI_DEVICE_ID_SPACEMIT_K3	0x0002
+=20
 +#define PCI_VENDOR_ID_PICOHEART		0x20fa
 +
  #define PCI_VENDOR_ID_HINT             0x3388
  #define PCI_DEVICE_ID_HINT_VXPROII_IDE 0x8013
 =20

--b0B81MGmHuKCT2kA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpwn9wACgkQJNaLcl1U
h9B8Qgf/ZDwUwgGzdBs0KcrveicOv7t/7I1hHk7cSuy/LeGMmA8T6SPorVkjS297
7nxZynMdyIR1UnEFpf4phs1Yrp3mpQCR9KxYZuKEkGKz9s6r4bSgth+SY3xOnbx5
zacEKAmjLltycy66XP4alJYj41/QI90zyEvIP+LPh8AppDXZWHQrKhDJagO24s9X
RKg0ClY/Ao4GfTGbVS1bZBNbutKn/1v0JoclJBJmmv8OteuT/hiX7LnzdaPo6kXZ
vjv2/bpqpEAnKay1NVw+IE+pjCMSl7ZN9otAyeX4ho2gGSiEgAyW4GydieYBBHy2
c6G6HDl546vpvLlFAGADLQFZveo0Hw==
=6mLZ
-----END PGP SIGNATURE-----

--b0B81MGmHuKCT2kA--
