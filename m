Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4614 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab3CZWAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 18:00:52 -0400
Message-ID: <51521A8A.6060900@broadcom.com> (sfid-20130326_230057_128590_8E4744AE)
Date: Tue, 26 Mar 2013 23:00:42 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John Talbut" <jt@dpets.co.uk>
cc: "Hauke Mehrtens" <hauke@hauke-m.de>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: brcmsmac in kernel driver on a Samsung NC110
References: <51514F1B.1080207@dpets.co.uk>
 <5151639F.4010700@broadcom.com> <51516BC2.5010004@dpets.co.uk>
 <515173A4.7030607@broadcom.com> <515179C5.50406@dpets.co.uk>
 <51517E28.5000303@broadcom.com> <515182C6.5030305@dpets.co.uk>
 <51518682.7060503@broadcom.com> <515189C6.7070003@dpets.co.uk>
 <51518E14.3050500@broadcom.com>
 <CACna6ryjYroPdWoKhz25KUtURpSGDta0UvGeOLms9jy1tnw1Xg@mail.gmail.com>
 <5151EC49.9030109@dpets.co.uk> <5151F088.2040408@hauke-m.de>
 <5151FB85.5080007@dpets.co.uk>
In-Reply-To: <5151FB85.5080007@dpets.co.uk>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/26/2013 08:48 PM, John Talbut wrote:
> On 26/03/13 19:01, Hauke Mehrtens wrote:
>> Hi,
>>
>> Could you provide the output of "modinfo bcma | grep alias" as Rafał asked.
>>
>> The Debian kernel 3.2 contains some patch removing all PCI IDs expect
>> 14e4:4331 from bcma, if this is still in your kernel that's the problem.
>>
>> If this is the case please try this:
>>
>> echo "14e4 4357" > /sys/bus/pci/drivers/bcma-pci-bridge/new_id
>>
>> Hauke
>>
> Hi
> 
> modinfo bcma | grep alias
> ERROR: Module bcma not found.

That is because you have it compiled into the kernel.

> echo "14e4 4357" > /sys/bus/pci/drivers/bcma-pci-bridge/new_id
> bash: /sys/bus/pci/drivers/bcma-pci-bridge/new_id: No such file or directory

This could mean you do not have CONFIG_BCMA_HOST_PCI=y in your .config

> Because I am not using modules?
> 
> I found a reference to this patch:
> http://git.grml.org/?p=grml-kernel.git;a=blobdiff;f=linux-3/debian/patches/debian/bcma-Do-not-claim-PCI-device-IDs-also-claimed-by-brc.patch;fp=linux-3/debian/patches/debian/bcma-Do-not-claim-PCI-device-IDs-also-claimed-by-brc.patch;h=0000000000000000000000000000000000000000;hp=f8fd94163e10ff9fa3803d6f7aaae7adb3b2c0f5;hb=dfd70ee5283216f7635b367327a9389b10030d87;hpb=76b7ce681bb74b69aea9b155747c47ec86d4e6c5
> 
> This appears to refer to /drivers/bcma/host_pci.c, but the patch does
> not appear to be applied to that file in the Debian 3.8 kernel source,
> there are lines including:
> { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4357) },
> in the 3.8 version of the file.

That patch was from the days that brcmsmac did not use bcma. In 3.8 you
do not need that patch.

Gr. AvS

