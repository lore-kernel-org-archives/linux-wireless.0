Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57040 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab1DLLTV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 07:19:21 -0400
Subject: Re: [PATCH 4/4] mac80211: Add IEEE802.11n for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <alexander.simon@saxnet.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20110412T130620-109@post.gmane.org>
References: <1302604964.2139.5.camel@alex-2>
	 <loom.20110412T130620-109@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 13:19:19 +0200
Message-ID: <1302607159.3639.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-12 at 11:07 +0000, Alexander Simon wrote:

>  	skb = dev_alloc_skb(sdata->local->hw.extra_tx_headroom +
> -			    36 /* bitrates */ +
> -			    34 /* SSID */ +
> -			    3  /* DS params */ +
> -			    4  /* IBSS params */ +
> -			    params->ie_len);
> +				sizeof(struct ieee80211_hdr_3addr) + 
> +				12 /* struct ieee80211_mgmt.u.beacon */ +
> +				2 + IEEE80211_MAX_SSID_LEN /* max SSID */ +

You have a tendency to mess up the coding style.

Also what if the IBSS is created with HT40+ and then joins, can it join
HT40-? Is the channel type "advisory" like the frequency? Can it join
HT20 IBSS as well?

johannes

