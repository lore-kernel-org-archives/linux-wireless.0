Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36420 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389066AbeGKPcL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jul 2018 11:32:11 -0400
Date: Wed, 11 Jul 2018 09:27:18 -0600
From: Rob Herring <robh@kernel.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: devicetree@vger.kernel.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, andy.gross@linaro.org,
        niklas.cassel@linaro.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 3/6] dt: bindings: add bindings for msa memory region
Message-ID: <20180711152718.GA18470@rob-hp-laptop> (sfid-20180711_172731_232930_42AAEDFF)
References: <20180706090043.28363-1-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180706090043.28363-1-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 06, 2018 at 02:30:43PM +0530, Govind Singh wrote:
> Add device tree binding documentation details of msa
> memory region for ath10k qmi client for SDM845/APQ8098
> SoC into "qcom,ath10k.txt".
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  .../bindings/net/wireless/qcom,ath10k.txt           | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> index 7fd4e8ce4149..87489054aea5 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> @@ -57,6 +57,16 @@ Optional properties:
>  - <supply-name>-supply: handle to the regulator device tree node
>  			   optional "supply-name" is "vdd-0.8-cx-mx".
>  
> += SUBNODES:
> +wcn3990-wifi node may contain one subnode, named "msa" representing
> +the fixed msa memory regions used by the wifi firmware running in Q6.
> +This sub-node must contain:

Why do you need a sub-node? Just add memory-region property.

> +
> +- memory-region:
> +	Usage: required
> +	Value type: <phandle>
> +	Definition: reference to the reserved-memory for the region
> +
>  Example (to supply the calibration data alone):
>  
>  In this example, the node is defined as child node of the PCI controller.
> @@ -149,4 +159,7 @@ wifi@18000000 {
>  			   <0 140 0 /* CE10 */ >,
>  			   <0 141 0 /* CE11 */ >;
>  		vdd-0.8-cx-mx-supply = <&pm8998_l5>;
> +		msa {
> +			memory-region = <&wifi_msa_mem>;
> +		};
>  };
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
