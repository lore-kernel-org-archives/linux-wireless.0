Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C15C67879
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 01:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75C5720C0A
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 01:30:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hIT5PdgB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75C5720C0A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbeJIIo7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 04:44:59 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44637 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbeJIIo7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 04:44:59 -0400
Received: by mail-pf1-f195.google.com with SMTP id r9-v6so9029611pff.11
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2018 18:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sljMj4Ke5C0iXblyHITF02XI0HyjpIUZ3xdXa/7tRgY=;
        b=hIT5PdgBoPbYW2kb6VF6wTDDj0JtY0hPZdDji4iIznHwALOsFPZlRcScfRgccp4CIx
         0v2sWSlBIcpKv0Q5AlfY5IgoOxiHfz5AOqvoqYxHALiwsDtVTKUsH1ykU1k2EQibt6Ww
         DWG6ivCUlEMRe+fkL9mL8GpAGvin6GOiwn2Bo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sljMj4Ke5C0iXblyHITF02XI0HyjpIUZ3xdXa/7tRgY=;
        b=deOsoRAj+js4dEbQe2TufO9lTiSuZrTDMhrjpJate22qbuGSbTj/Zka4u8LtDQG0PN
         oDBI/FOYE9yQRQCJFa+GlxcdUrFyTMaYN6N6E9Vo31iz1sJAq5HIyOnt9ULaZla6MnUm
         pyiX8VMw5wXySs3iweqmCTh/rNiogKPyvMR/Rdw8UN81O7zZi1AUNyYBtcwwRCtgF2Na
         VO1+nCjuXLwUofXHM8MkOjYdCfQIXeItzerV5WHhnTozEDSNcsTihYK3uuhJ4smLkCBB
         U/sb3TQSd2Hj2IUkqzJmoyEypWihzNpL4I7ErDQKJIcPHoCaMDLIUhIn+J78b/u7BNg9
         sbdw==
X-Gm-Message-State: ABuFfoipDaO57Co9tdZNN/2XAb3ShaTfs8cQ1oQ06nLHGti8PLYVZ6Di
        rr8BhpcCWHc+rP5NdSZCKjfxiw==
X-Google-Smtp-Source: ACcGV63xw9uUnWPjTMtUyAfQ3/DMIT1ssFXONilUyPgqMRTiXVcYSr146AodYqs0lhN+Ckq4aH7jgQ==
X-Received: by 2002:a63:d048:: with SMTP id s8-v6mr23198222pgi.311.1539048631032;
        Mon, 08 Oct 2018 18:30:31 -0700 (PDT)
Received: from ban.mtv.corp.google.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id r18-v6sm16267947pgv.17.2018.10.08.18.30.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Oct 2018 18:30:29 -0700 (PDT)
Date:   Mon, 8 Oct 2018 18:30:27 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        andy.gross@linaro.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org, Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 4/4] dts: arm64/sdm845: Enable iommu for WCN3990 wifi
 module device node
Message-ID: <20181009013026.GA83814@ban.mtv.corp.google.com>
References: <20181001112636.31715-1-govinds@codeaurora.org>
 <20181001112636.31715-5-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181001112636.31715-5-govinds@codeaurora.org>
User-Agent: Mutt/1.10.1+48 (1f3a9df87d11) (2018-07-22)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ linux-msm, linux-soc

On Mon, Oct 01, 2018 at 04:56:36PM +0530, Govind Singh wrote:
> WCN3990 wifi module can optionally make use of the IOMMU.
> Add phandle to the iommu and stream id of wifi iommu block.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  arch/arm64/boot/dts/qcom/sdm845.dtsi | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> index 36c716cf3a0c..f02da46542cc 100644
> --- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> @@ -1225,6 +1225,7 @@
>  				<0 423 0 /* CE9 */ >,
>  				<0 424 0 /* CE10 */ >,
>  				<0 425 0 /* CE11 */ >;
> +			iommus = <&apps_smmu 0x0040 0x1>;

I don't see an apps_smmu label in any of the sdm845 files yet. I don't
think this piece has landed in any -next tree yet. So your patch won't
work.

I think maybe you should just defer sending this particular patch
upstream until the dependency is worked out.

Brian

>  		};
>  	};
>  };
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
