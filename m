Return-Path: <SRS0=DQ7G=T4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82EC5C04AB6
	for <linux-wireless@archiver.kernel.org>; Tue, 28 May 2019 12:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5733120883
	for <linux-wireless@archiver.kernel.org>; Tue, 28 May 2019 12:37:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="T+IIbrds";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JQ4nJhoz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbfE1Mha (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 28 May 2019 08:37:30 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48140 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbfE1Mh3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 May 2019 08:37:29 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1708B606FC; Tue, 28 May 2019 12:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559047049;
        bh=GjdZgF383TFHDYhYNOQSAnFBkS9jHN+K2M3uXmBh/5A=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=T+IIbrdsjC4arqVbuzO4fyc0HkxHlinCNSnc5SzZYOOapasYqNRJWDR5s07Q8/lPV
         7YRmWV8ckdbEYG7hx4e+1245IoBeezlqf7nPDMmlpp98K4vrp5OvAwFFvT5yfpB1ws
         87udwbaxkCSMfs0nUx4Bf7cEaBz7fj8G2g8sOsN4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DC2766034D;
        Tue, 28 May 2019 12:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559047048;
        bh=GjdZgF383TFHDYhYNOQSAnFBkS9jHN+K2M3uXmBh/5A=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=JQ4nJhozQRUORTMmtOJja8shJ0vRZnXO4/M60qEBHMVATMHEpHBmPT9znaeZc4tND
         /oMH/PzZNcISfX2XMmPayIaf69VOrUPOH+h6DhPRSykNrPL6IJkLgEByJlhvxqDWZs
         2hrULve39PAXGdXF96TKfIh2aVeqzOxIERJHV98Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DC2766034D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8821ae: Remove set but not used variables
 'cur_txokcnt' and 'b_last_is_cur_rdl_state'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190525144332.17268-1-yuehaibing@huawei.com>
References: <20190525144332.17268-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <pkshih@realtek.com>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190528123729.1708B606FC@smtp.codeaurora.org>
Date:   Tue, 28 May 2019 12:37:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c: In function rtl8821ae_dm_check_rssi_monitor:
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c:658:6: warning: variable cur_txokcnt set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c: In function rtl8821ae_dm_check_edca_turbo:
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c:2657:7: warning: variable b_last_is_cur_rdl_state set but not used [-Wunused-but-set-variable]
> 
> They are never used so can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

3e42a66dfd15 rtlwifi: rtl8821ae: Remove set but not used variables 'cur_txokcnt' and 'b_last_is_cur_rdl_state'

-- 
https://patchwork.kernel.org/patch/10960841/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

