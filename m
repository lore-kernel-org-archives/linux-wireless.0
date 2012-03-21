Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2844 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab2CURvc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2012 13:51:32 -0400
Message-ID: <4F6A1514.9090907@broadcom.com> (sfid-20120321_185136_378447_BD7EE90F)
Date: Wed, 21 Mar 2012 18:51:16 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Problems with regulatory domain support and BCM43224
References: <CAB=NE6VapPfLjAh5Y+sCA4qA82s9HrQk_Mxr8FpKoCfjudMDig@mail.gmail.com>
 <4B96CD77D9161244899852B5F20DB5B70125BB72@nasanexd02d.na.qualcomm.com>
 <CAB=NE6U04a0XNrvt6HLCwqbHMtGL8CWh8No_=Bx0mwQZYEgGxQ@mail.gmail.com>
 <4B96CD77D9161244899852B5F20DB5B70125BC94@nasanexd02d.na.qualcomm.com>
 <CAB=NE6X9c1m63xayNsEf9XZ3AgPZDV2SiRivg3SV2Day83fPQA@mail.gmail.com>
 <20120308200734.GC28133@ubuntu-macmini> <4F591E14.4010000@broadcom.com>
 <CAB=NE6XnorRDEu976uMkPFNKHQjhRT0Craf3ZjL9dYysPjmQng@mail.gmail.com>
 <20120320220706.GA17272@thinkpad-t410> <4F69B604.4030303@broadcom.com>
 <20120321141916.GA23643@thinkpad-t410>
In-Reply-To: <20120321141916.GA23643@thinkpad-t410>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/21/2012 03:19 PM, Seth Forshee wrote:
> On Wed, Mar 21, 2012 at 12:05:40PM +0100, Arend van Spriel wrote:
>> On 03/20/2012 11:07 PM, Seth Forshee wrote:
>>> On Thu, Mar 08, 2012 at 01:06:57PM -0800, Luis R. Rodriguez wrote:
>>>>> Hi, Seth
>>>>>
>>>>> Noticed your email yesterday, but did not get to chime into the
>>>>> conversation. brcmsmac does indeed provide a regulatory hint, which is
>>>>> either from SPROM or hard-coded to "US". Since "X0" is not a known
>>>>> regulatory domain for crda it does not make sense to pass it as a regulatory
>>>>> hint. However, the "full" story is told on linuxwireless.org (see [1]).
>>>>
>>>> The Linux kernel allows you to define custom regulatory domains, the
>>>> ath module uses these, it defines 13 of them. You can review that code
>>>> for an example of how to use them. So your X0 can still be used, you
>>>> just have to define the data structure.
>>>
>>> I took a shot at implementing custom regulatory domain support for
>>> brcmsmac. I've got it working to the point of letting me see APs on the
>>> DFS channels at least. The patch is below. A number of issues
>>> undoubtedly remain to be resolved. Some that I can think of:
>>
>> Hi Seth,
>>
>> Thanks for looking into this. I also did some tinkering over here,
>> but not sure which way to go here, ie. 1) define and use custom
>> regulatory domains, or 2) be happy with world regulatory domain as
>> is and do not pass the custom codes if found in sprom.
>
> For 2 I think you also have to set WIPGHY_FLAG_CUSTOM_REGULATORY or else
> the default world domain will still be applied. That certainly seems to
> be the quick-and-easy fix, but I'm not sure about what's preferable.
>
> However, I do think that passing up the custom codes as hints doesn't
> make sense, and the patch I sent only passes it up if it's not known to
> be one of the custom domains.

Ok. so the wiphy_apply_custom_regulatory() does not make the custom 
domains known by their code (.alpha2).

>>>   - I set up two custom domains, X0 and X2, which are identical. I'm not
>>>     sure precisely how each needs to be set up, but I took a reasonable
>>>     guess.
>>
>> There are 9 custom domains in the proprietary driver. X0 only allows
>> using channels 1-11. X2 allows 1-13. There are other parameters like
>> rates and txpower that may differ.
>
> That's the kind if information I would need to make this patch viable.
> I'll go ahead and update the patch to remove channels 12-13 from X0, and
> 14 from both. Are the 5 GHz rules correct?

5G channels are all considered passive by brcmsmac. Not sure whether 
that should be made explicit in the rules. Also the driver does not 
support IBSS so those flags are redundant now, but it is good to have it 
already in place.

> Are the custom domains named X[0-8]? If that's the case I can simplify
> some of the code.

Unfortunately, no.

>>>   - I tried to integrate with the existing X2 domain support, but this
>>>     could probably be improved. I avoided making large changes because
>>>     there's some complexity in the current code that doesn't seem to
>>>     serve a purpose currently, but I assume it's there for a reason.
>>
>> The code in channel.c was taken from our proprietary driver.
>> Basically, the LOCALES hold the same information as the rules in
>> regdomain.
>
> I assumed as much, but I haven't made much of an effort to understand it
> yet.
>
> But the complexity I'm referring to is really the infrastructure to
> support multiple locales and revisions that just isn't used right now. I
> can only assume that there are plans to use additional locales and
> revisions at some point.

Understood. The proprietary driver (which is not a mac80211 driver) 
supports a lot of locales, which are selected on country code and 
regulatory revision (both read from sprom). I suspect this is done to 
support the regulatory rules for which the device was certified. 
Revisiting channel.c is on our work list, but it would mean more moving 
toward using the regdomain approach you started on instead of locales.

>>>   - The flow of the initialization and organization of the code make it
>>>     necessary to search through the list of custom regulatory domains
>>>     many times. It would be nice to improve upon this.
>>>
>>> Does this look to be on the right track?
>>>
>>
>> Looks good. I will see if I can map the LOCALES for these to
>> regdomain rules.
>
> Great! Thanks for you comments.
>
> Seth
>

Gr. AvS

