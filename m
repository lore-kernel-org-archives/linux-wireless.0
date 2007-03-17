Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:48480 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbXCQPfh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 11:35:37 -0400
Message-ID: <45FC0AC7.4030504@warmcat.com>
Date: Sat, 17 Mar 2007 15:35:35 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: Monitor mode radiotap-based packet injection
References: <20070317105800.659633351@warmcat.com> <200703171459.23246.mb@bu3sch.de> <45FC0205.2020409@warmcat.com> <200703171606.58803.mb@bu3sch.de>
In-Reply-To: <200703171606.58803.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Saturday 17 March 2007 15:58, Andy Green wrote:
>> Michael Buesch wrote:
>>
>>>> +#define IEEE80211_TXCTL_INJECTED_PACKET (1<<10) /* tx into monitor IF */
>>> What is a driver supposed to do on this flag? More documentation, please.
>> Hi Michael -
>>
>> The driver doesn't have to do anything with that flag... it's a private 
>> mac80211-internal flag to get the attribute that the packet was injected 
> 
>> If there's a simpler way I'm happy to use it.
> 
> Ok, no. I'm fine with this. But please mark it as mac80211-internal
> flag, so driver authors don't waste time on thinking about wtf this is. ;)
> Either by documenting it in a comment or by doing a special define
> (two underscores or something). Or both.

Both sounds like a good idea, thanks: I will wait a bit for any more 
comments and then add this to a try #3.  I noticed Michael Wu set his 
flag to 1<<20 and I guess he had this in mind, so I will change mine to 
1<<21 to further distance it from the other flags in bits and in meaning.

-Andy



