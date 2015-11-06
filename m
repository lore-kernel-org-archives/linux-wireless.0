Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:36135 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031997AbbKFLLB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 06:11:01 -0500
Subject: Re: [PATCH] mac80211: remove string from unaligned packet warning
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1446807595-12288-1-git-send-email-johannes@sipsolutions.net>
Cc: Johannes Berg <johannes.berg@intel.com>
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <563C8AC0.4070401@openwrt.org> (sfid-20151106_121106_851805_2F207D3B)
Date: Fri, 6 Nov 2015 12:10:56 +0100
MIME-Version: 1.0
In-Reply-To: <1446807595-12288-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-11-06 11:59, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This really should never happen except very early in the process
> of bringing up a new driver, at which point you'll have to add
> more debugging in the driver and this string isn't useful. Remove
> it and save some size (when it's even compiled in.)
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/rx.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 8bae5de0dc44..78346e89e997 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -661,8 +661,7 @@ static void ieee80211_parse_qos(struct ieee80211_rx_data *rx)
>  static void ieee80211_verify_alignment(struct ieee80211_rx_data *rx)
>  {
>  #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
> -	WARN_ONCE((unsigned long)rx->skb->data & 1,
> -		  "unaligned packet at 0x%p\n", rx->skb->data);
> +	WARN_ONCE((unsigned long)rx->skb->data & 1);
Shouldn't this be WARN_ON_ONCE?

- Felix
