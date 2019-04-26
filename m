Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23DFEC4321A
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 11:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6539206C1
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 11:59:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ObSeaUGr";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MyE1tNsQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfDZL7R (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 07:59:17 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45672 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfDZL7R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 07:59:17 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 12A1B60791; Fri, 26 Apr 2019 11:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556279956;
        bh=D32ieLsmOPF3ggVKO1rkpZuo/IEVdLX7oWpYY3KqZfU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ObSeaUGr69Z/ilUguD1LwfSvWlM7S05Y1MGFCf1bsB2HTdvyPLJl98H/gNA66R/+7
         eBDDOEpVEA+w4vxiIh0QrVBjXBpFZNc36b23JYdF8P8LMbLGqiWnHyZYPZtHlDDqwo
         PvmlGBGZ3jpOb2A/DI4crA2bHgJLHL4nFu+zCJ3A=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9BB8760275;
        Fri, 26 Apr 2019 11:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556279955;
        bh=D32ieLsmOPF3ggVKO1rkpZuo/IEVdLX7oWpYY3KqZfU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=MyE1tNsQ9E3HLAMbUe8kyPRY3UIprZUH4VgsArrA0xgID+A1nJYQNQr/2nJ2HiDU2
         gCrBPnzfnZYePxuKWcmK+RCCJBmIxhNTFcgPb7TaF40OfuMkXWmowbdq1yywCyfuaa
         WP/to06ORJmRXfnNyhUHPcYvZIeLaiZ0qXT5FuKE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9BB8760275
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8192cu: remove set but not used variable
 'turbo_scanoff'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190423143214.39392-1-yuehaibing@huawei.com>
References: <20190423143214.39392-1-yuehaibing@huawei.com>
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     <pkshih@realtek.com>, <Larry.Finger@lwfinger.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <davem@davemloft.net>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190426115916.12A1B60791@smtp.codeaurora.org>
Date:   Fri, 26 Apr 2019 11:59:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yue Haibing <yuehaibing@huawei.com> wrote:

> From: YueHaibing <yuehaibing@huawei.com>
> 
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c: In function 'rtl92cu_phy_rf6052_set_cck_txpower':
> drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c:45:7: warning: variable 'turbo_scanoff' set but not used [-Wunused-but-set-variable]
> 
> It is not used any more since
> commit e9b0784bb9de ("rtlwifi: rtl8192cu: Fix some code in RF handling")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

a0656c6ec2fd rtlwifi: rtl8192cu: remove set but not used variable 'turbo_scanoff'

-- 
https://patchwork.kernel.org/patch/10913203/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

