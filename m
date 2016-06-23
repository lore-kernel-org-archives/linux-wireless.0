Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35781 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbcFWSOv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 14:14:51 -0400
Received: by mail-wm0-f66.google.com with SMTP id a66so13006104wme.2
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2016 11:14:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160623175809.GA31170@leverpostej>
References: <20160623174536.5967-1-martin.blumenstingl@googlemail.com>
 <20160623174536.5967-2-martin.blumenstingl@googlemail.com> <20160623175809.GA31170@leverpostej>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Thu, 23 Jun 2016 20:14:29 +0200
Message-ID: <CAFBinCC6iY_y-_w_yeoqOOysqYBQxcRf8oVgXYs3YqqSE=sJrQ@mail.gmail.com> (sfid-20160623_201455_484619_BF98D158)
Subject: Re: [PATCH RFC v2 1/2] Documentation: dt: net: add ath9k wireless
 device binding
To: Mark Rutland <mark.rutland@arm.com>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, nbd@nbd.name, chunkeey@googlemail.com,
	robh+dt@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 23, 2016 at 7:58 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Thu, Jun 23, 2016 at 07:45:35PM +0200, Martin Blumenstingl wrote:
>> Add documentation how devicetree can be used to configure ath9k based
>> devices.
>>
>> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>> ---
>> changes in v1 -> v2:
>> - use vendor prefix "qca" instead of "ath"
>> - extend the example so it includes the "compatible" property
>>
>>  .../devicetree/bindings/net/wireless/qca,ath9k.txt | 41 ++++++++++++++++++++++
>>  1 file changed, 41 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
>>
>> diff --git a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
>> new file mode 100644
>> index 0000000..bb78f68
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
>> @@ -0,0 +1,41 @@
>> +* Qualcomm Atheros ath9k wireless devices
>> +
>> +This node provides properties for configuring the ath9k wireless device. The
>> +node is expected to be specified as a child node of the PCI controller to
>> +which the wireless chip is connected.
>> +
>> +Required properties:
>> +- compatible: Should be "qca,ath9k"
>> +
>> +Optional properties:
>> +- reg: Address and length of the register set for the device.
>> +- qca,gpio-mask: The GPIO mask
>> +- qca,gpio-val: The GPIO value
>> +- qca,led-pin: The GPIO number to which the LED is connected
>> +- qca,led-active-high: The LED is active when the GPIO is HIGH
>> +- qca,clk-25mhz: Defines that at 25MHz clock is used
>
> I must assume these apply to internal GPIOs, LEDs and clocks, so I'm
> somewhat surprised any description is necessary.
>
> How variable are these in practice?
led-pin and led-active-high are definitely used on various OpenWrt devices.
However, I am afraid that I have to pass this question to the ath9k
developers for the other properties (gpio-mask, gpio-val and
clk-25mhz).
If you want we can skip gpio-mask, gpio-val and clk-25mhz for now, but
keep led-pin and led-active-high.

>> +- qca,eeprom-name: The name of the file which contains the EEPROM data (which
>> +                     will be loaded via request_firmware)
>
> The binding shouldn't know anything about the host filesystem,
> request_firmware, etc. So the description is a best a little off.
>
> What happens when a new FW comes out? I shouldn't have to update my DT
> to cater for that.
This is not exactly a "firmware" but rather device-specific
calibration data (RF settings, MAC address, etc). Usually there is an
eeprom connected directly to the wifi chip, but on embedded devices
this is usually skipped and instead the calibration data is shipped
somewhere on the main flash (directly on SPI-/NOR-/NAND flash,
sometimes even inside an UBI volume).

> Please find a better way to identify relevant FW. What exactly affects
> which FW can be used, or would ideally be used? Are different FWs
> required for the same HW in some contexts?
>
> Can we not figure out the relevant FW names in the driver based on some
> identification mechanism (e.g. a more thoroughly defined set of
> compatible strings)?
The only way of auto-detecting a "correct" name would be via
dev_name() (with some prefix this could give something like
ath9k-pci-0000:00:0e.0.bin).

>> +- qca,check-eeprom-endianness: Allow checking the EEPROM endianness and
>> +                             swapping of the EEPROM data if required
>
> CAn we not simply always do this?
I've asked myself this question as well, but unfortunately some
manufacturers ship the EEPROM data with incorrect endianness magic.
Thus I decided to stay consistent with ath9k_platform_data which also
has a boolean (which defaults to false).

>> +- qca,disable-2ghz: Disables the 2.4GHz band, even if enabled in the EEPROM
>> +- qca,disable-5ghz: Disables the 5GHz band, even if enabled in the EEPROM
>
> When/why would these be necessary?
sometimes a manufacturer (accidentally) leaves both bands enabled in
the EEPROM data,while the RF hardware is only suitable for one of both
bands. The same settings exist in ath9k_platform_data, serving exactly
the same purpose


Regards,
Martin
