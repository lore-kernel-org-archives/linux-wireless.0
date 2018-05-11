Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39468 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbeEKKSf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 06:18:35 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Michael =?utf-8?Q?B=C3=BCsch?= <m@bues.ch>,
        Matt Redfearn <matt.redfearn@mips.com>,
        linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        LKML <linux-kernel@vger.kernel.org>,
        =?utf-8?Q?Rafa?= =?utf-8?Q?=C5=82_Mi=C5=82ecki?=
        <rafal@milecki.pl>
Subject: Re: [PATCH 4.17 2/2] ssb: make SSB_PCICORE_HOSTMODE depend on SSB = y
References: <20180510111401.1161-1-zajec5@gmail.com>
        <20180510111401.1161-2-zajec5@gmail.com>
        <ff18cb0a-e878-dff4-777b-134f0f3fe2e5@lwfinger.net>
Date: Fri, 11 May 2018 13:18:30 +0300
In-Reply-To: <ff18cb0a-e878-dff4-777b-134f0f3fe2e5@lwfinger.net> (Larry
        Finger's message of "Thu, 10 May 2018 11:07:09 -0500")
Message-ID: <8736yycx6x.fsf@codeaurora.org> (sfid-20180511_121902_760584_62B3D542)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 05/10/2018 06:14 AM, Rafa=C5=82 Mi=C5=82ecki wrote:
>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>
>> SSB_PCICORE_HOSTMODE protects MIPS specific code that calls not exported
>> symbols pcibios_enable_device and register_pci_controller. This code is
>> supposed to be compiled only with ssb builtin.
>>
>> This fixes:
>> ERROR: "pcibios_enable_device" [drivers/ssb/ssb.ko] undefined!
>> ERROR: "register_pci_controller" [drivers/ssb/ssb.ko] undefined!
>> make[1]: *** [scripts/Makefile.modpost:92: __modpost] Error 1
>>
>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> This patch needs a "Reported-by: Matt Redfearn <matt.redfearn@mips.com>".
>
> Applying both patches leads to a correct configuration for PCI. I
> cannot test on my present hardware, but the patches seem to be
> correct.
>
> Reviewed-by: Larry Finger <Larry.Finger@lwfinger.net>
>
> @Kalle: Please drop my patch from yesterday. This solution is much better.

Dropped, thanks for letting me know.

--=20
Kalle Valo
