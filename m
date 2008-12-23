Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:15409 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbYLWWrZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 17:47:25 -0500
Received: by nf-out-0910.google.com with SMTP id d3so364661nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 14:47:23 -0800 (PST)
Message-ID: <49516A78.9020402@gmail.com> (sfid-20081223_234734_711200_43B52A82)
Date: Tue, 23 Dec 2008 22:47:20 +0000
MIME-Version: 1.0
To: Richard Farina <sidhayn@gmail.com>
CC: linux-wireless@vger.kernel.org, simon@thekelleys.org.uk,
	jussi.kivilinna@mbnet.fi, acme@ghostprotocols.net, pe1rxq@amsat.org
Subject: Re: [PATCH] wireless: Add channel/frequency conversions to ieee80211.h
References: <1230041018-13341-1-git-send-email-kilroyd@googlemail.com> <49510D4F.7060102@gmail.com> <49514874.8060605@gmail.com> <495163C8.60003@gmail.com>
In-Reply-To: <495163C8.60003@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Richard Farina wrote:
> Dave wrote:
>> Richard Farina wrote:
>>> David Kilroy wrote:
>>>> Added mappings for FHSS, DSSS and OFDM channels - with macros to point
>>>> HR DSSS and ERP to the DSSS mappings. Currently just static inline
>>>> functions.

>>>> +static inline int ieee80211_ofdm_chan_to_freq(int s_freq, int channel)
>>>> +{
>>>> +	if ((channel > 0) && (channel <= 200) &&
>>>> +	    (s_freq >= 4000))
>>>> +		return s_freq + (channel * 5);
>>>> +	else
>>>> +		return -1;
>>>> +}

>>> Any desire to make 184-196 work? These are the 4.9 GHz channels.

>> Do you see a reason why these channels wouldn't work with these
>> conversion routines? Or are you asking about corresponding driver support?

> Channel 165 freq is 5825MHz
> Channel 183 freq is 4915MHz
> 
> Since your method is linear and 183 is greater than 165, it will output 
> a higher frequency for 183 than for 165 when converting from channel to 
> freq.

I suspect you're talking about US regulatory class 5 which names channel
165 with a starting frequency of 5GHz, and Japans regulatory class 16-20
 naming channel 183 with starting frequency 4GHz. These are accounted
for in the conversion routines by the s_freq parameter:

ieee80211_ofdm_chan_to_freq(5000, 165) ==> 5825
ieee80211_ofdm_chan_to_freq(4000, 183) ==> 4915

It means the caller must know the starting frequency when converting
OFDM channels and frequencies. I expect that this number will come from
the regulatory work that is underway (though I haven't been keeping
track of that).


Regards,

Dave.

>> If drivers don't currently support those channels, I suspect there's a
>> more significant issue to be addressed first.

> No drivers support these channels at the moment AFAIK but I'd be happy 
> to submit a patch that enables tuning if someone else could submit a 
> patch to support half/quarter clocked channels.  Japan is the only place 
> in the world that supports the 4.9GHz realm unlicensed, and I've already 
> been told that patches that enabled licensed only features will not be 
> accepted so I have not bothered to submit support as I lack the skill to 
> add support for half/quarter clock channels and hence it wouldn't be 
> unlicensed.
> 
> Thanks,
> Rick Farina

