Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:54589 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbZIYAJI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 20:09:08 -0400
Received: by iwn8 with SMTP id 8so1302205iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 17:09:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4ABC08FA.8030104@canonical.com>
References: <1253811559.4579.44.camel@pc3.dido> <4ABBAB47.8040300@canonical.com>
	<4ABBBB8C.8080401@hauke-m.de> <43e72e890909241137o7e853edfxb9e159df34927d7b@mail.gmail.com>
	<4ABC08FA.8030104@canonical.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 24 Sep 2009 17:08:50 -0700
Message-ID: <43e72e890909241708v55af30baia5f6fca8eb5d9d59@mail.gmail.com>
Subject: Re: A problem loading ssb module
To: tim.gardner@canonical.com
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Bryan Wu <bryan.wu@canonical.com>,
	Mauro Di Domenico <didomauro@tiscali.it>,
	bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2009 at 5:04 PM, Tim Gardner <tim.gardner@canonical.com> wrote:
> Luis R. Rodriguez wrote:
>>
>> On Thu, Sep 24, 2009 at 11:33 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>>>
>>> Bryan Wu wrote:
>>>>
>>>> Mauro Di Domenico wrote:
>>>>>
>>>>> Hi,
>>>>> I'm testing new b43 modules for my 14e4:4315 broadcom card.
>>>>> I've compiled and installed compat-wireless-2009-09-16 in a debian
>>>>> machine with kernel version 2.6.30-6.
>>>>>
>>>>> During the boot I experience this problem:
>>>>>
>>>>> $ dmesg|egrep "b43|ssb"
>>>>>
>>>>> [    2.384463] b43-pci-bridge 0000:06:00.0: PCI INT A -> GSI 17 (level,
>>>>> low) -> IRQ 17
>>>>> [    2.384477] b43-pci-bridge 0000:06:00.0: setting latency timer to 64
>>>>> [    2.544344] ssb: Sonics Silicon Backplane found on PCI device
>>>>> 0000:06:00.0
>>>>> [    6.968981] b43: disagrees about version of symbol
>>>>> ssb_device_is_enabled
>>>>> [    6.968986] b43: Unknown symbol ssb_device_is_enabled
>>>>> [    6.969280] b43: Unknown symbol ssb_pmu_set_ldo_paref
>>>>> [    6.969407] b43: disagrees about version of symbol
>>>>> ssb_pcicore_dev_irqvecs_enable
>>>>> [    6.969410] b43: Unknown symbol ssb_pcicore_dev_irqvecs_enable
>>>>> .....
>>>>> ....
>>>>> ...
>>>>>
>>>> I faced the exactly same issue as Mauro did. +1 from me, but currently
>>>> have
>>>> no time to take a deeper look.
>>>>
>>>> Thanks
>>>
>>> Hi,
>>>
>>> I had the same problem with the ssb module and compat-wireless in ubuntu
>>> 9.04. The problem is that the ssb module is integrated into the
>>> initramfs image. The version out of the initramfs image is loaded on
>>> startup and not the version of compat-wireless. Running "sudo
>>> update-initramfs -u" after installing compat-wireless and restaing the
>>> system fixes the problem for me. Either Debian/Ubuntu should remove ssb
>>> form default initramfs image or compat-wireless should update the image
>>> with the install command. At least the compat-wireless documentation
>>> needs an update.
>>>
>>> Hauke
>>>
>>> (adding Luis and linux-wireless list)
>>
>> Tim, do you guys update the initramfs upon installation of lbm? If a
>> user does not use lbm and uses compat-wireless I suppose we need to do
>> something similar.
>>
>>  Luis
>
> No, initramfs is not updated when LBM is installed. I think maybe its a bug
> that ssb is in the initramfs modules list since AFAIK its not a boot
> essential device. Even in the netboot case, ssb/b44 should be in a udeb.

That would make life much easier.

  Luis
