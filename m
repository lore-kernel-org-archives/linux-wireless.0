Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sj-iport-3.cisco.com ([171.71.176.72]:42739 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbZHUTGZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 15:06:25 -0400
Message-ID: <4A8EF031.4050604@cs.ucla.edu>
Date: Fri, 21 Aug 2009 12:06:25 -0700
From: Rafael Laufer <rlaufer@cs.ucla.edu>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Implementation of the IEEE80211_RADIOTAP_RATE option
References: <4A8DED03.2050502@cs.ucla.edu> <1250842695.13872.5.camel@johannes.local> 	<69e28c910908210630m47eda1eegcd502c212736decd@mail.gmail.com> 	<4A8EE182.6040709@cs.ucla.edu> <69e28c910908211152k4423d098i92b25078139ee827@mail.gmail.com>
In-Reply-To: <69e28c910908211152k4423d098i92b25078139ee827@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> 2009/8/21 Rafael Laufer <rlaufer@cs.ucla.edu>:
>   
>> Gábor Stefanik wrote:
>>     
>>> Maybe a new IEEE80211_TX_CTL_ or IEEE80211_TX_RC_ flag will also be
>>> needed, so Radiotap can indicate whether rate_control_get_rate needs
>>> to be called.
>>>       
>> ok, I am resending the patch. I included a new flag called
>> IEEE80211_TX_CTL_RATE_RADIOTAP to indicate if the rate has
>> been set in the radiotap header. If not, then the rate control
>> algorithm is called.
>>     
>
> Isn't it easier to check whether we already have a rate configured?
> (info->control.rates[0].idx is set to an invalid value before the
> rate_control_get_rate call AFAIK, unless you set it in the radiotap
> decoding function before.)
>   

I guess it is also possible, but in that case you rely on the assumption
that the rate is invalid before rate_control_get_rate(). If in the
future this assumption does not hold, the code will break. If, however,
this is always gonna be true, I can change the code to use your
suggestion. Personally, I prefer to use another flag so that future
changes do not affect this code, but let me know what is best.

Rafael
