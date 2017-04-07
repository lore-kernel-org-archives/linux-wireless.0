Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37914 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751968AbdDGVnH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Apr 2017 17:43:07 -0400
Received: by mail-wm0-f49.google.com with SMTP id t189so1555172wmt.1
        for <linux-wireless@vger.kernel.org>; Fri, 07 Apr 2017 14:43:07 -0700 (PDT)
Subject: Re: brcmfmac: don't warn user if requested nvram fails
To: Hans de Goede <hdegoede@redhat.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
References: <09063fc2-af77-ced6-ed90-ab20e2884969@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <577dc508-07ff-c74f-5c90-b6baf4e7694a@broadcom.com> (sfid-20170407_234312_027033_6431D7C2)
Date: Fri, 7 Apr 2017 23:43:04 +0200
MIME-Version: 1.0
In-Reply-To: <09063fc2-af77-ced6-ed90-ab20e2884969@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 6-4-2017 14:14, Hans de Goede wrote:
> Hi,
> 
> I noticed your patch-series on the lwn.net kernel page,
> and I took a peek :)
> 
> I don't think that this patch:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/commit/?h=20170329-driver-data-v2-try3&id=3968dd3031d1ff7e7be4acfb810948c70c2d4490
> 
> 
> Is a good idea, specifically the "do not warn" part,
> although the brcmfmac driver will indeed try to continue
> without a nvram file, in my experience it almost all
> the time will not work properly without the nvram file.

Actually, brcmfmac will only continue without nvram for PCIe devices.
For SDIO it is a different story, which may be the kind of devices you
have experienced.

> Arend, should we maybe just make the missing nvram file
> a fatal error ?
> 
> ###
> 
> While on the subject of nvram file loading, I want to make
> some changes to how brcmfmac does this, for pcie
> devices I want it to first try:
> 
> brcmfmac-4xxx-sdio-<pci-subsys-vid>-<pci-subsys-pid>.txt
> and only if that is not present fallback to
> brcmfmac-4xxx-sdio.txt, so that we can include the
> brcmfmac-4xxx-sdio-<pci-subsys-vid>-<pci-subsys-pid>.txt
> in the linux-firmware repo and have things just work.

You got me confused. I suppose the -sdio- should not be in the filename
examples above. So who is going to provide these nvram files. We can not
maintain that as there are too many variants and they are under control
of the OEM/ODM.

> Likewise for sdio devices on devicetree platforms
> first try brcmfmac-4xxx-sdio-<model>.txt.
> 
> And for sdio devices on ACPI/x86 systems I want to
> do something similar too.
> 
> Luis, do you think it would be a good idea to add
> .optional_postfix member to driver_data_req_params
> for this? I believe other sdio based wifi devices
> may want to do the same, or should this be handled
> in the driver by doing 2 driver_data_request_async
> calls (the 2nd when the 1st fails) ?

I think we briefly touched this subject a while ago. It would be great
if the driver_data api could be given a list/array of files which can be
flagged as required or optional. Just not sure how to deal with drivers
that request a firmware file and fallback to requesting older ones
repeatedly thus stop processing upon first successful load. Both
use-cases seem present in drivers.

Regards,
Arend

> Regards,
> 
> Hans
> 
> 
