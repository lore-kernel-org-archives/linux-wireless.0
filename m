Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44946 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbZGGIuw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 04:50:52 -0400
Subject: Re: [PATCH v3] Fix regression in mesh forwarding path.
From: Johannes Berg <johannes@sipsolutions.net>
To: javier@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>
In-Reply-To: <1246935252-19823-1-git-send-email-javier@cozybit.com>
References: <1246929954-15282-1-git-send-email-javier@cozybit.com>
	 <1246935252-19823-1-git-send-email-javier@cozybit.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wTAiP2YipWsjbqAl1FKf"
Date: Tue, 07 Jul 2009 10:50:52 +0200
Message-Id: <1246956652.4316.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wTAiP2YipWsjbqAl1FKf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-06 at 19:54 -0700, javier@cozybit.com wrote:
> From: Javier Cardona <javier@cozybit.com>
>=20
> The removal of the master netdev broke the mesh forwarding path.  This pa=
tch
> fixes it by using the new internal 'pending' queue.
>=20
> As a result of this change, mesh forwarding no longer does the inefficien=
t
> 802.11 -> 802.3 -> 802.11 conversion that was done before.
>=20
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/mesh_hwmp.c    |    3 ++-
>  net/mac80211/mesh_pathtbl.c |    9 ++++-----
>  net/mac80211/rx.c           |   17 +++++++++++++++--
>  net/mac80211/tx.c           |    3 ---
>  4 files changed, 21 insertions(+), 11 deletions(-)
>=20
> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
> index f49ef28..c31fe79 100644
> --- a/net/mac80211/mesh_hwmp.c
> +++ b/net/mac80211/mesh_hwmp.c
> @@ -784,7 +784,6 @@ int mesh_nexthop_lookup(struct sk_buff *skb,
>  		mesh_path_add(dst_addr, sdata);
>  		mpath =3D mesh_path_lookup(dst_addr, sdata);
>  		if (!mpath) {
> -			dev_kfree_skb(skb);
>  			sdata->u.mesh.mshstats.dropped_frames_no_route++;
>  			err =3D -ENOSPC;
>  			goto endlookup;
> @@ -804,6 +803,7 @@ int mesh_nexthop_lookup(struct sk_buff *skb,
>  		memcpy(hdr->addr1, mpath->next_hop->sta.addr,
>  				ETH_ALEN);
>  	} else {
> +		struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
>  		if (!(mpath->flags & MESH_PATH_RESOLVING)) {
>  			/* Start discovery only if it is not running yet */
>  			mesh_queue_preq(mpath, PREQ_Q_F_START);
> @@ -815,6 +815,7 @@ int mesh_nexthop_lookup(struct sk_buff *skb,
>  			skb_unlink(skb_to_free, &mpath->frame_queue);
>  		}
> =20
> +		info->flags |=3D IEEE80211_TX_INTFL_NEED_TXPROCESSING;
>  		skb_queue_tail(&mpath->frame_queue, skb);
>  		if (skb_to_free)
>  			mesh_path_discard_frame(skb_to_free, sdata);
> diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
> index 3c72557..1e32948 100644
> --- a/net/mac80211/mesh_pathtbl.c
> +++ b/net/mac80211/mesh_pathtbl.c
> @@ -14,6 +14,7 @@
>  #include <linux/string.h>
>  #include <net/mac80211.h>
>  #include "ieee80211_i.h"
> +#include "wme.h"
>  #include "mesh.h"

You _could_ drop that extra include now, but it's not like it really
matters.

johannes

--=-wTAiP2YipWsjbqAl1FKf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKUwxoAAoJEODzc/N7+QmatDIP/imHjezDm1u21frH4KUAXsvy
Zra5PenVMurbvVSdU1nKLOvxp9mNBozr3TVKWaRpOv4sSrDf4s2tjTpiKAIaJl6v
kvo9hwciCZwZwZ9esEaWGU8R9qiub88u2UibWAxoy54cCnwVBxYEMyZolMjWxVZy
I7bhbYIpOnl24XzFs2JNJ126EQLcUb4wRUFZaAYFNBSQ6o/cFwOisAF80BzuW5tD
hWZJIUjfly3QJATVkpDIEXR/RYUdKY6dYIxrYv1YnEghyWadYpJyByrNZPIAaaS5
AMoYtadIUbFaX843ZHF6HJoPQ2dCNyg13D6DCJyBRMDHHLag5Fi0QqQEo4UlKl1y
6eeJgOtGflpVDvXIDIUEsS+kpr3sbcDJbFBQo3qYXqz0Z78U1SECMd3tRkq2niJM
LslrgOT5N8x71pwE8h0uhh5hzJ0AMi2aG96IQlIdOwBKZjVb1cZyECykmjKMrikz
LyBtYIAXlp4LoNQSPx/kcw/iY9SW1lyyXnnti66Vn1pC5NYExsa0NDduIA/pyMN7
yaBMJCEJxCItzGtIljVS+L+V9dyPwieTa9fEBn1jA1JEDR52looy+vtMCRF43Vgv
PVEdmQbUR13o/tGAlFJBzwRakt3e0heEuKqPW2pxc3+gj9qKYKw7+Ak3NDnoquTs
oxcLzfI2YsmGiVMOpFod
=D1X2
-----END PGP SIGNATURE-----

--=-wTAiP2YipWsjbqAl1FKf--

