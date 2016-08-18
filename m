Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:33078 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754897AbcHSB3u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Aug 2016 21:29:50 -0400
Received: by mail-qt0-f173.google.com with SMTP id w38so5068625qtb.0
        for <linux-wireless@vger.kernel.org>; Thu, 18 Aug 2016 18:28:38 -0700 (PDT)
Subject: Re: [PATCH] mwifiex: propagate error if IRQ request fails in
 mwifiex_sdio_of()
To: Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-kernel@vger.kernel.org
References: <1471529868-13669-1-git-send-email-javier@osg.samsung.com>
 <10fb1110-4c0b-00a2-522c-7011ca397b8c@broadcom.com>
 <70b6a0d1-8cc4-280e-3e53-8c42cb43b721@osg.samsung.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <866da517-4b5c-492e-56d0-260afeb55ded@broadcom.com> (sfid-20160819_033047_150919_AB40E98E)
Date: Thu, 18 Aug 2016 21:49:09 +0200
MIME-Version: 1.0
In-Reply-To: <70b6a0d1-8cc4-280e-3e53-8c42cb43b721@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 18-08-16 21:29, Javier Martinez Canillas wrote:
> Hello Arend,
> 
> Thanks a lot for your feedback.
> 
> On 08/18/2016 03:14 PM, Arend van Spriel wrote:
>> On 18-08-16 16:17, Javier Martinez Canillas wrote:
>>> If request_irq() fails in mwifiex_sdio_probe_of(), only an error message
>>> is printed but the actual error is not propagated to the caller function.
>>
>> Hmm. The caller function, ie. mwifiex_sdio_probe(), does not seem to care.
>>
> 
> Hmm, I'm not so sure about that. It's checking the wifiex_sdio_probe_of()
> return value.

Ok. I looked at 4.7 sources on lxr [1].

> If the IRQ request failing is not an error, then at the very least the call
> to disable_irq() should be avoided if request_irq() fails, and the message
> should be changed from dev_err() to dev_dgb() or dev_info().

agree.

>> The device may still function without this wake interrupt.
>>
> 
> That's correct, the binding says that the "interrupts" property in the child
> node is optional since is just a wakeup IRQ. Now the question is if should
> be an error if the IRQ is defined but fails to be requested.

Clearly it indicates an error in the DT specification so behavior is not
as expected. Personally I would indeed consider it an error, but I was
just indicating that it might have done like this intentionally.

Regards,
Arend

[1]
http://lxr.free-electrons.com/source/drivers/net/wireless/marvell/mwifiex/sdio.c#L192

>> Regards,
>> Arend
>>
> 
> Best regards,
> 
