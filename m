Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cheetah.CS.UCLA.EDU ([131.179.128.24]:55330 "EHLO
	cheetah.cs.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbZHVWSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 18:18:47 -0400
Message-ID: <4A906BA6.3080309@cs.ucla.edu>
Date: Sat, 22 Aug 2009 15:05:26 -0700
From: Rafael Laufer <rlaufer@CS.UCLA.EDU>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Implementation of the IEEE80211_RADIOTAP_RATE option
References: <4A8DED03.2050502@cs.ucla.edu>	 <1250842695.13872.5.camel@johannes.local>	 <69e28c910908210630m47eda1eegcd502c212736decd@mail.gmail.com>	 <4A8EE182.6040709@cs.ucla.edu>	 <69e28c910908211152k4423d098i92b25078139ee827@mail.gmail.com>	 <4A8EF031.4050604@cs.ucla.edu>	 <69e28c910908211257p748e8be5w6078e7e98a205ef6@mail.gmail.com>	 <4A8F01B8.40708@cs.ucla.edu> <1250927425.23605.8.camel@johannes.local>
In-Reply-To: <1250927425.23605.8.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Fri, 2009-08-21 at 13:21 -0700, Rafael Laufer wrote:
>
>   
>> It is strange that a function called "get_rate" would also change other
>> fields which are at first sight do not look related to rate. Why not
>> call other functions for that? What is the reasoning behind this?
>> Different rates have different retry counts or RTS/CTS usage?
>>     
> I can't tell if you're kidding or not. This also doesn't get a single
> rate, but the entire rate control setup.
>   
>> As far as I could tell from a quick look in the code,
>> rate_control_get_rate only sets the fields of info->control.rates,
>> except for this driver-specific function.
>>     
> Right. And now look again what's in control.rates[].
>   

ok, I get it now. The flags and count also need to be set. Anything else?

>   
>> If this function really does other stuff, then a simple solution is to
>> check if the IEEE80211_TX_CTL_RATE_RADIOTAP flag is set and, in that
>> case, store the value of info->control.rates[0].idx before calling
>> rate_control_get_rate, and restoring it afterwards. Make sense?
>>     
> Ick, no.
>   
though so, it's so ugly

Rafael

