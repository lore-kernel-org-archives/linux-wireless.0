Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw1-f53.google.com ([209.85.161.53]:41823 "EHLO
        mail-yw1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbeHJORP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Aug 2018 10:17:15 -0400
Received: by mail-yw1-f53.google.com with SMTP id q129-v6so8337754ywg.8
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2018 04:47:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180810111425.GA16269@redhat.com>
References: <CAAemcoMYY7utGrrR+8JLPPzQ-YTKsrD=6DZigJ+o9A+72s7CxQ@mail.gmail.com>
 <20180809111049.GC1955@redhat.com> <CAAemcoOkA4y7zDMCKzD+nKJAQFoWCGPVHdbEV0j9ZOeaCe144g@mail.gmail.com>
 <20180810111425.GA16269@redhat.com>
From: Randy Oostdyk <linux-kernel@oostdyk.com>
Date: Fri, 10 Aug 2018 05:47:39 -0600
Message-ID: <CAAemcoM6u9103BDxVdqAE2-bZ-KFhhKK+1Lf72KRw8P0RAVtTQ@mail.gmail.com> (sfid-20180810_134743_522405_F176A10B)
Subject: Re: wireless dongle causing entire machine to hang
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's indeed possible that the cause was faulty or out-of-spec HW. I'm
confident the machine hung (soft lock?) due to log spam, because upon
reboot, log files were several GB each, covering the time period I was
unable to connect to it.

Thanks for the patch. I'll try to test it with my previous HW setup,
and let you know how it goes. It might take a few weeks, due to the
intermittent nature of the USB problem that triggered it.

On Fri, Aug 10, 2018 at 5:14 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Thu, Aug 09, 2018 at 12:49:58PM -0600, Randy Oostdyk wrote:
>> On Thu, Aug 9, 2018 at 5:10 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> > I'm reluctant to replace _warn by _dbg messages as if somethings
>> > will go wrong we will not notice that. We can use printk_ratelimited()
>> > variant instead to do not spam log in speed that it will hung
>> > the machine. But the correct fix should be in USB host drivers,
>> > which seems to be not in perfect shape on those embedded platforms.
>>
>> Agreed about the "correct" fix likely being on the USB side, but at
>> least using printk_ratelimited() will avoid the log spamming, and
>> avoid locking the machine, as you said.
>>
>> Will someone else take that approach and come up with a patch, or is
>> this something I should try to take on myself? I could certainly test
>> such a patch, if desired.
>>
>> Meanwhile, I'll look into reporting the USB bug, if it hasn't already been.
>
> I'm attaching the ratelimit patch for test.
>
> However after reading email from Larry I withdraw blaming USB host
> driver. The issue could be faulty HW and USB host driver can not do
> much much about this.
>
> Another question is if machine hung due to log spam or because there
> was some crash. Those error conditions trigger code paths that are
> not usually used, so there could be some oops that hung the system.
>
> Anyway you can test the patch and report back.
>
> Cheers
> Stanislaw
