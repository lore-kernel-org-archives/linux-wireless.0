Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:33632 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752763AbdDJVuf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 17:50:35 -0400
Received: by mail-wr0-f174.google.com with SMTP id l28so27948364wre.0
        for <linux-wireless@vger.kernel.org>; Mon, 10 Apr 2017 14:50:34 -0700 (PDT)
Subject: Re: brcmfmac: don't warn user if requested nvram fails
To: Hans de Goede <hdegoede@redhat.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
References: <09063fc2-af77-ced6-ed90-ab20e2884969@redhat.com>
 <577dc508-07ff-c74f-5c90-b6baf4e7694a@broadcom.com>
 <e6ef170b-2ec7-e364-5097-6e0daf5b8f0d@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <ae29eb44-76cb-783f-6e76-81ed15c8e0dd@broadcom.com> (sfid-20170410_235057_760098_6BF4162E)
Date: Mon, 10 Apr 2017 23:50:32 +0200
MIME-Version: 1.0
In-Reply-To: <e6ef170b-2ec7-e364-5097-6e0daf5b8f0d@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8-4-2017 11:53, Hans de Goede wrote:
> Hi,
> 
> On 07-04-17 23:43, Arend Van Spriel wrote:
>>
>>
>> On 6-4-2017 14:14, Hans de Goede wrote:
>>> Hi,
>>>
>>> I noticed your patch-series on the lwn.net kernel page,
>>> and I took a peek :)
>>>
>>> I don't think that this patch:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/commit/?h=20170329-driver-data-v2-try3&id=3968dd3031d1ff7e7be4acfb810948c70c2d4490
>>>
>>>
>>>
>>> Is a good idea, specifically the "do not warn" part,
>>> although the brcmfmac driver will indeed try to continue
>>> without a nvram file, in my experience it almost all
>>> the time will not work properly without the nvram file.
>>
>> Actually, brcmfmac will only continue without nvram for PCIe devices.
>> For SDIO it is a different story, which may be the kind of devices you
>> have experienced.
> 
> Ah, no I've experience with both now, and the device I've
> with a PCIE which needs nvram:
> 
> http://www.gpd.hk/gpdwin.asp
> 
> Will not work without the nvram file, so I really think
> we should at least keep a warning msg here.

Nice gadget.

>>> Arend, should we maybe just make the missing nvram file
>>> a fatal error ?
>>>
>>> ###
>>>
>>> While on the subject of nvram file loading, I want to make
>>> some changes to how brcmfmac does this, for pcie
>>> devices I want it to first try:
>>>
>>> brcmfmac-4xxx-sdio-<pci-subsys-vid>-<pci-subsys-pid>.txt
>>> and only if that is not present fallback to
>>> brcmfmac-4xxx-sdio.txt, so that we can include the
>>> brcmfmac-4xxx-sdio-<pci-subsys-vid>-<pci-subsys-pid>.txt
>>> in the linux-firmware repo and have things just work.
>>
>> You got me confused. I suppose the -sdio- should not be in the filename
>> examples above.
> 
> Right, sorry. For the pcie device I'm looking at the
> name is brcmfmac4356-pcie.txt and I would like to propose
> to first check for "brcmfmac4356-<pci-subsys-vid>-<pci-subsys-pid>.txt"
> 
>> So who is going to provide these nvram files. We can not
>> maintain that as there are too many variants and they are under control
>> of the OEM/ODM.
> 
> Users / people like me who are interested in using certain
> devices with Linux. The idea is to at least make it possible to
> have these devices just work. E.g. I would like a user to be
> able to insert a USB-stick with a live Fedora 27 and then
> have everything just work on the GPD win.
> 
> To make this happen I will submit the nvram file from the
> Windows install on the GPDwin to linux-firmware as
> "brcmfmac4356-<pci-subsys-vid>-<pci-subsys-pid>.txt"
> and yes I've checked that there are sensible values in
> the subsys ids.

I suppose the "nvram file from the Windows install" than has a
redistributable license?

> So would you be willing to accept a brcmfmac patch
> trying such a post-fixed nvram filename first ?

It seems a sensible approach, but the devil is probably in the details.

Regards,
Arend
