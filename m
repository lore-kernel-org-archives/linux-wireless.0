Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:63988 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbYLWWS7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 17:18:59 -0500
Received: by ewy10 with SMTP id 10so2972069ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 14:18:57 -0800 (PST)
Message-ID: <495163C8.60003@gmail.com> (sfid-20081223_231915_291929_00274867)
Date: Tue, 23 Dec 2008 17:18:48 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Dave <kilroyd@googlemail.com>
CC: linux-wireless@vger.kernel.org, simon@thekelleys.org.uk,
	jussi.kivilinna@mbnet.fi, acme@ghostprotocols.net, pe1rxq@amsat.org
Subject: Re: [PATCH] wireless: Add channel/frequency conversions to ieee80211.h
References: <1230041018-13341-1-git-send-email-kilroyd@googlemail.com> <49510D4F.7060102@gmail.com> <49514874.8060605@gmail.com>
In-Reply-To: <49514874.8060605@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave wrote:
> Richard Farina wrote:
>   
>> David Kilroy wrote:
>>     
>>> Added mappings for FHSS, DSSS and OFDM channels - with macros to point
>>> HR DSSS and ERP to the DSSS mappings. Currently just static inline
>>> functions.
>>>       
>
>   
>>> +/**
>>> + * ieee80211_ofdm_chan_to_freq - get channel center frequency
>>> + * @s_freq: starting frequency == (dotChannelStartingFactor/2) MHz
>>> + * @channel: the OFDM channel
>>> + *
>>> + * Convert IEEE802.11 OFDM channel to center frequency (MHz)
>>> + * Ref IEEE 802.11-2007 section 17.3.8.3.2
>>> + */
>>> +static inline int ieee80211_ofdm_chan_to_freq(int s_freq, int channel)
>>> +{
>>> +	if ((channel > 0) && (channel <= 200) &&
>>> +	    (s_freq >= 4000))
>>> +		return s_freq + (channel * 5);
>>> +	else
>>> +		return -1;
>>> +}
>>>       
>
>   
>> Any desire to make 184-196 work? These are the 4.9 GHz channels.
>>     
>
> Do you see a reason why these channels wouldn't work with these
> conversion routines? Or are you asking about corresponding driver support?
>
>   
Channel 165 freq is 5825MHz
Channel 183 freq is 4915MHz

Since your method is linear and 183 is greater than 165, it will output 
a higher frequency for 183 than for 165 when converting from channel to 
freq.

Please feel free to correct me if I'm wrong, my coding skills are not 
very good (hence the reason I have included a patch).  Considering none 
of the cards using this support 802.11a is doesn't seem to matter much, 
but the fact of the matter is I have had to correct this stuff in a 
driver or two and it would be nice if the drivers could pull this info 
from a single place instead of each driver doing the conversions 
(possibly wrongly) by themselves.
> >From the ack I assume the latter. My main motivation is to put the
> frequency conversions in a common place. In this case for old drivers
> which only use the 2.4 GHz band. The 5GHz conversions are just for
> completeness.
>
>   
My request of supporting the 4.9 stuff is also only for completeness, 
there is nothing at all that should stop you from committing your code 
as is, no code I have seen accounts for proper conversion so your work 
is by no means sub-par.
> If drivers don't currently support those channels, I suspect there's a
> more significant issue to be addressed first.
>
>   
No drivers support these channels at the moment AFAIK but I'd be happy 
to submit a patch that enables tuning if someone else could submit a 
patch to support half/quarter clocked channels.  Japan is the only place 
in the world that supports the 4.9GHz realm unlicensed, and I've already 
been told that patches that enabled licensed only features will not be 
accepted so I have not bothered to submit support as I lack the skill to 
add support for half/quarter clock channels and hence it wouldn't be 
unlicensed.

Thanks,
Rick Farina
>> I checked this all out pretty specifically, seems to work well. As if 
>> anyone cares but:
>>
>> ACKED-By: Rick Farina
>>     
>
> Thanks for having a look.
>
>
>
> Dave.
>
>   

