Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3993AC64EAD
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 06:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3031213A2
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 06:28:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="MO/nysDQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F3031213A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbeJINoE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 09:44:04 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40274 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbeJINoD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 09:44:03 -0400
Received: by mail-pl1-f194.google.com with SMTP id 1-v6so294184plv.7
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2018 23:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+eAFSZ7nJsYRkhbN1Z23DBBf9WaRuISUGEyoGN4nHbk=;
        b=MO/nysDQ8LcTEI4R8FIaxzuHIKEyKVkBd+NAWRXbJdCXHLSucUZqF2M4Y8TuqMMSjo
         cefd/QHigdmDz2SUEA5VhVDQBhXIrtgb8C/S6uNd5rflm4C6+wlqSzsWQ4iPop8w2qEZ
         4HH2G2XynkyvLlIzyMx7j5h8DZnRAtzAWNGcE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+eAFSZ7nJsYRkhbN1Z23DBBf9WaRuISUGEyoGN4nHbk=;
        b=BBrQS/NNQ2vAWwPdBeN0G4HmtsvETh2gZkmq+nGoPeN6UNft1MzO4yB8T/jC5u047Q
         9PE2mydkHIkcHl4jqoWpSdYxxQi3VyNhs1BwC9WYoyczIvLNoRdhW1jEYKj8K03MFqev
         3wDQiiFGM2VrJZWhBUSvt+n5kBOdiDsQvfvca8dUhBYxoC1iiOWvsiawsW2JbGWUK5tV
         TujiMc65HQnIzer8Dc8mm1FDmDx/lrTPGG/Ku0O2yvmvXEnyLBsfH8E/UvUSxBb7LF7P
         GteOZ5BV7pJpSSIXCAiFZq14TUA1Zn+DRFHhdR+9opHNQqKooUAdSVqCAwVwHtLQtMvO
         ydOg==
X-Gm-Message-State: ABuFfoi838Gr+lGiHMakqn+l0ETufEhThhYBF/8exAEMXOnujfkORw6q
        yHg6hS5ok0BIR+LzcGa0Dn3qrA==
X-Google-Smtp-Source: ACcGV62vFpENHQAFR/eNnXlEc2FZaU7EzyLDaZBEiCuo/EdWtSuxudRn+C/yYqxsdqeRJWi5i2fJcA==
X-Received: by 2002:a17:902:6689:: with SMTP id e9-v6mr27112808plk.115.1539066523207;
        Mon, 08 Oct 2018 23:28:43 -0700 (PDT)
Received: from tuxbook-pro (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id n13-v6sm21481700pgr.73.2018.10.08.23.28.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Oct 2018 23:28:42 -0700 (PDT)
Date:   Mon, 8 Oct 2018 23:28:40 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     ath10k@lists.infradead.org, briannorris@chromium.org,
        niklas.cassel@linaro.org, andy.gross@linaro.org,
        devicetree@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5 4/6] firmware: qcom: scm: Add WLAN VMID for Qualcomm
 SCM interface
Message-ID: <20181009062840.GA8498@tuxbook-pro>
References: <20180815092637.11455-1-govinds@codeaurora.org>
 <20180815092637.11455-5-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180815092637.11455-5-govinds@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed 15 Aug 02:26 PDT 2018, Govind Singh wrote:

> Add WLAN related VMID's to support wlan driver to set up
> the remote's permissions call via TrustZone.
> 

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  include/linux/qcom_scm.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/qcom_scm.h b/include/linux/qcom_scm.h
> index b401b962afff..da63d84e1e91 100644
> --- a/include/linux/qcom_scm.h
> +++ b/include/linux/qcom_scm.h
> @@ -1,4 +1,4 @@
> -/* Copyright (c) 2010-2015, The Linux Foundation. All rights reserved.
> +/* Copyright (c) 2010-2015, 2018, The Linux Foundation. All rights reserved.
>   * Copyright (C) 2015 Linaro Ltd.
>   *
>   * This program is free software; you can redistribute it and/or modify
> @@ -33,6 +33,8 @@ struct qcom_scm_vmperm {
>  
>  #define QCOM_SCM_VMID_HLOS       0x3
>  #define QCOM_SCM_VMID_MSS_MSA    0xF
> +#define QCOM_SCM_VMID_WLAN       0x18
> +#define QCOM_SCM_VMID_WLAN_CE    0x19
>  #define QCOM_SCM_PERM_READ       0x4
>  #define QCOM_SCM_PERM_WRITE      0x2
>  #define QCOM_SCM_PERM_EXEC       0x1
> -- 
> 2.17.0
> 
