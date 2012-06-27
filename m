Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:46869 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755760Ab2F0N3m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 09:29:42 -0400
Received: by qafl39 with SMTP id l39so918829qaf.16
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 06:29:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE9FD77.7050807@broadcom.com>
References: <4FE8CF77.5080400@broadcom.com>
	<CAC83ZvL2ozQD1DYmtKeFa1PB1pZ1JmBUKFWmDWnbJOCDL3sKNg@mail.gmail.com>
	<4FE9FD77.7050807@broadcom.com>
Date: Wed, 27 Jun 2012 18:59:40 +0530
Message-ID: <CAC83ZvK_ve-d8jZo9mOQ5aidYxFV5r1FUbTqEC3LxvkikOoFHg@mail.gmail.com> (sfid-20120627_152948_589983_3E17553C)
Subject: Re: Panda ES board hang when using GPIO as interrupt
From: "DebBarma, Tarun Kanti" <tarun.kanti@ti.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: khilman@ti.com, tony@atomide.com, santosh.shilimkar@ti.com,
	b-cousson@ti.com, grant.likely@secretlab.ca,
	linux-omap@vger.kernel.org,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 26, 2012 at 11:50 PM, Franky Lin <frankyl@broadcom.com> wrote:
> On 06/26/2012 12:21 AM, DebBarma, Tarun Kanti wrote:
>>
>> On Tue, Jun 26, 2012 at 2:22 AM, Franky Lin <frankyl@broadcom.com> wrote:
>>>
>>> Hi Kevin, Tarun,
>>>
>>> We are using the expansion connector A on Panda board to mount a SDIO
>>> WiFi
>>> dongle on MMC2 with a level triggered interrupt signal connected to GPIO
>>> 138. It's been working fine until 3.5 rc1. The board hang randomly within
>>> 5
>>> mins during a network traffic test. After bisecting we found the culprit
>>> is
>>> "[PATCH 8/8] gpio/omap: fix missing check in *_runtime_suspend()" [1].
>>>
>>> I noticed Kevin raised some similar cases on other platforms and also
>>> provided two patches in the patch mail thread. But unfortunately those
>>> two
>>> patches doesn't help in our case. I tested the driver with 3.5-rc3
>>> mainline
>>> kernel and the issue is still there. I can only "fix" the hang by either
>>> reverting the commit or disabling CONFIG_PM_RUNTIME. Also, the hang only
>>> happens on Panda ES board. Old Panda with 4430 works good.
>>>
>>> Any thoughts and suggestions?
>>
>> I just had a quick look at the code. Can you please check if the
>> attached patch solves
>> the issue? I just boot tested on Panda and Blaze.
>> --
>> Tarun
>>
>
> Thanks for the prompt reply.
>
> Booting is fine even without the patch and revert. The wifi dongle generates
> interrupt whenever there is data packet available for host to read. So
> during a traffic test a significant numbers of interrupt will be triggered
> through the GPIO. So I assume it has something to do with the interrupt
> GPIO.
>
> With the patch, the kernel still crashes. But the symptom is slightly
> different. Now it has a panic log every time. See attachment.
I tried comparing the present code with older version with regard
to enabled_non_wakeup_gpios check. The obvious difference I
observed is that this check is performed after off-mode check,
unlike the present case where the check is done just prior to
off-mode check. But then, as Kevin pointed out, we need to understand
the exact problem. I am trying to have a setup to reproduce the
problem. BTW, you can ignore my patch because I realized that
saved_datain is part of the workaround.
---
Tarun

>
> Regards,
> Franky
