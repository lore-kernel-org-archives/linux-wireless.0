Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8973DC65C20
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 19:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4263B2145D
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 19:44:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="bWcC740k"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4263B2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbeJIC5t (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 22:57:49 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33680 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbeJIC5t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 22:57:49 -0400
Received: by mail-pg1-f195.google.com with SMTP id y18-v6so8297507pge.0
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2018 12:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ssAo1Q+Vh/jWBDeVAtfdBcxcpqaZqoB+cW98jZCvJ4s=;
        b=bWcC740kaFIkIr51QNirUxN1uINvOapPUg22obslhb2rFdtI9ohUFKHlzD7fLBUMF6
         MmaQyZEyHXj0lQtRBn+62tYWk2yv+aItJexJx1wY0biZm32AnLoTIo2tLk1GEqDU1568
         tAPeHjMK9lPWGB9cSR/pbPPnQXA5UKRPEBoq8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ssAo1Q+Vh/jWBDeVAtfdBcxcpqaZqoB+cW98jZCvJ4s=;
        b=nnl7LgArycqA+kYQxCXHiDpzfqkk+9NokptCSX65tcheB2DErSn79ldip2lUN5wHbG
         KUsiQKrWGnu/ctsV8B78CDj6HEUZ3t4p2Bifi/+30aQlyOKUw4TGN/4Ml+CQ0XQHQ/jt
         liJlXPhs/O26SYQezuWvKYZvojgJU9ObdEHDr5RBT1RCLnyHf8z9mRDLdwsd+RNYulri
         sp4zDhhv23tqdLmaCLHcVugKvTZLX/N6M/qVfCJBqhceN8G+g3z7F08MQKyM1tDICSTQ
         wHHh8dfsqfxXNVPbh16kXccCGc023s32VBRB6ur4JLGRz6NfwECS4kMP+3PTKwbsFjuB
         Nx6w==
X-Gm-Message-State: ABuFfojc0fsRH7nWhCwb+vOjvSsFYDSdI9KmZ/Klg8CE5bRWdGVEagpk
        bIEQzd7O4d/rdzt+z/+aYjZDqw==
X-Google-Smtp-Source: ACcGV60vL+Q2yrxdHp44p+NMAfhOHjY5swWl21QNjuE4smk+r7Wz0VN9Jq1A379zwuzPsfnjMgNLSQ==
X-Received: by 2002:a63:dd0a:: with SMTP id t10-v6mr22537867pgg.379.1539027866972;
        Mon, 08 Oct 2018 12:44:26 -0700 (PDT)
Received: from ban.mtv.corp.google.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id n7-v6sm6695308pgv.63.2018.10.08.12.44.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Oct 2018 12:44:25 -0700 (PDT)
Date:   Mon, 8 Oct 2018 12:44:23 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        andy.gross@linaro.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org
Subject: Re: [PATCH v2 2/4] dts: arm64/sdm845: Add WCN3990 WLAN module device
 node
Message-ID: <20181008194422.GA124443@ban.mtv.corp.google.com>
References: <20181001112636.31715-1-govinds@codeaurora.org>
 <20181001112636.31715-3-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181001112636.31715-3-govinds@codeaurora.org>
User-Agent: Mutt/1.10.1+48 (1f3a9df87d11) (2018-07-22)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ linux-msm, linux-soc

Hi Govind,

On Mon, Oct 01, 2018 at 04:56:34PM +0530, Govind Singh wrote:
> Add device node for the ath10k SNOC platform driver probe
> and add resources required for WCN3990 on SDM845 soc.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  arch/arm64/boot/dts/qcom/sdm845-mtp.dts |  7 +++++++
>  arch/arm64/boot/dts/qcom/sdm845.dtsi    | 26 +++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sdm845-mtp.dts b/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
> index eedfaf8922e2..4de57f7df93c 100644
> --- a/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
> +++ b/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
> @@ -440,3 +440,10 @@
>  		bias-pull-up;
>  	};
>  };
> +
> +&wifi {

You missed overriding 'status':

	status = "okay";

Also, I think pinctrl overrides are purposely kept separate from other
node modifications here (see the /* PINCTRL - ... */ comment header). So
&wifi should probably be just after the &usb_2_qmpphy override I
currently see in linux-next.

Brian

> +	vdd-0.8-cx-mx-supply = <&vreg_l5a_0p8>;
> +	vdd-1.8-xo-supply = <&vreg_l7a_1p8>;
> +	vdd-1.3-rfa-supply = <&vreg_l17a_1p3>;
> +	vdd-3.3-ch0-supply = <&vreg_l25a_3p3>;
> +};
> diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> index e080072cdfdb..36c716cf3a0c 100644
> --- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> @@ -86,6 +86,11 @@
>  			reg = <0 0x86200000 0 0x2d00000>;
>  			no-map;
>  		};
> +
> +		wlan_msa_mem: reserved-memory@96700000 {
> +			no-map;
> +			reg = <0 0x96700000 0 0x100000>;
> +		};
>  	};
>  
>  	cpus {
> @@ -1200,5 +1205,26 @@
>  				status = "disabled";
>  			};
>  		};
> +
> +		wifi: wifi@18800000 {
> +			compatible = "qcom,wcn3990-wifi";
> +			status = "disabled";
> +			reg = <0x18800000 0x800000>;
> +			reg-names = "membase";
> +			memory-region = <&wlan_msa_mem>;
> +			interrupts =
> +				<0 413 0 /* CE0 */ >,
> +				<0 414 0 /* CE1 */ >,
> +				<0 415 0 /* CE2 */ >,
> +				<0 416 0 /* CE3 */ >,
> +				<0 417 0 /* CE4 */ >,
> +				<0 418 0 /* CE5 */ >,
> +				<0 420 0 /* CE6 */ >,
> +				<0 421 0 /* CE7 */ >,
> +				<0 422 0 /* CE8 */ >,
> +				<0 423 0 /* CE9 */ >,
> +				<0 424 0 /* CE10 */ >,
> +				<0 425 0 /* CE11 */ >;
> +		};
>  	};
>  };
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
