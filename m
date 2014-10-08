Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:45604 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919AbaJHK1Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 06:27:16 -0400
Date: Wed, 8 Oct 2014 13:27:08 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Loic Poulain <loic.poulain@intel.com>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] net: rfkill: gpio: Configurable GPIO idx
Message-ID: <20141008102708.GA3514@kuha.fi.intel.com> (sfid-20141008_122719_765509_1476A7EC)
References: <1412757280-31367-1-git-send-email-loic.poulain@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1412757280-31367-1-git-send-email-loic.poulain@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 08, 2014 at 10:34:36AM +0200, Loic Poulain wrote:
> Some devices don't match the current static gpio mapping:
> -BCM4752 (GPS) uses gpio res 0 as host wake irq.
> -OBDA8723 (Bluetooth) uses gpio res 0 as controller wake gpio
> and res 2 as host wake irq.
> 
> To allow more flexibility, this patch introduces an index
> map description.
> By default, legacy config still used (reset: idx 0;
> shutdown: idx 1).
> 
> Signed-off-by: Loic Poulain <loic.poulain@intel.com>
> ---
>  net/rfkill/rfkill-gpio.c | 125 +++++++++++++++++++++++++++++++++--------------
>  1 file changed, 88 insertions(+), 37 deletions(-)

NAK

I'm afraid the order of the GPIOs is platform specific. This would
break the systems already out in the market.

You need to fix your firmware to generate ACPI DSDT according to ACPI
spec. v5.1 [1], which introduces the Device Specific Data (_DSD) and
dt like device properties. We need to be able to request the GPIO
based on the label, not the index, with all new platforms. Here is an
example of the type of_ASL you need to have for the device..

        ...
        Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
        {
            Name (BBUF, ResourceTemplate ()
            {
                UartSerialBus (0x0001C200, DataBitsEight, StopBitsOne,
                    0xFC, LittleEndian, ParityTypeNone, FlowControlNone,
                    0x0020, 0x0020, "\\_SB.PCI0.URT1",
                    0x00, ResourceConsumer, ,
                    )
                GpioInt (Level, ActiveLow, Exclusive, PullNone, 0x0000,
                    "\\_SB.GPO3", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x003C
                    }
                GpioIo (Exclusive, PullDefault, 0x0000, 0x0000, IoRestrictionOutputOnly,
                    "\\_SB.GPO3", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x003E
                    }
                GpioIo (Exclusive, PullDefault, 0x0000, 0x0000, IoRestrictionOutputOnly,
                    "\\_SB.GPO3", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x0040
                    }
            })
            Return (BBUF) /* \_SB_.PCI0.URT1.BTH1._CRS.BBUF */
        }

        Name (_DSD, Package ()
        {
            ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
            Package () {
                Package () {"reset-gpio", Package () {^BTH1, 1, 0, 0}},
                Package () {"shutdown-gpio", Package () {^BTH1, 2, 0, 0}},
            }
        })
        ...

That will make sure you get the correct GPIO the moment we get support
for the ACPI properties [2], regardless of the index. So there is no
need for any changes to the driver.


[1] http://www.uefi.org/sites/default/files/resources/ACPI_5_1release.pdf
[2] https://lkml.org/lkml/2014/9/16/229


-- 
heikki
