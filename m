Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98354C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 07:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E1FF21720
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 07:45:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="liyC5MQF";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XQnw67Vp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730577AbeLTHpG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 02:45:06 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:52468 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727790AbeLTHpG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 02:45:06 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9A84A609BD; Thu, 20 Dec 2018 07:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545291905;
        bh=Ps+jTx430mNatVK6eXnpdGimwC8ru0CTiKlGF61Uy1M=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=liyC5MQFSQh/+qq7gwj6sIZx2wubtFBYHe7BSje3ruIGRSZFSU9C3e+2j2HGlB36x
         NdE1ZDH8AK9Z42TOMVkr5a2fcykazI4IkpjIpZL7QKROBYpFNOxkCT6SBsJ/7gHJnG
         hlIdfzlKBc6IXdBcyjYc/vYyAT0UkDKhSjYmdjpM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3907D60985;
        Thu, 20 Dec 2018 07:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545291904;
        bh=Ps+jTx430mNatVK6eXnpdGimwC8ru0CTiKlGF61Uy1M=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=XQnw67VpwluyamBo1RRltflGIXN1/HR/12h3dlLPIIa0GFCpSc7dfS+nioGW9tLrd
         hfzSIcVyOMjxbG87SN9/maQBnX1ZWqC9GUD8dbN0uxzBIfTKtdFD8aIuq+NwpzQZhb
         Lagou239G1HcLPdJbicfQuuq/p4e2eeZLbo00F/U=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3907D60985
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wil6210: remove set but not used variable 'wdev'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1543996743-137124-1-git-send-email-yuehaibing@huawei.com>
References: <1543996743-137124-1-git-send-email-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Maya Erez <merez@codeaurora.org>,
        YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <wil6210@qti.qualcomm.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181220074505.9A84A609BD@smtp.codeaurora.org>
Date:   Thu, 20 Dec 2018 07:45:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/ath/wil6210/main.c: In function '_wil6210_disconnect':
> drivers/net/wireless/ath/wil6210/main.c:407:23: warning:
>  variable 'wdev' set but not used [-Wunused-but-set-variable]
> 
> It never used since commit ("e1b43407c034 wil6210: refactor disconnect flow")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Reviewed-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

3fe970e76b37 wil6210: remove set but not used variable 'wdev'

-- 
https://patchwork.kernel.org/patch/10713127/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

