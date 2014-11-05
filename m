Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:47134 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbaKEJIP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 04:08:15 -0500
Received: by mail-wg0-f47.google.com with SMTP id a1so367811wgh.20
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2014 01:08:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54523557.1030908@neratec.com>
References: <CAOtFK_Ue0xjEaYY3qm0n2Tj=Hnu1dbphupmdZmiouVuGLnktoA@mail.gmail.com>
 <544E21D4.9020401@neratec.com> <CAOtFK_XWgBxPNy77XVDc1XbYUkdPSd-Q9wmREN2iL6A8bzFDoQ@mail.gmail.com>
 <544E5BCF.6000703@neratec.com> <CAOtFK_VG0Z3EkAfYNjiQGdcUp03Pa2SMP+-6cfdJMMT8Rg4Y6A@mail.gmail.com>
 <54523557.1030908@neratec.com>
From: Adrien Decostre <ad.decostre@gmail.com>
Date: Wed, 5 Nov 2014 10:07:33 +0100
Message-ID: <CAOtFK_UNewJHRrLNG6cLsgXDE5P0mgUWvwJj_8MvvNGb0cMEAQ@mail.gmail.com> (sfid-20141105_100826_709283_90BFE678)
Subject: Re: Questions regarding ath9k and new EN 300 328 regulation
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Zefir,

Thanks a lot for this last precision.
It is now clear to me that the adaptivity mechanism required by EN 300
328 v1.8.1 is handled by the CCA algorithm.

Best regards

Adrien

On Thu, Oct 30, 2014 at 1:55 PM, Zefir Kurtisi
<zefir.kurtisi@neratec.com> wrote:
> As written before, you need to look at DFS and adaptivity as two independent
> mechanisms.
>
> You can disable support for DFS channels in the driver anytime by not setting the
> required configuration options. As a result, you won't be able to operate actively
> on a DFS channel (monitor mode should still work).
>
> Adaptivity you could start playing without DFS (it is anyway not limited to DFS
> channels). At a later stage a working adaptivity module might provide
> meta-information helpful to improve DFS processing / management (like: ah, there
> is a master already using DFS channel X - assuming that one did a CAC already,
> there should be no radar device around). The certification requirements leave
> enough room for interpreting those supplemental results in one way or another.
>
>
> Cheers,
> Zefir
>
> On 10/27/2014 07:23 PM, Adrien Decostre wrote:
>> Dear Zefir,
>>
>> Thanks a lot for these precisions, This makes thing more clear.
>>
>> There is still one thing unclear to me. If we do not consider working
>> on the DFS channels and that we only want to operate on channels 36,
>> 40, 44 and 48 in EU. Do we still need to enable DFS flags in ath9k to
>> comply with EN 300 328 v1.8.1. I mean, is the same pulse detector
>> algorithm used for DFS and for the adaptivity tests on channels 36 to
>> 48?
>>
>> Many thanks in advance for your answer.
>>
>> Best regards
>>
>> Adrien
>>
>>
>> On Mon, Oct 27, 2014 at 3:50 PM, Zefir Kurtisi
>> <zefir.kurtisi@neratec.com> wrote:
>>> On 10/27/2014 03:18 PM, Adrien Decostre wrote:
>>>> Hello Zefir,
>>>>
>>>> Thanks a lot for your answer. This helps me a lot.
>>>> If I correctly understand, the ability of ath9k to detect all pulses
>>>> may also depend of the platform performances. So on an embedded
>>>> platform with limited performances, we may observe more pulses losses
>>>> than on a more powerful platform. Is this a right statement?
>>>>
>>> No, there is no bottleneck in the platform performance. Presumed radar pulses are
>>> reported as RX_ERROR descriptors and even lower end embedded systems are able to
>>> handle the load. What makes the difference with the minimum pulse width is the
>>> chip DFS engine's ability to isolate and identify very short spikes as potential
>>> radar pulses.
>>>
>>> This goes very deeply into material I had available under NDA while implementing
>>> the DFS support for ath9k. If you intend to work on that topic, I encourage you to
>>> contact the folks at QCA and join their 'NDA for Developers' program. The document
>>> you want to read is 'Baseband DFS 2 (Radar) Micro-Architecture'.
>>>
>>>> What about the CONFIG_ATH9K_DFS_CERTIFIED build options? Do we need it
>>>> to enable the detection of 0.5usec. pulses?
>>>>
>>> Yes, this driver specific flag (also available for 10k) you need to set to get the
>>> DFS detector built (not related to pulse width). It essentially shifts the
>>> responsibility of the product working in restricted bands to you / the manufacturer.
>>>
>>>
>>>> Thanks in advance for your answer.
>>>>
>>>> Best regards
>>>>
>>>> Adrien
>>>>
>>>
>>> Good Luck,
>>> Zefir
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
