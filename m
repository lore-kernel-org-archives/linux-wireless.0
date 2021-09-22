Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A393AC433F5
	for <linux-wireless@archiver.kernel.org>; Wed, 22 Sep 2021 20:33:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85E2261019
	for <linux-wireless@archiver.kernel.org>; Wed, 22 Sep 2021 20:33:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237581AbhIVUfB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 22 Sep 2021 16:35:01 -0400
Received: from mail-ot1-f47.google.com ([209.85.210.47]:44838 "EHLO
        mail-ot1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236860AbhIVUfB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Sep 2021 16:35:01 -0400
Received: by mail-ot1-f47.google.com with SMTP id h9-20020a9d2f09000000b005453f95356cso5293013otb.11;
        Wed, 22 Sep 2021 13:33:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+032e70i08NosH2L550S84MiHmrCemoO0aT5S55a2io=;
        b=ln7yeQ7ZeyzO3TCgXUPSB/TU1Zy3pANk5OncXmfJl2MbpzosM0IghbmK4asrrR67qt
         C50zqE5oPLLWRSOwrRvWSWAB9YBIf9KrEWrhFOqJ83V0wEGO+kIs1m6m45VKUQmGDBC8
         8rcbEOiFketPfb4IkwswBJaC3vYtgDu6WGJ5rC2U5/h00FgYOKdjXqgruyT6IPSbGRxN
         k0T/hi3BoIH2oLKcaHigkkyNyiAtxVGRBRBzlTr1bE1miiSbl+HFBmntLOq5THZ8KkCO
         r6yJEP9EaXLlL2lsZ1NKzK0KzROEG4KVW/ZzdhY5cgIo+pEa3JrerekBHBvH/bpcak3V
         IMaA==
X-Gm-Message-State: AOAM532UV80AL0+ZUStQKWH1qWyeh+fKNsdec5Ti4St8iY5LtSAB1kSO
        9R/b5lrmrUvuOPb6NwLrv0Mn6PQ02Q==
X-Google-Smtp-Source: ABdhPJwyarhLCtwCbuT0tc1bP/7Weinth8Z3MeaqDXGNOlb+i4cGzU+1NGVt4tYnSZrMKE0vaK9oHg==
X-Received: by 2002:a9d:721b:: with SMTP id u27mr1030029otj.214.1632342810619;
        Wed, 22 Sep 2021 13:33:30 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id bk40sm789475oib.8.2021.09.22.13.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 13:33:30 -0700 (PDT)
Received: (nullmailer pid 1243882 invoked by uid 1000);
        Wed, 22 Sep 2021 20:33:29 -0000
Date:   Wed, 22 Sep 2021 15:33:29 -0500
From:   Rob Herring <robh@kernel.org>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     devicetree@vger.kernel.org, linux-wireless@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH] dt-bindings: net: wireless: qca,ath9k: convert to the
 json-schema
Message-ID: <YUuTGXk0EvuaYdqk@robh.at.kernel.org>
References: <20210917164636.120658-1-chunkeey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210917164636.120658-1-chunkeey@gmail.com>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Sep 17, 2021 at 06:46:36PM +0200, Christian Lamparter wrote:
> This replaces the existing .txt binding file. Furthermore, this
> also helps with validating DTS files.
> 
> Introduced binding changes:
>  1. added inherited mac-address nvmem property
>  2. added inherited ieee80211-freq-limit property
>  3. added new calibration nvmem property
> 
> Added binding .yaml to MAINTAINERS.
> 
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> ---
> 
> Q: Is there a way to encode the pci-id device value to the
> specific chip? This is because the qca,ath9k.txt had this
> nice list:
>                   - 002e for AR9287
>                   - 0030 for AR9380, AR9381 and AR9382
>                   - 0032 for AR9485

You can add a comment after each compatible value.

> 
> I would like to preserve this information.
> 
> Thanks,
> Christian
> 
> ---
>  .../bindings/net/wireless/qca,ath9k.txt       | 48 -----------
>  .../bindings/net/wireless/qca,ath9k.yaml      | 82 +++++++++++++++++++
>  MAINTAINERS                                   |  1 +
>  3 files changed, 83 insertions(+), 48 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml

Reviewed-by: Rob Herring <robh@kernel.org>
