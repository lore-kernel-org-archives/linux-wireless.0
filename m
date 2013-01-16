Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:48953 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab3APPq7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 10:46:59 -0500
Message-ID: <1358351162.6252.7.camel@cumari.coelho.fi> (sfid-20130116_164704_013958_73397F6E)
Subject: Re: [RFC] mac80211: remove ARP filter enable/disable logic
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Date: Wed, 16 Jan 2013 17:46:02 +0200
In-Reply-To: <1358178202-18727-1-git-send-email-johannes@sipsolutions.net>
References: <1358178202-18727-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, 2013-01-14 at 16:43 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Depending on the driver, having ARP filtering for
> some addresses may be possible. Remove the logic
> that tracks whether ARP filter is enabled or not
> and give the driver the total number of addresses
> instead of the length of the list so it can make
> its own decision.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

As we discussed on IRC, I checked this change (the mac80211 part) and it
looks good to me.

[...]

> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index ce6e62a..c2497b0 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -4107,14 +4107,14 @@ sta_not_found:
>  	}
>  
>  	/* Handle arp filtering. Done after join. */
> -	if ((changed & BSS_CHANGED_ARP_FILTER) ||
> -	    (!is_ibss && (changed & BSS_CHANGED_QOS))) {
> +	if (bss_conf->assoc &&
> +	    ((changed & BSS_CHANGED_ARP_FILTER) ||
> +	     (!is_ibss && (changed & BSS_CHANGED_QOS)))) {
>  		__be32 addr = bss_conf->arp_addr_list[0];
>  		wlvif->sta.qos = bss_conf->qos;
>  		WARN_ON(wlvif->bss_type != BSS_TYPE_STA_BSS);
>  
> -		if (bss_conf->arp_addr_cnt == 1 &&
> -		    bss_conf->arp_filter_enabled) {
> +		if (bss_conf->arp_addr_cnt == 1) {
>  			wlvif->ip_addr = addr;
>  			/*
>  			 * The template should have been configured only upon

This part, though, I think it's safer to do slightly different:

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d7de063..88fb587 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4115,8 +4115,8 @@ sta_not_found:
                wlvif->sta.qos = bss_conf->qos;
                WARN_ON(wlvif->bss_type != BSS_TYPE_STA_BSS);
 
-               if (bss_conf->arp_addr_cnt == 1 &&
-                   bss_conf->arp_filter_enabled) {
+               if (bss_conf->assoc &&
+                   bss_conf->arp_addr_cnt == 1) {
                        wlvif->ip_addr = addr;
                        /*
                         * The template should have been configured only upon

This is because the WiLink firmwares are quite finicky and in many cases
they don't clean things up on disassoc, so we can get into weird bugs.

So I think it's good to keep the wl1271_acx_arp_ip_filter() call to
explicitly disable ARP filtering when we get a BSS_CHANGED_ARP_FILTER
during disassociation (and bss_conf->assoc is false).

--
Luca.

