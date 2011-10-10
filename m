Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:47960 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab1JJJN5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 05:13:57 -0400
Message-ID: <4E92B74F.9030901@neratec.com> (sfid-20111010_111557_159096_976E08A1)
Date: Mon, 10 Oct 2011 11:13:51 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 0/8] wireless: add DFS master support
References: <1317772067-6998-1-git-send-email-mcgrof@qca.qualcomm.com> <CAB=NE6V1gUSNc4L8sNv-NnDDVSzDB4A=cc_Z7tmZ79Q4LKtbwQ@mail.gmail.com> <CAB=NE6VxNKJPQPBbkn9ha1EC6dWawj96B6f-R1XREN1JAcrOQQ@mail.gmail.com> <CAB=NE6U6hFMBhgkjhpjpQk+FpMbDi4X6aW6i70MUWRH73K+AuQ@mail.gmail.com> <CAB=NE6Xz26oOudnyw17_1ijqe+L8qwQAGH8qjZEocgHQOY54eg@mail.gmail.com> <4E908C6D.7040703@neratec.com> <CAB=NE6UouofityugcjTvcXpBFx6cYEbAQ_FAe3gPO-GaS8Vh3w@mail.gmail.com>
In-Reply-To: <CAB=NE6UouofityugcjTvcXpBFx6cYEbAQ_FAe3gPO-GaS8Vh3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/08/2011 08:26 PM, Luis R. Rodriguez wrote:
> On Sat, Oct 8, 2011 at 10:46 AM, Zefir Kurtisi
> <zefir.kurtisi@neratec.com> wrote:
>> On 08.10.2011 00:32, Luis R. Rodriguez wrote:
>>>
>>> On Fri, Oct 7, 2011 at 3:29 PM, Luis R. Rodriguez
>>> <mcgrof@qca.qualcomm.com>  wrote:
>>>>
>>>> On Fri, Oct 7, 2011 at 2:11 PM, Luis R. Rodriguez
>>>> <mcgrof@qca.qualcomm.com>  wrote:
>>>>>
>>>>> On Tue, Oct 4, 2011 at 5:14 PM, Luis R. Rodriguez
>>>>> <mcgrof@qca.qualcomm.com>  wrote:
>>>>>>
>>>>>> On Tue, Oct 4, 2011 at 4:47 PM, Luis R. Rodriguez
>>>>>> <mcgrof@qca.qualcomm.com>  wrote:
>>>>>>>
>>>>>>> This set of 8 patches adds DFS master support to the Linux wireless
>>>>>>> subsystem.
>>>>>>> I've reviewed future possible changes to DFS master regions and it
>>>>>>> seems that
>>>>>>> we are not going to be having multiple DFS regions for one country,
>>>>>>> instead
>>>>>>> we'll always have one DFS region for one country.
>>>>>>>
>>>>>>> The changes here are spread out throughout wireless-regdb, crda the
>>>>>>> kernel and
>>>>>>> lastly iw. The changes made allow for older verions of CRDA to work
>>>>>>> with new
>>>>>>> wireless-regdb files with DFS region support. If you want DFS master
>>>>>>> region
>>>>>>> support you'll need to upgrade your CRDA, your kernel and then hope
>>>>>>> someone
>>>>>>> implements DFS master support for your respective driver.
>>>>>>>
>>>>>>> This patch series does not have specific driver changes, although some
>>>>>>> seem to
>>>>>>> be backing in the oven right now.
>>>>>>
>>>>>> Here's a puzzle though... If we change this series to use the other
>>>>>> pad byte that was available, the first pad byte, instead of the last
>>>>>> one, we loose backward compatibility support and I cannot figure out
>>>>>> why. What I ended up seeing was that crda sends the message, and for
>>>>>> some reason (return code is 222 from nl_wait_for_ack(), whatever that
>>>>>> is) the kernel rejects it. I suspect it may have to do with some sort
>>>>>> of offset to the *other* data that makes some of the rules output
>>>>>> invalid data for the attribute policy, but at least when I hexdump the
>>>>>> wireless-regdb the only changes I see are in the signature and the pad
>>>>>> shift.
>>>>>>
>>>>>> I got tired of trying though and after seeing flipping the pad bytes
>>>>>> things worked decided to stay with it. In my original RFC in December
>>>>>> I had used u16 instead, but since the data was in the last pad byte
>>>>>> things still worked. So something is fishy about only using the first
>>>>>> pad byte. The change below, as far as I can tell, should not have any
>>>>>> issues but it does with the older version of CRDA and even a new one.
>>>>>
>>>>> Johannes spotted the issue, I'll send the fix, thanks to Johannes.
>>>>> John, Johannes the patches still apply my fix goes on top of these
>>>>> changes, the fix is not addressing a regression introduced by this
>>>>> patchset, instead it fixes a long standing issue which would prevent
>>>>> us from using the next available pad byte.
>>>>
>>>> I'm going to respin this to make use of 2 bits:
>>>>
>>>> 00 unset
>>>> 01 FCC
>>>> 10 ETSI
>>>> 11 JP
>>>>
>>>> We may need some more DFS values later but
>>>
>>> Sorry I did not finish this e-mail I meant that we may later have a
>>> requirement for more DFS values but at this time we don't, we should
>>> consider whether or not we will want to leave more bits for usage of
>>> more DFS values and if so how many? Using two bits will give us
>>> support for what we know today but nothing for the future.
>>>
>> For the future things we do not know of today we should add another bit and
>> define
>>
>> 111 unknown / other
>>
>> to be able to mark special countrycodes that do not fully belong to the
>> three known domains.
> 
> I thought about this a bit more, so we'd have to define this as a U8
> attribute either way, so I would instead of calling NL80211_DFS_REGION
> call it something like NL80211_CTRY_REQS and for now only use 2 bits
> for the known DFS regions. We'd mask out the rest of the values. If we
> ever decide we need a new DFS region we could just extend the values
> on NL80211_CTRY_REQS after the last region. If we want to add a new
> requirement that is country specific other than DFS we could start at
> the end of the u8 instead of after the last DFS region. We could do
> this without making any explicit reservations.
> 
>> We could use some invalid coding for those CCs (like no
>> DFS domain set in CC
> 
> Sure, I should point out today every single regulatory domain will
> have this set except US, only because I added a patch to match US to
> DFS-FCC DFS region.
> 
>> but flag set for frequency band) to identify those
>> special domains,
> 
> So you're saying in case later we find out we need band specific DFS data later?
> 
No, I guess I initially misinterpreted the meaning of '00 unset' as a flag for countrycodes not restricted by DFS at all, but in fact this is done by not setting the per-band DFS flags.

So, if we consider the per-country DFS domain as an enabler for DFS support on top of per-band DFS restrictions (that otherwise remain disabled), we can support 'fancy' CCs by not setting the domain. The concern I brought up is therefore void.

WRT band specific DFS data, we agreed that this will break backwards compatibility and therefore needs some detailed planning. Adrian already brought up some issues we will face and why he is using per-band (or even per-channel) DFS properties.

I opt for keeping this proposed per-country DFS domain scheme until we get DFS fully working and find its limitations significant enough to start a major revision.

>> but using an additional bit would make things easier to
>> handle.
> 
> We can extend this as we go, and just ensure upon review of new code
> that we accommodate non -DFS crap at the end of the u8. Whatdya think?
> 
>   Luis

Zefir
