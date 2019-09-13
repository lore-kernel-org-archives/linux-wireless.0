Return-Path: <SRS0=I2fZ=XI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 045CEC49ED7
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Sep 2019 14:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D01F920644
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Sep 2019 14:20:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Iogji4XO";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ifV51aP/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388058AbfIMOU0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 13 Sep 2019 10:20:26 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41998 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387693AbfIMOU0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Sep 2019 10:20:26 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E297360767; Fri, 13 Sep 2019 14:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568384424;
        bh=SAShVU3cg4kjywNYAt7pKciptCpXufeKkrQJMy1mPa8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Iogji4XO3mbNTK32q4D4/esmb6Vhsxq5yp5+u396vfkSihudz8gJtquOfmM7XopVD
         fiYLp2Rx17FWwjrgY7oM/5Km3ehIW8cbXLugTEYoPxvdsEPnVm4vTdwob5qNmYdgHK
         K98RFjKmpLfjZ9bzOvbCikv5VpeTdDSzJcTBrGtc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 102C1602EE;
        Fri, 13 Sep 2019 14:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568384424;
        bh=SAShVU3cg4kjywNYAt7pKciptCpXufeKkrQJMy1mPa8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ifV51aP/DalYVwZ0paErOcsj7IYtPXIvU6ZTf9vg8ODEwcgGIckgdqurkwHsbt+95
         5//khtFQ2FmdHPBZ6H7dhxiAFBa9cJKJuplZ3apPRCSbu+1XQH0ibuhkhxRoaCr3iX
         GOlgjVHs13GFHKWOtruhnO4iQDd185PxxpajncNo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 102C1602EE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmsmac: Use DIV_ROUND_CLOSEST directly to make it
 readable
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1567700648-28162-1-git-send-email-zhongjiang@huawei.com>
References: <1567700648-28162-1-git-send-email-zhongjiang@huawei.com>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     <davem@davemloft.net>, <zhongjiang@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190913142024.E297360767@smtp.codeaurora.org>
Date:   Fri, 13 Sep 2019 14:20:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

zhong jiang <zhongjiang@huawei.com> wrote:

> The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
> but is perhaps more readable.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

3dfb22003f98 brcmsmac: Use DIV_ROUND_CLOSEST directly to make it readable

-- 
https://patchwork.kernel.org/patch/11133663/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

