Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:34754 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbcF2PIm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 11:08:42 -0400
Received: by mail-pa0-f68.google.com with SMTP id us13so4629496pab.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2016 08:08:07 -0700 (PDT)
Subject: Re: [PATCH v3] mac80211: Encrypt "Group addressed privacy" action
 frames
To: j@w1.fi, johannes@sipsolutions.net
References: <20160621170120.GA24882@w1.fi>
 <1466592920-2716-1-git-send-email-masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <5773E453.9060206@gmail.com> (sfid-20160629_170847_432004_2572A5CD)
Date: Thu, 30 Jun 2016 00:08:03 +0900
MIME-Version: 1.0
In-Reply-To: <1466592920-2716-1-git-send-email-masashi.honma@gmail.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016年06月22日 19:55, Masashi Honma wrote:
> Previously, the action frames to group address was not encrypted. But
> [1] "Table 8-38 Category values" indicates "Mesh" and "Multihop" category
> action frames should be encrypted (Group addressed privacy == yes). And the
> encyption key should be MGTK ([1] 10.13 Group addressed robust management frame
> procedures). So this patch modifies the code to make it suitable for spec.
>
> [1] IEEE Std 802.11-2012
>
> Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
> ---
>  include/linux/ieee80211.h | 32 ++++++++++++++++++++++++++++++++
>  net/mac80211/rx.c         |  7 ++++++-
>  net/mac80211/tx.c         |  6 +++++-
>  3 files changed, 43 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index b118744..7c0771a 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -19,6 +19,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/if_ether.h>
> +#include <linux/etherdevice.h>
>  #include <asm/byteorder.h>
>  #include <asm/unaligned.h>
>  
> @@ -2487,6 +2488,37 @@ static inline bool ieee80211_is_public_action(struct ieee80211_hdr *hdr,
>  }
>  
>  /**
> + * _ieee80211_is_group_privacy_action - check if frame is a group addressed
> + * privacy action frame
> + * @hdr: the frame
> + */
> +static inline bool _ieee80211_is_group_privacy_action(struct ieee80211_hdr *hdr)
> +{
> +	struct ieee80211_mgmt *mgmt;
> +
> +	if (!ieee80211_is_action(hdr->frame_control) ||
> +	    !is_multicast_ether_addr(hdr->addr1))
> +		return false;
> +
> +	mgmt = (struct ieee80211_mgmt *)hdr;
> +
> +	return mgmt->u.action.category == WLAN_CATEGORY_MESH_ACTION ||
> +		mgmt->u.action.category == WLAN_CATEGORY_MULTIHOP_ACTION;
> +}
> +
> +/**
> + * ieee80211_is_group_privacy_action - check if frame is a group addressed
> + * privacy action frame
> + * @skb: the skb containing the frame, length will be checked
> + */
> +static inline bool ieee80211_is_group_privacy_action(struct sk_buff *skb)
> +{
> +	if (skb->len < IEEE80211_MIN_ACTION_SIZE)
> +		return false;
> +	return _ieee80211_is_group_privacy_action((void *)skb->data);
> +}
> +
> +/**
>   * ieee80211_tu_to_usec - convert time units (TU) to microseconds
>   * @tu: the TUs
>   */
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 5e65e83..2300c0f 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1624,8 +1624,13 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
>  		if (mmie_keyidx < NUM_DEFAULT_KEYS ||
>  		    mmie_keyidx >= NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS)
>  			return RX_DROP_MONITOR; /* unexpected BIP keyidx */
> -		if (rx->sta)
> +		if (rx->sta) {
> +			if (ieee80211_is_group_privacy_action(skb) &&
> +			    test_sta_flag(rx->sta, WLAN_STA_MFP))
> +				return RX_DROP_MONITOR;
> +
>  			rx->key = rcu_dereference(rx->sta->gtk[mmie_keyidx]);
> +		}
>  		if (!rx->key)
>  			rx->key = rcu_dereference(rx->sdata->keys[mmie_keyidx]);
>  	} else if (!ieee80211_has_protected(fc)) {
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 2030443..e194df6 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -590,6 +590,9 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
>  	else if (tx->sta &&
>  		 (key = rcu_dereference(tx->sta->ptk[tx->sta->ptk_idx])))
>  		tx->key = key;
> +	else if (ieee80211_is_group_privacy_action(tx->skb) &&
> +		(key = rcu_dereference(tx->sdata->default_multicast_key)))
> +		tx->key = key;
>  	else if (ieee80211_is_mgmt(hdr->frame_control) &&
>  		 is_multicast_ether_addr(hdr->addr1) &&
>  		 ieee80211_is_robust_mgmt_frame(tx->skb) &&
> @@ -622,7 +625,8 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
>  		case WLAN_CIPHER_SUITE_GCMP_256:
>  			if (!ieee80211_is_data_present(hdr->frame_control) &&
>  			    !ieee80211_use_mfp(hdr->frame_control, tx->sta,
> -					       tx->skb))
> +					       tx->skb) &&
> +			    !ieee80211_is_group_privacy_action(tx->skb))
>  				tx->key = NULL;
>  			else
>  				skip_hw = (tx->key->conf.flags &

Is there any comment about this ?


