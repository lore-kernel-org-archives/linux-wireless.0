Return-Path: <SRS0=PZxT=RJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B8CC43381
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 08:50:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3E8A20675
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 08:50:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ifnifFjD";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BIUdGIsX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbfCFIuS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Mar 2019 03:50:18 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46068 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbfCFIuR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Mar 2019 03:50:17 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 24EFB60398; Wed,  6 Mar 2019 08:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551862217;
        bh=aCi7K7kf0KXGyhwif8O/gBGBed1Pify5anRwjpUh8Jg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ifnifFjDMA364MdzhSPu48AmVhZCNk5572LqxvWBDTcYBk/R+MQE6pNwerAjha0bV
         0jWpIHdQKJ5OgW5yclxlFRd9h/LZfn+x6Bh+gvCjnm080ZxvXgLVP/QC6Q6HoW3HkG
         3sX/QlODV2Iu1gmiFU8NOCn/iZi+/O3gBjVCCU5w=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D7C11606AC;
        Wed,  6 Mar 2019 08:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551862216;
        bh=aCi7K7kf0KXGyhwif8O/gBGBed1Pify5anRwjpUh8Jg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BIUdGIsXWP4HcZ1kKVy5ITqfFxW6S/d6ZH9C6+KGrSKJYlknnOxKiaLHi/EVdEgmV
         Db4gtJezsm+7XkBhUntHliSZOZVaIRTs+iRe+GHw2523X75Rfmz1EsrfWkoG+Vi8kD
         r7S794rvHxpdhgLODUiZlpkOyLy+6+Q5YOMCP0qA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D7C11606AC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] mt76: Fix an IS_ERR() vs NULL check in mt76_wmac_probe()
References: <20190306072633.GA2625@kadam>
Date:   Wed, 06 Mar 2019 10:50:11 +0200
In-Reply-To: <20190306072633.GA2625@kadam> (Dan Carpenter's message of "Wed, 6
        Mar 2019 10:26:33 +0300")
Message-ID: <875zswfku4.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:

> The devm_ioremap_resource() function never returns NULL, it returns
> error pointers.
>
> Fixes: c8846e101502 ("mt76: add driver for MT7603E and MT7628/7688")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt7603/soc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/soc.c b/drivers/net/wireless/mediatek/mt76/mt7603/soc.c
> index e13fea80d970..b920be1f5718 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7603/soc.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7603/soc.c
> @@ -23,9 +23,9 @@ mt76_wmac_probe(struct platform_device *pdev)
>  	}
>  
>  	mem_base = devm_ioremap_resource(&pdev->dev, res);
> -	if (!mem_base) {
> +	if (IS_ERR(mem_base)) {
>  		dev_err(&pdev->dev, "Failed to get memory resource\n");
> -		return -EINVAL;
> +		return PTR_ERR(mem_base);
>  	}

Wei already posted an identical patch:

https://patchwork.kernel.org/patch/10837285/

-- 
Kalle Valo
