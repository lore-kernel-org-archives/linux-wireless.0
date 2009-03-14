Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:41867 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbZCNSql (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 14:46:41 -0400
Message-ID: <49BBFB78.6070708@nokia.com> (sfid-20090314_194646_732590_F0BACFC1)
Date: Sat, 14 Mar 2009 20:46:16 +0200
From: Kalle Valo <kalle.valo@nokia.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [RFC PATCH v2 1/4] mac80211: decrease execution of the	associated
 timer
References: <20090314171234.11126.21125.stgit@tikku>	 <20090314171431.11126.51242.stgit@tikku> <1237051084.5235.97.camel@johannes.local>
In-Reply-To: <1237051084.5235.97.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sat, 2009-03-14 at 19:14 +0200, Kalle Valo wrote:
> 
>> +void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
>> +			     struct ieee80211_hdr *hdr)
>> +{
>> +	/* timer triggers only when there is no unicast traffic */
>> +	if (!is_multicast_ether_addr(hdr->addr1))
>> +		mod_timer(&sdata->u.mgd.timer,
>> +			  jiffies + IEEE80211_MONITORING_INTERVAL);
>> +}
> 
> Do we really need the multicast check? The frame will be coming from the
> AP in managed mode in both cases, so why regard the data path as idle
> when we're receiving multicast traffic?

It seems that I had a good vacation because I can't remember anymore why 
I added the check :D Too bad that even the comment I wrote was next to 
useless.

I'll remove the multicast check because I don't see the point for it. 
And if in case I finally recall the reason I'll definitely add a better 
comment.

Thanks for all the review!

Kalle
