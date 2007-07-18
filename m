Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:46305 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756136AbXGRQOr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2007 12:14:47 -0400
Message-ID: <469E3C70.4070809@lwfinger.net>
Date: Wed, 18 Jul 2007 11:14:40 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: David Miller <davem@davemloft.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: fix GCC warning on 64bit platforms
References: <20070714.185935.18577806.davem@davemloft.net>	<20070714.204116.23012949.davem@davemloft.net>	<20070716184653.355253bf@griffin.suse.cz>	<20070716.145358.35015496.davem@davemloft.net> <20070718171044.2de287cd@griffin.suse.cz>
In-Reply-To: <20070718171044.2de287cd@griffin.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> net/mac80211/ieee80211.c: In function ieee80211_register_hw:
> net/mac80211/ieee80211.c:4989: warning: comparison of distinct pointer types lacks a cast
> 
> Size of ieee80211_tx_status_rtap_hdr structure will never be greater than
> unsigned int.
> 
> Signed-off-by: Jiri Benc <jbenc@suse.cz>
> 
> ---
> 
> On Mon, 16 Jul 2007 14:53:58 -0700 (PDT), David Miller wrote:
>> The macro "max_t" exists for these kinds of situations, please
>> use it. :-)
> 
> Ok.
> 
> ---
>  net/mac80211/ieee80211.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- mac80211-2.6.orig/net/mac80211/ieee80211.c
> +++ mac80211-2.6/net/mac80211/ieee80211.c
> @@ -4986,8 +4986,8 @@ int ieee80211_register_hw(struct ieee802
>  	 * and we need some headroom for passing the frame to monitor
>  	 * interfaces, but never both at the same time.
>  	 */
> -	local->tx_headroom = max(local->hw.extra_tx_headroom,
> -				 sizeof(struct ieee80211_tx_status_rtap_hdr));
> +	local->tx_headroom = max_t(unsigned, local->hw.extra_tx_headroom,
> +				   sizeof(struct ieee80211_tx_status_rtap_hdr));
>  
>  	debugfs_hw_add(local);

For my info on how to use max_t, not as a critique of this patch. (1) Is 'unsigned' enough or should 
it be 'unsigned int'? (2) Because tx_headroom is an int, why use unsigned at all?

Larry
