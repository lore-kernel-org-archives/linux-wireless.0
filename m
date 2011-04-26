Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:36597 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757059Ab1DZGyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 02:54:07 -0400
Received: by eyx24 with SMTP id 24so118958eyx.5
        for <linux-wireless@vger.kernel.org>; Mon, 25 Apr 2011 23:53:17 -0700 (PDT)
Subject: Re: [PATCH V2 1/2] wl12xx: consider encryption when configuring
 auto arp template
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1302774475-2977-1-git-send-email-eliad@wizery.com>
References: <1302774475-2977-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 09:53:13 +0300
Message-ID: <1303800793.2336.25.camel@cumari> (sfid-20110426_085411_571855_EE10FC4B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eliad,

On Thu, 2011-04-14 at 12:47 +0300, Eliad Peller wrote:
> When configuring the arp response template, and encryption is enabled,
> we should add some space and set the protected flag bit in the fc.
> 
> In order to track the encryption type, set wl->encryption_type when
> setting an encryption key, and reconfigure the arp response.
> Clear this field on wl1271_join, as keys have to be re-configured
> anyway after a join command.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

A couple of style comments.


> diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
> index 2468044..65bcecb 100644
> --- a/drivers/net/wireless/wl12xx/cmd.c
> +++ b/drivers/net/wireless/wl12xx/cmd.c
> @@ -742,28 +742,30 @@ out:
>  
>  int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, __be32 ip_addr)
>  {
> -	int ret;
> -	struct wl12xx_arp_rsp_template tmpl;
> +	int ret, extra = 0;
> +	u16 fc;
> +	struct sk_buff *skb;
> +	struct wl12xx_arp_rsp_template *tmpl;
>  	struct ieee80211_hdr_3addr *hdr;
>  	struct arphdr *arp_hdr;
>  
> -	memset(&tmpl, 0, sizeof(tmpl));
> +	skb = dev_alloc_skb(sizeof(*hdr) + sizeof(*tmpl) + 8);

[...]

> +	skb_reserve(skb, sizeof(*hdr) + 8);

What's 8? Maybe it would be better to make it clear with something like
WL1271_EXTRA_SPACE_MAX?


> @@ -771,12 +773,41 @@ int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, __be32 ip_addr)
>  	arp_hdr->ar_op = cpu_to_be16(ARPOP_REPLY);
>  
>  	/* arp payload */
> -	memcpy(tmpl.sender_hw, wl->vif->addr, ETH_ALEN);
> -	tmpl.sender_ip = ip_addr;
> +	memcpy(tmpl->sender_hw, wl->vif->addr, ETH_ALEN);
> +	tmpl->sender_ip = ip_addr;
> +
> +	/* encryption space */
> +	switch (wl->encryption_type) {
> +	case KEY_TKIP:
> +		extra = WL1271_TKIP_IV_SPACE;
> +		break;
> +	case KEY_AES:
> +		extra = 8;
> +		break;
> +	}

It would be nicer to have WL1271_EXTRA_SPACE_AES here instead.  And
maybe rename the WL1271_TKIP_IV_SPACE to WL1271_EXTRA_SPACE_TKIP, to
make it consistent and clearer?

Maybe we should also complete the switch and explicitly set extra to
zero for KEY_NONE, KEY_WEP, KEY_GEM and default?


> @@ -2734,6 +2748,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
>  
>  		if (bss_conf->arp_addr_cnt == 1 &&
>  		    bss_conf->arp_filter_enabled) {
> +			wl->ip_addr = addr;
>  			/*
>  			 * The template should have been configured only upon
>  			 * association. however, it seems that the correct ip
> @@ -2749,8 +2764,10 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
>  			ret = wl1271_acx_arp_ip_filter(wl,
>  				ACX_ARP_FILTER_ARP_FILTERING,
>  				addr);
> -		} else
> +		} else {
> +			wl->ip_addr = 0;
>  			ret = wl1271_acx_arp_ip_filter(wl, 0, addr);
> +		}

This is not important at all, but maybe it's a bit cleaner: you could
remove the addr argument in wl1271_acx_arp_ip_filter() and always use
wl->ip_addr instead? You could then also get rid of the local addr here.


-- 
Cheers,
Luca.

