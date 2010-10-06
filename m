Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55584 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933057Ab0JFTWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 15:22:15 -0400
Received: by iwn5 with SMTP id 5so10103803iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Oct 2010 12:22:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CACC92E.6090309@candelatech.com>
References: <4CACA3D7.90108@candelatech.com> <AANLkTimB7=odPK3qTAhFBdzaMFFGVar0kyMrb-p9SgYy@mail.gmail.com>
 <4CACC4B8.7040500@candelatech.com> <AANLkTi=k50=+9oZvXbHde8ZVV-uZk4MtpywmkHzKwWyE@mail.gmail.com>
 <4CACC92E.6090309@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 6 Oct 2010 12:21:52 -0700
Message-ID: <AANLkTinQxOTD8_HsQQQ6cTHgrtH3DZvV0L14zivFwRzx@mail.gmail.com>
Subject: Re: Any /n NICs that support APs and multiple STAs other than ath9k?
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 6, 2010 at 12:08 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 10/06/2010 11:58 AM, Luis R. Rodriguez wrote:
>>
>> On Wed, Oct 6, 2010 at 11:49 AM, Ben Greear<greearb@candelatech.com>
>>  wrote:
>>>
>>> On 10/06/2010 11:45 AM, Luis R. Rodriguez wrote:
>>>>
>>>> On Wed, Oct 6, 2010 at 9:29 AM, Ben Greear<greearb@candelatech.com>
>>>>  wrote:
>>>>>
>>>>> I would like to have a different hardware/driver combination to try
>>>>> to tie-break whether bugs are in mac80211 or in the ath9k
>>>>> driver/hardware.
>>>>>
>>>>> I don't mind doing a bit of driver hacking so long as the basic support
>>>>> is there (I think it's mostly the ability to set a BSSID mask and
>>>>> rxfilter
>>>>> accordingly).
>>>>
>>>> Your best bet is to test against mac80211_hwsim, that would rule out
>>>> any hardware. I think Jouni and Johannes have also a way to get the
>>>> devices to talk to each other. Perhaps some documentation of that on
>>>> the kernel Documentation/networking/mac80211_hwsim/
>>>
>>> Ok.  I'm trying to hack slub to give me a better stack trace of where
>>> the skb was deleted.  If that doesn't turn up anything obvious, then
>>> I'll go read up on hwsim.
>>>
>>> Are you aware of any DMA issues that might cause ath9k to write into
>>> places it should not?  Previously, I've seen a lot of errors in
>>> the logs about ath9k not being able to stop DMA in time, but I haven't
>>> seen those while reproducing the memory corruption.
>>
>> Yeah, well there have been a few bug reports but when we asked for
>> instructions how to reproduce we get nowhere. You are the first to
>> actually find some reproducible instructions. Forgive me but I haven't
>> had time yet to work on this though. Seems you have a good grasp of
>> things though and can easily reproduce so you likely are in a better
>> position right now to debug at the moment.
>
> My understanding is that the bad DMA access could
> corrupt things right out from under slub, and with no way for me
> to possibly add any debugging to catch it in action.
>
> I'm quite ignorant of hardware, DMA issues, etc, so if you have any
> ideas on how to go about verifying bad DMA writes or not, I'm
> interested.
>
> Otherwise, I'll basically have to check and double check to make sure
> we don't have a normal use-after-free with the skb, and if I can't find
> anything, just assert that it's DMA issues and pretty much give up until
> someone that understands that stuff has an idea to try.

You are able to reproduce easily so we should be able to now, we'll
get this bitch fixed.

  Luis
