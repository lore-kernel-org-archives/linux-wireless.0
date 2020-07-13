Return-Path: <SRS0=uAqM=AY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2393C433E1
	for <linux-wireless@archiver.kernel.org>; Mon, 13 Jul 2020 18:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99C522067D
	for <linux-wireless@archiver.kernel.org>; Mon, 13 Jul 2020 18:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594666280;
	bh=2u4NzwccIq+s0JWCd50cqYM7N/biSOkqRNZOgiHeIlo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=o2f1xydGNrjOPrRpvtxG2nCN9DFgpHLC/jaNfyHtPMLg0VplgbO3+ZVyySU8oQH1o
	 JayojRq2HIOffXmjPTWLlaaxe/3ENwtRApxF6be7PzllWxyRDZdPlSojmq4s7+JfJR
	 qYhkU1uvNCiUz8NnsP/nRsA+WKerQr1ajj1TvHbU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbgGMSvT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 13 Jul 2020 14:51:19 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:41211 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgGMSvT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Jul 2020 14:51:19 -0400
Received: by mail-io1-f66.google.com with SMTP id p205so6085693iod.8;
        Mon, 13 Jul 2020 11:51:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5I3GK8ON13ZeITKAZxa8BAwViFRoyB1EmrHHm5nafuM=;
        b=sDbrTxu26JAuW+34nXMIIaZmsFnn4ZiLW0uJfG6ZLc7lDWEDKxc+dVlV+eQ8e6rgOj
         J+xtEW3vwcDjkSC9An+aqBC4aHoffjsnJsTi9RnVQDsl7fDSc+nrgeR9CGdoFy9RVo42
         kyqLeTfu97tv9yyxmO6Juw6WTTl7lrEv+YcqFrTKs4hz1f3VR+nMmz4G6WKEyuVzoR+V
         gtJG5tlljbM52r47v/64slZmGq+nLQPdOJBFJ19JVPpyBvqaogxQV4Getb34Go1daSJ8
         6n9T2ptNUs9UYbmS40k8wCtjC18EY6R1JCPtu8tXCz0CjhzOOUlwaEqR5YoJfSeqDIzx
         aNNQ==
X-Gm-Message-State: AOAM530r2B+I94hmmiRwMeKepsMPVvE8APWE7GzdBPcb1yLwpi1vS9Kt
        4GtzuioEMsyUx4BG7qT9lA==
X-Google-Smtp-Source: ABdhPJxY7MYG7dgnOcq01GdR3ZrbB5Uuy2jWOltjU1O5UTSsTNwiMZ5UDwXUhFl0bCkNgc8pjKQkMw==
X-Received: by 2002:a05:6602:1544:: with SMTP id h4mr1235724iow.24.1594666278319;
        Mon, 13 Jul 2020 11:51:18 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id f18sm7978542ion.47.2020.07.13.11.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 11:51:17 -0700 (PDT)
Received: (nullmailer pid 531387 invoked by uid 1000);
        Mon, 13 Jul 2020 18:51:16 -0000
Date:   Mon, 13 Jul 2020 12:51:16 -0600
From:   Rob Herring <robh@kernel.org>
To:     Anilkumar Kolli <akolli@codeaurora.org>
Cc:     ath11k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 1/3] dt: bindings: net: update compatible for ath11k
Message-ID: <20200713185116.GB529968@bogus>
References: <1592458104-2961-1-git-send-email-akolli@codeaurora.org>
 <1592458104-2961-2-git-send-email-akolli@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592458104-2961-2-git-send-email-akolli@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Jun 18, 2020 at 10:58:22AM +0530, Anilkumar Kolli wrote:
> Add IPQ6018 wireless driver support,
> its based on ath11k driver.
> 
> Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
> ---
> V3:
>  - Use 'enum' rather than oneOf+const.
> 
>  Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> index a1717db36dba..b22cde6f3594 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> @@ -17,7 +17,11 @@ description: |
>  
>  properties:
>    compatible:
> -    const: qcom,ipq8074-wifi
> +    oneOf:
> +      - items:
> +          - enum:
> +              - qcom,ipq8074-wifi
> +              - qcom,ipq6018-wifi

Just need:

enum:
  - qcom,ipq8074-wifi
  - qcom,ipq6018-wifi
