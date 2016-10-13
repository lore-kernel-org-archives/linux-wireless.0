Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34158 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751882AbcJMHeR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 03:34:17 -0400
Subject: Re: [PATCHv4] mac80211: fix A-MSDU outer SA/DA
To: Michael Braun <michael-dev@fami-braun.de>,
        johannes@sipsolutions.net
References: <1476337315-26845-1-git-send-email-michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <fc2ae46b-f049-41de-3eec-465e83b5ecef@nbd.name> (sfid-20161013_093420_874498_AE81CEAD)
Date: Thu, 13 Oct 2016 09:19:30 +0200
MIME-Version: 1.0
In-Reply-To: <1476337315-26845-1-git-send-email-michael-dev@fami-braun.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-10-13 07:41, Michael Braun wrote:
> According to IEEE 802.11-2012 section 8.3.2 table 8-19, the outer SA/DA
> of A-MSDU frames need to be changed depending on FromDS/ToDS values.
> 
> Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
> 
> --
> v4:
>  - h_80211_src/dst has been memmove'd and thus needs to be fixed
> v3:
>  - write to outer 802.11 header instead of inner amsdu subframe header
> v2:
>  - avoid the extra write to amsdu_hdr
>  - avoid copy of asmdu_hdr into skb, use ptr instead
> ---
>  net/mac80211/tx.c | 46 ++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 36 insertions(+), 10 deletions(-)
> 
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 5023966..5f80b94 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -3058,19 +3059,44 @@ static bool ieee80211_amsdu_prepare_head(struct ieee80211_sub_if_data *sdata,
>  	if (info->control.flags & IEEE80211_TX_CTRL_AMSDU)
>  		return true;
>  
> -	if (!ieee80211_amsdu_realloc_pad(local, skb, sizeof(amsdu_hdr),
> +	if (!ieee80211_amsdu_realloc_pad(local, skb, sizeof(*amsdu_hdr),
>  					 &subframe_len))
>  		return false;
>  
> -	amsdu_hdr.h_proto = cpu_to_be16(subframe_len);
> -	memcpy(amsdu_hdr.h_source, skb->data + fast_tx->sa_offs, ETH_ALEN);
> -	memcpy(amsdu_hdr.h_dest, skb->data + fast_tx->da_offs, ETH_ALEN);
> +	data = skb_push(skb, sizeof(*amsdu_hdr));
> +	memmove(data, data + sizeof(*amsdu_hdr), hdr_len);
> +	hdr = data;
> +	amsdu_hdr = data + hdr_len;
> +	/* h_80211_src/dst is addr* field within hdr */
> +	h_80211_src = data + fast_tx->sa_offs;
> +	h_80211_dst = data + fast_tx->da_offs;
> +
> +	amsdu_hdr->h_proto = cpu_to_be16(subframe_len);
> +	memcpy(amsdu_hdr->h_source, h_80211_src, ETH_ALEN);
> +	memcpy(amsdu_hdr->h_dest, h_80211_dst, ETH_ALEN);
> +
> +	/* according to IEEE 802.11-2012 8.3.2 table 8-19, the outer SA/DA
> +	 * fields needs to be changed to BSSID for A-MSDU frames depending
> +	 * on FromDS/ToDS values.
> +	 */
> +	switch (sdata->vif.type) {
> +	case NL80211_IFTYPE_STATION:
> +		bssid = sdata->u.mgd.bssid;
> +		break;
> +	case NL80211_IFTYPE_AP:
> +	case NL80211_IFTYPE_AP_VLAN:
> +		bssid = sdata->vif.addr;
> +		break;
> +	default:
> +		bssid = NULL;
> +	}
>  
> -	data = skb_push(skb, sizeof(amsdu_hdr));
> -	memmove(data, data + sizeof(amsdu_hdr), hdr_len);
> -	memcpy(data + hdr_len, &amsdu_hdr, sizeof(amsdu_hdr));
> +	if (bssid && ieee80211_has_fromds(hdr->frame_control))
> +		memcpy(h_80211_src, bssid, ETH_ALEN);
> +
> +	if (bssid && ieee80211_has_tods(hdr->frame_control))
> +		memcpy(h_80211_dst, bssid, ETH_ALEN);
I think this is probably wrong for 4-addr, since there both FromDS and
ToDS are set. Maybe you should use !ieee80211_has_tods instead of
ieee80211_has_fromds and vice versa.

- Felix
