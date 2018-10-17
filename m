Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9605ECDE30
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 07:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 907A021527
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 07:41:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="2JZzOk2m"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 907A021527
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbeJQPfx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 11:35:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726691AbeJQPfx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 11:35:53 -0400
Received: from localhost (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6C33214C3;
        Wed, 17 Oct 2018 07:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1539762089;
        bh=F8YLvT+ikiPRQP11Nx/hqEUvoNtGMxKGBg8AfjpJUCs=;
        h=To:From:In-Reply-To:Cc:References:Subject:Date:From;
        b=2JZzOk2miaB/RlN7sX5UQKZe/YLpp0idMbqIPKTKgBMjKPjAkq/ZP361P4FSObljG
         0DbP3bVWRJ5Ae2IF4iIZNuxKFmyT7QWfdppD1Ny2P/Cpou/gA3aNIkZbKbfD4foAD5
         BtHBq56hFqjaRLSeJdizIAMYP9hNV4EbEDvN+o5E=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
To:     Govind Singh <govinds@codeaurora.org>, andy.gross@linaro.org,
        ath10k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-wireless@vger.kernel.org, robh+dt@kernel.org
From:   Stephen Boyd <sboyd@kernel.org>
In-Reply-To: <1539172376-19269-2-git-send-email-govinds@codeaurora.org>
Cc:     Govind Singh <govinds@codeaurora.org>
References: <1539172376-19269-1-git-send-email-govinds@codeaurora.org>
 <1539172376-19269-2-git-send-email-govinds@codeaurora.org>
Message-ID: <153976208916.5275.15753381614937010537@swboyd.mtv.corp.google.com>
User-Agent: alot/0.7
Subject: Re: [PATCH v3 1/3] dt: bindings: add missing dt properties for WCN3990 wifi
 node
Date:   Wed, 17 Oct 2018 00:41:29 -0700
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Quoting Govind Singh (2018-10-10 04:52:54)
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.t=
xt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> index 7fd4e8c..f831bb1 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> @@ -37,12 +37,20 @@ Optional properties:
>  - clocks: List of clock specifiers, must contain an entry for each requi=
red
>            entry in clock-names.
>  - clock-names: Should contain the clock names "wifi_wcss_cmd", "wifi_wcs=
s_ref",
> -               "wifi_wcss_rtc".
> -- interrupts: List of interrupt lines. Must contain an entry
> -             for each entry in the interrupt-names property.
> +              "wifi_wcss_rtc" for "qcom,ipq4019-wifi" compatible target =
and
> +              "cxo_ref_clk_pin", "smmu_aggre2_noc_clk" for "qcom,wcn3990=
-wifi"
> +              compatible target.
> +- interrupts: reference to the list of 17 interrupt no's for "qcom,ipq40=
19-wifi"

Nitpick: Can you write out "numbers" instead of "no's"?

> +             compatible target.
> +             reference to the list of 12 interrupt no's for "qcom,wcn399=
0-wifi"
> +             compatible target.
> +             Must contain interrupt-names property per entry for
> +             "qcom,ath10k", "qcom,ipq4019-wifi" compatible targets.
> +
>  - interrupt-names: Must include the entries for MSI interrupt
>                    names ("msi0" to "msi15") and legacy interrupt
> -                  name ("legacy"),
> +                  name ("legacy") for "qcom,ath10k", "qcom,ipq4019-wifi"
> +                  compatible targets.
>  - qcom,msi_addr: MSI interrupt address.
>  - qcom,msi_base: Base value to add before writing MSI data into
>                 MSI address register.
> @@ -55,7 +63,8 @@ Optional properties:
>  - qcom,ath10k-pre-calibration-data : pre calibration data as an array,
>                                      the length can vary between hw versi=
ons.
>  - <supply-name>-supply: handle to the regulator device tree node
> -                          optional "supply-name" is "vdd-0.8-cx-mx".
> +                          optional "supply-name" are "vdd-0.8-cx-mx",
> +                          "vdd-1.8-xo", "vdd-1.3-rfa" and "vdd-3.3-ch0".

Why can't the wifi firmware manage these regulators itself?

And these names don't seem to match any sort of schematic or really
describe what this device is. From what I can tell, we've combined the
off-SoC wifi module with the on-SoC wifi I/O space into one DT node here
and then relied on that node to make some driver probe in the kernel to
do wifi stuff. Can we model this properly by actually showing that
there's something in the SoC, and there's something outside the SoC, and
these two things are connected by having two nodes and a phandle between
them?

>  =

>  Example (to supply the calibration data alone):
>  =

> @@ -133,8 +142,10 @@ wifi@18000000 {
>                 compatible =3D "qcom,wcn3990-wifi";
>                 reg =3D <0x18800000 0x800000>;
>                 reg-names =3D "membase";
> -               clocks =3D <&clock_gcc clk_aggre2_noc_clk>;
> -               clock-names =3D "smmu_aggre2_noc_clk"
> +               clocks =3D <&clock_gcc clk_aggre2_noc_clk>,
> +                        <&clock_gcc clk_rf_clk2_pin>;
> +               clock-names =3D "smmu_aggre2_noc_clk",
> +                             "cxo_ref_clk_pin";
>                 interrupts =3D
>                            <0 130 0 /* CE0 */ >,
>                            <0 131 0 /* CE1 */ >,
