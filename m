Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49764 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbbCENpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 08:45:07 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jim Davis <jim.epost@gmail.com>,
	linux-next <linux-next@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>, zajec5@gmail.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: randconfig build error with next-20150303, in drivers/bcma/driver_pcie2.c
References: <CA+r1Zhio+Kp30y4DHS0SW20PjZrAY3PZLXjskykpa8CY0tcrMA@mail.gmail.com>
	<87d24o7s2j.fsf@kamboji.qca.qualcomm.com>
	<20150305080130.41b132ee@canb.auug.org.au>
Date: Thu, 05 Mar 2015 15:44:56 +0200
In-Reply-To: <20150305080130.41b132ee@canb.auug.org.au> (Stephen Rothwell's
	message of "Thu, 5 Mar 2015 08:01:30 +1100")
Message-ID: <87sidj4kyv.fsf@kamboji.qca.qualcomm.com> (sfid-20150305_144535_497342_84FD4EF3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Kalle,
>
> On Wed, 04 Mar 2015 16:31:00 +0200 Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>> Jim Davis <jim.epost@gmail.com> writes:
>> 
>> > Building with the attached random configuration file,
>> >
>> > drivers/bcma/driver_pcie2.c: In function 'bcma_core_pcie2_up':
>> > drivers/bcma/driver_pcie2.c:196:2: error: implicit declaration of
>> > function 'pcie_set_readrq' [-Werror=implicit-function-declaration]
>> >   err = pcie_set_readrq(dev, pcie2->reqsize);
>> >   ^
>> 
>> This should fix it:
>> 
>> bcma: add missing includes
>> 
>> https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=2264fc857decd45798368f46861d9aecac23546f
>
> However, that commit is in next-20150304 and we still get the error
> (see, for example,
> http://kisskb.ellerman.id.au/kisskb/buildresult/12376688/).

I applied few fixes from Rafal and Chen:

1ca2760fb2c1 bcma: prepare Kconfig symbol for PCI driver
0a4e699a41f7 bcma: move internal function declarations to private header
c32ec2a11321 bcma: make bcma_host_pci_(up|down) calls safe for every config
b09f5ec18b16 bcma: Kconfig: Let it depend on PCI

It would be great if someone could report if the build errors are gone
now.

-- 
Kalle Valo
