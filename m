Return-Path: <SRS0=BEmV=76=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63426C433DF
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Jun 2020 21:46:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 352FD2070A
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Jun 2020 21:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592430377;
	bh=j3G2r2DDyAxDcJdA+lLN3PY+GwwTVW4qN2WUYT8Z7aM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=U8ZptybjcAvCFeubW1xmHGcuq4ONyaflNCUA3hDRangysPsa8Wt45jRDEB8/sEFQx
	 +T07Gx0eQZohJQT4ggU2nLXnTKBIUhwEHk2W4bC6h4f646HkSQdwxCA3HEuzbFfwbm
	 QIyJ1x6i0I/IZODIdpKwZwB52BzuJJR8MpGRB99w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgFQVqQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Jun 2020 17:46:16 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:43185 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgFQVqP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jun 2020 17:46:15 -0400
Received: by mail-io1-f66.google.com with SMTP id u13so4693451iol.10;
        Wed, 17 Jun 2020 14:46:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NbVAS6uqtetynyOgAaJxu9i9M19Zf5MQLT1mt0GDjtE=;
        b=kfo/+HqJNop9/zHhe5dMv7X7avAAl+dkZydt4Nj5PIAPM9YBEkiYJagBkGuxt3W5Th
         x2N3spW8tre0ejHVFLgmjG8mPhWegcHNiRqAMe9JMed0Dnz0giUAhVahonDslmA4FXbS
         d7CGCNDrDQPMgqHFCRK1X49StZxPj3Hk1Rmm8ctXqjwFWoprboJQd/LPOuLDC3/rvrVq
         GWFhiMxGXr7G69BRDTeYkrL6F3yUHe7/MeyGAYoiySxxOnRr8M7nyekhEO2dbWzC3VyX
         YcEZGJA/Zwv3Eahi+4rZekgbtZD56DcTzwtTO2iwyI07+y1MvuPe6MAkq8mg3q/tqKGU
         7tIg==
X-Gm-Message-State: AOAM532CpPFBsHaXIq2cceLzg8ExtxkTVFDwOFyXETlb1JBzFt1jIVAj
        Uy/4BL9Uq2CsnjI9HSRpCQ==
X-Google-Smtp-Source: ABdhPJztFPH6mS1jXhotRIzgaImDXcXY7vO4PxBZBPtRhquqbIxZy/INpuYP+SEnOyPSd9pDfQT+Mw==
X-Received: by 2002:a02:a78e:: with SMTP id e14mr1397253jaj.9.1592430374881;
        Wed, 17 Jun 2020 14:46:14 -0700 (PDT)
Received: from xps15 ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id j63sm503092ilg.50.2020.06.17.14.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 14:46:14 -0700 (PDT)
Received: (nullmailer pid 2883337 invoked by uid 1000);
        Wed, 17 Jun 2020 21:46:13 -0000
Date:   Wed, 17 Jun 2020 15:46:13 -0600
From:   Rob Herring <robh@kernel.org>
To:     Anilkumar Kolli <akolli@codeaurora.org>
Cc:     ath11k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/8] dt: bindings: net: update compatible for ath11k
Message-ID: <20200617214613.GA2882286@bogus>
References: <1591709581-18039-1-git-send-email-akolli@codeaurora.org>
 <1591709581-18039-2-git-send-email-akolli@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1591709581-18039-2-git-send-email-akolli@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Jun 09, 2020 at 07:02:54PM +0530, Anilkumar Kolli wrote:
> Add IPQ6018 wireless driver support,
> its based on ath11k driver.
> 
> Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
> ---
>  Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> index a1717db36dba..844edd87be20 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> @@ -17,7 +17,9 @@ description: |
>  
>  properties:
>    compatible:
> -    const: qcom,ipq8074-wifi
> +    oneOf:
> +      - const: qcom,ipq8074-wifi
> +      - const: qcom,ipq6018-wifi

Use 'enum' rather than oneOf+const.

>  
>    reg:
>      maxItems: 1
> -- 
> 2.7.4
> 
