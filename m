Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:56979 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478AbbLQKMk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 05:12:40 -0500
Subject: Re: [RFC/RFT 1/2] mac80211: Add NEED_ALIGNED4_SKBS hw flag
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
References: <1450344029-5296-1-git-send-email-janusz.dziedzic@tieto.com>
Cc: johannes@sipsolutions.net
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56728A91.7010503@openwrt.org> (sfid-20151217_111245_867124_9E0B2F98)
Date: Thu, 17 Dec 2015 11:12:33 +0100
MIME-Version: 1.0
In-Reply-To: <1450344029-5296-1-git-send-email-janusz.dziedzic@tieto.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-12-17 10:20, Janusz Dziedzic wrote:
> HW/driver should set NEED_ALIGNED4_SKBS flag in case require
> aligned skbs to four-byte boundaries.
> 
> Before we have to do memmove() in the driver before
> pass this to HW and memmove() back in tx completion.
> This patch allow to save CPU and skip such memmoves.
> For each skb we called memmove(ieee80211_hdrsize()) twice.
> 
> Currently this was tested with ath9k, both hw/sw crypt for
> tkip/ccmp.
> For sure more tests required.
> 
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> ---
>  include/net/mac80211.h |  4 ++++
>  net/mac80211/debugfs.c |  1 +
>  net/mac80211/tkip.c    | 15 ++++++++++++---
>  net/mac80211/tx.c      | 21 +++++++++++++++++++--
>  net/mac80211/wep.c     |  6 ++++++
>  net/mac80211/wpa.c     | 35 +++++++++++++++++++++++++++--------
>  6 files changed, 69 insertions(+), 13 deletions(-)
> 
> diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
> index 0ae2077..26b2663 100644
> --- a/net/mac80211/tkip.c
> +++ b/net/mac80211/tkip.c
> @@ -204,9 +204,18 @@ void ieee80211_get_tkip_p2k(struct ieee80211_key_conf *keyconf,
>  	const u8 *tk = &key->conf.key[NL80211_TKIP_DATA_OFFSET_ENCR_KEY];
>  	struct tkip_ctx *ctx = &key->u.tkip.tx;
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> -	const u8 *data = (u8 *)hdr + ieee80211_hdrlen(hdr->frame_control);
> -	u32 iv32 = get_unaligned_le32(&data[4]);
> -	u16 iv16 = data[2] | (data[0] << 8);
> +	unsigned int hdrlen;
> +	const u8 *data;
> +	u32 iv32;
> +	u16 iv16;
> +
> +	hdrlen = ieee80211_hdrlen(hdr->frame_control);
> +	if (ieee80211_hw_check(&key->local->hw, NEEDS_ALIGNED4_SKBS))
> +		hdrlen += hdrlen & 3;
I think this check is duplicated way too often, maybe you should
implement a wrapper for ieee80211_hdrlen and convert all relevant call
sites. Makes it easier to spot places where this was forgotten.

- Felix
