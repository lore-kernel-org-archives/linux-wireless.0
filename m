Return-Path: <SRS0=DQ7G=T4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E2DC04AB6
	for <linux-wireless@archiver.kernel.org>; Tue, 28 May 2019 11:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68BB52070D
	for <linux-wireless@archiver.kernel.org>; Tue, 28 May 2019 11:39:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="npW7wyj+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QhBnrF/l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfE1LjX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 28 May 2019 07:39:23 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57326 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbfE1LjX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 May 2019 07:39:23 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 062376077A; Tue, 28 May 2019 11:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559043563;
        bh=c3sNut8JDvcBDnwmKxoXocAd1hhWsAcc9vRUjO4cMEw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=npW7wyj+lbSMyrhhE/FZN9Z4hwjB8zbHqYrLD9U03vnoKHZSNtMPRZfVDRmBJgtXx
         X2QS36q/zhLmUkqe8XATf5kQ4WA4KKAWKLuiwKYRtcmEAAP/pF/I4QMNc2XrZ7mmtT
         wmL7hRPa4GLYRsVBE6gU3OKc6aHj8dSgF3mSEpg4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6B9FB6034D;
        Tue, 28 May 2019 11:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559043562;
        bh=c3sNut8JDvcBDnwmKxoXocAd1hhWsAcc9vRUjO4cMEw=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=QhBnrF/loAEzvhjV0PLYnZJHgZh38bdMlVbnmrc8HstH9EndRn334ytMaeYGxnqF9
         T8m/GvCKT8/vlEF9VVelOXr+4vGO+7II+vhOe+3tStHOg/SLYfwRPFchliUVE2Pbkj
         tlS/D5iy+QGTLybYV3IWcwbTm/6I1T2SGBF8d+TQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6B9FB6034D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wlcore: spi: Fix a memory leaking bug in wl1271_probe()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190524030117.GA6024@zhanggen-UX430UQ>
References: <20190524030117.GA6024@zhanggen-UX430UQ>
To:     Gen Zhang <blackgod016574@gmail.com>
Cc:     davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190528113923.062376077A@smtp.codeaurora.org>
Date:   Tue, 28 May 2019 11:39:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Gen Zhang <blackgod016574@gmail.com> wrote:

> In wl1271_probe(), 'glue->core' is allocated by platform_device_alloc(),
> when this allocation fails, ENOMEM is returned. However, 'pdev_data'
> and 'glue' are allocated by devm_kzalloc() before 'glue->core'. When
> platform_device_alloc() returns NULL, we should also free 'pdev_data'
> and 'glue' before wl1271_probe() ends to prevent leaking memory.
> 
> Similarly, we shoulf free 'pdev_data' when 'glue' is NULL. And we should
> free 'pdev_data' and 'glue' when 'glue->reg' is error and when 'ret' is
> error.
> 
> Further, we should free 'glue->core', 'pdev_data' and 'glue' when this 
> function normally ends to prevent leaking memory.
> 
> Signed-off-by: Gen Zhang <blackgod016574@gmail.com>

Same questions as with similar SDIO patch:

https://patchwork.kernel.org/patch/10959049/

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10959053/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

