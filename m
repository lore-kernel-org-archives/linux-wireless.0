Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sj-iport-3.cisco.com ([171.71.176.72]:32423 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352AbZHUUYO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 16:24:14 -0400
Message-ID: <4A8F0261.30408@cs.ucla.edu>
Date: Fri, 21 Aug 2009 13:24:01 -0700
From: Rafael Laufer <rlaufer@cs.ucla.edu>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Implementation of the IEEE80211_RADIOTAP_RATE option
References: <4A8DED03.2050502@cs.ucla.edu> <1250842695.13872.5.camel@johannes.local> 	<69e28c910908210630m47eda1eegcd502c212736decd@mail.gmail.com> 	<4A8EE182.6040709@cs.ucla.edu> <69e28c910908211152k4423d098i92b25078139ee827@mail.gmail.com> 	<4A8EF031.4050604@cs.ucla.edu> <69e28c910908211257p748e8be5w6078e7e98a205ef6@mail.gmail.com> <4A8F01B8.40708@cs.ucla.edu>
In-Reply-To: <4A8F01B8.40708@cs.ucla.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafael Laufer wrote:
> Gábor Stefanik wrote:
>   
>> 2009/8/21 Rafael Laufer <rlaufer@cs.ucla.edu>:
>>   
>>     
>>> Gábor Stefanik wrote:
>>>     
>>>       
>>>> 2009/8/21 Rafael Laufer <rlaufer@cs.ucla.edu>:
>>>>
>>>>       
>>>>         
>>>>> Gábor Stefanik wrote:
>>>>>
>>>>>         
>>>>>           
>>>>>> Maybe a new IEEE80211_TX_CTL_ or IEEE80211_TX_RC_ flag will also be
>>>>>> needed, so Radiotap can indicate whether rate_control_get_rate needs
>>>>>> to be called.
>>>>>>
>>>>>>           
>>>>>>             
>>>>> ok, I am resending the patch. I included a new flag called
>>>>> IEEE80211_TX_CTL_RATE_RADIOTAP to indicate if the rate has
>>>>> been set in the radiotap header. If not, then the rate control
>>>>> algorithm is called.
>>>>>
>>>>>         
>>>>>           
>>>> Isn't it easier to check whether we already have a rate configured?
>>>> (info->control.rates[0].idx is set to an invalid value before the
>>>> rate_control_get_rate call AFAIK, unless you set it in the radiotap
>>>> decoding function before.)
>>>>
>>>>       
>>>>         
>>> I guess it is also possible, but in that case you rely on the assumption
>>> that the rate is invalid before rate_control_get_rate(). If in the
>>> future this assumption does not hold, the code will break. If, however,
>>> this is always gonna be true, I can change the code to use your
>>> suggestion. Personally, I prefer to use another flag so that future
>>> changes do not affect this code, but let me know what is best.
>>>
>>> Rafael
>>>
>>>     
>>>       
>> Actually, that's a good point.
>>
>> One thing to watch out for is that the actual rate index is not the
>> only thing the rate controller sets - it is also responsible for
>> things like retry count & RTS/CTS usage. Those are controlled by other
>> radiotap fields. So, if any of these values is unset in radiotap, you
>> will need to call rate control for them, or auto-generate them in
>> other ways. Otherwise you may end up with e.g. an incorrect retry
>> count.
>>
>>   
>>     
> This is a good point. Where is this done? Is it in the driver-specific
> function?
>
> ref->ops <http://localhost/lxr/http/ident?v=2.6.31-rc3;i=ops>->get_rate(ref->priv <http://localhost/lxr/http/ident?v=2.6.31-rc3;i=priv>, ista, priv_sta, txrc);
>
>
> It is strange that a function called "get_rate" would also change other
> fields which are at first sight do not look related to rate. Why not
> call other functions for that? What is the reasoning behind this?
> Different rates have different retry counts or RTS/CTS usage?
>
> As far as I could tell from a quick look in the code,
> rate_control_get_rate only sets the fields of info->control.rates,
> except for this driver-specific function.
>
> If this function really does other stuff, then a simple solution is to
> check if the IEEE80211_TX_CTL_RATE_RADIOTAP flag is set and, in that
> case, store the value of info->control.rates[0].idx before calling
> rate_control_get_rate, and restoring it afterwards. Make sense?
>   

ops, I meant

ref->ops->get_rate(ref->priv, ista, priv_sta, txrc);


