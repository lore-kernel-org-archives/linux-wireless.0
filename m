Return-Path: <SRS0=0mSa=WC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1022BC32751
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Aug 2019 12:39:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D254020B1F
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Aug 2019 12:39:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="eaEOzmbK";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="oFlljBMr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbfHFMjO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Aug 2019 08:39:14 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33638 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfHFMjO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Aug 2019 08:39:14 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7EC546090F; Tue,  6 Aug 2019 12:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565095153;
        bh=pd7Qw4xZhWXnQJq4hyNdvdBFiPxcv50Ew5013stflR8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=eaEOzmbKx6eas23hBlqxSjkTvt7uxPYr2o097eVSK+mYe/fi5mlx1HdmA0tLUbUKK
         ZG3ppf1XR2huv5JtBS/MtWRXwPh9y/Sw+aXZj6xjqTrSeGZ76oxHNNuOcYk3imKfGx
         38NV+EDvBmFeCXn1038FJLWthilZgwIGPnqXxrY0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D6A1B60590;
        Tue,  6 Aug 2019 12:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565095153;
        bh=pd7Qw4xZhWXnQJq4hyNdvdBFiPxcv50Ew5013stflR8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=oFlljBMrHfp/5itSxYDO3XvPFc80fAyirUIqngrI4wfxk+Kq9jar2jVMWZKCJXqAZ
         p6A4/848A955/YtMxeA/ZxuqN7Et/Q2tUMV7QRKxIAYY5Mv1H9BBy2jnYGcXCM++Hn
         dhpq1dbPwmG6gmAix+6YOWw8nHjTmvhp+27qb+XM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D6A1B60590
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtw88: pci: remove set but not used variable 'ip_sel'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190726142018.20792-1-yuehaibing@huawei.com>
References: <20190726142018.20792-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <yhchuang@realtek.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190806123913.7EC546090F@smtp.codeaurora.org>
Date:   Tue,  6 Aug 2019 12:39:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/realtek/rtw88/pci.c: In function 'rtw_pci_phy_cfg':
> drivers/net/wireless/realtek/rtw88/pci.c:993:6: warning:
>  variable 'ip_sel' set but not used [-Wunused-but-set-variable]
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

d1b68c118238 rtw88: pci: remove set but not used variable 'ip_sel'

-- 
https://patchwork.kernel.org/patch/11061177/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

