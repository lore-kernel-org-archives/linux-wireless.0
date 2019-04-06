Return-Path: <SRS0=AXTt=SI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19475C282DA
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Apr 2019 06:06:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3FAA21855
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Apr 2019 06:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554530775;
	bh=aMVH0AA7NMu7n93uAI9gR2hImaiRnVhXz+svA+Zsdno=;
	h=Date:From:Subject:References:In-Reply-To:Cc:Cc:To:List-ID:From;
	b=KjkcXLXYZwknqnMxW7edFOu0uezK359tq+9E00yPKuZgmWUWXMOvWiUWDXuf7lmh9
	 xFJr4W7jJdSMtO4Z3iEbZFTJQMgCo3sM6wUy9jF3yF2cUKW7asT4NfYrL/MM1B+4bt
	 UzT3RcM57j0V7y9wTgWH48XbhTUFGBMV+TdKhW3g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfDFGGO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Apr 2019 02:06:14 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45309 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbfDFGGN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Apr 2019 02:06:13 -0400
Received: by mail-pl1-f194.google.com with SMTP id bf11so4165659plb.12;
        Fri, 05 Apr 2019 23:06:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:subject:references
         :in-reply-to:cc:cc:to;
        bh=vHSi4SGK69vwHy4fERQMxrDWU2Xn9teQurmQABG1kF8=;
        b=OpCtlmp04GyCwocXmQMfZ8WTgMfFcQiHQgnQ1tFzg4BVjjfnH/Y1Uv6J4y1jE64R9x
         yn4VXTBJFZfPNAUQwwQMAq2x0qw4QUd4Uf2YIXCImfXUN+MUcwVZ6FbOrn5iDIMuJuK9
         wfBg6NU9qM6Om/HA9C4K4rJL+Iuq6/geYw44sNyLoibUAGk/YpKMzF2uy0fim2XOOtpm
         T7wdlbqSa7Ro86YmoITqpJhTDJIAOJeE2YierQzuxevqqI3bBuOL3sEGyXb1+wKO7zwR
         O2zr4LRI79LzfkRw7GHfRbEb1k5OvtHm6jBsGLZGJIPXxdzfHhRzsIFOkSovV38TDLRp
         XpRA==
X-Gm-Message-State: APjAAAWG4uQS8WD1xWaOwoX0LxCX0p0byjmNXx9wJERmJiHbsHWngT9p
        rxj+A+7yfoUU/WmVgNxZQQ==
X-Google-Smtp-Source: APXvYqy2gAtCz4/BwS4gSVxuc/13wUhHpuZLLoJrKvE3RaxStU3eppmfAhKFoF/+4JT6bFW0m3Fbmg==
X-Received: by 2002:a17:902:7841:: with SMTP id e1mr17137415pln.303.1554530772550;
        Fri, 05 Apr 2019 23:06:12 -0700 (PDT)
Received: from localhost ([210.160.217.71])
        by smtp.gmail.com with ESMTPSA id t22sm28133497pgu.45.2019.04.05.23.06.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Apr 2019 23:06:11 -0700 (PDT)
Message-ID: <5ca841d3.1c69fb81.7ec38.ae4e@mx.google.com>
Date:   Sat, 06 Apr 2019 01:06:10 -0500
From:   Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 1/2] dt: bindings: add dt entry for XO calibration support
References: <20190401091926.19119-1-govinds@codeaurora.org> <20190401091926.19119-2-govinds@codeaurora.org>
In-Reply-To: <20190401091926.19119-2-govinds@codeaurora.org>
Cc:     ath10k@lists.infradead.org, robh@kernel.org
Cc:     linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
To:     Govind Singh <govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon,  1 Apr 2019 14:49:25 +0530, Govind Singh wrote:
> Add dt binding to get xo calibration data support for wifi rf clock.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>

