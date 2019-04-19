Return-Path: <SRS0=g+pd=SV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C2BC282DF
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Apr 2019 18:21:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99E4E222AF
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Apr 2019 18:21:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="naIP3E07"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbfDSSVU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:21:20 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46135 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727448AbfDSSVT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Apr 2019 14:21:19 -0400
Received: by mail-wr1-f67.google.com with SMTP id t17so7791863wrw.13;
        Fri, 19 Apr 2019 11:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8sNxl0hEqODlC+hizSvqr3xUDHjjB8NZZkZymPPfOvY=;
        b=naIP3E07hKz9hhJLONZLM7NzxQwVLhpVzVE0rbFHxxGq15ALwhLw6H7ABoX4JERvdX
         nPx6ErSt54JKMABpMiNjJG11NXzCjG/1pGSwGOPHD0dHRVt2evWpIUbmTUK0146mNm1M
         CDojXmqspVqiPZx6r0VSleUcw2nsacUN45VHmMcpL7cCstQTmvGETfAEs7yYhubFfea9
         zfaX60KKiNxuKC0Yd1vrsxXr0Bu9cFxBZ3w477BNQkpydYazALvEuxq8QsulZ84cyynf
         ZrilGYcNiWmFGJrLksDC1C54mjK0ysRtwZthtsIv4xgtsg2ujQehxeyEpOwjMxL2gB8R
         KMkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8sNxl0hEqODlC+hizSvqr3xUDHjjB8NZZkZymPPfOvY=;
        b=Mn8Db0XtIIPTWjb8vSBzhdjzY2Qw4eM1eQ2cMNdk4rm3BdP0UZ7vaGqFCVim8Akwd+
         1ZdVnfgVQF/V6B35Ho6NE/CKiN9r6FRyo37B62MCmL3mwHtXp/4qm9ClL4XIjKAaCzC+
         dwwVG2k8gQqODOVWq2N/uguJn7ce//baN6+TScHr2qI7MXPYTpjVDN/W86FRNAsmb+0K
         oD5FuosXOW4Pm4PA7K4i4jWddBPxt+rxCNBVEPOqbNrpagPpi1jmXi+bKcDENnloNxY6
         pVJeLYsV744qSooNIAJavIbiBQOotTpb6OVyMUezgwGQtqHj5R3ynQWWtcTgIeQgby1a
         wQ1A==
X-Gm-Message-State: APjAAAUf+aSHHjFzTabNxCeL/00wqY4Ha3r17MVGBEMW1HMO/SAo/fp0
        AMu/fjoe8qWgYMndcXSpC+gH3I3m
X-Google-Smtp-Source: APXvYqwh6gIi39S5w5C6TPjurD4+26bXvW/pWLM6lP5xIJizR5hUqlc8BiOjXGcQVwM/YYwkaO1ZVQ==
X-Received: by 2002:a5d:4d42:: with SMTP id a2mr4134240wru.130.1555696630034;
        Fri, 19 Apr 2019 10:57:10 -0700 (PDT)
Received: from debian64.daheim (p4FD090B5.dip0.t-ipconnect.de. [79.208.144.181])
        by smtp.gmail.com with ESMTPSA id c2sm4718719wrr.13.2019.04.19.10.57.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Apr 2019 10:57:08 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1] helo=debian64.localnet)
        by debian64.daheim with esmtp (Exim 4.92)
        (envelope-from <chunkeey@gmail.com>)
        id 1hHXkr-0007gA-OV; Fri, 19 Apr 2019 19:56:59 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     Pan Bian <bianpan2016@163.com>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: p54: drop device reference count if fails to enable device
Date:   Fri, 19 Apr 2019 19:56:47 +0200
Message-ID: <4374745.djV02MS7NJ@debian64>
In-Reply-To: <1555494083-130833-1-git-send-email-bianpan2016@163.com>
References: <1555494083-130833-1-git-send-email-bianpan2016@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Subject should include a "[PATCH]" as per:
https://www.kernel.org/doc/html/v4.15/process/submitting-patches.html#include-patch-in-the-subject

Nevertheless, patchwork picked it up.... so, you are probably fine.

https://patchwork.kernel.org/patch/10905039/

On Wednesday, April 17, 2019 11:41:23 AM CEST Pan Bian wrote:
> The function p54p_probe takes an extra reference count of the PCI
> device. However, the extra reference count is not dropped when it fails
> to enable the PCI device. This patch fixes the bug.
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>
Cc: stable@vger.kernel.org 
Acked-by: Christian Lamparter <chunkeey@gmail.com>

> ---
>  drivers/net/wireless/intersil/p54/p54pci.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intersil/p54/p54pci.c b/drivers/net/wireless/intersil/p54/p54pci.c
> index 27a4906..57ad564 100644
> --- a/drivers/net/wireless/intersil/p54/p54pci.c
> +++ b/drivers/net/wireless/intersil/p54/p54pci.c
> @@ -554,7 +554,7 @@ static int p54p_probe(struct pci_dev *pdev,
>  	err = pci_enable_device(pdev);
>  	if (err) {
>  		dev_err(&pdev->dev, "Cannot enable new PCI device\n");
> -		return err;
> +		goto err_put;
>  	}
>  
>  	mem_addr = pci_resource_start(pdev, 0);
> @@ -639,6 +639,7 @@ static int p54p_probe(struct pci_dev *pdev,
>  	pci_release_regions(pdev);
>   err_disable_dev:
>  	pci_disable_device(pdev);
> +err_put:
>  	pci_dev_put(pdev);
>  	return err;
>  }
> 




