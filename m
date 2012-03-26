Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58238 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932258Ab2CZLek (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 07:34:40 -0400
Message-ID: <4F70543F.2010007@hauke-m.de> (sfid-20120326_133443_459183_E67C1EFF)
Date: Mon, 26 Mar 2012 14:34:23 +0300
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>, zajec5@gmail.com,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] bcma: fix build error on MIPS; implicit pcibios_enable_device
References: <1332720175-7659-1-git-send-email-paul.gortmaker@windriver.com> <CAGRGNgVBwKppzMa7HZeWm+ZW1a7u0JKwxxFS2xCRv=bpxXnk+Q@mail.gmail.com> <20120326012038.GA7722@windriver.com> <CAGRGNgVm_cNAdXZcSjj1oUz98vAVNEsdpZZ9L6=cc_sX_AZ8Rg@mail.gmail.com>
In-Reply-To: <CAGRGNgVm_cNAdXZcSjj1oUz98vAVNEsdpZZ9L6=cc_sX_AZ8Rg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/26/2012 04:28 AM, Julian Calaby wrote:
> Hi Paul,
> 
> On Mon, Mar 26, 2012 at 12:20, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
>> [Re: [PATCH] bcma: fix build error on MIPS; implicit pcibios_enable_device] On 26/03/2012 (Mon 11:13) Julian Calaby wrote:
>>
>>> Hi Paul,
>>>
>>> On Mon, Mar 26, 2012 at 11:02, Paul Gortmaker
>>> <paul.gortmaker@windriver.com> wrote:
>>>> The following is seen during allmodconfig builds for MIPS:
>>>>
>>>> drivers/bcma/driver_pci_host.c:518:2: error: implicit declaration
>>>> of function 'pcibios_enable_device' [-Werror=implicit-function-declaration]
>>>> cc1: some warnings being treated as errors
>>>> make[3]: *** [drivers/bcma/driver_pci_host.o] Error 1
>>>>
>>>> Most likey introduced by commit 49dc9577155576b10ff79f0c1486c816b01f58bf
>>>>
>>>>    "bcma: add PCIe host controller"
>>>>
>>>> Add the header instead of implicitly assuming it will be present.
>>>> Sounds like a good idea, but that alone doesn't fix anything.
>>>>
>>>> The real problem is that the Kconfig has settings related to whether
>>>> PCI is possible, i.e.
>>>>
>>>>  config BCMA_HOST_PCI_POSSIBLE
>>>>        bool
>>>>        depends on BCMA && PCI = y
>>>>        default y
>>>>
>>>>  config BCMA_HOST_PCI
>>>>        bool "Support for BCMA on PCI-host bus"
>>>>        depends on BCMA_HOST_PCI_POSSIBLE
>>>>
>>>> ...but what is missing is that BCMA_DRIVER_PCI_HOSTMODE doesn't
>>>> have any dependencies on the above.  Add one.
>>>>
>>>> CC: Hauke Mehrtens <hauke@hauke-m.de>
>>>> CC: John W. Linville <linville@tuxdriver.com>
>>>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>>>>
>>>> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
>>>> index c1172da..fb7c80f 100644
>>>> --- a/drivers/bcma/Kconfig
>>>> +++ b/drivers/bcma/Kconfig
>>>> @@ -29,7 +29,7 @@ config BCMA_HOST_PCI
>>>>
>>>>  config BCMA_DRIVER_PCI_HOSTMODE
>>>>        bool "Driver for PCI core working in hostmode"
>>>> -       depends on BCMA && MIPS
>>>> +       depends on BCMA && MIPS && BCMA_HOST_PCI
>>>
>>> I don't know the hardware, but I'm sure there'd be situations
>>> (probably for embedded devices) where hostmode would be wanted without
>>> the PCI host support - so shouldn't this depend on
>>> BCMA_HOST_PCI_POSSIBLE?
>>
>> My reading of things is that BCMA_HOST_PCI is equivalent to, or
>> at most a subset of BCMA_HOST_PCI_POSSIBLE.  But if the maintainers
>> want to tweak things accordingly, then great -- I'm just reporting
>> what I see in build failures.
> 
> That's not the case.
> 
> BCMA_HOST_PCI is a separate config option that depends on
> ...._POSSIBLE but is user selectable. ...._POSSIBLE isn't user
> selectable and is automatically "y" when the conditions for PCI
> support for BCMA are true.
> 
> Thanks,
> 
Yes that's correct. BCMA_HOST_PCI_POSSIBLE is used to only show
BCMA_DRIVER_PCI_HOSTMODE if PCI is enabled. For now you are not able to
use PCI host mode without also supporting client mode in bcma. I have
only seen device where an other bcma based device was being behind the
PCIe link.

Hauke
