Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:14696 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbYKXWVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 17:21:43 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1177120nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 14:21:41 -0800 (PST)
Message-ID: <492B28F5.5000708@gmail.com> (sfid-20081124_232148_463402_85B03929)
Date: Mon, 24 Nov 2008 17:21:41 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Jouni Malinen <j@w1.fi>, Johannes Berg <johannes@sipsolutions.net>,
	Michael Renzmann <mrenzmann@madwifi-project.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Fwd: please don't regress ath5k.h]
References: <492A14A7.4040808@gmail.com>	 <1205.94.79.146.217.1227505499.squirrel@webmail.madwifi.org>	 <1227507381.3599.55.camel@johannes.berg> <492AC870.3030103@gmail.com>	 <20081124182943.GA9790@jm.kir.nu> <492AF4EC.4060705@gmail.com> <43e72e890811241335j41515d9an701d76de011efdc8@mail.gmail.com>
In-Reply-To: <43e72e890811241335j41515d9an701d76de011efdc8@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Mon, Nov 24, 2008 at 10:39 AM, Richard Farina <sidhayn@gmail.com> wrote:
>   
>> Jouni Malinen wrote:
>>     
>>> On Mon, Nov 24, 2008 at 10:29:52AM -0500, Richard Farina wrote:
>>>
>>>
>>>       
>>>> I actually don't have a problem with removing chan_debug, I was merely
>>>>  requesting that the size hack it enables not be removed.
>>>>
>>>> More specifically in base.h I believe the code I specifically require is:
>>>>
>>>> #if CHAN_DEBUG
>>>> #define ATH_CHAN_MAX    (26+26+26+200+200)
>>>> #else
>>>> #define ATH_CHAN_MAX    (14+14+14+252+20)
>>>> #endif
>>>>
>>>>
>>>> When removing chan_debug just please leave the higher max.
>>>>
>>>>         
>>> I would actually prefer to reduce this number _way_ down to something
>>> reasonable in the upstream kernel. ath5k should not really register more
>>> than channels 1-14 in 2.4 GHz and 5 GHz channels that are really used
>>> (i.e., only every fourth and only at ISM bands). The maximum number
>>> would be somewhere closer to 40 than 500..
>>>
>>> If you have a license to use other frequencies, you can take care of
>>> that with your own private patches, but the upstream kernel should not
>>> do that. Channels in 2.3 GHz or 2.5 GHz or many of the 5 GHz areas that
>>> are currently registered do not really belong here in the upstream
>>> kernel no matter what the hardware might be capable of doing.
>>>
>>>
>>>       
>> Your response to my request seems a bit flawed in my eyes.  Drivers are
>> supposed to run the hardware, we have crda to handle limiting the device
>> back to to what is legal in your area.
>>     
>
> CRDA does indeed handle proper regulatory rules for a country however
> keep in mind drivers still need to use the data it is calibrated for.
> So although the radio can technically use certain frequency ranges you
> will find only find calibrated data for the device's targeted EEPROM
> settings and for its world roaming capabilities.
>
>   
Considering the fact that multiple companies sell Atheros wireless cards 
that support 4.9GHz and even down to 4.4GHz I'm going to guess that the 
hardware is capable just fine.  If it provides poor performance in 
testing then so be it, but right now, it looks pretty clean on the 
spectrum analyzer from where I was sitting the day I did my testing.
>>  I'm sure there are places where it
>> is legal to use 2192MHz and even if not, look at the driver, it has a max of
>> 2732MHz set in the driver (for the .11b/g radio), clearly the person who
>> wrote that agrees that drivers should support the hardware.
>>     
>
> Please send patches to the wireless regulatory database if such places
> do exist and please provide documentation of such findings:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-regdb.git
>
> Once we have listed a country with these settings then it makes sense
> to add it to the database and to the card's capabilities. Keep in mind
> that the EEPROM will always be respected though (patches pending).
>
>   
This seems kind of silly, I was purposely avoiding updating crda because 
I'm sure that if I do 99% of the people that use these frequencies will 
be breaking the law.  At your request, I will send my suggested change 
set to wireless-regdb.  I only know about the USA but I'm sure if I 
google hard enough I can expand it at a later time.
>> Honestly if you want to argue the legality I purposely posted an RFC for
>> that, this change (and this email thread) is to stop a regression that would
>> cause the hardware to no longer be fully and properly supported.
>>     
>
> This part is certainly important, and is greatly appreciated.
>
>   
>> Yes, I can maintain my own personal patches to all of the drivers in the
>> kernel (as a matter of fact I likely do) but this kind of thing belongs in
>> the kernel,
>>     
>
> What belongs in the kernel is driver components to make your 802.11
> work. The arguments used here are similar to that of disagreeing with
> easily allowing mac80211 to allow APs to operate without proper power
> save implementation.
>
>   
>> we are discussing hardware support, nothing more.
>>     
>
> Yes however the channels must be registered too and the EEPROM must be
> respected. More work on that area is in the right direction.
>
>   
I never said anything about hacking around the eeprom, nor did I even 
mention allowing people to tx on the channels I am adding.  Frankly I'd 
like to see half of what I do remain out of kernel because of the 
obvious problem of abuse, the changes I have outlined so far belong in 
the kernel to allow the hardware to operate to it's full extent.
>> Limiting the
>> driver to enforce some random regulatory domain is pointless and against
>> kernel policy as reg domain enforcement is supposed to be handled by crda or
>> oldreg.
>>     
>
> oldreg is just that -- old, and it will be removed. It was there to
> help with the migration and to account for the fact distributions may
> not have CRDA packaged yet. Drivers should register channels that make
> sense to support for 802.11, not every single channel a radio is
> capable of tuning into. If not you'd be seeing the channel list
> growing for other drivers  as well.
>
>   
Exactly why does 4400MHz not make sense to use 802.11 on in your 
opinion?  NATO disagrees as they have adopted equipment such as this:
http://www.belairnetworks.com/solutions/armed_forces.cfm

wireless-regdb update coming up next...

Thanks,
Rick Farina
>   Luis
>
>   

