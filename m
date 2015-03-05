Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:43696 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbbCERGR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 12:06:17 -0500
MIME-Version: 1.0
In-Reply-To: <87sidj4kyv.fsf@kamboji.qca.qualcomm.com>
References: <CA+r1Zhio+Kp30y4DHS0SW20PjZrAY3PZLXjskykpa8CY0tcrMA@mail.gmail.com>
	<87d24o7s2j.fsf@kamboji.qca.qualcomm.com>
	<20150305080130.41b132ee@canb.auug.org.au>
	<87sidj4kyv.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 5 Mar 2015 10:06:16 -0700
Message-ID: <CA+r1Zhj+OnSsPzHy6mLRBU5QDYVeVFCwaKtvHWkfSy2hoL6=0w@mail.gmail.com> (sfid-20150305_180636_577854_33F70589)
Subject: Re: randconfig build error with next-20150303, in drivers/bcma/driver_pcie2.c
From: Jim Davis <jim.epost@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next <linux-next@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>, zajec5@gmail.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 5, 2015 at 6:44 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Stephen Rothwell <sfr@canb.auug.org.au> writes:
>
>> Hi Kalle,
>>
>> On Wed, 04 Mar 2015 16:31:00 +0200 Kalle Valo <kvalo@codeaurora.org> wrote:
>>>
>>> Jim Davis <jim.epost@gmail.com> writes:
>>>
>>> > Building with the attached random configuration file,
>>> >
>>> > drivers/bcma/driver_pcie2.c: In function 'bcma_core_pcie2_up':
>>> > drivers/bcma/driver_pcie2.c:196:2: error: implicit declaration of
>>> > function 'pcie_set_readrq' [-Werror=implicit-function-declaration]
>>> >   err = pcie_set_readrq(dev, pcie2->reqsize);
>>> >   ^
>>>
>>> This should fix it:
>>>
>>> bcma: add missing includes
>>>
>>> https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=2264fc857decd45798368f46861d9aecac23546f
>>
>> However, that commit is in next-20150304 and we still get the error
>> (see, for example,
>> http://kisskb.ellerman.id.au/kisskb/buildresult/12376688/).
>
> I applied few fixes from Rafal and Chen:
>
> 1ca2760fb2c1 bcma: prepare Kconfig symbol for PCI driver
> 0a4e699a41f7 bcma: move internal function declarations to private header
> c32ec2a11321 bcma: make bcma_host_pci_(up|down) calls safe for every config
> b09f5ec18b16 bcma: Kconfig: Let it depend on PCI
>
> It would be great if someone could report if the build errors are gone
> now.

I reran that configuration file on
wireless-drivers-next-for-davem-2015-02-07-9274-g1ca2760fb2c13, with
no build errors.
