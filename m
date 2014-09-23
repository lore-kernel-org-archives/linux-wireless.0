Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:36554 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbaIWWEW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 18:04:22 -0400
Message-ID: <5421EE62.2080701@hauke-m.de> (sfid-20140924_000426_623866_46496B0E)
Date: Wed, 24 Sep 2014 00:04:18 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	devicetree@vger.kernel.org, zajec5@gmail.com,
	varkabhadram@gmail.com, arend@broadcom.com
Subject: Re: [PATCH v4 1/2] bcma: register bcma as device tree driver
References: <1411339108-22307-1-git-send-email-hauke@hauke-m.de> <4345256.UGZH9SeRYG@wuerfel>
In-Reply-To: <4345256.UGZH9SeRYG@wuerfel>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/22/2014 09:26 AM, Arnd Bergmann wrote:
> On Monday 22 September 2014 00:38:27 Hauke Mehrtens wrote:
>> +
>> +- reg : iomem address range of chipcommon core
>> +
>> +The cores on the AXI bus are automatically detected by bcma with the
>> +memory ranges they are using and they get registered afterwards.
>> +Automatic detection of the IRQ number is not reliable on
>> +BCM47xx/BCM53xx ARM SoCs. To assign IRQ numbers to the cores, provide
>> +them manually through device tree. The IRQ number and the device tree
>> +child entry will get assigned to the core with the matching reg address.
>> +
>> +Example:
>> +
>> +       axi@18000000 {
>> +               compatible = "brcm,bus-axi";
>> +               reg = <0x18000000 0x1000>;
>> +               ranges = <0x00000000 0x18000000 0x00100000>;
>> +               #address-cells = <1>;
>> +               #size-cells = <1>;
>> +
>> +               pcie@12000 {
>> +                       reg = <0x00012000 0x1000>;
>> +                       interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>;
>> +               };
>> +
>> +               ethernet@24000 {
>> +                       reg = <0x00024000 0x1000>;
>> +                       interrupts = <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>;
>> +               };
>> +
>> +               ethernet@25000 {
>> +                       reg = <0x00025000 0x1000>;
>> +                       interrupts = <GIC_SPI 148 IRQ_TYPE_LEVEL_HIGH>;
>> +               };
>> +       };
>>
> 
> While reading through this new version, I had a new idea about how
> this could be handled better for any machines that have a unique
> number in the interrupt field: If you do the same thing as PCI
> and add an interrupt-map property [1], you can translate that
> number into a real interrupt specifier for the child nodes.
> 
> This can work even if every device lists the local interrupt
> as '0', since you can have device-specific lookup entries if you
> use the correct interrupt-map-mask property.
> 
> 	Arnd
> 
> [1] http://www.openfirmware.org/1275/practice/imap/imap0_9d.pdf
> 

I assume this should then look somehow like this:

axi@18000000 {
	compatible = "brcm,bus-axi";
	reg = <0x18000000 0x1000>;
	ranges = <0x00000000 0x18000000 0x00100000>;
	#address-cells = <1>;
	#size-cells = <1>;

	#interrupt-cells = <1>;
	interrupt-map = <
		/* ChipCommon */
		0x00000000 0 &gic  GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH

		/* PCIe Controller 0 */
		0x00012000 0 &gic GIC_SPI 126 IRQ_TYPE_LEVEL_HIGH
		0x00012000 1 &gic GIC_SPI 127 IRQ_TYPE_LEVEL_HIGH
		0x00012000 2 &gic GIC_SPI 128 IRQ_TYPE_LEVEL_HIGH
		0x00012000 3 &gic GIC_SPI 129 IRQ_TYPE_LEVEL_HIGH
		0x00012000 4 &gic GIC_SPI 130 IRQ_TYPE_LEVEL_HIGH
		0x00012000 5 &gic GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH

		/* USB 2.0 Controller */
		0x00021000 0 &gic GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH
		>;
	};

How does the mapping of these interrupts to the devices work?

Do I have to add a device tree entry for every device after all?

Do you have some example code where this is handled in code, I could not
find the code doing this for PCI.

Hauke
