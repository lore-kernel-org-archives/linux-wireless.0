Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:39261 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbeEKRJk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 13:09:40 -0400
Received: by mail-pg0-f65.google.com with SMTP id e1-v6so2689618pga.6
        for <linux-wireless@vger.kernel.org>; Fri, 11 May 2018 10:09:40 -0700 (PDT)
Date: Fri, 11 May 2018 10:11:01 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 02/12] dt: bindings: add bindings for ath10k qmi client
Message-ID: <20180511171101.GN2259@tuxbook-pro> (sfid-20180511_190944_308090_8D21113C)
References: <1522042748-25677-1-git-send-email-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1522042748-25677-1-git-send-email-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun 25 Mar 22:39 PDT 2018, Govind Singh wrote:

> Add device tree binding documentation details for ath10k
> qmi client for SDM845/APQ8098 SoC into "qcom,ath10k.txt".
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> index 34e4f98..8076ae3 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> @@ -5,6 +5,7 @@ Required properties:
>  	* "qcom,ath10k"
>  	* "qcom,ipq4019-wifi"
>  	* "qcom,wcn3990-wifi"
> +	* "qcom,ath10k-qmi"
>  
>  PCI based devices uses compatible string "qcom,ath10k" and takes calibration
>  data along with board specific data via "qcom,ath10k-calibration-data".
> @@ -21,6 +22,8 @@ can be provided per device.
>  
>  SNOC based devices (i.e. wcn3990) uses compatible string "qcom,wcn3990-wifi".
>  
> +- qcom,wlan-msa-memory: MSA memory size
> +
>  Optional properties:
>  - reg: Address and length of the register set for the device.
>  - reg-names: Must include the list of following reg names,
> @@ -150,3 +153,8 @@ qcom,wifi@18000000 {
>  			   <0 141 0 /* CE11 */ >;
>  		vdd-0.8-cx-mx-supply = <&pm8998_l5>;
>  };
> +
> +qcom,ath10k-qmi {
> +	compatible = "qcom,ath10k-qmi";
> +	qcom,wlan-msa-memory = <0x100000>;

Is this a complete example for what's needed to get working WiFi?
> +};

Regards,
Bjorn
