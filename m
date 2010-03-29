Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41601 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755438Ab0C2AJ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Mar 2010 20:09:29 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: stable@kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Halton <johnhalton@gmail.com>, 575726@bugs.debian.org
In-Reply-To: <alpine.DEB.2.00.1003282040480.4731@ernie.pinecrest>
References: <alpine.DEB.2.00.1003282040480.4731@ernie.pinecrest>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SN3QLJ45FfnfRugWJ4+m"
Date: Mon, 29 Mar 2010 01:09:17 +0100
Message-ID: <1269821357.8653.231.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH] rt2860sta: Fix argument to linux_pci_unmap_single()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SN3QLJ45FfnfRugWJ4+m
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John Halton wrote in <http://bugs.debian.org/575726>:
> Whenever wpa_supplicant is deactivated (whether by killing the process or=
=20
> during a normal shutdown) I am getting a kerneloops that prevents the=20
> computer from completing shutdown. Here is the relevant syslog output:

The backtrace points to an incorrect call from RTMPFreeTxRxRingMemory()
into linux_pci_unmap_single().  This appears to have been fixed in Linux
2.6.33 by this change:

commit ca97b8388838ee9ea4b4bad04948f8f7f8a607a3
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Tue Sep 22 20:44:07 2009 +0200

    Staging: rt28x0: updates from vendor's V2.1.0.0 drivers

For stable-2.6.32, just fix this one function call.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/rt2860/common/2860_rtmp_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rt2860/common/2860_rtmp_init.c b/drivers/stagi=
ng/rt2860/common/2860_rtmp_init.c
index 0bc0fb9..98b0f8e 100644
--- a/drivers/staging/rt2860/common/2860_rtmp_init.c
+++ b/drivers/staging/rt2860/common/2860_rtmp_init.c
@@ -716,7 +716,7 @@ VOID RTMPFreeTxRxRingMemory(
 	{
 		if ((pAd->RxRing.Cell[index].DmaBuf.AllocVa) && (pAd->RxRing.Cell[index]=
.pNdisPacket))
 		{
-			PCI_UNMAP_SINGLE(pObj->pci_dev, pAd->RxRing.Cell[index].DmaBuf.AllocPa,=
 pAd->RxRing.Cell[index].DmaBuf.AllocSize, PCI_DMA_FROMDEVICE);
+			PCI_UNMAP_SINGLE(pAd, pAd->RxRing.Cell[index].DmaBuf.AllocPa, pAd->RxRi=
ng.Cell[index].DmaBuf.AllocSize, PCI_DMA_FROMDEVICE);
 			RELEASE_NDIS_PACKET(pAd, pAd->RxRing.Cell[index].pNdisPacket, NDIS_STAT=
US_SUCCESS);
 		}
 	}
--=20
1.7.0.3


--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-SN3QLJ45FfnfRugWJ4+m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS6/vpue/yOyVhhEJAQIkPQ//Ttmy1wwBOMHWY8kZ/YuIyX81JDknxhMJ
tEaCMREJYdTcPcTOoUadIPadRnP5PMPMa/yh9hp9c+WX1d1LRU6324g73v29hnqx
Jp2qhwTttFsOLCmsLv1UdGoiSeealtBbW+ERGTZr7tRM7TEAeOI6WCBjfaAnf1Fy
8JREss88lZWXD/rK8jz537uglxbW7iQvVPCpbFPQA5VneCddzGM6q687rMLeIoST
SymvO5XwzetMaRQ129Jq4bLUXDRwoTbQhj+/Jq8GnrPL12DzzuKC8u4JHtXSIt2e
ILua5IpBl7B3UrG7sIi0104X8RYpZOE34rmwV3K+fb+8z0Mb9XoyfFG+2mB50WD4
2QXJ3npdti7RbFTnK7yERkd7corCRDzO8vNWQLkgyZ7BNS03L4Au8Spf9bBe6kWS
nHM+530J94ORqkwEoFA3RSy2GnfFIWKrQ8/B++V7yavsFxlSWeWuwDYC0BtkxiwC
iapGC7wjW44vJXN/BfZ6XGBcR/YfK80kl54maJgVgnIwSCWdNgJE2BZNmDKaqX1Q
wZw1f7ERHWbdcWwEDXkhKUcW8HZWZkamch15s+vY/7pfk8lyT5t4nzB3HJwcgrjf
R1sk3UVbB5KlWhZ3aUkdqWD9528JIK3z1I4RLaX9xYv7+E2eKhqjgInzqEHqoCUO
TiXuhxHqpVI=
=NxJn
-----END PGP SIGNATURE-----

--=-SN3QLJ45FfnfRugWJ4+m--
