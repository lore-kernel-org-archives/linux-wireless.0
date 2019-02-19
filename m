Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23998C4360F
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC10B21736
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:09:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Kh+JC+xY";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dbza5LAj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbfBSPJp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:09:45 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38008 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfBSPJp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 10:09:45 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1C579608C6; Tue, 19 Feb 2019 15:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550588984;
        bh=1+dQPNC77lHuNUdNOr82fnVzKSOUCIH0pM/IUgOApfA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Kh+JC+xYgQyiCGxYmf2v2INmUa+QbcRCW2Z/Anpp7TyxPaIGKVMZrRsBxyI9XIAWg
         xmaESQFpxzDe78EAtiiM9Aa97/lKNbuOeVlF4Zv2SWGs2GxZBbMT9bRg1MaydzaboB
         RlpGgkq4Aq4uqq57zDBdYgJXyPgKS44RH7FkqUgU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9D41F60791;
        Tue, 19 Feb 2019 15:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550588983;
        bh=1+dQPNC77lHuNUdNOr82fnVzKSOUCIH0pM/IUgOApfA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=dbza5LAj6ZOUbap+gEC6mIOnjW2O7zOko/eZVgrxb0TfTU7lB4v7Z6FXzBZB/SiQr
         xlQCD0zUd26iZZWVv9ihli/f+R7+E9dbmm4rVdj502BSa5jhKeGGEE11YrLaqwetAC
         00kZNLQen7SOoftHq1cTdgtoPegNe/H5kZFKyjGw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9D41F60791
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rsi: remove set but not used variables 'info, vif'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190218075156.183879-1-yuehaibing@huawei.com>
References: <20190218075156.183879-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190219150944.1C579608C6@smtp.codeaurora.org>
Date:   Tue, 19 Feb 2019 15:09:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/rsi/rsi_91x_main.c: In function 'rsi_prepare_skb':
> drivers/net/wireless/rsi/rsi_91x_main.c:127:24: warning:
>  variable 'vif' set but not used [-Wunused-but-set-variable]
> 
> drivers/net/wireless/rsi/rsi_91x_main.c:124:28: warning:
>  variable 'info' set but not used [-Wunused-but-set-variable]
> 
> They're not used any more since 160ee2a11ce0 ("rsi: fill rx_params only once.")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

6f6e4f98ee52 rsi: remove set but not used variables 'info, vif'

-- 
https://patchwork.kernel.org/patch/10817423/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

