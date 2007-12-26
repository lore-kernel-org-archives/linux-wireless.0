Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.polimi.it ([131.175.12.3]:56113 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbXLZAWF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2007 19:22:05 -0500
From: stefano.brivio@polimi.it
Message-ID: <20071226012007.otwhbzzi80ck8kko@webmail.polimi.it> (sfid-20071226_002211_558923_91C7C493)
Date: Wed, 26 Dec 2007 01:20:07 +0100
To: Michael Wu <flamingice@sourmilk.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: [PATCH] mac80211: Fix rate reporting regression
References: <20071226000958.21143.10527.stgit@tetra.sourmilk.net>
In-Reply-To: <20071226000958.21143.10527.stgit@tetra.sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Michael Wu <flamingice@sourmilk.net>:

> Mattias Nissler's "clean up rate selection" patch incorrectly changes
> the behavior of txrate setting in sta_info. This patch backs out parts
> of the rate selection consolidation in order to fix this issue for now.

Looks good, except that...

> --- a/net/mac80211/rc80211_pid_algo.c
> +++ b/net/mac80211/rc80211_pid_algo.c
> @@ -307,22 +307,34 @@ static void rate_control_pid_get_rate(void   
> *priv, struct net_device *dev,
>  {
>  	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
> +	struct ieee80211_sub_if_data *sdata;
>  	struct sta_info *sta;
>  	int rateidx;
> +	u16 fc;
>
>  	sta = sta_info_get(local, hdr->addr1);
>
> -	if (!sta) {
> -		sel->rate = rate_lowest(local, mode, NULL);
> -		sta_info_put(sta);
> +	/* Send management frames and broadcast/multicast data using lowest
> +	 * rate. */
> +	fc = le16_to_cpu(hdr->frame_control);
> +	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
> +	    is_multicast_ether_addr(hdr->addr1) || !sta) {
> +		sel->rate = rate_lowest(local, mode, sta);
>  		return;
>  	}
>
> +	/* If a forced rate is in effect, select it. */
> +	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1)
> +		sta->txrate = sdata->bss->force_unicast_rateidx;

...you could be dereferencing a NULL pointer :)


--
Ciao
Stefano



