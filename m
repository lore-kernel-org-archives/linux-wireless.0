Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.irobot.com ([206.83.81.187]:15432 "EHLO smtp1.irobot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbZKLTnS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 14:43:18 -0500
Message-ID: <4AFC655A.5020706@irobot.com>
Date: Thu, 12 Nov 2009 11:43:22 -0800
From: Adam Wozniak <awozniak@irobot.com>
MIME-Version: 1.0
To: Derek Smithies <derek@indranet.co.nz>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org
Subject: Re: compat-wireless and minstrel
References: <4AF0D54D.4090303@irobot.com> <200911041653.33737.chunkeey@googlemail.com> <alpine.DEB.2.00.0911050951000.16407@kauri.acheron.indranet.co.nz> <4AF9F03E.2010405@irobot.com> <alpine.DEB.2.00.0911111217580.6214@kauri.acheron.indranet.co.nz> <4AFA0E76.6060806@irobot.com> <alpine.DEB.2.00.0911111508391.6214@kauri.acheron.indranet.co.nz>
In-Reply-To: <alpine.DEB.2.00.0911111508391.6214@kauri.acheron.indranet.co.nz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was hoping for more of an "ah-ha!" response. =)

It worked well initially, but when I let it run overnight it fell back 
into that same failure mode.

Derek Smithies wrote:
> Hi,
>
>> Is it possible this is the problem? (note supp_rates is used at the 
>> bottom of the function, outside the "if")
>
> Could be. Did it fix your problem?
>
> Derek.
>
> On Tue, 10 Nov 2009, Adam Wozniak wrote:
>
>> Is it possible this is the problem? (note supp_rates is used at the 
>> bottom of the function, outside the "if")
>>
>> *** a/net/mac80211/ibss.c    2009-11-02 09:11:36.000000000 -0800
>> --- b/net/mac80211/ibss.c    2009-11-10 16:31:46.291563951 -0800
>> ***************
>> *** 246,254 ****
>>     if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
>>         return;
>>
>>     if (sdata->vif.type == NL80211_IFTYPE_ADHOC && elems->supp_rates &&
>>         memcmp(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0) {
>> -         supp_rates = ieee80211_sta_get_rates(local, elems, band);
>>
>>         rcu_read_lock();
>>
>> --- 246,255 ----
>>     if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
>>         return;
>>
>> +     supp_rates = ieee80211_sta_get_rates(local, elems, band);
>> +
>>     if (sdata->vif.type == NL80211_IFTYPE_ADHOC && elems->supp_rates &&
>>         memcmp(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0) {
>>
>>         rcu_read_lock();
>>
>>
>>
>> Derek Smithies wrote:
>>> Hi,
>>>> Do you know which frames in the mac80211 code are missing this 
>>>> required information?  Or was that conjecture?
>>>
>>> it was mostly conjecture. I had done some work with an earlier pull 
>>> of compat wireless in adhoc. the rates tried by minstrel were bad - 
>>> it was stuck at the slowest rate.
>>>
>>> I too had found that the fix was to adjust the array so that all 
>>> rates were marked as supported.
>>>
>>> Derek
>>>
>>> On Tue, 10 Nov 2009, Adam Wozniak wrote:
>>>
>>>> Reading through the 802.11 spec, it appears to me that "Supported 
>>>> rates" (and "Extended Supported Rates" when number of rates > 8) is 
>>>> REQUIRED for all management frames except authentication, 
>>>> deauthentication, and action frames. (IEEE 802.11-2007, 7.2.3)
>>>>
>>>> Do you know which frames in the mac80211 code are missing this 
>>>> required information?  Or was that conjecture?
>>>>
>>>> Looking at mac80211/tx.c ieee80211_beacon_get_tim, it is not clear 
>>>> to me how (or if) this rate information is being set for ad-hoc 
>>>> beacons.
>>>>
>>>> Derek Smithies wrote:
>>>>> Some management frames don't contain a full report of the rates 
>>>>> supported by the sender.
>>>>> My view is that node A (in this example) is incorrectly 
>>>>> determining that B only supports the 1mb/sec rate. Consequently, 
>>>>> node A fills the rate_supported  array with one rate - 1mb/sec.
>>>>
>>>>
>>>>
>>>
>>
>>
>>
>

