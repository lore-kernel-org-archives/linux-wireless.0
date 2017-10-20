Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41768 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751772AbdJTGfl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Oct 2017 02:35:41 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: Marc MERLIN <marc@merlins.org>, linux-wireless@vger.kernel.org,
        linuxwifi@intel.com
Subject: Re: After upgrading to 4.11.1, wifi driver refuses to load after being unloaded once.
References: <20170526024826.3qjx7pe3kz44klk3@merlins.org>
        <1496396575.9478.54.camel@coelho.fi>
        <20170603165950.GC29546@merlins.org>
        <20170816233844.qtigfurckdr44awa@merlins.org>
        <20171017094440.25tpkoeyfm6q2lqw@merlins.org>
        <1508249157.5497.103.camel@coelho.fi>
        <20171017212319.eranorcigrmgcpyo@merlins.org>
        <1508276099.5497.122.camel@coelho.fi>
        <87infduk4b.fsf@purkki.adurom.net>
        <1508307368.5497.125.camel@coelho.fi>
        <87bml4iy40.fsf@kamboji.qca.qualcomm.com>
        <1508322176.5497.152.camel@coelho.fi>
Date: Fri, 20 Oct 2017 09:35:37 +0300
In-Reply-To: <1508322176.5497.152.camel@coelho.fi> (Luca Coelho's message of
        "Wed, 18 Oct 2017 13:22:56 +0300")
Message-ID: <8760bafhs6.fsf@kamboji.qca.qualcomm.com> (sfid-20171020_083555_586612_E9917D99)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> On Wed, 2017-10-18 at 12:50 +0300, Kalle Valo wrote:
>> Luca Coelho <luca@coelho.fi> writes:
>> 
>> > On Wed, 2017-10-18 at 07:59 +0300, Kalle Valo wrote:
>> > > Luca Coelho <luca@coelho.fi> writes:
>> > > 
>> > > > On Tue, 2017-10-17 at 14:23 -0700, Marc MERLIN wrote:
>> > > > 
>> > > > > I don't know how or why, but I seem to:
>> > > > > saruman:~# grep IWLWIFI /boot/config-4.12.10-amd64-preempt-
>> > > > > sysrq-
>> > > > > 20170406 
>> > > > > CONFIG_IWLWIFI=m
>> > > > > CONFIG_IWLWIFI_LEDS=y
>> > > > > CONFIG_IWLWIFI_OPMODE_MODULAR=y
>> > > > > # CONFIG_IWLWIFI_BCAST_FILTERING is not set
>> > > > > CONFIG_IWLWIFI_PCIE_RTPM=y
>> > > > > CONFIG_IWLWIFI_DEBUG=y
>> > > > > CONFIG_IWLWIFI_DEVICE_TRACING=y
>> > > > > 
>> > > > > I'll remove that, thanks.
>> > > > 
>> > > > Cool, I think that might help.  If it doesn't, please report a
>> > > > bug
>> > > > in
>> > > > buzilla. ;)
>> > > 
>> > > But a Kconfig option should never break functionality, so IMHO
>> > > this
>> > > still sounds like a bug in iwlwifi.
>> > 
>> > The problem is that to get this to work, some changes need to be
>> > made
>> > in the platform side.  In this case, the rootport is not configured
>> > properly so it won't work.
>> 
>> Yeah, but users or distros might accidentally enable this Kconfig
>> option and break the driver unintentionally. And subtle bugs like
>> this
>> are even worse as the user will not realise that it's because of a
>> new
>> Kconfig option.
>> 
>> So I guess you can't automatically detect it the platform supports
>> RTPM,
>> right? Maybe there should be a module parameter which has to be set
>> to
>> enable this? And at least a big fat warning to the user that RTPM is
>> enabled, bugs are likely and the user has to know what she's doing.
>
> I thought this was what EXPERT was used for:
>
> menuconfig EXPERT
>         bool "Configure standard kernel features (expert users)"
>         # Unhide debug options, to make the on-by-default options visible
>         select DEBUG_KERNEL
>         help
>           This option allows certain base kernel options and settings
>           to be disabled or tweaked. This is for specialized
>           environments which can tolerate a "non-standard" kernel.
>           Only use this if you really know what you are doing.
>
>
> But it seems that it's widely used even by people/distros who don't
> know what they are doing. :(

Yeah, people seem to just blindly enable kconfig options. I don't blame
them, there are so many options and difficult to know what to choose.

> Would it be okay if we just add a printk(KERN_ERR, ...)?

I think we at least we should do that, preferably even something else to
prevent accidental use if the feature is so fragile.

-- 
Kalle Valo
