Return-Path: <SRS0=RnVe=O2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85155C43387
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 21:45:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53E1A214C6
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 21:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545083100;
	bh=3Ws3+Wt7xspl+jvwh0yHwjErjaXf72ezqpAZL33iRWo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=tkXQO9seoucSxqVI+mfWIrPMaAW9sucS1tBoebCWjgrFBpd9fJcGQOcRoAl2U9BJf
	 FHcHiqqSEe/e2AzPKw6FBQIgJpghZsrOvhyVnKsilH3APaKZjkRDUW24ZZpcl/oUnF
	 o4qLKUXEYT3w7q1B28NZW2RemBfMZJofMaBkb7fs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbeLQVo7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Dec 2018 16:44:59 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:33477 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbeLQVo7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Dec 2018 16:44:59 -0500
Received: by mail-ot1-f66.google.com with SMTP id i20so13708580otl.0;
        Mon, 17 Dec 2018 13:44:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cyTW9FkIGTWnHmUx5OFfOz7PfBqu7+ZnBDJDJfZWr1s=;
        b=LTj1Xcnmd+tD1XnkNoBRuser5o0VxpSgThJf+AwehScc3ZcKGBs+tlECP56yglOm4r
         903rpJNGIE5muGJ8QIfb/SXCSQigvCeTWej1p8HIvSE3n/0sHXczY6OTOU/IjbLbZDJr
         tJFlJakccKgbgqiHIXqSs+OWZjidt8QGOWZbYX3ttm9SmRkmbPIHFmsL0kg9K+MNqpIi
         nc6YkrvEs4m6rRf70HzF/6XrmqpkACw6jo9CWxfJkxWUJOs6Afl8DwSKSaFdJ6a3KKW+
         etkEiTcX9sIpqgF4WKVb6kkTmCbd3aJIHzvyMBT6yg+/+vTdxmLXlbbDMmZjgl8iXTkW
         WHhw==
X-Gm-Message-State: AA+aEWYe6wRvE+gAfUshHXObkagcRupI4Q1t2QJAFmkGybAnomeS1zxV
        gRPIHFyhu+Zq2JprRlFdLQ==
X-Google-Smtp-Source: AFSGD/Ut8tWrEi5gzVc20b97zRi+fxUjzoaS/a7vNPOLrlslNTMFRu5JHOTRT1i6NT5e9T32+Z0mlQ==
X-Received: by 2002:a9d:635a:: with SMTP id y26mr10048584otk.27.1545083098481;
        Mon, 17 Dec 2018 13:44:58 -0800 (PST)
Received: from localhost (cpe-70-114-214-127.austin.res.rr.com. [70.114.214.127])
        by smtp.gmail.com with ESMTPSA id i22sm6622931otp.7.2018.12.17.13.44.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 17 Dec 2018 13:44:57 -0800 (PST)
Date:   Mon, 17 Dec 2018 15:44:57 -0600
From:   Rob Herring <robh@kernel.org>
To:     Bhagavathi Perumal S <bperumal@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org,
        Bhagavathi Perumal S <bperumal@codeaurora.org>
Subject: Re: [PATCH v4 1/3] dt-bindings: net: ath10k: fix node name and
 device type in qcom ath10k example
Message-ID: <20181217214457.GA21038@bogus>
References: <1544544804-4039-1-git-send-email-bperumal@codeaurora.org>
 <1544544804-4039-2-git-send-email-bperumal@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1544544804-4039-2-git-send-email-bperumal@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 11 Dec 2018 21:43:22 +0530, Bhagavathi Perumal S wrote:
> In qcom,ath10k documentation, ath10k is used as node name in the example of
> pci based device. Normally, node name should be class of device and not the
> model name, so fix it to node name "wifi". And remove the property device_type
> pci since only pci bridges should have this property.
> 
> Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>
> ---
>  Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
