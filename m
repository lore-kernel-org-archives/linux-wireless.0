Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:59561 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbXKXNlW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 08:41:22 -0500
Date: Sat, 24 Nov 2007 14:13:46 +0100
From: Ulrich Kunitz <kune@deine-taler.de>
To: Daniel Drake <dsd@gentoo.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	davem@davemloft.net, shaddy_baddah@hotmail.com
Subject: Re: [PATCH 2.6.24] zd1211rw: fix unaligned memory accesses comparing MAC addresses
Message-ID: <20071124131346.GB28785@deine-taler.de> (sfid-20071124_134128_043077_395063F1)
References: <20071123001428.03A199D4A1F@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071123001428.03A199D4A1F@zog.reactivated.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Drake wrote:

> Shaddy Baddah reported some unaligned accesses with the zd1211rw driver.
> David Miller found an issue with comparison of ethernet addresses, and I
> found a few others on top of that. This patch should remove most/all of the
> unaligned accesses.
> 
> Signed-off-by: Daniel Drake <dsd@gentoo.org>

This patch will probably not solve all the issues, because the IP
header will not be aligned. This is caused by the ZD1211 specific
five-byte PLCP header. See my other mail from today, which
includes a patch, which should solve the issue.

Uli

> 
> ---
> 
> A different patch will follow for 2.6.25 soon, probably using
> compare_ether_addr_unaligned() if David accepts that patch.
> 
> Index: linux-2.6.24-rc3-git1/drivers/net/wireless/zd1211rw/zd_mac.c
> ===================================================================
> --- linux-2.6.24-rc3-git1.orig/drivers/net/wireless/zd1211rw/zd_mac.c
> +++ linux-2.6.24-rc3-git1/drivers/net/wireless/zd1211rw/zd_mac.c
> @@ -974,14 +974,14 @@ static int is_data_packet_for_us(struct 
>  	switch (ieee->iw_mode) {
>  	case IW_MODE_ADHOC:
>  		if ((fc & (IEEE80211_FCTL_TODS|IEEE80211_FCTL_FROMDS)) != 0 ||
> -		    compare_ether_addr(hdr->addr3, ieee->bssid) != 0)
> +		    memcmp(hdr->addr3, ieee->bssid, ETH_ALEN) != 0)
>  			return 0;
>  		break;
>  	case IW_MODE_AUTO:
>  	case IW_MODE_INFRA:
>  		if ((fc & (IEEE80211_FCTL_TODS|IEEE80211_FCTL_FROMDS)) !=
>  		    IEEE80211_FCTL_FROMDS ||
> -		    compare_ether_addr(hdr->addr2, ieee->bssid) != 0)
> +		    memcmp(hdr->addr2, ieee->bssid, ETH_ALEN) != 0)
>  			return 0;
>  		break;
>  	default:
> @@ -989,9 +989,9 @@ static int is_data_packet_for_us(struct 
>  		return 0;
>  	}
>  
> -	return compare_ether_addr(hdr->addr1, netdev->dev_addr) == 0 ||
> +	return memcmp(hdr->addr1, netdev->dev_addr, ETH_ALEN) == 0 ||
>  	       (is_multicast_ether_addr(hdr->addr1) &&
> -		compare_ether_addr(hdr->addr3, netdev->dev_addr) != 0) ||
> +		memcmp(hdr->addr3, netdev->dev_addr, ETH_ALEN) != 0) ||
>  	       (netdev->flags & IFF_PROMISC);
>  }
>  
> @@ -1047,7 +1047,7 @@ static void update_qual_rssi(struct zd_m
>  	hdr = (struct ieee80211_hdr_3addr *)buffer;
>  	if (length < offsetof(struct ieee80211_hdr_3addr, addr3))
>  		return;
> -	if (compare_ether_addr(hdr->addr2, zd_mac_to_ieee80211(mac)->bssid) != 0)
> +	if (memcmp(hdr->addr2, zd_mac_to_ieee80211(mac)->bssid, ETH_ALEN) != 0)
>  		return;
>  
>  	spin_lock_irqsave(&mac->lock, flags);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Uli Kunitz
