Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34445 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754217AbdBGTSM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 14:18:12 -0500
Received: by mail-oi0-f68.google.com with SMTP id w144so9565334oiw.1
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2017 11:18:12 -0800 (PST)
Date: Tue, 7 Feb 2017 12:43:56 -0600
From: Rob Herring <robh@kernel.org>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 1/3] Documentation: dt: net: add mt76 wireless device
 binding
Message-ID: <20170207184356.hujknabzd7plrj6w@rob-hp-laptop> (sfid-20170207_201815_774778_08F0D86A)
References: <20170202115208.8614-1-nbd@nbd.name>
 <20170202115208.8614-2-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170202115208.8614-2-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 02, 2017 at 12:52:06PM +0100, Felix Fietkau wrote:
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  .../bindings/net/wireless/mediatek,mt76.txt        | 25 ++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
> new file mode 100644
> index 000000000000..2be480c0eab8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
> @@ -0,0 +1,25 @@
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
> +		mt76@0,0 {

wifi@0,0

> +			reg = <0x0000 0 0 0 0>;
> +			device_type = "pci";

This only applies to PCI bridge nodes, so drop.

> +			ieee80211-freq-limit = <5000000 6000000>;
> +			mediatek,mtd-eeprom = <&factory 0x8000>;
> +		};
> +	};
> +};
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
