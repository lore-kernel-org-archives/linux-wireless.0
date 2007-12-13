Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2261 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761320AbXLMV3e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 16:29:34 -0500
Date: Thu, 13 Dec 2007 15:49:33 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>,
	Tomas Winkler <tomasw@gmail.com>, Jouni Malinen <j@w1.fi>
Subject: Re: [RFC] mac80211: clean up frame receive handling
Message-ID: <20071213204933.GD3083@tuxdriver.com> (sfid-20071213_212940_286346_D928894B)
References: <1197483844.6558.158.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1197483844.6558.158.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 12, 2007 at 07:24:04PM +0100, Johannes Berg wrote:

> @@ -1014,6 +992,24 @@ ieee80211_drop_unencrypted(struct ieee80
>  	return 0;
>  }
>  
> +static bool ieee80211_frame_allowed(struct ieee80211_txrx_data *rx)
> +{
> +	static const u8 pae_group_addr[ETH_ALEN]
> +		= { 0x01, 0x80, 0xC2, 0x00, 0x00, 0x03 };
> +	struct ethhdr *ehdr = (struct ethhdr *)rx->skb->data;
> +
> +	if (rx->skb->protocol == htons(ETH_P_PAE) &&
> +	    (compare_ether_addr(ehdr->h_dest, pae_group_addr) == 0 ||
> +	     compare_ether_addr(ehdr->h_dest, rx->dev->dev_addr) == 0))
> +		return true;

Should you reverse these two compare_ether_addr calls?
rx->dev->dev_addr seems more likely for any given packet.  It probably
makes little difference but it seems like checking for that first
would still be better.

John
-- 
John W. Linville
linville@tuxdriver.com
