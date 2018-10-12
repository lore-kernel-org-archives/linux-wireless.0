Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6830C6783C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 16:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A151520868
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 16:19:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A151520868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbeJLXwk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 19:52:40 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40409 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728537AbeJLXwj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 19:52:39 -0400
Received: by mail-ot1-f66.google.com with SMTP id w67so12896557ota.7;
        Fri, 12 Oct 2018 09:19:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vf6B80EBystJ9eh1Zv81QOgK8E3FqkY3IWNjeJh5dPc=;
        b=ilBUd/od8EJ8ArPo8/3DVZUR9aZx+q7jywWd41+XPRHPl8CT8y5QX3SqiHI/qw4HPE
         QZI3uuin33DNcx3eDNoc0YUzf81DZw8tiYypD3H0eoFmCsUdzpN0d1mb86ctpty76Q7d
         sPoq8HLGzXsSfcHTBzK7IMnwSRXZkTlw4Qp2DZM5wux9Q9+ILj6ytAruHirB53euaYgB
         hq+NsMC8aPv6xho5pzbDNQ8qjmhDm7OJ6lGIYuhmDim6NxUcWyvqb98uE8qlBOR/KH6v
         clT2CQ2+p+/lsTw6ysWpkd1azaXlW+FgzsYLvS+gM5Zl4GrWK1YiVeaEYjhK+qINTdzs
         NpvA==
X-Gm-Message-State: ABuFfogFReiwVZ94dyWmHPJQuBx9rQs2HA3nzGzmE9pPR7GXz4F84l3f
        ZJhmgKsaijsR03yJuitVB4gd9Sw=
X-Google-Smtp-Source: ACcGV63zoFHun2daEL2sPwwVQHXcpoV+3Vw+CBUnN5jTYXUBEi2KGlhYR1clhV6it1Tr/yfzCtpLeQ==
X-Received: by 2002:a9d:7742:: with SMTP id t2mr4396690otl.148.1539361165247;
        Fri, 12 Oct 2018 09:19:25 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id u17-v6sm432678oia.43.2018.10.12.09.19.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 09:19:24 -0700 (PDT)
Date:   Fri, 12 Oct 2018 11:19:23 -0500
From:   Rob Herring <robh@kernel.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        robh+dt@kernel.org, andy.gross@linaro.org,
        linux-soc@vger.kernel.org, Govind Singh <govinds@codeaurora.org>
Subject: Re: [PATCH v3 3/3] dt: bindings: add bindings for wifi iommu node
Message-ID: <20181012161923.GA28389@bogus>
References: <1539172376-19269-1-git-send-email-govinds@codeaurora.org>
 <1539172376-19269-4-git-send-email-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539172376-19269-4-git-send-email-govinds@codeaurora.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 10 Oct 2018 17:22:56 +0530, Govind Singh wrote:
> WCN3990 wifi module can optionally make use of the IOMMU.
> Add binding documentation for phandle to the IOMMU and
> the stream id of wifi iommu block.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 5 +++++
>  1 file changed, 5 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
