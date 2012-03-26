Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42671 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab2CZB2r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Mar 2012 21:28:47 -0400
Received: by eaaq12 with SMTP id q12so1387582eaa.19
        for <linux-wireless@vger.kernel.org>; Sun, 25 Mar 2012 18:28:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120326012038.GA7722@windriver.com>
References: <1332720175-7659-1-git-send-email-paul.gortmaker@windriver.com>
 <CAGRGNgVBwKppzMa7HZeWm+ZW1a7u0JKwxxFS2xCRv=bpxXnk+Q@mail.gmail.com> <20120326012038.GA7722@windriver.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 26 Mar 2012 12:28:26 +1100
Message-ID: <CAGRGNgVm_cNAdXZcSjj1oUz98vAVNEsdpZZ9L6=cc_sX_AZ8Rg@mail.gmail.com> (sfid-20120326_032851_490423_FE7EEECA)
Subject: Re: [PATCH] bcma: fix build error on MIPS; implicit pcibios_enable_device
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Paul,

On Mon, Mar 26, 2012 at 12:20, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> [Re: [PATCH] bcma: fix build error on MIPS; implicit pcibios_enable_device] On 26/03/2012 (Mon 11:13) Julian Calaby wrote:
>
>> Hi Paul,
>>
>> On Mon, Mar 26, 2012 at 11:02, Paul Gortmaker
>> <paul.gortmaker@windriver.com> wrote:
>> > The following is seen during allmodconfig builds for MIPS:
>> >
>> > drivers/bcma/driver_pci_host.c:518:2: error: implicit declaration
>> > of function 'pcibios_enable_device' [-Werror=implicit-function-declaration]
>> > cc1: some warnings being treated as errors
>> > make[3]: *** [drivers/bcma/driver_pci_host.o] Error 1
>> >
>> > Most likey introduced by commit 49dc9577155576b10ff79f0c1486c816b01f58bf
>> >
>> >    "bcma: add PCIe host controller"
>> >
>> > Add the header instead of implicitly assuming it will be present.
>> > Sounds like a good idea, but that alone doesn't fix anything.
>> >
>> > The real problem is that the Kconfig has settings related to whether
>> > PCI is possible, i.e.
>> >
>> >  config BCMA_HOST_PCI_POSSIBLE
>> >        bool
>> >        depends on BCMA && PCI = y
>> >        default y
>> >
>> >  config BCMA_HOST_PCI
>> >        bool "Support for BCMA on PCI-host bus"
>> >        depends on BCMA_HOST_PCI_POSSIBLE
>> >
>> > ...but what is missing is that BCMA_DRIVER_PCI_HOSTMODE doesn't
>> > have any dependencies on the above.  Add one.
>> >
>> > CC: Hauke Mehrtens <hauke@hauke-m.de>
>> > CC: John W. Linville <linville@tuxdriver.com>
>> > Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>> >
>> > diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
>> > index c1172da..fb7c80f 100644
>> > --- a/drivers/bcma/Kconfig
>> > +++ b/drivers/bcma/Kconfig
>> > @@ -29,7 +29,7 @@ config BCMA_HOST_PCI
>> >
>> >  config BCMA_DRIVER_PCI_HOSTMODE
>> >        bool "Driver for PCI core working in hostmode"
>> > -       depends on BCMA && MIPS
>> > +       depends on BCMA && MIPS && BCMA_HOST_PCI
>>
>> I don't know the hardware, but I'm sure there'd be situations
>> (probably for embedded devices) where hostmode would be wanted without
>> the PCI host support - so shouldn't this depend on
>> BCMA_HOST_PCI_POSSIBLE?
>
> My reading of things is that BCMA_HOST_PCI is equivalent to, or
> at most a subset of BCMA_HOST_PCI_POSSIBLE.  But if the maintainers
> want to tweak things accordingly, then great -- I'm just reporting
> what I see in build failures.

That's not the case.

BCMA_HOST_PCI is a separate config option that depends on
...._POSSIBLE but is user selectable. ...._POSSIBLE isn't user
selectable and is automatically "y" when the conditions for PCI
support for BCMA are true.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
