Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:41739 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbZA2SPv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 13:15:51 -0500
Message-ID: <4981F232.5000801@nokia.com> (sfid-20090129_191555_535857_B6DF77EE)
Date: Thu, 29 Jan 2009 20:15:14 +0200
From: Kalle Valo <kalle.valo@nokia.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "vivek.natraj@gmail.com" <vivek.natraj@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC PATCH v2 2/2] mac80211: use ps-poll when dynamic power	save
 mode is disabled
References: <20090122114240.31443.18218.stgit@tikku>	 <20090122114546.31443.79387.stgit@tikku>	 <1232643729.5819.3.camel@johannes.local>  <87hc3jgyu9.fsf@nokia.com> <1233168737.4811.18.camel@johannes.local>
In-Reply-To: <1233168737.4811.18.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2009-01-28 at 18:49 +0200, Kalle Valo wrote:
> 
>>> If we receive a frame, but don't send any, we'll still stay awake.
>>> Should receiving update the dynamic timer as well, to avoid that case?
>>> Here, I mean:
>>>
>>>> @@ -1816,9 +1851,24 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
>>> ...
>>>> +                       if (local->hw.conf.dynamic_ps_timeout > 0) {
>>>> +                               local->hw.conf.flags &= ~IEEE80211_CONF_PS;
>>>> +                               ieee80211_hw_config(local,
>>>> +                                                   IEEE80211_CONF_CHANGE_PS);
>>>> +                               ieee80211_send_nullfunc(local, sdata, 0);
>> You mean case where directed_time is set, dynamic_ps_timeout is zero
>> and station doesn't transmit anything? That's not a problem because in
>> that case power save is not disabled at all, ps-poll is sent while
>> power save mode is enabled. So there won't any problem.
> 
> No, I mean in the timeout > 0 case, what vivek mentioned too. We never
> go back to sleep unless we send a packet.

First of all, this patchset doesn't change the logic for timeout > 0 
case. But that case was working already earlier, here's my analysis:

1. tim bit is set
2. if timeout > 0 disable power save and send null frame
3. null frame enables dynamic_ps_timer in ieee80211_master_start_xmit()
4. after dynamic_ps_timer triggers, power save is enabled again

I understood that this was the reason why Vivek moved the running of 
dynamic_ps_timer from subif to the master interface. Or did I miss 
something?

Kalle
