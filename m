Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:38151 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbYKXP3y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 10:29:54 -0500
Received: by ug-out-1314.google.com with SMTP id 39so774020ugf.37
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 07:29:52 -0800 (PST)
Message-ID: <492AC870.3030103@gmail.com> (sfid-20081124_162958_727157_0E91F357)
Date: Mon, 24 Nov 2008 10:29:52 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michael Renzmann <mrenzmann@madwifi-project.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Fwd: please don't regress ath5k.h]
References: <492A14A7.4040808@gmail.com>	 <1205.94.79.146.217.1227505499.squirrel@webmail.madwifi.org>	 (sfid-20081124_071514_224762_60872498) <1227507381.3599.55.camel@johannes.berg>
In-Reply-To: <1227507381.3599.55.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2008-11-24 at 06:44 +0100, Michael Renzmann wrote:
>   
>> Hi.
>>
>> Richard Farina wrote:
>>     
>>> I recently saw this additional comment added to wireless-testing.git and
>>> it has me a bit concerned.  I use this feature for a specific patch set
>>> that I maintain and it would break it pretty bad to remove this.
>>>       
>> Just an idea: what prevents you to add a patch to that patchset that
>> reenables the amount of code you require from the CHAN_DEBUG stuff should
>> it be removed upstream?
>>     
>
> Seconded, upstream should remove all the junk that it doesn't directly
> need.
>
> johannes
>   
I actually don't have a problem with removing chan_debug, I was merely 
requesting that the size hack it enables not be removed.

More specifically in base.h I believe the code I specifically require is:

#if CHAN_DEBUG
#define ATH_CHAN_MAX    (26+26+26+200+200)
#else
#define ATH_CHAN_MAX    (14+14+14+252+20)
#endif


When removing chan_debug just please leave the higher max.  To be honest 
I don't know for sure what this code means but since enabling it fixes 
my patch it is clearly required.  There is no reason to be removing this 
as I am hoping to push a few patches upstream to properly support the 
capabilities of the hardware.

Thanks,
Rick
