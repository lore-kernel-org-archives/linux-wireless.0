Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33379 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752032AbcIPMh1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Sep 2016 08:37:27 -0400
Date: Fri, 16 Sep 2016 07:37:25 -0500
From: Rob Herring <robh@kernel.org>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: ath9k-devel@lists.ath9k.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        mcgrof@do-not-panic.com, mark.rutland@arm.com,
        kvalo@codeaurora.org, chunkeey@googlemail.com,
        arend.vanspriel@broadcom.com, julian.calaby@gmail.com,
        bjorn@mork.no, linux@rempel-privat.de, nbd@nbd.name
Subject: Re: [PATCH v6 1/3] Documentation: dt: net: add ath9k wireless device
 binding
Message-ID: <20160916123724.GA9689@rob-hp-laptop> (sfid-20160916_143731_793084_721E1578)
References: <20160821143105.27487-1-martin.blumenstingl@googlemail.com>
 <20160906214623.20424-1-martin.blumenstingl@googlemail.com>
 <20160906214623.20424-2-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160906214623.20424-2-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 06, 2016 at 11:46:21PM +0200, Martin Blumenstingl wrote:
> Add documentation how devicetree can be used to configure ath9k based
> devices.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  .../devicetree/bindings/net/wireless/qca,ath9k.txt | 39 ++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
> new file mode 100644
> index 0000000..77b9202
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
> @@ -0,0 +1,39 @@
> +* Qualcomm Atheros ath9k wireless devices
> +
> +This node provides properties for configuring the ath9k wireless device. The
> +node is expected to be specified as a child node of the PCI controller to
> +which the wireless chip is connected.
> +
> +Required properties:
> +- compatible: For PCI and PCIe devices this should be an identifier following
> +		the format as defined in "PCI Bus Binding to Open Firmware"
> +		Revision 2.1. One of the possible formats is "pciVVVV,DDDD"
> +		where VVVV is the PCI vendor ID and DDDD is PCI device ID.
> +
> +Optional properties:
> +- reg: Address and length of the register set for the device.

reg is not optional.

> +- qca,clk-25mhz: Defines that a 25MHz clock is used
> +- qca,no-eeprom: Indicates that there is no physical EEPROM connected to the
> +			ath9k wireless chip (in this case the calibration /
> +			EEPROM data will be loaded from userspace using the
> +			kernel firmware loader).
> +- qca,disable-2ghz: Overrides the settings from the EEPROM and disables the
> +			2.4GHz band. Setting this property is only needed
> +			when the RF circuit does not support the 2.4GHz band
> +			while it is enabled nevertheless in the EEPROM.
> +- qca,disable-5ghz: Overrides the settings from the EEPROM and disables the
> +			5GHz band. Setting this property is only needed when
> +			the RF circuit does not support the 5GHz band while
> +			it is enabled nevertheless in the EEPROM.
> +- mac-address: See ethernet.txt in the parent directory
> +- local-mac-address: See ethernet.txt in the parent directory
> +
> +
> +In this example, the node is defined as child node of the PCI controller:
> +&pci0 {
> +	ath9k@168c,002d {

unit address is not the vendor/device ID, but the reg value. So 
'@7000,0,0' I think in this case. Double check the OF PCI bus binding.


> +		compatible = "pci168c,002d";
> +		reg = <0x7000 0 0 0 0x1000>;
> +		qca,disable-5ghz;
> +	};
> +};
> -- 
> 2.9.3
> 
