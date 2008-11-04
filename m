Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38149 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbYKDWtR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 17:49:17 -0500
Subject: Re: [PATCH] make assocaittion only if SSID is known.
From: Dan Williams <dcbw@redhat.com>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rjw@sisk.pl, kernel-testers@vger.kernel.org
In-Reply-To: <1225836101-5723-1-git-send-email-bug-track@fisher-privat.net>
References: <1225836101-5723-1-git-send-email-bug-track@fisher-privat.net>
Content-Type: text/plain
Date: Tue, 04 Nov 2008 17:47:08 -0500
Message-Id: <1225838828.22671.0.camel@localhost.localdomain> (sfid-20081104_234921_826704_D7672C2D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-11-04 at 23:01 +0100, Alexey Fisher wrote:
> 'iwconfig eth1 channel 6' would trigger association to _something_, which is wrong.  Changing the channel should (and does) trigger reassociation, but only if there is an SSID to associate with!

Heh :)  Need the Signed-off-by: here too though.

Dan


>  drivers/net/wireless/ipw2200.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
> index dcce354..d26beed 100644
> --- a/drivers/net/wireless/ipw2200.c
> +++ b/drivers/net/wireless/ipw2200.c
> @@ -7581,8 +7581,7 @@ static int ipw_associate(void *data)
>  	}
>  
>  	if (!(priv->config & CFG_ASSOCIATE) &&
> -	    !(priv->config & (CFG_STATIC_ESSID |
> -			      CFG_STATIC_CHANNEL | CFG_STATIC_BSSID))) {
> +	    !(priv->config & (CFG_STATIC_ESSID | CFG_STATIC_BSSID))) {
>  		IPW_DEBUG_ASSOC("Not attempting association (associate=0)\n");
>  		return 0;
>  	}

