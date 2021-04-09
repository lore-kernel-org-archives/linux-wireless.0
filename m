Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 444E7C43461
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Apr 2021 15:22:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16266610E5
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Apr 2021 15:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbhDIPWw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Apr 2021 11:22:52 -0400
Received: from mail-oi1-f170.google.com ([209.85.167.170]:34352 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234065AbhDIPWv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Apr 2021 11:22:51 -0400
Received: by mail-oi1-f170.google.com with SMTP id k18so1212776oik.1;
        Fri, 09 Apr 2021 08:22:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vCodsZZIoTvQzkpJnTU8BlxA64HJCCTzMZq32HqgNnM=;
        b=V/ArUs1E2gYegL8gdxJMgQt+HGYX5+Z1vRPwKo6TXTzFZj9kUgsI0g2yMtvJCb1HGH
         wJk/Dq3bvPaCFqrIZ0Ei69cuGTECSmpVM0srQGCz02rZDRDDk7M4kZDBt3KIlFJplPMp
         q84H9PFgImkxAVHwDDpyCtI81MOCOBy+w0BP2LeXzOYK2OgWHcUoOEWmXzxHJY0DOZhH
         4RFcBVXr4CfAL5dciPbb9MIsw0DGV0AY7CBPvokjd1LKG1l/VLoV2m39k///j4bVhqSW
         9Ea+/8eV3+F4Y0kz/py6Dsm81MC0z/FWZhpN083ncjBoo0q1yfGnzJ5BIbb/2gSeQF1k
         KPnw==
X-Gm-Message-State: AOAM530/+UyF4W07KIZv4dEds2MGYdLg3U0anHkzS0YALXvF/KsqSYdJ
        jYRSrLuueEAJavJtNe83EA==
X-Google-Smtp-Source: ABdhPJwAdAuiAVjQviaVDOPFU6EiLZKnX28uUKM5/wWTRkOUDlDIYcj9X/fksUxBrOZPWmKqf/RjTA==
X-Received: by 2002:a05:6808:14c8:: with SMTP id f8mr10681880oiw.55.1617981758249;
        Fri, 09 Apr 2021 08:22:38 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id g84sm574029oia.45.2021.04.09.08.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 08:22:37 -0700 (PDT)
Received: (nullmailer pid 3676380 invoked by uid 1000);
        Fri, 09 Apr 2021 15:22:36 -0000
Date:   Fri, 9 Apr 2021 10:22:36 -0500
From:   Rob Herring <robh@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org,
        lorenzo.bianconi@redhat.com, sean.wang@mediatek.com,
        ryder.lee@mediatek.com, shayne.chen@mediatek.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 2/8] dt-bindings:net:wireless:mediatek,mt76: introduce
 power-limits node
Message-ID: <20210409152236.GB3662358@robh.at.kernel.org>
References: <cover.1617625912.git.lorenzo@kernel.org>
 <eb6998d12c7f60a28c7f3eab455d4339656f76e2.1617625912.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb6998d12c7f60a28c7f3eab455d4339656f76e2.1617625912.git.lorenzo@kernel.org>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Apr 05, 2021 at 02:40:26PM +0200, Lorenzo Bianconi wrote:
> Introduce power-limits node in mt76 binding in order to specify
> per-rate power limit values for each 802.11n/802.11ac rate
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  .../bindings/net/wireless/mediatek,mt76.yaml  | 79 +++++++++++++++++++
>  1 file changed, 79 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
> index d6f835d17d66..6ede331e3e52 100644
> --- a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
> @@ -72,6 +72,62 @@ properties:
>        led-sources:
>          maxItems: 1
>  
> +  power-limits:
> +    type: object
> +    properties:
> +      regdomain: true

This shouldn't really be in ieee80211.yaml if it belongs under 
'power-limits' node. You may need a 2nd power limits schema if this 
something that should/can be common.

> +
> +    patternProperties:
> +      "^r[0-9]+":
> +        type: object
> +        patternProperties:
> +          "^txpower-[256]g$":
> +            type: object
> +            patternProperties:
> +              "^b[0-9]+$":
> +                type: object
> +                properties:
> +                  channels:
> +                    $ref: /schemas/types.yaml#/definitions/uint32-array
> +                    minItems: 2
> +                    maxItems: 2
> +                    description:
> +                      Pairs of first and last channel number of the selected
> +                      band
> +
> +                  cck:
> +                    $ref: /schemas/types.yaml#/definitions/uint32-array

What's the range of values? Could be 8-bit?

> +                    minItems: 4
> +                    maxItems: 4
> +                    description:
> +                      4 half-dBm per-rate power limit values
> +
> +                  mcs:
> +                    $ref: /schemas/types.yaml#/definitions/uint32-matrix
> +                    description:
> +                      Sets of per-rate power limit values for 802.11n/802.11ac
> +                      rates for multiple channel bandwidth settings.
> +                      Each set starts with the number of channel bandwidth
> +                      settings for which the rate set applies, followed by
> +                      either 8 or 10 power limit values. The order of the
> +                      channel bandwidth settings is 20, 40, 80 and 160 MHz.
> +
> +                  ru:
> +                    $ref: /schemas/types.yaml#/definitions/uint32-matrix
> +                    description:
> +                      Sets of per-rate power limit values for 802.11ax rates
> +                      for multiple channel bandwidth or resource unit settings.
> +                      Each set starts with the number of channel bandwidth or
> +                      resource unit settings for which the rate set applies,
> +                      followed by 12 power limit values. The order of the
> +                      channel resource unit settings is RU26, RU52, RU106,
> +                      RU242/SU20, RU484/SU40, RU996/SU80 and RU2x996/SU160.

These short property names bother me because we don't want 2 property 
names with different meanings. A 2-3 letter name seems more likely to 
collide. Also, the names aren't really self describing either.

> +
> +                  txs-delta:
> +                    $ref: /schemas/types.yaml#/definitions/uint32-array
> +                    description:
> +                      Half-dBm power delta for different numbers of antennas
> +
>  required:
>    - compatible
>    - reg
> @@ -93,6 +149,29 @@ examples:
>          led {
>            led-sources = <2>;
>          };
> +
> +        power-limits {
> +          r0 {
> +            txpower-5g {
> +               regdomain = "FCC";

Not the right location for what you've defined.

> +               b0 {
> +                   channels = <36 48>;
> +                   ofdm = <23 23 23 23 23 23 23 23>;
> +                   mcs = <1 23 23 23 23 23 23 23 23 23 23>,
> +                         <3 22 22 22 22 22 22 22 22 22 22>;
> +                   ru = <3 22 22 22 22 22 22 22 22 22 22 22 22>,
> +                        <4 20 20 20 20 20 20 20 20 20 20 20 20>;
> +               };
> +               b1 {
> +                   channels = <100 181>;
> +                   ofdm = <14 14 14 14 14 14 14 14>;
> +                   mcs = <4 14 14 14 14 14 14 14 14 14 14>;
> +                   txs-delta = <12 9 6>;
> +                   ru = <7 14 14 14 14 14 14 14 14 14 14 14 14>;
> +               };
> +             };
> +          };
> +        };
>        };
>      };
>  
> -- 
> 2.30.2
> 
