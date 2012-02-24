Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55480 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab2BXHzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 02:55:51 -0500
Subject: Re: [RFCv2] cfg80211: 80Mhz Bandwidth channel flags in 5Gig band
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh <maheshp@posedge.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <4F471F40.8060503@posedge.com>
References: <f17c700977012ada368da4f339b9c639@posedge.com>
	 (sfid-20120222_185112_125868_ED7DF18C)  <1329933458.4657.2.camel@jlt3.sipsolutions.net>
	 (sfid-20120222_185746_860409_0CF57D5F) <1329937072.4657.4.camel@jlt3.sipsolutions.net>
	 <4F471F40.8060503@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Feb 2012 08:55:45 +0100
Message-ID: <1330070145.3426.8.camel@jlt3.sipsolutions.net> (sfid-20120224_085554_830854_56C51BAD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-02-24 at 10:55 +0530, Mahesh wrote:

> Agree. we will work towards updating regulatory database with 80Mhz 
> bandwidth in 5Gig band. I had modified code to check maximum bandwidth 
> as well. Please find the updated change below.

> -	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
> -		bw_flags = IEEE80211_CHAN_NO_HT40;
> +	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40)) {
> +		bw_flags = IEEE80211_CHAN_NO_HT40 | IEEE80211_CHAN_NO_VHT80;
> +    } else if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(80)) {
> +		bw_flags = IEEE80211_CHAN_NO_VHT80;
> +    }

no braces needed

Also this will always be true now, so the patch isn't very useful right
now?


> -	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
> -		bw_flags = IEEE80211_CHAN_NO_HT40;
> +	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40)) {
> +		bw_flags = IEEE80211_CHAN_NO_HT40 | IEEE80211_CHAN_NO_VHT80;
> +    } else if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(80)) {
> +		bw_flags = IEEE80211_CHAN_NO_VHT80;
> +    }

Seems some refactoring could be useful since this is duplicated?

johannes

