Return-Path: <SRS0=yVm+=OT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 918BAC04EB8
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 23:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55A6B2081F
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 23:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544484326;
	bh=nFu/8yIHK7LHfug80sxGc0pY+Ew93Q5CFOk0j3niVSo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=EIRVxv7Iht333kBoZ92rpkW4S79qzFcKQ8bOzMtUIeRjGx1MBCp29QxuyfrP5rj4m
	 xkX/+U0Sj6aGj6Y2Cx+zytsgO1wW0lr+hgI/q//Vv4qtLCs5otnm8m3aU8y6mUCbb6
	 vpjcP2iobcTTsbWD9MUUTuOaiVzM8EFwBH3AqI98=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 55A6B2081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729515AbeLJXZZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Dec 2018 18:25:25 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:39494 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727330AbeLJXZZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Dec 2018 18:25:25 -0500
Received: by mail-ot1-f66.google.com with SMTP id n8so12220688otl.6;
        Mon, 10 Dec 2018 15:25:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QHIdQzLf9m7vh0IlQ+gduF2Ec374AEOWiprrSnYbyrA=;
        b=nmWtP/iKauorpv8MqpR4KG6CCgx41h02+2qbMgYO9x2hQcOnQv/SIsFdYa1jt8nkBe
         wE8lMjoJrUnLoz+cOQZxC8nBkfiP0jKMaaBo8P5jkDqSvPZvibeVk/yXrCU4aopqNriN
         6+O7/Py6V1dhx7kzP7aqOY5iCSPtn7VrhzvWjmbHZCXtJu93RoNYIDOgHA0OO5WqX8oV
         tUsQocRBwFzkwMPA2SYCOelDmG+Jzvk1h9fRPH4+oSIkDC9D3/VgegWBritTbbsKcGId
         jHynRWsZ5KsNJEOqOQBPYwNoYjLOlV1LODKjjOnkM47Rcdpl/HlYHUlJs3wE22IjpEgO
         nMVw==
X-Gm-Message-State: AA+aEWbZbdfxeJmv5lVBhdbSjXr0tAZsuJ73G5WJ1eXUAxFGQTu8uiJT
        F9T8aLWu4kd6QYx0aPyfdy/NbKE=
X-Google-Smtp-Source: AFSGD/UVypOvKR7yF4ECQQTl6Txzle0k2n+XaYHD1t+NwM2ovRckuYOHZe960IxX6ea+Kcebd/zhfg==
X-Received: by 2002:a9d:70d5:: with SMTP id w21mr9130038otj.301.1544484324549;
        Mon, 10 Dec 2018 15:25:24 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id f18sm6281113otl.18.2018.12.10.15.25.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 10 Dec 2018 15:25:24 -0800 (PST)
Date:   Mon, 10 Dec 2018 17:25:23 -0600
From:   Rob Herring <robh@kernel.org>
To:     Bhagavathi Perumal S <bperumal@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/3] dt-bindings: net: ath10k: fix node name and
 device type in qcom ath10k example
Message-ID: <20181210232523.GA14192@bogus>
References: <1544466691-11821-1-git-send-email-bperumal@codeaurora.org>
 <1544466691-11821-2-git-send-email-bperumal@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1544466691-11821-2-git-send-email-bperumal@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Dec 11, 2018 at 12:01:29AM +0530, Bhagavathi Perumal S wrote:
> In qcom,ath10k documentation, ath10k is used as node name in the example of
> pci based device. Normally, node name shoud be class of device and not the model

s/shoud/should/

> name, so fix it to node name "wifi". And remove the property device_type pci
> since only pci bridges should have this property.
> 
> Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>
> ---
>  Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> index 2196d1a..ef60f25 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> @@ -74,9 +74,8 @@ pci {
>  		#address-cells = <3>;
>  		device_type = "pci";
>  
> -		ath10k@0,0 {
> +		wifi@0,0 {
>  			reg = <0 0 0 0 0>;
> -			device_type = "pci";
>  			qcom,ath10k-calibration-data = [ 01 02 03 ... ];
>  		};
>  	};
> -- 
> 1.9.1
> 
