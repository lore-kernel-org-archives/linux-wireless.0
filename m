Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-5.exch022.serverdata.net ([206.225.164.188]:50600
	"EHLO HUB022-nj-5.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818Ab2KTGDs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 01:03:48 -0500
Message-ID: <50AB1D3E.4090808@posedge.com> (sfid-20121120_070351_459643_6582D73D)
Date: Tue, 20 Nov 2012 11:33:42 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2 4/8] nl80211/cfg80211: support VHT channel configuration
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>  <1352492254-29399-5-git-send-email-johannes@sipsolutions.net>  <50AA237F.4090102@posedge.com> <1353334304.18299.2.camel@jlt4.sipsolutions.net>
In-Reply-To: <1353334304.18299.2.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/19/2012 07:41 PM, Johannes Berg wrote:
> On Mon, 2012-11-19 at 17:48 +0530, Mahesh Palivela wrote:
>
>>> +	case NL80211_CHAN_WIDTH_160:
>>> +		if (chandef->center_freq1 != control_freq + 70 &&
>>> +		    chandef->center_freq1 != control_freq + 50 &&
>>> +		    chandef->center_freq1 != control_freq + 30 &&
>>> +		    chandef->center_freq1 != control_freq + 10 &&
>>> +		    chandef->center_freq1 != control_freq - 10 &&
>>> +		    chandef->center_freq1 != control_freq - 30 &&
>>> +		    chandef->center_freq1 != control_freq - 50 &&
>>> +		    chandef->center_freq1 != control_freq - 70)
>>> +			return false;
>>
>> Should we create a macro instead of +70 to -70 to take care of all 3
>> cases 80, 80p80 and 160?
>
> Not sure, I hope we won't duplicate this code anywhere else, so I don't
> really think we need to?
>

you kind of used it in cfg80211_check_beacon_chans() in wireless/chan.c

         for (freq = center_freq - bw/2 + 10;
              freq <= center_freq + bw/2 - 10;
              freq += 20)

we can use in 3 switch cases, 80, 80p80 and 160.
