Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:50244 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751057AbdJMTHv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 15:07:51 -0400
Date: Fri, 13 Oct 2017 14:07:49 -0500
From: Rob Herring <robh@kernel.org>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v6 1/3] dt-bindings: net: add mt76 wireless device binding
Message-ID: <20171013190749.lzzw4zjzt7fkp3hs@rob-hp-laptop> (sfid-20171013_210755_855376_4D9B4427)
References: <20171006110249.31013-1-nbd@nbd.name>
 <20171006110249.31013-2-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171006110249.31013-2-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 06, 2017 at 01:02:47PM +0200, Felix Fietkau wrote:
> Add documentation describing how device tree can be used to configure
> wireless chips supported by the mt76 driver.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  .../bindings/net/wireless/mediatek,mt76.txt        | 24 ++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
> new file mode 100644
> index 000000000000..19522ab97d62
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
> @@ -0,0 +1,24 @@
> +* MediaTek mt76xx devices
> +
> +This node provides properties for configuring the MediaTek mt76xx wireless
> +device. The node is expected to be specified as a child node of the PCI
> +controller to which the wireless chip is connected.
> +
> +Optional properties:
> +
> +- mac-address: See ethernet.txt in the parent directory
> +- local-mac-address: See ethernet.txt in the parent directory
> +- ieee80211-freq-limit: See ieee80211.txt
> +- mediatek,mtd-eeprom: Specify a MTD partition + offset containing EEPROM data

MTD is a Linuxism. And is an EEPROM the only supported device? I'd 
suggest naming if after what the data contains.

> +
> +&pcie {
> +	status = "okay";

Don't show status in examples.

> +
> +	pcie0 {
> +		wifi@0,0 {

You need a compatible here too.

> +			reg = <0x0000 0 0 0 0>;
> +			ieee80211-freq-limit = <5000000 6000000>;
> +			mediatek,mtd-eeprom = <&factory 0x8000>;
> +		};
> +	};
> +};
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
