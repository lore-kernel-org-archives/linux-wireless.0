Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51931 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbZKZJt7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 04:49:59 -0500
Subject: Re: [RFC 1/2] wireless: add ieee80211_asmdu_to_8023s
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1259215413-16753-1-git-send-email-yi.zhu@intel.com>
References: <1259215413-16753-1-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+WUcv2uXMoMgSFctl22k"
Date: Thu, 26 Nov 2009 10:49:28 +0100
Message-ID: <1259228968.32372.40.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+WUcv2uXMoMgSFctl22k
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-11-26 at 14:03 +0800, Zhu Yi wrote:
> Move the A-MSDU handling code from mac80211 to cfg80211 so that more
> drivers can use it. The new created function ieee80211_asmdu_to_8023s
> converts an A-MSDU frame to a list of 802.3 frames.
>=20
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
>  include/net/cfg80211.h |   12 +++++
>  net/mac80211/rx.c      |  107 ++++++++++--------------------------------=
-----
>  net/wireless/util.c    |  105 ++++++++++++++++++++++++++++++++++++++++++=
+++++
>  3 files changed, 140 insertions(+), 84 deletions(-)
>=20
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 0884b9a..ad31b55 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1593,6 +1593,18 @@ int ieee80211_data_from_8023(struct sk_buff *skb, =
u8 *addr,
>  			     enum nl80211_iftype iftype, u8 *bssid, bool qos);
> =20
>  /**
> + * ieee80211_asmdu_to_8023s - decode an IEEE 802.11n A-MSDU frame
                 ^ typo

> +	skb->dev =3D dev;
> +	skb_queue_head_init(&frame_list);

^ use __ versions please, no need for locking since it's on stack
=20
> +	dev->stats.rx_packets++;
> +	dev->stats.rx_bytes +=3D skb->len;

Shouldn't rx_packets be per sub-frame?

> +	while (!skb_queue_empty(&frame_list)) {
> +		rx->skb =3D skb_dequeue(&frame_list);

__skb_dequeue
=20
> +/**
> + * ieee80211_asmdu_to_8023s - decode an IEEE 802.11n A-MSDU frame
                 ^ copy/paste :)

Why do you have the kernel-doc twice anyway?


> +		skb_queue_tail(list, frame);

__

> + purge:
> +	skb_queue_purge(list);

__ (does that exist? guess it must?)

johannes

--=-+WUcv2uXMoMgSFctl22k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLDk8lAAoJEODzc/N7+QmaafYQAMW4erINyDw4nlXKM/wa53pi
Oe2TAkOBb/haBOHcgC9kDzBld8IK9mDWux3SkNaqoYBZVHLKoUA+5nHu6fCLTTFb
odm0N6mNKyOggwyaN0xgN7FtnEJey+HEUv3ccFjLGE7ZT4/6MIZ/PrkASUXDsp96
J4f/OOIHa5KEerbhBk1hEVQW+YlFwYrBXM8z6/nXe4MjInTJYI6GQlN/TLJa4zEY
4dgkwk3Rn1BQatGz/S9FNI5eTnZVGFvjRreYxBohAGwX6pn7QlXBlaYM6LopGBNN
Foq56XkPgSgEZn6Q6F73by9jpn4zy/ojpSGJx7m7TOuVCCF5lqZ5iU7HVHo+qz9R
t9pfROYWQ8FpKhRH6m5anWb+fi5OPExotL8nQyOOgMOUIpKfIWn2wNNypBW235I+
M5vAXJs+aFH0hqcl7vuSC/UePT6HkCoRcB5At3gitT7mP1anZcYYsy5nMZvQCiwg
/1u2fVMgDlLezj+CFTLAwYxBKjirWXj/1DWzrXrPhwQHZWH+xz2E1iXC4XTQz8IG
s4LfDvpKV3K0N4O9l4bAs6GITBZx0FXLyQu97NKJsjbZ8VN95yRD9w/T7xWSi1tF
yXSsbZxL3c4DYQgovCrG5kt7IJ+M84tQx5ltCCcNA7qD+El8qvp5MMLby/SDzGMw
uORp2cRrWsRuiFfXwVgZ
=eNJ1
-----END PGP SIGNATURE-----

--=-+WUcv2uXMoMgSFctl22k--

