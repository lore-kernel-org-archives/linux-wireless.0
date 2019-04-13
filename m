Return-Path: <SRS0=M/jX=SP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1DF0C10F11
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 11:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6FEE2075B
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 11:18:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="G+Nqu8F1";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aZefSDBO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfDMLSb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Apr 2019 07:18:31 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41432 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbfDMLSb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Apr 2019 07:18:31 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1E79361728; Sat, 13 Apr 2019 11:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555154310;
        bh=EuGuq0POBs2eKCgoMG+BWbmyZ8YXUq/xLsJ7uRskxCY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=G+Nqu8F1lfc2OuWmL2w8JYQa1J0/yM3ge15chdVeQjBTG4UYMyaH0rxOB5YDQI9cg
         nytstq7FFUbnUX8eSR0BEm0WBdPzdpXkzpP7tarq1xulrxsBHMXvLUkFuquXjBFdBh
         FaI1AtrYyRs92zWt96B5kO7DkWgkmRLpwxB80TfU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BA30F616D6;
        Sat, 13 Apr 2019 11:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555154309;
        bh=EuGuq0POBs2eKCgoMG+BWbmyZ8YXUq/xLsJ7uRskxCY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=aZefSDBOmwHQsvXLN1vREgdmmJnnsha/VH/PZiy2q0MoFV7sntXs1Ry0cY5c5d8LI
         N/JnDNWpEROLXSv673rEpLsyFUH5BpDatceL+B7z8dszjJzDPn9ZxvZwe/CJfeQSBl
         ePY92jGNhXHYdb0+Gqt2LuS5GmTJWARx8nrYvzCk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BA30F616D6
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8723ae: Make
 rtl8723e_dm_refresh_rate_adaptive_mask static
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190319151927.19392-1-yuehaibing@huawei.com>
References: <20190319151927.19392-1-yuehaibing@huawei.com>
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <pkshih@realtek.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190413111830.1E79361728@smtp.codeaurora.org>
Date:   Sat, 13 Apr 2019 11:18:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yue Haibing <yuehaibing@huawei.com> wrote:

> From: YueHaibing <yuehaibing@huawei.com>
> 
> Fix sparse warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c:666:6:
>  warning: symbol 'rtl8723e_dm_refresh_rate_adaptive_mask' was not declared. Should it be static?
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

bdfc4027de15 rtlwifi: rtl8723ae: Make rtl8723e_dm_refresh_rate_adaptive_mask static

-- 
https://patchwork.kernel.org/patch/10859777/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

