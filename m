Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from test.hauke-m.de ([5.39.93.123]:45934 "EHLO test.hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbaHZVZj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2014 17:25:39 -0400
Message-ID: <53FCFB50.80800@hauke-m.de> (sfid-20140826_232543_150889_FB62DA57)
Date: Tue, 26 Aug 2014 23:25:36 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-mips@linux-mips.org, zajec5@gmail.com
Subject: Re: [RFC 4/7] bcma: register bcma as device tree driver
References: <1408915485-8078-1-git-send-email-hauke@hauke-m.de> <1408915485-8078-6-git-send-email-hauke@hauke-m.de> <2462012.kILSFadzpm@wuerfel>
In-Reply-To: <2462012.kILSFadzpm@wuerfel>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/25/2014 09:57 AM, Arnd Bergmann wrote:
> On Sunday 24 August 2014 23:24:42 Hauke Mehrtens wrote:
>> This driver is used by the bcm53xx ARM SoC code. Now it is possible to
>> give the address of the chipcommon core in device tree and bcma will
>> search for all the other cores.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> 
> Looks good to me overall. Two small comments:
> 
>>  Documentation/devicetree/bindings/bus/bcma.txt | 46 +++++++++++++++++
>>  drivers/bcma/host_soc.c                        | 70 ++++++++++++++++++++++++++
>>  include/linux/bcma/bcma.h                      |  2 +
>>  3 files changed, 118 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/bus/bcma.txt
>>
>> diff --git a/Documentation/devicetree/bindings/bus/bcma.txt b/Documentation/devicetree/bindings/bus/bcma.txt
>> new file mode 100644
>> index 0000000..52fb929
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/bus/bcma.txt
>> @@ -0,0 +1,46 @@
>> +Broadcom AIX bcma bus driver
>> +
>> +
>> +Required properties:
>> +
>> +- compatible : brcm,bus-aix
>> +
>> +- reg : iomem address range of chipcommon core
>> +
>> +Optional properties:
>> +
>> +- sprom: reference to a sprom driver. This is needed for sprom less devices.
>> +        Use bcm47xx_sprom for example.
>> +
>> +
>> +The cores on the AIX bus are auto detected by bcma. Detection of the
>> +IRQ number is not supported on BCM47xx/BCM53xx ARM SoCs, so it is
>> +possible to provide the IRQ number over device tree. The IRQ number and
>> +the device tree child entry will be added to the core with the matching
>> +reg address.
> 
> What is the problem with the interrupt numbers? Is that information
> missing completely from the data available to the brcm bus, or is it
> in an inconvenient format?

I do not have access to the datasheet, only to the vendor source code.
The irq numbers are hard coded in the vendor code, see:
https://github.com/RMerl/asuswrt-merlin/blob/master/release/src-rt-6.x.4708/linux/linux-2.6.36/arch/arm/plat-brcm/bcm5301x_pcie.c#L286

On the mips SoCs it was possible to read them from some register in the
mips core on the aix bus.

> 
>> +Example:
>> +
>> +       aix@18000000 {
>> +               compatible = "brcm,bus-aix";
>> +               reg = <0x18000000 0x1000>;
>> +               ranges = <0x00000000 0x18000000 0x00100000>;
>> +               #address-cells = <1>;
>> +               #size-cells = <1>;
>> +               sprom = <&sprom0>;
>> +
>> +               gmac@0 {
>> +                       reg = <0x18024000 0x1000>;
>> +                       interrupts = <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>;
>> +               };
> 
> The @0 part seems wrong here: the address should generally match
> the first entry in the reg property, which would be gmac@18024000.
> 
> Also, you probably mean ethernet@ not gmac@.

Will change that.

>> +               gmac@1 {
>> +                       reg = <0x18025000 0x1000>;
>> +                       interrupts = <GIC_SPI 148 IRQ_TYPE_LEVEL_HIGH>;
>> +               };
>> +
>> +               pcie@0 {
>> +                       reg = <0x18012000 0x1000>;
>> +                       interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>;
>> +               };
>> +       };
> 
> We may require additional properties for the pcie node, depending on whether
> we want to use the DT probing interfaces for it, or whether it should just
> hardcode the settings used on brcm based on the ID.

I wrote a driver for the PCIe host controller and it also automatically
detects all needed memory addresses, it just had to provide the IRQ
number through device tree.

> 
> 	Arnd
> 

