Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51490 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759536AbbKTKtP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2015 05:49:15 -0500
Message-ID: <1448016547.3141.4.camel@sipsolutions.net> (sfid-20151120_114918_608835_E4FAAAE8)
Subject: Re: [PATCH v2 2/2] mac80211: passively scan DFS channels if
 requested
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>,
	Simon Wunderlich <sw@simonwunderlich.de>
Date: Fri, 20 Nov 2015 11:49:07 +0100
In-Reply-To: <1447464560-28104-2-git-send-email-antonio@meshcoding.com>
References: <1447464560-28104-1-git-send-email-antonio@meshcoding.com>
	 <1447464560-28104-2-git-send-email-antonio@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> @@ -599,7 +599,9 @@ static int __ieee80211_start_scan(struct
> ieee80211_sub_if_data *sdata,
>  
>  		if ((req->channels[0]->flags &
>  		     IEEE80211_CHAN_NO_IR) ||
> -		    !req->n_ssids) {
> +		    !req->n_ssids ||
> +		    ((req->channels[0]->flags &
> IEEE80211_CHAN_RADAR) &&
> +		     (req->flags &
> NL80211_SCAN_FLAG_PASSIVE_RADAR))) {
>  			next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
> 

I don't really see any circumstances under which it's valid to actively
scan radar channels ... seems like we should do this unconditionally?

johannes
