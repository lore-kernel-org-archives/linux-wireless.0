Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:59482 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbcBKK5H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2016 05:57:07 -0500
From: Sven Eckelmann <sven@narfation.org>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>, nbd@openwrt.org,
	sw@simonwunderlich.de
Subject: Re: [PATCH] mac80211: fix wiphy supported_band access
Date: Thu, 11 Feb 2016 11:57:03 +0100
Message-ID: <8270380.srAs4YNvGf@bentobox> (sfid-20160211_115712_355363_9041B99C)
In-Reply-To: <1455116897-24811-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1455116897-24811-1-git-send-email-lorenzo.bianconi83@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3862181.bt4dzRZMLJ"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3862181.bt4dzRZMLJ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Wednesday 10 February 2016 16:08:17 Lorenzo Bianconi wrote:
> Fix wiphy supported_band access in tx radiotap parsing. In particular,
> info->band is always set to 0 (IEEE80211_BAND_2GHZ) since it has not
> assigned yet. This cause a kernel crash on 5GHz only devices.
> Move ieee80211_parse_tx_radiotap() after info->band assignment
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>

Thanks for the patch. I really never tested with 5GHz only cards and
forgot to check when info->band is assigned.

Can you please add a line describing which patch this one fixes (I hope
the ids are stable in this tree):

Fixes: 5ec3aed9ba4c ("mac80211: Parse legacy and HT rate in injected frames")

And btw., I am happy about the VHT patches. I should really get some MT76
compatible hardware to test how well AC works with a less annoying firmware.


@Felix, I saw that you've added the original patch to OpenWrt. Can you also
check this patch and maybe add it as fix for OpenWrt? Thanks

Kind regards,
	Sven


> ---
>  net/mac80211/tx.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 7bb67fa..b07d037 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1892,10 +1892,6 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
>  	info->flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
>  		      IEEE80211_TX_CTL_INJECTED;
>  
> -	/* process and remove the injection radiotap header */
> -	if (!ieee80211_parse_tx_radiotap(local, skb))
> -		goto fail;
> -
>  	rcu_read_lock();
>  
>  	/*
> @@ -1957,6 +1953,10 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
>  		goto fail_rcu;
>  
>  	info->band = chandef->chan->band;
> +	/* process and remove the injection radiotap header */
> +	if (!ieee80211_parse_tx_radiotap(local, skb))
> +		goto fail_rcu;
> +
>  	ieee80211_xmit(sdata, NULL, skb);
>  	rcu_read_unlock();
>  
> 

--nextPart3862181.bt4dzRZMLJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJWvGj/AAoJEF2HCgfBJntGdKQQAKCsTufSUNCfKarulvET3tgh
PzulA4cKrRpMVrrUWN7jKYJoqJiKiAGez2Vh9KK1vwHaLxiWotoZrZ7X/ihx0n6P
ivCUbTSLpY4OsDG6QxBzmVVOXU81qgwBFHcPyvhyCdqJo7OiRgUxMWFSb/gK9tcu
qFil13gpcv/GkS7t8U7jW252TIsOeRVg1anDRl8zl7kHpKqEVcBPPCmtL+WatYLE
6myN00dx0db4k2uZu1DYZWx2xf1jKIMqhzzEAREWsOyYapv1E7Sd4kQQXOAQqhwe
6zpeZnDOWnlOoM7oEVbGCWDrqbAJA8iuyL0MGFvh4PMe+SGQjtbJzpleS17x6Gkn
Nw/Q6C5POocOAo4HgPCnsUk5VMkEDkPO2kNRvv76K5JJYOFtPWkkI6nmAZrZyhLP
t2MpIFOm99jlxqP4MI8YOg33QdfNip2AC/8GZur3Gj0mzVzaItKoTCAI0IBvk24Z
YJAz/nQ6GO67tzLrOoIiT/8xNsbf46NmuMwyLdS50Nuv2sltBBu9WGBFefoWxWZU
xN+RVX+5ADlSRDuriwvf4prZYNBqKF4kjCqgjGzJOSoCLzYWN9wJJ4yRIIJu0LhT
vQ1Ek9gDAfEexAykKBo3in3NH8bu0+qAa8KJ3YHh/e2T0XZ617C3SAJfrt3PdjOA
x180ylX5g2BAkGKhhCfE
=KR84
-----END PGP SIGNATURE-----

--nextPart3862181.bt4dzRZMLJ--

