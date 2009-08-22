Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cheetah.CS.UCLA.EDU ([131.179.128.24]:55330 "EHLO
	cheetah.cs.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074AbZHVWSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 18:18:47 -0400
Message-ID: <4A906B4C.6010208@cs.ucla.edu>
Date: Sat, 22 Aug 2009 15:03:56 -0700
From: Rafael Laufer <rlaufer@CS.UCLA.EDU>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Implementation of the IEEE80211_RADIOTAP_RATE option
References: <4A8DED03.2050502@cs.ucla.edu>	 <1250842695.13872.5.camel@johannes.local>	 <69e28c910908210630m47eda1eegcd502c212736decd@mail.gmail.com>	 <4A8EE182.6040709@cs.ucla.edu> <1250927308.23605.6.camel@johannes.local>
In-Reply-To: <1250927308.23605.6.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Fri, 2009-08-21 at 11:03 -0700, Rafael Laufer wrote:
>
>   
>> + * @IEEE80211_TX_CTL_RATE_RADIOTAP: completely internal to mac80211,
>> + *	used to indicate that the rate was defined in the received radiotap
>> + *	header and therefore the rate control algorithm should not change it.
>>     
>
> This should be an internal flag, the driver doesn't care.
>   

right, and where are those set?
>   
>> +	/* In monitor mode, if the IEEE80211_RADIOTAP_RATE option is set in 
>> +	 * the received radiotap header, do not call the rate control algorithm.
>> +	 */
>>     
>
> coding style
>
>   
>> +		/* Get the rate parameter from the radiotap header, 
>> +		 * allowing rate selection on a per-packet basis 
>> +		 */
>>     
>
> coding style
>   

I am a newbie, I am gonna look into the coding style, but I assume you 
are talking about the missing blank line in the beginning

>   
>> +		case IEEE80211_RADIOTAP_RATE:
>> +			bitrate = (*iterator.this_arg) * 5;
>> +			for (i = 0; i < sband->n_bitrates; i++) {
>> +				if (sband->bitrates[i].bitrate == bitrate)
>> +					break;
>> +			}
>> +			if (i != sband->n_bitrates) {
>> +				info->control.rates[0].idx = i;
>> +				info->flags |= IEEE80211_TX_CTL_RATE_RADIOTAP;
>> +			}
>>     
>
> You never set the counter, or any other fields.
>   

This is a good point and now I see that Gábor pointed this out as well. 
There are other fields in the radiotap header that define the RTS and 
DATA retries. However, if those fields are not set, there must be a 
default value in this case. Are there any?

>   
>>  		/*
>>  		 * Please update the file
>>  		 * Documentation/networking/mac80211-injection.txt
>>     
>
> And you even quote the instructions.
>   

come on...

Rafael

