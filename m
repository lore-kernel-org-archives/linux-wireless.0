Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34193 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753082AbcJIBbY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Oct 2016 21:31:24 -0400
Date: Sat, 8 Oct 2016 20:28:56 -0500
From: Rob Herring <robh@kernel.org>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: ath9k-devel@lists.ath9k.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        mcgrof@do-not-panic.com, mark.rutland@arm.com,
        kvalo@codeaurora.org, chunkeey@googlemail.com,
        arend.vanspriel@broadcom.com, julian.calaby@gmail.com,
        bjorn@mork.no, linux@rempel-privat.de, nbd@nbd.name
Subject: Re: [PATCH v7 1/3] Documentation: dt: net: add ath9k wireless device
 binding
Message-ID: <20161009012856.GK18158@rob-hp-laptop> (sfid-20161009_033130_922925_B09DE0F5)
References: <20160906214623.20424-1-martin.blumenstingl@googlemail.com>
 <20161002214743.2263-1-martin.blumenstingl@googlemail.com>
 <20161002214743.2263-2-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161002214743.2263-2-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 02, 2016 at 11:47:41PM +0200, Martin Blumenstingl wrote:
> Add documentation how devicetree can be used to configure ath9k based
> devices.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  .../devicetree/bindings/net/wireless/qca,ath9k.txt | 30 ++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
> new file mode 100644
> index 0000000..9b58ede
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
> @@ -0,0 +1,30 @@
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

Are there some known values you can document here? Like the one in the 
example.

> +- reg: Address and length of the register set for the device.
> +
> +Optional properties:
> +- qca,no-eeprom: Indicates that there is no physical EEPROM connected to the
> +			ath9k wireless chip (in this case the calibration /
> +			EEPROM data will be loaded from userspace using the
> +			kernel firmware loader).
> +- mac-address: See ethernet.txt in the parent directory
> +- local-mac-address: See ethernet.txt in the parent directory
> +
> +
> +In this example, the node is defined as child node of the PCI controller:
> +&pci0 {
> +	ath9k@168c,002d {

wifi@...

> +		compatible = "pci168c,002d";
> +		reg = <0x7000 0 0 0 0x1000>;
> +		qca,no-eeprom;
> +	};
> +};
> -- 
> 2.10.0
> 
