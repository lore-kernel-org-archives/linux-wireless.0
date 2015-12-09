Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:33709 "EHLO
	mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbbLIOBb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2015 09:01:31 -0500
Received: by vkca188 with SMTP id a188so47178777vkc.0
        for <linux-wireless@vger.kernel.org>; Wed, 09 Dec 2015 06:01:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151207090853.GA10097@rmanohar-arch.qca.qualcomm.com>
References: <loom.20151201T071931-353@post.gmane.org> <CALhHN=o4xAhy9oz0Q7sy-Ubji-nBf6pdJ7OSj8xLU0mn86n1qQ@mail.gmail.com>
 <CADaZW1E42rnjaxjnjskW_j83m=moauNBttZ-M=oyWoiXXS2ZiQ@mail.gmail.com>
 <CA+BoTQ=k9NHd6KHt2qzgjs5g3B6Q58fX=hTRB-BvxcvjejmWog@mail.gmail.com>
 <CADaZW1Eww2TNimciP5JxVam0y+-V4Ez2VfFXdT=_jh14TgOp0g@mail.gmail.com>
 <CA+BoTQk0Y+djSBNMonhkpZ3Aw8aKuxefdgSa9zUa-vgV9HTL4A@mail.gmail.com>
 <CACKGw+GPjr1fQ_u5yHfsAa=GBJmk7vRfcTUS3nt1N+id7UoPzg@mail.gmail.com>
 <CADaZW1Fy_7z8sHDjML1G_u8F3jyNrbSvLKRmxnCPw6M2HYc8oA@mail.gmail.com>
 <CADaZW1F=5NcMomcxKczb92rvxYR=kcwpSo8yu25C7AHQ4UHK3A@mail.gmail.com> <20151207090853.GA10097@rmanohar-arch.qca.qualcomm.com>
From: Bartlomiej Grzeskowiak <bartlomiej.grzeskowiak@gmail.com>
Date: Wed, 9 Dec 2015 15:01:01 +0100
Message-ID: <CADaZW1FJ8e0aLAb5owcn3uAG6dd1qaxHm=o5TOZgTcYmjejpVA@mail.gmail.com> (sfid-20151209_150134_672799_26AC7960)
Subject: Re: ath10k: device has crashed during init - qca6174 chipset
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: Bartosz Markowski <bartosz.markowski@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rajkumar,

Great. It works now.
I do not have a fully functional wlan yet, but at least the insmod goes through.

This issue is solved.

BR
Bartek

2015-12-07 10:08 GMT+01:00 Rajkumar Manoharan <rmanohar@qti.qualcomm.com>:
> On Tue, Dec 01, 2015 at 11:28:25AM +0100, Bartlomiej Grzeskowiak wrote:
>> I have tested borad-2.bin file with my module, by forcing
>> ar->id.subsystem_vendor = 0x168c;
>> ar->id.subsystem_device = 0x3363; (1,2,3)
>> in ath/ath10k/pci.c file.
>>
>> All the tests failed with:
>> ath10k_pci 0000:01:00.0: failed to receive initialized event from
>> target: 00000000
>> ath10k_pci 0000:01:00.0: firmware crashed! (uuid
>> 5506e81c-d538-4492-91d7-dc899fed8d8c)
>>
>> Does it mean, that this module is not supported?
>> I will need to dump firmware from windows driver, when I get it from
>> the vendor ?
>>
> Can you please apply below changes in your rc2 backports.
>
> https://github.com/kvalo/ath/commit/2727a743e9eeb3d4063d4077afee3fd2a5e198ca
> https://github.com/kvalo/ath/commit/6419fdbb6f90e147690f8833cba59d289d613da5
>
> or try with latest backports.
>
> https://www.kernel.org/pub/linux/kernel/projects/backports/2015/11/20/backports-20151120.tar.gz
>
> -Rajkumar
