Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36375 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbcFWTZ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 15:25:58 -0400
Received: by mail-pa0-f42.google.com with SMTP id wo6so30003611pac.3
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2016 12:25:58 -0700 (PDT)
Subject: Re: [PATCH RFC v2 1/2] Documentation: dt: net: add ath9k wireless
 device binding
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
References: <20160623174536.5967-1-martin.blumenstingl@googlemail.com>
 <20160623174536.5967-2-martin.blumenstingl@googlemail.com>
Cc: nbd@nbd.name, chunkeey@googlemail.com, mark.rutland@arm.com,
	robh+dt@kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5bba7624-ad61-f603-5574-d9863e2c666e@broadcom.com> (sfid-20160623_212602_475938_01756CEB)
Date: Thu, 23 Jun 2016 21:25:48 +0200
MIME-Version: 1.0
In-Reply-To: <20160623174536.5967-2-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 23-6-2016 19:45, Martin Blumenstingl wrote:
> Add documentation how devicetree can be used to configure ath9k based
> devices.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
> changes in v1 -> v2:
> - use vendor prefix "qca" instead of "ath"
> - extend the example so it includes the "compatible" property
> 
>  .../devicetree/bindings/net/wireless/qca,ath9k.txt | 41 ++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
> new file mode 100644
> index 0000000..bb78f68
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
> @@ -0,0 +1,41 @@
> +* Qualcomm Atheros ath9k wireless devices
> +
> +This node provides properties for configuring the ath9k wireless device. The
> +node is expected to be specified as a child node of the PCI controller to
> +which the wireless chip is connected.
> +
> +Required properties:
> +- compatible: Should be "qca,ath9k"
> +
> +Optional properties:
> +- reg: Address and length of the register set for the device.

Is 'reg' property handled. I don't see it in patch 2/2.

> +- qca,gpio-mask: The GPIO mask
> +- qca,gpio-val: The GPIO value
> +- qca,led-pin: The GPIO number to which the LED is connected
> +- qca,led-active-high: The LED is active when the GPIO is HIGH
> +- qca,clk-25mhz: Defines that at 25MHz clock is used

For the above I can somehow see them as variables for different hardware
platforms.

> +- qca,eeprom-name: The name of the file which contains the EEPROM data (which
> +			will be loaded via request_firmware)
> +- qca,check-eeprom-endianness: Allow checking the EEPROM endianness and
> +				swapping of the EEPROM data if required
> +- qca,disable-2ghz: Disables the 2.4GHz band, even if enabled in the EEPROM
> +- qca,disable-5ghz: Disables the 5GHz band, even if enabled in the EEPROM

These not really. Storing filename information in device tree seems
wrong as it does not describe hardware configuration. The other three
also seem more like driver module parameters. I think what you are
trying here with the last two properties is to use the same eeprom file
for different types of hardware, ie. for dual-band, 2g-only, and 5g-only
devices. From device tree perspective I would use those types, eg.:

qca,2g-capable: Device can operate in 2.4GHz band.
qca,5g-capable: Device can operate in 5GHz band.

The other patch also looks for a MAC address for the device. I suppose
that should be documented as well.

> +In this example, the node is defined as child node of the PCI controller.
> +
> +pci {
> +	pcie@0 {
> +		reg = <0 0 0 0 0>;
> +		#interrupt-cells = <1>;
> +		#size-cells = <2>;
> +		#address-cells = <3>;
> +		device_type = "pci";
> +
> +		ath9k@0,0 {
> +			compatible = "qca,ath9k";
> +			reg = <0 0 0 0 0>;
> +			device_type = "pci";

Is this just a copy-paste or should device_type be specified?

Regards,
Arend
