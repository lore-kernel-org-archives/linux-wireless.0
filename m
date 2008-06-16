Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbYFPUUW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 16:20:22 -0400
Subject: Re: [PATCH] mac80211: remove shared key todo
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213642529.3803.47.camel@johannes.berg>
References: <1213642529.3803.47.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 16:19:26 -0400
Message-Id: <1213647566.18384.6.camel@localhost.localdomain> (sfid-20080616_222026_501325_02801AE5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-06-16 at 20:55 +0200, Johannes Berg wrote:
> Adding shared key authentication is not going to happen anyway.

+1; I've _never_ heard or seen anyone using Shared Key auth with adhoc.
How would that work anyway, given that there's no AP to send you the
challenge text?  Just auth against some random peer?

Dan

> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/mac80211/mlme.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> --- everything.orig/net/mac80211/mlme.c	2008-06-16 09:30:45.000000000 +0200
> +++ everything/net/mac80211/mlme.c	2008-06-16 09:31:01.000000000 +0200
> @@ -1753,11 +1753,12 @@ static void ieee80211_rx_mgmt_auth(struc
>  	       auth_transaction, status_code);
>  
>  	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
> -		/* IEEE 802.11 standard does not require authentication in IBSS
> +		/*
> +		 * IEEE 802.11 standard does not require authentication in IBSS
>  		 * networks and most implementations do not seem to use it.
>  		 * However, try to reply to authentication attempts if someone
>  		 * has actually implemented this.
> -		 * TODO: Could implement shared key authentication. */
> +		 */
>  		if (auth_alg != WLAN_AUTH_OPEN || auth_transaction != 1) {
>  			printk(KERN_DEBUG "%s: unexpected IBSS authentication "
>  			       "frame (alg=%d transaction=%d)\n",
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

