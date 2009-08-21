Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:29956 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299AbZHUT6D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 15:58:03 -0400
Received: by fg-out-1718.google.com with SMTP id e12so246784fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2009 12:58:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A8EF031.4050604@cs.ucla.edu>
References: <4A8DED03.2050502@cs.ucla.edu> <1250842695.13872.5.camel@johannes.local>
	<69e28c910908210630m47eda1eegcd502c212736decd@mail.gmail.com>
	<4A8EE182.6040709@cs.ucla.edu> <69e28c910908211152k4423d098i92b25078139ee827@mail.gmail.com>
	<4A8EF031.4050604@cs.ucla.edu>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 21 Aug 2009 21:57:43 +0200
Message-ID: <69e28c910908211257p748e8be5w6078e7e98a205ef6@mail.gmail.com>
Subject: Re: [PATCH] Implementation of the IEEE80211_RADIOTAP_RATE option
To: Rafael Laufer <rlaufer@cs.ucla.edu>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/21 Rafael Laufer <rlaufer@cs.ucla.edu>:
> Gábor Stefanik wrote:
>> 2009/8/21 Rafael Laufer <rlaufer@cs.ucla.edu>:
>>
>>> Gábor Stefanik wrote:
>>>
>>>> Maybe a new IEEE80211_TX_CTL_ or IEEE80211_TX_RC_ flag will also be
>>>> needed, so Radiotap can indicate whether rate_control_get_rate needs
>>>> to be called.
>>>>
>>> ok, I am resending the patch. I included a new flag called
>>> IEEE80211_TX_CTL_RATE_RADIOTAP to indicate if the rate has
>>> been set in the radiotap header. If not, then the rate control
>>> algorithm is called.
>>>
>>
>> Isn't it easier to check whether we already have a rate configured?
>> (info->control.rates[0].idx is set to an invalid value before the
>> rate_control_get_rate call AFAIK, unless you set it in the radiotap
>> decoding function before.)
>>
>
> I guess it is also possible, but in that case you rely on the assumption
> that the rate is invalid before rate_control_get_rate(). If in the
> future this assumption does not hold, the code will break. If, however,
> this is always gonna be true, I can change the code to use your
> suggestion. Personally, I prefer to use another flag so that future
> changes do not affect this code, but let me know what is best.
>
> Rafael
>

Actually, that's a good point.

One thing to watch out for is that the actual rate index is not the
only thing the rate controller sets - it is also responsible for
things like retry count & RTS/CTS usage. Those are controlled by other
radiotap fields. So, if any of these values is unset in radiotap, you
will need to call rate control for them, or auto-generate them in
other ways. Otherwise you may end up with e.g. an incorrect retry
count.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
