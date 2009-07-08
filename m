Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53184 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbZGHKkq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2009 06:40:46 -0400
Subject: Re: [PATCH] Assign next hop address to pending mesh frames once
 the path is resolved.
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
In-Reply-To: <1247032403-8312-1-git-send-email-javier@cozybit.com>
References: <>  <1247032403-8312-1-git-send-email-javier@cozybit.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UhNkLIW23wNFBIqGwkuB"
Date: Wed, 08 Jul 2009 12:40:13 +0200
Message-Id: <1247049613.4755.65.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UhNkLIW23wNFBIqGwkuB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-07 at 22:53 -0700, Javier Cardona wrote:
> Regression.  Frames transmitted when a mesh path was wating to be resolve=
d were
> being transmitted with an invalid Receiver Address.

> -	rcu_assign_pointer(mpath->next_hop, sta);
> +	struct sk_buff *skb, *skb_first =3D NULL;
> +	struct ieee80211_hdr *hdr;
> +
> +	rcu_read_lock();
> +	mpath->next_hop =3D sta;
> +
> +	while ((skb =3D skb_dequeue(&mpath->frame_queue)) !=3D skb_first) {
> +		if (!skb_first)
> +			skb_first =3D skb;
> +		hdr =3D (struct ieee80211_hdr *) skb->data;
> +		memcpy(hdr->addr1, sta->sta.addr, ETH_ALEN);
> +		skb_queue_tail(&mpath->frame_queue, skb);
> +	}
> +	if (skb_first)
> +		skb_queue_tail(&mpath->frame_queue, skb_first);
> +
> +	rcu_read_unlock();

Since skb queues have a locks, why use rcu too?

Also I think you should probably use a different pattern -- this looks
prone to breakage, maybe something like

	sk_buff_head tmpq;
	unsigned long flags;

	__skb_queue_head_init(&tmpq);

	spin_lock_irqsave(&frame_queue->lock);

	while (skb =3D __skb_dequeue(&frame_queue)) {
		hdr =3D (struct ieee80211_hdr *) skb->data;
		memcpy(hdr->addr1, sta->sta.addr, ETH_ALEN);
		__skb_queue_tail(&tmpq, skb);
	}

	skb_queue_splice(&tmpq, frame_queue);
	spin_unlock_irqrestore(&frame_queue->lock);

johannes

--=-UhNkLIW23wNFBIqGwkuB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKVHeIAAoJEODzc/N7+QmamcAP+gIIX9eCr5/xeVRBBKjWwB0w
G4T4jI7vK+Pd4zdfzCzg6Bt92HBZqykXdP6arxNhEAaVA6q0o4KyaFK4z1T6Q+gj
vasWvdB9ddggVy2j86oPYEGNHJHkx6UeOpaarZXOSsY9DMSh3Iy5OiYtVCzDCFhp
Xxri0ei70gvZ5D+GYGlM15L1Maj2MTkWGn+mbDKN/CvV9+RAgl2+ThkR8WLrWnjI
6728mZE5cfkc0W4SWMBxPzxcrbLaqQWu5AOcpPAAHc/0W6TiwUzARshgZt8ReXsD
UEXCBhIKG17Yz76Q4IzIv18XSUssyDBrqUvoHEWmsAkBH1xXtlgoiEcSsKIx+6ww
sBT/MYs7vGeDgRlHIkOyDiaAEjMd/AMsa+EAvVlrsAivDWbojPdfvNiQ6cTUdfYW
FBUk03o9E1cypJcEmovcQJXH2bwnqgVqUB2PWcgjKoZ1hXYiiDRBqaOZLubHANP9
TQMgharAj+ZlQ5VolvRqaS/mWuHD7ixTL+tCRK5i3cgkUegeweTv2zYCJGXeKcFB
uhtoJlWowSXWYq+9/cHqoNHCHy3hV7W7Pnz+FxYJGVLz6UbEzp3nL07RkEYU8Eup
hQrPFmPdxvqRQvwgCZfKE6KxZy8/BrUH5i+TIkF6DtcyB1qE9/VkeLEImuBA2ueM
wJfPemHZlPU16P8p6cYN
=dEq0
-----END PGP SIGNATURE-----

--=-UhNkLIW23wNFBIqGwkuB--

