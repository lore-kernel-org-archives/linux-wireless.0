Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58327 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625Ab3HQPzF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Aug 2013 11:55:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1VAiqE-000053-Vx
	for linux-wireless@vger.kernel.org; Sat, 17 Aug 2013 17:55:03 +0200
Received: from 46.164.199.182 ([46.164.199.182])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 17 Aug 2013 17:55:02 +0200
Received: from perplexus by 46.164.199.182 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 17 Aug 2013 17:55:02 +0200
To: linux-wireless@vger.kernel.org
From: Sergey K <perplexus@ya.ru>
Subject: Re: [PATCH 1/1] Delete duplicate code. Use of the variable instead call a function
Date: Sat, 17 Aug 2013 15:53:07 +0000 (UTC)
Message-ID: <loom.20130817T174536-378@post.gmane.org> (sfid-20130817_175509_856720_87300996)
References: <1376741797-25505-1-git-send-email-perplexus@ya.ru> <1376741797-25505-2-git-send-email-perplexus@ya.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey K <perplexus@...> writes:

> 
> ---
>  net/mac80211/tx.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 098ae85..79db7f3 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
>  <at>  <at>  -1769,8 +1769,6  <at>  <at>  netdev_tx_t 
ieee80211_subif_start_xmit(struct sk_buff *skb,
>  			memcpy(hdr.addr3, skb->data, ETH_ALEN);
>  			memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
>  			hdrlen = 30;
> -			authorized = test_sta_flag(sta, 
WLAN_STA_AUTHORIZED);
> -			wme_sta = test_sta_flag(sta, WLAN_STA_WME);
>  		}
>  		ap_sdata = container_of(sdata->bss, struct 
ieee80211_sub_if_data,
>  					u.ap);
>  <at>  <at>  -1979,7 +1977,7  <at>  <at>  netdev_tx_t 
ieee80211_subif_start_xmit(struct sk_buff *skb,
>  	 * EAPOL frames from the local station.
>  	 */
>  	if (unlikely(!ieee80211_vif_is_mesh(&sdata->vif) &&
> -		     !is_multicast_ether_addr(hdr.addr1) && !authorized &&
> +		     !multicast && !authorized &&
>  		     (cpu_to_be16(ethertype) != sdata-
>control_port_protocol ||
>  		      !ether_addr_equal(sdata->vif.addr, skb->data + 
ETH_ALEN)))) {
>  #ifdef CONFIG_MAC80211_VERBOSE_DEBUG


We need to delete authorized and wme_sta flags, because these flags are set 
below:

1956         multicast = is_multicast_ether_addr(hdr.addr1);
1957         if (!multicast) {
1958                 sta = sta_info_get(sdata, hdr.addr1);
1959                 if (sta) {
1960                         authorized = test_sta_flag(sta, 
WLAN_STA_AUTHORIZED);
1961                         wme_sta = test_sta_flag(sta, WLAN_STA_WME);
1962                 }
1963         }


