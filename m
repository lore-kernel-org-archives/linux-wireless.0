Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40609
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753820AbcHSCWc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Aug 2016 22:22:32 -0400
Subject: Re: [PATCH] mwifiex: propagate error if IRQ request fails in
 mwifiex_sdio_of()
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-kernel@vger.kernel.org
References: <1471529868-13669-1-git-send-email-javier@osg.samsung.com>
 <10fb1110-4c0b-00a2-522c-7011ca397b8c@broadcom.com>
 <70b6a0d1-8cc4-280e-3e53-8c42cb43b721@osg.samsung.com>
 <866da517-4b5c-492e-56d0-260afeb55ded@broadcom.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <33686ef5-14d9-5e9c-bd3a-aaab0356ad83@osg.samsung.com> (sfid-20160819_042435_215018_6CEF2A86)
Date: Thu, 18 Aug 2016 16:23:30 -0400
MIME-Version: 1.0
In-Reply-To: <866da517-4b5c-492e-56d0-260afeb55ded@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Arend,

On 08/18/2016 03:49 PM, Arend van Spriel wrote:
> 
> 
> On 18-08-16 21:29, Javier Martinez Canillas wrote:
>> Hello Arend,
>>
>> Thanks a lot for your feedback.
>>
>> On 08/18/2016 03:14 PM, Arend van Spriel wrote:
>>> On 18-08-16 16:17, Javier Martinez Canillas wrote:
>>>> If request_irq() fails in mwifiex_sdio_probe_of(), only an error message
>>>> is printed but the actual error is not propagated to the caller function.
>>>
>>> Hmm. The caller function, ie. mwifiex_sdio_probe(), does not seem to care.
>>>
>>
>> Hmm, I'm not so sure about that. It's checking the wifiex_sdio_probe_of()
>> return value.
> 
> Ok. I looked at 4.7 sources on lxr [1].
>

Oh, right. That was fixed quite recently indeed.
 
>> If the IRQ request failing is not an error, then at the very least the call
>> to disable_irq() should be avoided if request_irq() fails, and the message
>> should be changed from dev_err() to dev_dgb() or dev_info().
> 
> agree.
> 
>>> The device may still function without this wake interrupt.
>>>
>>
>> That's correct, the binding says that the "interrupts" property in the child
>> node is optional since is just a wakeup IRQ. Now the question is if should
>> be an error if the IRQ is defined but fails to be requested.
> 
> Clearly it indicates an error in the DT specification so behavior is not
> as expected. Personally I would indeed consider it an error, but I was
> just indicating that it might have done like this intentionally.
>

Yes, might had been done intentionally indeed but I don't think that is
the case since the driver lacked error checking and propagation in many
places. But if someone thinks that's better to not honor the DT and at
least have the driver working without the wake up capability, then I'm
happy to respin the patch and change the print log level to info/debug.
 
> Regards,
> Arend
> 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
