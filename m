Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:32856 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751717AbdBSVXD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 19 Feb 2017 16:23:03 -0500
Received: by mail-oi0-f66.google.com with SMTP id 2so1232590oif.0
        for <linux-wireless@vger.kernel.org>; Sun, 19 Feb 2017 13:23:03 -0800 (PST)
Subject: Re: [PATCH] Fix rtl8187 multicast reception
To: Nils Holland <nholland@tisys.org>
References: <20170219013520.GA3190@tisys.org>
 <2eb1dd33-4d71-86b7-c579-412419e2a2e5@lwfinger.net>
 <87lgt28vxz.fsf@purkki.adurom.net> <20170219094138.GA3228@tisys.org>
 <87y3x22tsn.fsf@codeaurora.org>
 <65e6d653-b1e8-e9f7-ce18-210ae1b3ee63@lwfinger.net>
 <20170219185332.GA7643@tisys.org>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <1ef4181b-66bf-6e0c-2938-566aeb41bb28@lwfinger.net> (sfid-20170219_222309_597827_21BF30F9)
Date: Sun, 19 Feb 2017 15:23:01 -0600
MIME-Version: 1.0
In-Reply-To: <20170219185332.GA7643@tisys.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/19/2017 12:53 PM, Nils Holland wrote:
> On Sun, Feb 19, 2017 at 12:11:50PM -0600, Larry Finger wrote:
>> On 02/19/2017 07:29 AM, Kalle Valo wrote:
>>> Nils Holland <nholland@tisys.org> writes:
>>>
>>>> On Sun, Feb 19, 2017 at 09:46:16AM +0200, Kalle Valo wrote:
>>>>> Larry Finger <Larry.Finger@lwfinger.net> writes:
>>>>>
>>>>>> On 02/18/2017 07:35 PM, Nils Holland wrote:
>>>>>>
>>>>>> I would prefer a module parameter that would allow this change to be
>>>>>> implemented only if the user takes special action. I suspect that you
>>>>>> will have no difficulty preparing such a change. If that is not true,
>>>>>> I would be happy to help.
>>>>>
>>>>> I understand why you prefer having a module parameter but the thing is
>>>>> that being able to receive multicast frames is really basic
>>>>> functionality. We should not hide it under a module parameter.
>>>>
>>>> Well, this is a tough question, I have to admit that I have a somewhat
>>>> weird feeling making a change that also applies to other hardware that
>>>> I cannot test on, so I don't know about any negative consequences that
>>>> might arise there, especially when the change isn't based on some
>>>> official information from some documentation, but rather a result of
>>>> trial & error. So I can fully understand Larry's concerns and do in
>>>> fact think that a module parameter could be a nice solution, so that
>>>> by default the behavior if the driver does not change.
>>>
>>> There are lots of hardware variations that cannot be tested when a patch
>>> is commited. If we followed the same methdology with all patches we
>>> would have thousands of module parameters in kernel in no time :)
>>>
>>>> From an end-user standpoint, it's probably always worse to see
>>>> something break which has always worked before than it is to have
>>>> something not work properly right from the start, but being able to
>>>> easily find some parameter to fix this.
>>>
>>> Sure. But if there's a report about this patch breaking something, it's
>>> easy to revert it.
>>>
>>>> On the other hand, use of this particular USB wifi card is probably
>>>> not so common these days so relatively few people would notice at all.
>>>> Tough! I guess I'll submit a module parameter based v2 of the patch
>>>> later today, just as Larry suggested!
>>>
>>> Also remember to add a prefix to the title:
>>>
>>> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#subject
>>>
>>>>> Isn't there any other option, for example does anyone have hw to test
>>>>> this with other hw? (what exactly?) Or maybe we just take the risk and
>>>>> take it as is and revert if problems arise?
>>>>
>>>> Of course, if someone has other hw, more testing would be nice! Any
>>>> situation where the card is supposed to receive multicast frames
>>>> should be suitable as a test case - in my case, just connecting to my
>>>> local network and expecting to see the card pick up RAs and acquire an
>>>> IPv6 address is the easiest test case. This works nicely on several
>>>> other machines with completely different wifi hardware as well as
>>>> wired machines, but fails without the fix on the rtl8187b. It would,
>>>> for example, be interesting to see if a non-b 8187 behaves the same or
>>>> if things work there out of the box.
>>>
>>> I'm not familiar with the driver so when you say "non-b 8187" what do
>>> you mean exactly? What kind of hardware are we talking about? How many
>>> different hardware versions are there that this patch affects? Is the
>>> firmware/hardware really so different that the chances are high that
>>> this breaks something?
>>>
>>>> In that case, instead of doing a module parameter, I could also change
>>>> the fix so that it only does something different on the b-variants of
>>>> the card and doesn't change behavior at all on non-b.
>>>
>>> Now that's much better option than adding a module parameter.
>>
>> There are three variants of the chip, the RTL8187, RTL8187L, and RTL8187B.
>> Programming for the first two are the same. The RTL8187B has a number of newer
>> features such as priority queues and a more complete set of parameters in the
>> descriptors.
>>
>> OK, for the moment I agree to this patch with a respin of the commit message. I
>> will test with my 8187L device. If those fail, I will request that it be limited
>> to the 8187B.
>
> Sounds good, so I guess I'll wait for your report regarding behavior
> on your 8187l. Then, I'll either re-submit the patch as a v2 with a
> reworked commit message and proper tag in the title, or, if the fix
> as-is causes problems on the 8187l, re-submit the patch with limiting
> the scope of its change to the 8187b only. Sounds good? :-)

The 8187L is working as expected. The only downside of your patch is that the 
NIC is put into monitor mode silently, which is probably a security hole. As 
Kalle is opposed to a module parameter, then I guess that is an acceptable risk. 
Go ahead with V2 with the revised tag and commit message.

Larry
