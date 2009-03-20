Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:17003 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbZCTJWv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 05:22:51 -0400
Received: by fg-out-1718.google.com with SMTP id e12so157037fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2009 02:22:48 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [RFC PATCH v2 1/4] mac80211: decrease execution of the	associated timer
References: <20090314171234.11126.21125.stgit@tikku>
	<20090314171431.11126.51242.stgit@tikku>
	<1237051084.5235.97.camel@johannes.local> <49BBFB78.6070708@nokia.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 20 Mar 2009 11:22:45 +0200
Message-ID: <87zlfglfa2.fsf@litku.valot.fi> (sfid-20090320_102255_550890_87399D78)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@nokia.com> writes:

> Johannes Berg wrote:
>> On Sat, 2009-03-14 at 19:14 +0200, Kalle Valo wrote:
>>
>>> +void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
>>> +			     struct ieee80211_hdr *hdr)
>>> +{
>>> +	/* timer triggers only when there is no unicast traffic */
>>> +	if (!is_multicast_ether_addr(hdr->addr1))
>>> +		mod_timer(&sdata->u.mgd.timer,
>>> +			  jiffies + IEEE80211_MONITORING_INTERVAL);
>>> +}
>>
>> Do we really need the multicast check? The frame will be coming from the
>> AP in managed mode in both cases, so why regard the data path as idle
>> when we're receiving multicast traffic?
>
> It seems that I had a good vacation because I can't remember anymore
> why I added the check :D Too bad that even the comment I wrote was
> next to useless.
>
> I'll remove the multicast check because I don't see the point for it.
> And if in case I finally recall the reason I'll definitely add a
> better comment.

Now I remember what this test was about. In ieee80211_associated()
there are two tests: probe request check after an data idle period
(currently 60 secs) and beacon loss check for drivers not supporting
filtering (2 secs).

The former test has been originally (even before my beacon filter
patches) implemented so that the probe request is sent even though we
are receiving beacons. mod_timer() is called only for unicast traffic
so that the probe request test will trigger when we are still
receiving beacons.

I'll add a proper comment explaining all this.

Also currently ieee80211_associated() is called every two seconds, we
need to fix this in future to avoid waking up cpu needlessly. I don't
want to make too intrusive changes right now.

-- 
Kalle Valo
