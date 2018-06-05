Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33852 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752758AbeFEXST (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Jun 2018 19:18:19 -0400
Received: by mail-pg0-f68.google.com with SMTP id q4-v6so931070pgr.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jun 2018 16:18:19 -0700 (PDT)
Date: Tue, 5 Jun 2018 16:18:16 -0700
From: Brian Norris <briannorris@chromium.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: devicetree@vger.kernel.org, andy.gross@linaro.org,
        bjorn.andersson@linaro.org, david.brown@linaro.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v2 3/6] dt: bindings: add bindings for msa memory region
Message-ID: <20180605231814.GB194157@rodete-desktop-imager.corp.google.com> (sfid-20180606_011825_596901_7FD6ABC4)
References: <20180605123616.528-1-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180605123616.528-1-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Rob

On Tue, Jun 05, 2018 at 06:06:16PM +0530, Govind Singh wrote:
> Add device tree binding documentation details of msa
> memory region for ath10k qmi client for SDM845/APQ8098
> SoC into "qcom,ath10k.txt".
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  .../devicetree/bindings/net/wireless/qcom,ath10k.txt          | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> index 7fd4e8ce4149..0efc47f4ba34 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> @@ -56,6 +56,8 @@ Optional properties:
>  				     the length can vary between hw versions.
>  - <supply-name>-supply: handle to the regulator device tree node
>  			   optional "supply-name" is "vdd-0.8-cx-mx".
> +- msa-fixed-region: phandle, specifier to children of reserved MSA memory.

As in reserved-memory/reserved-memory.txt? Might refer to that doc here.
Or is this some other kind of reserved memory?

If the former, it's normally called just "memory-region", although
that does seem somewhat non-descriptive...

> +- msa-size: MSA memory size for fw internal use.

Do you really need both of these? It seems like your code uses one or
the other, not both. In which case, this is not a very good description,
because it sounds like they would go together.

Also, if you're not using standard/generic properties (e.g., the
aforementioned "memory-region" binding), you typically should use a
vendor prefix, like "qcom,msa-size".

Brian

>  
>  Example (to supply the calibration data alone):
>  
> @@ -133,6 +135,8 @@ wifi@18000000 {
>  		compatible = "qcom,wcn3990-wifi";
>  		reg = <0x18800000 0x800000>;
>  		reg-names = "membase";
> +		msa-fixed-region = <&wlan_msa_mem>;
> +		msa-size = <0x100000>;
>  		clocks = <&clock_gcc clk_aggre2_noc_clk>;
>  		clock-names = "smmu_aggre2_noc_clk"
>  		interrupts =
> -- 
> 2.17.0
> 
