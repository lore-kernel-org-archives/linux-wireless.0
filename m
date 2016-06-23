Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38156 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbcFWVqp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 17:46:45 -0400
Received: by mail-wm0-f51.google.com with SMTP id r201so1249082wme.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2016 14:46:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5bba7624-ad61-f603-5574-d9863e2c666e@broadcom.com>
References: <20160623174536.5967-1-martin.blumenstingl@googlemail.com>
 <20160623174536.5967-2-martin.blumenstingl@googlemail.com> <5bba7624-ad61-f603-5574-d9863e2c666e@broadcom.com>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Thu, 23 Jun 2016 23:46:23 +0200
Message-ID: <CAFBinCDCVRMp4W1orkBD55csgE=SEnGqRrAzUVYgLrqDD_A78g@mail.gmail.com> (sfid-20160623_234648_778775_AA8F27E3)
Subject: Re: [PATCH RFC v2 1/2] Documentation: dt: net: add ath9k wireless
 device binding
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, nbd@nbd.name, chunkeey@googlemail.com,
	mark.rutland@arm.com, robh+dt@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 23, 2016 at 9:25 PM, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
>> +Optional properties:
>> +- reg: Address and length of the register set for the device.
>
> Is 'reg' property handled. I don't see it in patch 2/2.
for AHB we would probably have to handle it separately, but AHB
support is not scope of my patch. For PCI(e) this is parsed
automatically by of_pci_find_child_device when the PCI controller is
found and the child nodes are enumerated. See [0]

>> +- qca,eeprom-name: The name of the file which contains the EEPROM data (which
>> +                     will be loaded via request_firmware)
>> +- qca,check-eeprom-endianness: Allow checking the EEPROM endianness and
>> +                             swapping of the EEPROM data if required
>> +- qca,disable-2ghz: Disables the 2.4GHz band, even if enabled in the EEPROM
>> +- qca,disable-5ghz: Disables the 5GHz band, even if enabled in the EEPROM
>
> These not really. Storing filename information in device tree seems
> wrong as it does not describe hardware configuration. The other three
> also seem more like driver module parameters. I think what you are
> trying here with the last two properties is to use the same eeprom file
> for different types of hardware, ie. for dual-band, 2g-only, and 5g-only
> devices. From device tree perspective I would use those types, eg.:
>
> qca,2g-capable: Device can operate in 2.4GHz band.
> qca,5g-capable: Device can operate in 5GHz band.
please let me explain this a bit more detailed (and clean up the
confusion which I may have created):
ath9k itself does not need a firmware to run.
But it needs to know some details of the actual RF hardware (let's
call it calibration/EEPROM data) to which the ath9k chip is wired
(which frequencies/bands are enabled, how many RX/TX antennas are
there, max TX power, if there's a LNA, and so on).
This calibration/EEPROM data is unique for each "ath9k + RF hardware"
combination and usually stored inside an EEPROM connected directly to
the ath9k chip. However, many embedded devices do not have a physical
EEPROM connected to ath9k. For these devices we have to obtain the
calibration/EEPROM data from "somewhere" (which is usually stored
somewhere on SPI/NOR/NAND flash, but can sometimes even be stored
inside an UBI volume).

"qca,eeprom-name" tries to solve the problem that ath9k needs
calibration/EEPROM data even if there is no physical EEPROM attached
to the wifi chip.
One important thing here is that we need to be able to load two
different calibration/EEPROM data files in case one system uses two
ath9k chips (there might for example be a dedicated 2.4G and dedicated
5G chip).
If this should not be part of devicetree then we could do it like
ath10k does and generate the filename for request_firmware based on
the dev_name() - see [1].
I would then replace "qca,eeprom-name" with a boolean
"qca,use-external-eeprom" to signal ath9k that this chip does not have
a (physical) EEPROM attached (ath9k would then start the
request_firmware mechanism).

qca,check-eeprom-endianness is unfortunately required because some
vendors use the little endian magic while the data is actually big
endian.
Endianness swapping needs to be done inside ath9k because it's a quite
complex operation (due to the fact that there are some 16bit and 32bit
fields which have to be swapped differently).
So one would set qca,check-eeprom-endianness if the device vendor
chose the wrong endianness magic, while the data inside the
calibration/EEPROM data is correct.
Enabling it unconditionally would result in the calibration/EEPROM
data being endianness-swapped.

qca,disable-2ghz/qca,disable-5ghz exist due to a similar issue as we
find with the eeprom endianness magic:
Normally the information which bands are enabled for this specific
"ath9k + RF hardware" combination is stored inside the
calibration/EEPROM data.
Unfortunately some vendors left for example the 5GHz band enabled in
the calibration/EEPROM data while the RF hardware only supports
2.4GHz.
Using the 5GHz band on such devices will lead to issues, so it should
be possible to disable those "incorrectly allowed" frequencies/bands.

> The other patch also looks for a MAC address for the device. I suppose
> that should be documented as well.
good catch, thanks!

>> +In this example, the node is defined as child node of the PCI controller.
>> +
>> +pci {
>> +     pcie@0 {
>> +             reg = <0 0 0 0 0>;
>> +             #interrupt-cells = <1>;
>> +             #size-cells = <2>;
>> +             #address-cells = <3>;
>> +             device_type = "pci";
>> +
>> +             ath9k@0,0 {
>> +                     compatible = "qca,ath9k";
>> +                     reg = <0 0 0 0 0>;
>> +                     device_type = "pci";
>
> Is this just a copy-paste or should device_type be specified?
indeed, as far as I understand it should only be defined on the bridge
- thus it should be removed from the ath9k node.
again, thanks for noting this!


Regards,
Martin


[0] http://lxr.free-electrons.com/source/drivers/of/of_pci.c?v=4.6#L21
[1] http://lxr.free-electrons.com/source/drivers/net/wireless/ath/ath10k/core.c#L729
