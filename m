Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38894 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753441AbdDFMOE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 08:14:04 -0400
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: brcmfmac: don't warn user if requested nvram fails
Message-ID: <09063fc2-af77-ced6-ed90-ab20e2884969@redhat.com> (sfid-20170406_141435_567977_07BE3220)
Date: Thu, 6 Apr 2017 14:14:02 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I noticed your patch-series on the lwn.net kernel page,
and I took a peek :)

I don't think that this patch:

https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/commit/?h=20170329-driver-data-v2-try3&id=3968dd3031d1ff7e7be4acfb810948c70c2d4490

Is a good idea, specifically the "do not warn" part,
although the brcmfmac driver will indeed try to continue
without a nvram file, in my experience it almost all
the time will not work properly without the nvram file.

Arend, should we maybe just make the missing nvram file
a fatal error ?

###

While on the subject of nvram file loading, I want to make
some changes to how brcmfmac does this, for pcie
devices I want it to first try:

brcmfmac-4xxx-sdio-<pci-subsys-vid>-<pci-subsys-pid>.txt
and only if that is not present fallback to
brcmfmac-4xxx-sdio.txt, so that we can include the
brcmfmac-4xxx-sdio-<pci-subsys-vid>-<pci-subsys-pid>.txt
in the linux-firmware repo and have things just work.

Likewise for sdio devices on devicetree platforms
first try brcmfmac-4xxx-sdio-<model>.txt.

And for sdio devices on ACPI/x86 systems I want to
do something similar too.

Luis, do you think it would be a good idea to add
.optional_postfix member to driver_data_req_params
for this? I believe other sdio based wifi devices
may want to do the same, or should this be handled
in the driver by doing 2 driver_data_request_async
calls (the 2nd when the 1st fails) ?

Regards,

Hans
