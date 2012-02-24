Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:58985 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751979Ab2BXLVU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 06:21:20 -0500
Message-ID: <4F4772AB.9000305@posedge.com> (sfid-20120224_122123_319595_0FF2B153)
Date: Fri, 24 Feb 2012 16:51:15 +0530
From: Mahesh <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Chakra Parvathaneni <chakra@posedge.com>
Subject: Re: [RFCv2] cfg80211: 80Mhz Bandwidth channel flags in 5Gig band
References: <f17c700977012ada368da4f339b9c639@posedge.com>  (sfid-20120222_185112_125868_ED7DF18C)  <1329933458.4657.2.camel@jlt3.sipsolutions.net>  (sfid-20120222_185746_860409_0CF57D5F) <1329937072.4657.4.camel@jlt3.sipsolutions.net>  <4F471F40.8060503@posedge.com> <1330070145.3426.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1330070145.3426.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 02/24/2012 01:25 PM, Johannes Berg wrote:
> On Fri, 2012-02-24 at 10:55 +0530, Mahesh wrote:
>
>> Agree. we will work towards updating regulatory database with 80Mhz
>> bandwidth in 5Gig band. I had modified code to check maximum bandwidth
>> as well. Please find the updated change below.
>
>> -	if (freq_range->max_bandwidth_khz<  MHZ_TO_KHZ(40))
>> -		bw_flags = IEEE80211_CHAN_NO_HT40;
>> +	if (freq_range->max_bandwidth_khz<  MHZ_TO_KHZ(40)) {
>> +		bw_flags = IEEE80211_CHAN_NO_HT40 | IEEE80211_CHAN_NO_VHT80;
>> +    } else if (freq_range->max_bandwidth_khz<  MHZ_TO_KHZ(80)) {
>> +		bw_flags = IEEE80211_CHAN_NO_VHT80;
>> +    }
>
> no braces needed
>
> Also this will always be true now, so the patch isn't very useful right
> now?
True. But once reg database reflects 80MHz BW, we need it. Anyways its 
part of new feature. Not a bug fix.
>
>
>> -	if (freq_range->max_bandwidth_khz<  MHZ_TO_KHZ(40))
>> -		bw_flags = IEEE80211_CHAN_NO_HT40;
>> +	if (freq_range->max_bandwidth_khz<  MHZ_TO_KHZ(40)) {
>> +		bw_flags = IEEE80211_CHAN_NO_HT40 | IEEE80211_CHAN_NO_VHT80;
>> +    } else if (freq_range->max_bandwidth_khz<  MHZ_TO_KHZ(80)) {
>> +		bw_flags = IEEE80211_CHAN_NO_VHT80;
>> +    }
>
> Seems some refactoring could be useful since this is duplicated?
May be a macro?

>
> johannes
>
