Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE4BC64EAD
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 06:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A74721479
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 06:33:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="jRu9+gif"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A74721479
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbeJINsb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 09:48:31 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40641 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbeJINsb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 09:48:31 -0400
Received: by mail-pl1-f194.google.com with SMTP id 1-v6so300272plv.7
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2018 23:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aUIyXrhAfdj/xqdNpSPiEGhgDEIuGyEe6vuCPF1Zp7I=;
        b=jRu9+gifnZH9HzGfDnqCrppkaLesve4DIm97Xdil55dY1TU4HHl1SYnziTE+bqXsWS
         xw6sixdgo6LRcHwb54c0Rcf/RAI8iKqmlKDnRuBHpMy1Z4W0gANR7oBMLG2F/YSyy78n
         h4ELsLgH6JOkkW1WWqXdLyGuQA4c/hUn6RA1A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aUIyXrhAfdj/xqdNpSPiEGhgDEIuGyEe6vuCPF1Zp7I=;
        b=nTuH40TYs46NPs/0nebIMHslcjL7BI05BvgewF1eXV9BvbflD7YS2D8ef2BgTYBai9
         HUDe0uxKwS6cxyAxnFXgJPcfVJCCSlRrlnLFFkdBhGB5p9cqxtjXlSvHLOrLi1B/b5w5
         h02xIOcWp3MhykBJ801c8wwyJiGnblTY4Z8ENcyi817Zr7CV3ecdxELMklXMM+egGYEp
         J7dMoiRfVuBGaPYyZ/nd4y4/PK4fGCgDbwHzR9oTqokBlTI0l0+ZJhv1Ex/8xlC5E2DW
         1d62xPvGlOFBS5FMQNf96wCw48/SZGzkJ91wtmv+y660xmYAza1s1MCiGeOP2ffJx44G
         H0og==
X-Gm-Message-State: ABuFfoj6KvQ0CM1eNVDh4jz918pFtqvePRkacG/I0IlW+3bePelBT0Hj
        85KtW/eAqSWJBx75jz3+gNoECA==
X-Google-Smtp-Source: ACcGV63z2FRppf9V/3Z3Ub6CHd3MUt69yeV8NgUDAq6dDMUn8+14I06xMnbHL2gr66qmQq1t881dfw==
X-Received: by 2002:a17:902:447:: with SMTP id 65-v6mr27033738ple.325.1539066789430;
        Mon, 08 Oct 2018 23:33:09 -0700 (PDT)
Received: from tuxbook-pro (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id o62-v6sm25840261pfb.0.2018.10.08.23.33.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Oct 2018 23:33:08 -0700 (PDT)
Date:   Mon, 8 Oct 2018 23:33:06 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     ath10k@lists.infradead.org, briannorris@chromium.org,
        niklas.cassel@linaro.org, andy.gross@linaro.org,
        devicetree@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5 3/6] dt: bindings: add bindings for msa memory region
Message-ID: <20181009063306.GD8498@tuxbook-pro>
References: <20180815092637.11455-1-govinds@codeaurora.org>
 <20180815092637.11455-4-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180815092637.11455-4-govinds@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed 15 Aug 02:26 PDT 2018, Govind Singh wrote:

> Add device tree binding documentation details of msa
> memory region for ath10k qmi client for SDM845/APQ8098
> SoC into "qcom,ath10k.txt".
> 

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  .../devicetree/bindings/net/wireless/qcom,ath10k.txt        | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> index 7fd4e8ce4149..2196d1ab3c8c 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> @@ -56,6 +56,11 @@ Optional properties:
>  				     the length can vary between hw versions.
>  - <supply-name>-supply: handle to the regulator device tree node
>  			   optional "supply-name" is "vdd-0.8-cx-mx".
> +- memory-region:
> +	Usage: optional
> +	Value type: <phandle>
> +	Definition: reference to the reserved-memory for the msa region
> +		    used by the wifi firmware running in Q6.
>  
>  Example (to supply the calibration data alone):
>  
> @@ -149,4 +154,5 @@ wifi@18000000 {
>  			   <0 140 0 /* CE10 */ >,
>  			   <0 141 0 /* CE11 */ >;
>  		vdd-0.8-cx-mx-supply = <&pm8998_l5>;
> +		memory-region = <&wifi_msa_mem>;
>  };
> -- 
> 2.17.0
> 
