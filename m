Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www19.servergod.com ([64.89.16.20]:55468 "EHLO
	www19.servergod.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508Ab2FZQoh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 12:44:37 -0400
Message-ID: <4FE9E6F0.2070909@opentechinstitute.org> (sfid-20120626_184440_447068_65258E12)
Date: Tue, 26 Jun 2012 12:44:32 -0400
From: Will Hawkins <hawkinsw@opentechinstitute.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Will Hawkins <hawkinsw@opentechinitiative.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Help tracing NL80211_CMD_AUTHENTICATE as event in IBSS mode
References: <24f-4fe93400-17-239c5900@2266046>   (sfid-20120626_061218_757773_249E152D) <1340693584.4662.3.camel@jlt3.sipsolutions.net>  <4FE9E201.1010903@opentechinstitute.org> <1340728873.4484.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340728873.4484.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/26/2012 12:41 PM, Johannes Berg wrote:
> On Tue, 2012-06-26 at 12:23 -0400, Will Hawkins wrote:
> 
>>>> "When used as an event, this reports reception of an Authentication
>>>> frame in station and IBSS modes when the local MLME processed the
>>>> frame, i.e., it was for the local STA and was received in correct
>>>> state."
>>>>
>>>> I very much want this to be true for IBSS modes. However, I cannot
>>>> seem to trace through the source code to confirm that this actually
>>>> happens. I can easily follow the code for the case when the interface
>>>> is in station mode but lose the trail for IBSS. 
>>>
>>> I'm afraid that isn't actually true for IBSS. The event you get there
>>> will be NL80211_CMD_NEW_STATION.
>>
>> Thank you for the sanity check! Do you think it's worthwhile to patch
>> the nl80211.h file to address this?
> 
> Yes, we should remove the IBSS text here :-)
> 
>>> I think in your case though, what you really want is a NL80211_CMD_FRAME
>>> event? You register for auth frames, also to prevent mac80211 from
>>> handling them itself, and then they get diverted to cfg80211_rx_mgmt()
>>> and on to nl80211_send_mgmt().
>>
>> Thanks for this, as well. As far as the patch that I submitted, you are
>> exactly correct. I was only investigating this other method since it
>> appears that's how wpa_supplicant claims to support IBSS RSN.
>> wpa_supplicant never actually registers for AUTH frames (through
>> NL80211_CMD_REGISTER) and relies solely on the NL80211_CMD_AUTHENTICATE
>> to actually receive copies of those frames.
> 
> Huh, now I'm confused, why would it need the authenticate frames for
> IBSS? As far as I can tell, it looks at CMD_NEW_STA, which calls
> nl80211_new_station_event(), 

This is what I understand as well.

which in IBSS sends EVENT_IBSS_RSN_START to
> the supplicant core -- that will trigger the 4-way-handshake. No? Hence
> it doesn't need to register for auth frames, it never needs them, since
> RSN uses open auth, if any is even used in IBSS at all.

This is where I am still trying to figure out exactly how it works.

No false modesty, but I'm sure you are correct and I was wrong. I've
only started to really dive into the wpa_supplicant stuff. Either way, I
will submit a patch for that documentation and continue my work :-)

Thanks again!
Will

> 
> johannes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

