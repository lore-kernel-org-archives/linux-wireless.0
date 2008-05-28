Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2763 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbYE1P6S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 11:58:18 -0400
Date: Wed, 28 May 2008 11:16:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: johannes@sipsolutions.net, ron.rindjunsky@intel.com,
	linux-wireless@vger.kernel.org, Luis.Rodriguez@Atheros.com
Subject: Re: [PATCH] mac80211: fix alignment issue with compare_ether_addr()
Message-ID: <20080528151651.GA13461@tuxdriver.com> (sfid-20080528_175821_349548_128405FB)
References: <20080528145048.GB5244@senthil-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080528145048.GB5244@senthil-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 28, 2008 at 08:20:48PM +0530, Senthil Balasubramanian wrote:
> This addresses an alignment issue with compare_ether_addr().
> The addresses passed to compare_ether_addr should be two bytes aligned.
> It may function properly in x86 platform. However may not work properly
> on IA-64 or ARM processor.

> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1116,7 +1116,9 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
>  	u16 fc, hdrlen, ethertype;
>  	u8 *payload;
>  	u8 dst[ETH_ALEN];
> -	u8 src[ETH_ALEN];
> +	/* Should be aligned on 2 bytes for compare_ether_addr() */
> +	u16 src_aligned[ETH_ALEN >> 1];
> +	u8 *src = (u8 *)src_aligned;
>  	struct sk_buff *skb = rx->skb;
>  	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>  	DECLARE_MAC_BUF(mac);

Any reason you couldn't just do this?

@@ -1116,7 +1116,7 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 	u16 fc, hdrlen, ethertype;
 	u8 *payload;
 	u8 dst[ETH_ALEN];
-	u8 src[ETH_ALEN];
+	u8 src[ETH_ALEN] __attribute__ ((aligned(2)));
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	DECLARE_MAC_BUF(mac);

It seems to compile w/o errors on i686, and it seems more clear to me.
Will that not work?

John
-- 
John W. Linville
linville@tuxdriver.com
