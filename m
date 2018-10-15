Return-Path: <SRS0=ZQ3y=M3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78BFEC04AA5
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 19:24:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 492C3208D9
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 19:24:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 492C3208D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbeJPDLE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Oct 2018 23:11:04 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:47020 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbeJPDLE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Oct 2018 23:11:04 -0400
Received: by mail-oi1-f196.google.com with SMTP id k64-v6so16003979oia.13;
        Mon, 15 Oct 2018 12:24:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8B39x+jqS06iAuKOOGFmx0QmnL0MqrEGHcKu2LHqoYQ=;
        b=Ml6IIFuM94aZtZ54DLa0x5MTevzRNBxn+b+Zy4QHF9myvZRlX3+54v9hI5I4c2iseJ
         7FxRGwfc5gq0wxRcECHO5bIGXzRnnRAkyw3UpezUV83bg77/j5umRCGLLE4kQ1OypKnL
         R61Mo3FTufcZHfkojZ+1HQmAHZ3ceNSqDlSl4uhWl5UZCIWxTagh0mHzLh3/z1F/pDYB
         Qk/Cl+gld84iZWd8BAbQ+VU6ABucK82DgCJNMTgOHLYqAgdX0LGDk6t+OgNfZkiPifa6
         SqlEdHAvLyZrJk/8N/P2QTk6mTBt3e7vbY2S9q2PdTwdZ7WkxHr0xnXPdGwkSH78Raqi
         TBtw==
X-Gm-Message-State: ABuFfohYU4Sg9Z+OL8wYk4x8UPiERyCxeBYME59WQ5rkl+0aImOt0gT3
        OTfH79kHpiy1SOA+uffP4A==
X-Google-Smtp-Source: ACcGV614wUBbYan4qSOH3Z4W91JJXugTK253ixu2aCHB1EVRPhWU69SJrKwEZtAfseWMlXVMotNEtA==
X-Received: by 2002:aca:3195:: with SMTP id x143-v6mr9433739oix.213.1539631467206;
        Mon, 15 Oct 2018 12:24:27 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id t69sm3743198ota.10.2018.10.15.12.24.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Oct 2018 12:24:26 -0700 (PDT)
Date:   Mon, 15 Oct 2018 14:24:25 -0500
From:   Rob Herring <robh@kernel.org>
To:     Bhagavathi Perumal S <bperumal@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] dt: bindings: add new dt entry to indentify external
 FEM
Message-ID: <20181015192425.GA19699@bogus>
References: <1538653364-1239-1-git-send-email-bperumal@codeaurora.org>
 <1538653364-1239-2-git-send-email-bperumal@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538653364-1239-2-git-send-email-bperumal@codeaurora.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Oct 04, 2018 at 05:12:43PM +0530, Bhagavathi Perumal S wrote:
> This adds new dt entry ext-fem-name, it is used by ath10k driver
> to select correct timing parameters and configure it in target wifi hardware.
> The Front End Module(FEM) normally includes tx power amplifier(PA) and
> rx low noise amplifier(LNA). The default timing parameters like tx end to
> PA off timing values were fine tuned for internal FEM used in reference
> design. And these timing values can not be same if ODM modifies hardware
> design with different external FEM. This DT entry helps to choose correct
> timing values in driver if different external FEM hardware used.

'dt-bindings: net: ath10k: ...' for the subject please.

> 
> Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>
> ---
>  .../bindings/net/wireless/qcom,ath10k.txt          | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> index 7fd4e8c..fbaf309 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> @@ -56,6 +56,7 @@ Optional properties:
>  				     the length can vary between hw versions.
>  - <supply-name>-supply: handle to the regulator device tree node
>  			   optional "supply-name" is "vdd-0.8-cx-mx".
> +- ext-fem-name: name of external front end module used.

What are valid names? What if the OS doesn't recognize the name? Perhaps 
this should be a compatible string for the particular module instead? 
Then it could cover any differences, not just the FEM.

>  
>  Example (to supply the calibration data alone):
>  
> @@ -150,3 +151,24 @@ wifi@18000000 {
>  			   <0 141 0 /* CE11 */ >;
>  		vdd-0.8-cx-mx-supply = <&pm8998_l5>;
>  };
> +
> +Example (to supply the external front end module name):
> +
> +In this example, the front end module is defined as a property of the ath10k
> +device node.

Really need a whole new example for 1 property?

> +
> +pci {
> +	pcie@0 {
> +		reg = <0 0 0 0 0>;
> +		#interrupt-cells = <1>;
> +		#size-cells = <2>;
> +		#address-cells = <3>;
> +		device_type = "pci";
> +
> +		ath10k@0,0 {

wifi@0,0

> +			reg = <0 0 0 0 0>;
> +			device_type = "pci";
> +			ext-fem-name = "microsemi-lx5586";
> +		};
> +	};
> +};
> -- 
> 1.9.1
> 
