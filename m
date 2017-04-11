Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34216 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753448AbdDKIyB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 04:54:01 -0400
Subject: Re: brcmfmac: don't warn user if requested nvram fails
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
References: <09063fc2-af77-ced6-ed90-ab20e2884969@redhat.com>
 <577dc508-07ff-c74f-5c90-b6baf4e7694a@broadcom.com>
 <e6ef170b-2ec7-e364-5097-6e0daf5b8f0d@redhat.com>
 <ae29eb44-76cb-783f-6e76-81ed15c8e0dd@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <6cee092a-f8b7-f658-cd71-829f66559882@redhat.com> (sfid-20170411_105634_717788_4D6E05DD)
Date: Tue, 11 Apr 2017 10:53:57 +0200
MIME-Version: 1.0
In-Reply-To: <ae29eb44-76cb-783f-6e76-81ed15c8e0dd@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 10-04-17 23:50, Arend Van Spriel wrote:
> On 8-4-2017 11:53, Hans de Goede wrote:
>> Hi,
>>
>> On 07-04-17 23:43, Arend Van Spriel wrote:
>>>
>>>
>>> On 6-4-2017 14:14, Hans de Goede wrote:
>>>> Hi,
>>>>
>>>> I noticed your patch-series on the lwn.net kernel page,
>>>> and I took a peek :)
>>>>
>>>> I don't think that this patch:
>>>>
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/commit/?h=20170329-driver-data-v2-try3&id=3968dd3031d1ff7e7be4acfb810948c70c2d4490
>>>>
>>>>
>>>>
>>>> Is a good idea, specifically the "do not warn" part,
>>>> although the brcmfmac driver will indeed try to continue
>>>> without a nvram file, in my experience it almost all
>>>> the time will not work properly without the nvram file.
>>>
>>> Actually, brcmfmac will only continue without nvram for PCIe devices.
>>> For SDIO it is a different story, which may be the kind of devices you
>>> have experienced.
>>
>> Ah, no I've experience with both now, and the device I've
>> with a PCIE which needs nvram:
>>
>> http://www.gpd.hk/gpdwin.asp
>>
>> Will not work without the nvram file, so I really think
>> we should at least keep a warning msg here.
>
> Nice gadget.
>
>>>> Arend, should we maybe just make the missing nvram file
>>>> a fatal error ?
>>>>
>>>> ###
>>>>
>>>> While on the subject of nvram file loading, I want to make
>>>> some changes to how brcmfmac does this, for pcie
>>>> devices I want it to first try:
>>>>
>>>> brcmfmac-4xxx-sdio-<pci-subsys-vid>-<pci-subsys-pid>.txt
>>>> and only if that is not present fallback to
>>>> brcmfmac-4xxx-sdio.txt, so that we can include the
>>>> brcmfmac-4xxx-sdio-<pci-subsys-vid>-<pci-subsys-pid>.txt
>>>> in the linux-firmware repo and have things just work.
>>>
>>> You got me confused. I suppose the -sdio- should not be in the filename
>>> examples above.
>>
>> Right, sorry. For the pcie device I'm looking at the
>> name is brcmfmac4356-pcie.txt and I would like to propose
>> to first check for "brcmfmac4356-<pci-subsys-vid>-<pci-subsys-pid>.txt"
>>
>>> So who is going to provide these nvram files. We can not
>>> maintain that as there are too many variants and they are under control
>>> of the OEM/ODM.
>>
>> Users / people like me who are interested in using certain
>> devices with Linux. The idea is to at least make it possible to
>> have these devices just work. E.g. I would like a user to be
>> able to insert a USB-stick with a live Fedora 27 and then
>> have everything just work on the GPD win.
>>
>> To make this happen I will submit the nvram file from the
>> Windows install on the GPDwin to linux-firmware as
>> "brcmfmac4356-<pci-subsys-vid>-<pci-subsys-pid>.txt"
>> and yes I've checked that there are sensible values in
>> the subsys ids.
>
> I suppose the "nvram file from the Windows install" than has a
> redistributable license?

IANAL but I fail to see how the contents of this file is
anything but functional and as such not copyright-able.

That at least is what I plan to put in the commit msg
when submitting it to linux-firmware and then we will
see from there.

>> So would you be willing to accept a brcmfmac patch
>> trying such a post-fixed nvram filename first ?
>
> It seems a sensible approach, but the devil is probably in the details.

Ok, I'll leave this on my todo list then. Expect a patch
sometime in the future (but not really soon).

Regards,

Hans
