Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:34516 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751654AbdBOWdg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 17:33:36 -0500
Date: Wed, 15 Feb 2017 16:33:24 -0600
From: Rob Herring <robh@kernel.org>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        sgruszka@redhat.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 1/3] Documentation: dt: net: add mt76 wireless device
 binding
Message-ID: <20170215223324.r7cgljfqkulyuany@rob-hp-laptop> (sfid-20170215_233352_201110_43BF6B47)
References: <20170207202035.64224-1-nbd@nbd.name>
 <20170207202035.64224-2-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170207202035.64224-2-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 07, 2017 at 09:20:33PM +0100, Felix Fietkau wrote:
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Commit msg? Also, use "dt-bindings: net: " for the subject prefix.

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
> +
> +&pcie {
> +	status = "okay";
> +
> +	pcie0 {
> +		wifi@0,0 {
> +			reg = <0x0000 0 0 0 0>;
> +			ieee80211-freq-limit = <5000000 6000000>;
> +			mediatek,mtd-eeprom = <&factory 0x8000>;
> +		};
> +	};
> +};
> -- 
> 2.11.0
> 
