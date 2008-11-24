Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:38347 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbYKXSjl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 13:39:41 -0500
Received: by ey-out-2122.google.com with SMTP id 6so871470eyi.37
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 10:39:39 -0800 (PST)
Message-ID: <492AF4EC.4060705@gmail.com> (sfid-20081124_193946_741722_BD0C7E37)
Date: Mon, 24 Nov 2008 13:39:40 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Michael Renzmann <mrenzmann@madwifi-project.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Fwd: please don't regress ath5k.h]
References: <492A14A7.4040808@gmail.com> <1205.94.79.146.217.1227505499.squirrel@webmail.madwifi.org> <1227507381.3599.55.camel@johannes.berg> <492AC870.3030103@gmail.com> <20081124182943.GA9790@jm.kir.nu>
In-Reply-To: <20081124182943.GA9790@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen wrote:
> On Mon, Nov 24, 2008 at 10:29:52AM -0500, Richard Farina wrote:
>
>   
>> I actually don't have a problem with removing chan_debug, I was merely  
>> requesting that the size hack it enables not be removed.
>>
>> More specifically in base.h I believe the code I specifically require is:
>>
>> #if CHAN_DEBUG
>> #define ATH_CHAN_MAX    (26+26+26+200+200)
>> #else
>> #define ATH_CHAN_MAX    (14+14+14+252+20)
>> #endif
>>
>>
>> When removing chan_debug just please leave the higher max.
>>     
>
> I would actually prefer to reduce this number _way_ down to something
> reasonable in the upstream kernel. ath5k should not really register more
> than channels 1-14 in 2.4 GHz and 5 GHz channels that are really used
> (i.e., only every fourth and only at ISM bands). The maximum number
> would be somewhere closer to 40 than 500..
>
> If you have a license to use other frequencies, you can take care of
> that with your own private patches, but the upstream kernel should not
> do that. Channels in 2.3 GHz or 2.5 GHz or many of the 5 GHz areas that
> are currently registered do not really belong here in the upstream
> kernel no matter what the hardware might be capable of doing.
>
>   
Your response to my request seems a bit flawed in my eyes.  Drivers are 
supposed to run the hardware, we have crda to handle limiting the device 
back to to what is legal in your area.  I'm sure there are places where 
it is legal to use 2192MHz and even if not, look at the driver, it has a 
max of 2732MHz set in the driver (for the .11b/g radio), clearly the 
person who wrote that agrees that drivers should support the hardware.

Honestly if you want to argue the legality I purposely posted an RFC for 
that, this change (and this email thread) is to stop a regression that 
would cause the hardware to no longer be fully and properly supported.

Yes, I can maintain my own personal patches to all of the drivers in the 
kernel (as a matter of fact I likely do) but this kind of thing belongs 
in the kernel, we are discussing hardware support, nothing more.  
Limiting the driver to enforce some random regulatory domain is 
pointless and against kernel policy as reg domain enforcement is 
supposed to be handled by crda or oldreg.

Thanks,
Rick
