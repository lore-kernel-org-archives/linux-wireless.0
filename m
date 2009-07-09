Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36514 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbZGIVyl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 17:54:41 -0400
Subject: Re: [PATCH v2] Assign next hop address to pending mesh frames once
 the path is resolved.
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>, linville@tuxdriver.com
In-Reply-To: <1247175736-6915-1-git-send-email-javier@cozybit.com>
References: <1247049613.4755.65.camel@johannes.local>
	 <1247175736-6915-1-git-send-email-javier@cozybit.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kP5CREcvwXaoXVqGnWcM"
Date: Thu, 09 Jul 2009 23:54:37 +0200
Message-Id: <1247176477.1905.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kP5CREcvwXaoXVqGnWcM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-09 at 14:42 -0700, Javier Cardona wrote:
> Regression.  Frames transmitted when a mesh path was wating to be resolve=
d were
> being transmitted with an invalid Receiver Address.
>=20
> [Changes since v1]
>=20
> Suggested by Johannes:
>  - Improved frame_queue traversal
>  - Narower RCU scope
>=20
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/mesh_pathtbl.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
> index ae98766..1981af9 100644
> --- a/net/mac80211/mesh_pathtbl.c
> +++ b/net/mac80211/mesh_pathtbl.c
> @@ -55,7 +55,25 @@ static DEFINE_RWLOCK(pathtbl_resize_lock);
>   */
>  void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *=
sta)
>  {
> +	struct sk_buff *skb;
> +	struct ieee80211_hdr *hdr;
> +	struct sk_buff_head tmpq;
> +	unsigned long flags;
> +
>  	rcu_assign_pointer(mpath->next_hop, sta);
> +
> +	__skb_queue_head_init(&tmpq);
> +
> +	spin_lock_irqsave(&mpath->frame_queue.lock, flags);
> +
> +	while ((skb =3D __skb_dequeue(&mpath->frame_queue)) !=3D NULL) {
> +		hdr =3D (struct ieee80211_hdr *) skb->data;
> +		memcpy(hdr->addr1, sta->sta.addr, ETH_ALEN);
> +		__skb_queue_tail(&tmpq, skb);
> +	}
> +
> +	skb_queue_splice(&tmpq, &mpath->frame_queue);
> +	spin_unlock_irqrestore(&mpath->frame_queue.lock, flags);
>  }
> =20
>=20

--=-kP5CREcvwXaoXVqGnWcM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKVmcaAAoJEODzc/N7+Qmac/UP+wV3vvAmKchcdFwfzt0ewcAi
0VDwbF2BIy/ED9wa5bVVSxZP9b6LcCJFugeZT24AAzzpaVRbg5CGWyJfSi8RHiHI
dRqW7k7X9pHpVuND3XTOpQiHYhb6vTTcvxRuE7BTq54ME6JzCUUPOhLvYPpuMNu4
zBkDr0KH9mAu3zmgNYM+GCmSmoPJafLyiA63NE3oPN7Ms5r2kD8NIdXTMtzsfWJ7
Nidx5ObKOZgFN0SWTunHJPWcJLIsAUbe2dIAKviIfGUmJHRaz5pRBpnIUiJ/R7HK
TAE9GqXxAKG1nlcXTN0gQ94YAAelh0U/rbbPkvty5n006BUy45g3SFyp3Ps9JfrG
AVpRWBXqjEDha12as7diE8jI5FZWkhjUr3WxfXqQ8xIgOeAyIxeh6k74oGKmj74U
KssH8jV8CS9fhDolswBt/muXU+36QOPeto6EFQRShniAhPOZADWXuWmomL8YRtKZ
HkH+9G8CIuvE0wS+PmcaG6AVrBz1ZIaN3c0dp7/1GLCdQybnk/IWpUWWuR5AdQeu
BqZkTyuBZmuCYvS+bK7MIPyJEiEGjS9l3s8fM6na1d57tTq1Ws+zcQnLzuchvTaR
VzTzCiFnP+E6Qx8MSOgLFO6lIBdXXP87dmStpajD4ssDg13Rqz5eWK8ebY2+146W
cb+Wo8kzkrtkfctGDUdP
=m+t3
-----END PGP SIGNATURE-----

--=-kP5CREcvwXaoXVqGnWcM--

