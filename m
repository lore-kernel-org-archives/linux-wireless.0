Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:51494 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538AbcFUQmL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 12:42:11 -0400
Date: Tue, 21 Jun 2016 19:42:07 +0300
From: Jouni Malinen <j@w1.fi>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: Encrypt "Group addressed privacy" action
 frames
Message-ID: <20160621164207.GA7323@w1.fi> (sfid-20160621_184214_800459_B912B04F)
References: <20160620212529.GA19076@w1.fi>
 <1466490219-2891-1-git-send-email-masashi.honma@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466490219-2891-1-git-send-email-masashi.honma@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 21, 2016 at 03:23:39PM +0900, Masashi Honma wrote:

> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> +static inline bool ieee80211_is_group_privacy_action(struct ieee80211_hdr *hdr)

This is somewhat problematic since no indication of the frame length is
passed in here and we are reading beyond the frame header below.. Maybe
this should use the same style as ieee80211_is_robust_mgmt_frame()
instead, i.e., use skb as the argument and define
_ieee80211_is_group_privacy_action() to take in struct ieee80211_hdr *.

> +	return mgmt->u.action.category == WLAN_CATEGORY_MESH_ACTION ||
> +		mgmt->u.action.category == WLAN_CATEGORY_MULTIHOP_ACTION;

These read the buffer at offset 24, i.e., just after the header. This
should do same as ieee80211_is_robust_mgmt_frame(), i.e., return false
if skb->len < 25.

> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> @@ -608,7 +611,6 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
>  		bool skip_hw = false;
>  
>  		/* TODO: add threshold stuff again */
> -
>  		switch (tx->key->conf.cipher) {
>  		case WLAN_CIPHER_SUITE_WEP40:
>  		case WLAN_CIPHER_SUITE_WEP104:

This looks completely separate item and I don't see why we would even
delete that empty line.. In any case, it should probably not be in this
patch.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
