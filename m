Return-Path: <SRS0=cbEF=BC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F894C433E8
	for <linux-wireless@archiver.kernel.org>; Thu, 23 Jul 2020 15:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5017D20792
	for <linux-wireless@archiver.kernel.org>; Thu, 23 Jul 2020 15:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595519663;
	bh=xOdIURdksIa9QF2fAtH1zOnoXNic4rqcFhJCxoE+ckc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=0fa+SmOECUcCZHsdlAh95gXJUlWJ9nYEXNN3aFIzRf+b1EksUsIeomgMHXPMbUp2g
	 ML8bIyKnf4CPufruxU3NwJwBkZwxSBbmI3lr3Cztms3oDBPzwhjJXX0/xe4j1XWYSd
	 pbTVixd+WY0C0GtVODDRo0RdGPi2QtfMwV8PyKGo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729640AbgGWPyW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 23 Jul 2020 11:54:22 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:36599 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgGWPyV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Jul 2020 11:54:21 -0400
Received: by mail-il1-f196.google.com with SMTP id x9so4746602ila.3;
        Thu, 23 Jul 2020 08:54:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LannAD2AX1fh6q7gHSRa8VqKVqFIn5KRyC4DsoZMwXo=;
        b=cMy2certaOv0+zqWXPEKqgOKspoSvXfRLXXkDSZkSVOy/97FC0CzX00KI0w8HJGd5z
         ruUbQ4mQiZNEmN9JIOFDkH8xWvoHuI+V/tJg3uqSCZgEOlhxsHf0c6DXC/uSVGzPt4Kp
         5v2u/C/t8PxYRzpMqCL/j6NkJypWQmvy8AO2rKHS9NClzrvULK/wYA6YNYKClb7f/wxN
         kopqvXSZVt8ZgYLEdg37f9hPHn3L+sRrj6fgJD0Qt0wep3/J9yEDf1+4snsOJ4Z+/svV
         ZjjCsdyVnXtYORR4yXBgl6UUszu2yakI9jbbCbq1kLKDGapX9FxIIlNBDBOTenrVY21U
         12Og==
X-Gm-Message-State: AOAM53281PP7TsZACV+j2uSAzAWDgTl/RtN3dx82a8+OHe7uTVP9C5fW
        173ln3Inuz0aCHHQ+CaMkkuLmfpcGA==
X-Google-Smtp-Source: ABdhPJywARBshz2+0DGQQChaKCPrF7Q5cVSGWUX2ed65RXvpBb9WB1QX1mqkbQNg55v9AFpOewT71g==
X-Received: by 2002:a92:1b5b:: with SMTP id b88mr2651749ilb.104.1595519660249;
        Thu, 23 Jul 2020 08:54:20 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id p9sm1660623ilc.78.2020.07.23.08.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 08:54:19 -0700 (PDT)
Received: (nullmailer pid 440701 invoked by uid 1000);
        Thu, 23 Jul 2020 15:54:18 -0000
Date:   Thu, 23 Jul 2020 09:54:18 -0600
From:   Rob Herring <robh@kernel.org>
To:     Anilkumar Kolli <akolli@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        ath11k@lists.infradead.org
Subject: Re: [PATCH v4 1/3] dt: bindings: net: update compatible for ath11k
Message-ID: <20200723155418.GA439882@bogus>
References: <1595506264-6393-1-git-send-email-akolli@codeaurora.org>
 <1595506264-6393-2-git-send-email-akolli@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595506264-6393-2-git-send-email-akolli@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 23 Jul 2020 17:41:02 +0530, Anilkumar Kolli wrote:
> Add IPQ6018 wireless driver support,
> its based on ath11k driver.
> 
> Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
> ---
> V3:
>  - Use 'enum' rather than oneOf+const.
> V4:
>  - removed oneOf, use just enum (Rob)
> 
>  Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 


My bot found errors running 'make dt_binding_check' on your patch:

/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml: properties:compatible: [{'enum': ['qcom,ipq8074-wifi', 'qcom,ipq6018-wifi']}] is not of type 'object', 'boolean'
Documentation/devicetree/bindings/Makefile:20: recipe for target 'Documentation/devicetree/bindings/net/wireless/qcom,ath11k.example.dts' failed
make[1]: *** [Documentation/devicetree/bindings/net/wireless/qcom,ath11k.example.dts] Error 1
make[1]: *** Waiting for unfinished jobs....
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml: ignoring, error in schema: properties: compatible
warning: no schema found in file: ./Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml: ignoring, error in schema: properties: compatible
warning: no schema found in file: ./Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
Makefile:1347: recipe for target 'dt_binding_check' failed
make: *** [dt_binding_check] Error 2


See https://patchwork.ozlabs.org/patch/1334839

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure dt-schema is up to date:

pip3 install git+https://github.com/devicetree-org/dt-schema.git@master --upgrade

Please check and re-submit.

