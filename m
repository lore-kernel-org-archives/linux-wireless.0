Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:49377 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0LSKK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Dec 2010 05:10:57 -0500
Received: by bwz16 with SMTP id 16so2417516bwz.4
        for <linux-wireless@vger.kernel.org>; Sun, 19 Dec 2010 02:10:56 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 1/3] mac80211: fix initialization of skb->cb in ieee80211_subif_start_xmit
Date: Sun, 19 Dec 2010 11:09:43 +0100
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
References: <1292697050-25741-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1292697050-25741-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201012191109.43198.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag, 18. Dezember 2010 schrieb Felix Fietkau:
> The change 'mac80211: Fix BUG in pskb_expand_head when transmitting shared skbs'
> added a check for copying the skb if it's shared, however the tx info variable
> still points at the cb of the old skb
> 
> Cc: Helmut Schaa <helmut.schaa@googlemail.com>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Ah, missed that. Thanks Felix.

Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>

> ---
>  net/mac80211/tx.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 898e864..7d78aca 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1742,7 +1742,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
>  {
>  	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>  	struct ieee80211_local *local = sdata->local;
> -	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +	struct ieee80211_tx_info *info;
>  	int ret = NETDEV_TX_BUSY, head_need;
>  	u16 ethertype, hdrlen,  meshhdrlen = 0;
>  	__le16 fc;
> @@ -2033,6 +2033,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
>  	skb_set_network_header(skb, nh_pos);
>  	skb_set_transport_header(skb, h_pos);
>  
> +	info = IEEE80211_SKB_CB(skb);
>  	memset(info, 0, sizeof(*info));
>  
>  	dev->trans_start = jiffies;
> 

