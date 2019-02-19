Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EFC2C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:18:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F19F20700
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:18:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cusvAyBf";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Z8G5zmrL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbfBSPSE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:18:04 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:45630 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfBSPSD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 10:18:03 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F3006608D4; Tue, 19 Feb 2019 15:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589482;
        bh=NgZQcx9snxNrKIpCpFt7e6sMZp34136olHL4kLszet8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=cusvAyBfiHzqX4QusCLIE0g4mgh7S+CvUeAVn4jfZplPuRQaDwd2tYaiaq7WADJW9
         kXIEfhG6dybIXSoWflfBBgGiVjlz9BUayG30O0adZExLmAPFJ7Lfws/EFKhFSLcVDz
         LoxfQdNC88b1TRYPafPcGIqzqP0aRNh/IRMsfU1g=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 564BB6071A;
        Tue, 19 Feb 2019 15:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589481;
        bh=NgZQcx9snxNrKIpCpFt7e6sMZp34136olHL4kLszet8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Z8G5zmrLoyOOlYlAilXzUDKjbIgGPADY1TY/hcUjj+2lFJPu4gPcAg39H33s865+x
         +UN86fdtkZnUMO3Eh3Ir+NKDwxZ1+UIF6HTPGMG5YNfaBQTHYa1ArxkzDZaFT1S9sx
         8h8iUuS9pLc9onliwCvxQ5YRxYR1IK4z5viKaIik=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 564BB6071A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtl818x_pci: Remove set but not used variables 'io_addr,
 mem_addr'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190218075226.183964-1-yuehaibing@huawei.com>
References: <20190218075226.183964-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     "John W. Linville" <linville@tuxdriver.com>,
        Colin Ian King <colin.king@canonical.com>,
        YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190219151801.F3006608D4@smtp.codeaurora.org>
Date:   Tue, 19 Feb 2019 15:18:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c: In function 'rtl8180_probe':
> drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c:1727:15: warning:
>  variable 'io_addr' set but not used [-Wunused-but-set-variable]
> 
> drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c:1726:16: warning:
>  variable 'mem_addr' set but not used [-Wunused-but-set-variable]
> 
> They're never used since introduction.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

b9b81d152cfb rtl818x_pci: Remove set but not used variables 'io_addr, mem_addr'

-- 
https://patchwork.kernel.org/patch/10817425/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

