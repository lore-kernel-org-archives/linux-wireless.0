Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74619C282CC
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 15:29:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 438432080F
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 15:29:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="I82nPfYO";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AdCGe60S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbfBHP3G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 10:29:06 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33564 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbfBHP3G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 10:29:06 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1A8B660D2E; Fri,  8 Feb 2019 15:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549639745;
        bh=RSivgelWf0tOpJcqIVSHPiViDNBZHs9eqkKhI4kyDgI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=I82nPfYOpCBiFBa/Bh6ARH7vjtBm+xkcfdTBHGolPJk29Tb7HGOmWSS2EPhUhm2es
         rTs69E/gPvuTxPz9Um8u/ZaLs8Ktk9KwvwP8/UDP04WvNGUXBkp3AK0dAojI+gxYNw
         FExr2hARr7XpxNl4t+VeOaIfT1AS2q/ISxOf4Z94=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7C2D560A60;
        Fri,  8 Feb 2019 15:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549639743;
        bh=RSivgelWf0tOpJcqIVSHPiViDNBZHs9eqkKhI4kyDgI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=AdCGe60SyF7N99PFY9OPr9I7rbQdKCyGnAijZ0+T5CM2WbNzsV5cS+TPULNIxfRh+
         HBhL1OTEEEVqRs4MfWY3wLV1gsZ8cRng5I4vdDDUPKqos4y8cAYrAhnkMjgD5mf7C4
         xCAAHD7goyB57eCNPCEgibKLh/KqFLKh5UDJVP8g=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7C2D560A60
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][RESEND] rtlwifi: remove set but not used variable
 'cmd_seq'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190130031526.20308-1-yuehaibing@huawei.com>
References: <20190130031526.20308-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <pkshih@realtek.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190208152905.1A8B660D2E@smtp.codeaurora.org>
Date:   Fri,  8 Feb 2019 15:29:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/realtek/rtlwifi/base.c: In function 'rtl_c2h_content_parsing':
> drivers/net/wireless/realtek/rtlwifi/base.c:2313:13: warning:
>  variable 'cmd_seq' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

78f2ef18e185 rtlwifi: remove set but not used variable 'cmd_seq'

-- 
https://patchwork.kernel.org/patch/10787619/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

