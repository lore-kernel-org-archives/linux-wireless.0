Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58545 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751709Ab0JJTDb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 15:03:31 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Julien Cristau <jcristau@debian.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, 599345@bugs.debian.org,
	ilw@linux.intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <1286437870.3657.16.camel@jlt3.sipsolutions.net>
References: <20101006191947.GA3036@radis.liafa.jussieu.fr>
	 <1286402043.2955.81.camel@localhost>
	 <1286437870.3657.16.camel@jlt3.sipsolutions.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Ig7/6PqpED9iVTWfC82K"
Date: Sun, 10 Oct 2010 20:03:13 +0100
Message-ID: <1286737393.2955.225.camel@localhost>
Mime-Version: 1.0
Subject: Re: Bug#599345: linux-image-2.6.32-5-amd64: iwlagn allocation
 failure
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ig7/6PqpED9iVTWfC82K
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-10-07 at 09:51 +0200, Johannes Berg wrote:
> On Wed, 2010-10-06 at 22:54 +0100, Ben Hutchings wrote:
> > On Wed, 2010-10-06 at 21:19 +0200, Julien Cristau wrote:
> > > Package: linux-2.6
> > > Version: 2.6.32-23
>=20
> > > Oct  6 21:05:02 radis kernel: [378665.326381] NetworkManager: page al=
location failure. order:4, mode:0x40d0
> > > Oct  6 21:05:02 radis kernel: [378665.326393] Pid: 25555, comm: Netwo=
rkManager Not tainted 2.6.32-5-amd64 #1
> > [...]
> > > Oct  6 21:05:02 radis kernel: [378665.363630] iwlagn 0000:0c:00.0: km=
alloc for auxiliary BD structures failed
> > [...]
> >=20
> > This particular allocation is for an array which is not used for DMA an=
d
> > therefore could be stored in non-contiguous pages allocated with
> > vmalloc().  But there may be some good reason not to do this.
>=20
> I have, however much more recently than that kernel, cleaned this up in
> commit ff0d91c3eea6e25b47258349b455671f98f1b0cd -- this particular
> allocation is now 2048 or 4096 bytes depending on the architecture (32
> vs 64 bit pointers). If you want to backport this, there are two or
> three more commits right before it that would probably be required.

It seems like we can get away with a much smaller change though.
Julien, could you test this patch?

Ben.

---
From: Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 17 May 2010 02:37:34 -0700
Subject: [PATCH] iwlwifi: reduce memory allocation

Vaguely based on
commit ff0d91c3eea6e25b47258349b455671f98f1b0cd upstream,
from which the following description comes.

From: Johannes Berg <johannes.berg@intel.com>

Currently, the driver allocates up to 19 skb pointers
for each TFD, of which we have 256 per queue. This
means that for each TX queue, we allocate 19k/38k
(an order 4 or 5 allocation on 32/64 bit respectively)
just for each queue's "txb" array, which contains only
the SKB pointers.

However, due to the way we use these pointers only the
first one can ever be assigned. When the driver was
initially written, the idea was that it could be
passed multiple SKBs for each TFD and attach all
those to implement gather DMA. However, due to
constraints in the userspace API and lack of TCP/IP
level checksumming in the device, this is in fact not
possible. And even if it were, the SKBs would be
chained, and we wouldn't need to keep pointers to
each anyway.

Change this to only keep track of one SKB per TFD,
and thereby reduce memory consumption to just one
pointer per TFD, which is an order 0 allocation per
transmit queue.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/=
iwlwifi/iwl-agn.c
index c56d355..6323bd7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -438,7 +438,7 @@ void iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct =
iwl_tx_queue *txq)
 	/* Sanity check on number of chunks */
 	num_tbs =3D iwl_tfd_get_num_tbs(tfd);
=20
-	if (num_tbs >=3D IWL_NUM_OF_TBS) {
+	if (num_tbs >=3D 2) {
 		IWL_ERR(priv, "Too many chunks: %i\n", num_tbs);
 		/* @todo issue fatal error, it is quite serious situation */
 		return;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/=
iwlwifi/iwl-dev.h
index 8f98d72..48927f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -197,7 +197,7 @@ struct iwl_queue {
=20
 /* One for each TFD */
 struct iwl_tx_info {
-	struct sk_buff *skb[IWL_NUM_OF_TBS - 1];
+	struct sk_buff *skb[1];
 };
=20
 /**
---

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-Ig7/6PqpED9iVTWfC82K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATLIN7Oe/yOyVhhEJAQL44A/+NOzBJ65Fx8V3n9r0F6FWJUIednc93o1H
M0GvMb9hcApsr/OGcbd7WqmlIfe+5zGUQBTCylF43YYCwMehNREn7caD8NMKOxZG
rB8iSNhirCA3E1TKb340t0vVp63/XSSQpjaqbZBN5kFUTQyyWPzU6YmpLj8TiJD0
9RCNNNXqMG8nwLQUw+fRE7NgBKa9XjjID9whUtwDf9HPJ2DZTJ4dlBlP2Kh0I7Is
YDKQg6xc+4IcXuSUdt0MT6gxCnkjGj0pE6p07YxvgXLuw3MnKc1G01dXbxTjvWR/
4wrakNXL916NX172UM+3iM7viQ7N1wMmpw0+31apuQrMffihr5zqKGkGzm6HUQt9
+5VJ0y2rkGTJO55PuIzgxVLStWbQbG2v05V+Ur0Nzzt13mCbvPeRP6n43GHy0gbs
wjR1osbHhdvAinRE32qDGbSB/yY7x15uHcb5arr+aN8APh+8CoSDEqFQKaia78ml
+3y0e6sgRr4bzxrfSEJwiJ2lvJ+IUCH5ZKLJhMB/NyACp9Ex9LXI7NYqq+Rh36la
RKkzleD+UDukBvtxYwCe0QjGNUkjrunwWIVWhP0FmX+Q+EraeDcsO6LYaEI51Wim
JghUYaPbP4d42wJ1v9ficmwYcu8QMKibC/THHJL1oQqYskQvf+C8kTiHNTiEzU9C
j51pO6OnX+0=
=3zQq
-----END PGP SIGNATURE-----

--=-Ig7/6PqpED9iVTWfC82K--
