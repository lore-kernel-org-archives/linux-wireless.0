Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90AC6C28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:06:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 564BE20659
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:06:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GxAXdlWA";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="h/xl7UMo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 564BE20659
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbeJNAnu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 20:43:50 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39680 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbeJNAnu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 20:43:50 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3879D60B72; Sat, 13 Oct 2018 17:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539450354;
        bh=T3niiUekW6H17D3koI+YESKbhPh+vkVSMp3lV6DKPw0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=GxAXdlWAH/zbwanIdvme4RZdG9vOuW+uAXLH2vJmIabw8HfGyqB4MyQhFScjx4nwt
         8nZsMgnJpVWXV+tN0QS9yqwsDIFDRmysP7xao9lckQ/IdIOlYXypw/3etFDNhhc4WD
         lE/cQxJvUajI/1YMS11YpcxAyrj12VTqjVlv8hZc=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3776B605A4;
        Sat, 13 Oct 2018 17:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539450352;
        bh=T3niiUekW6H17D3koI+YESKbhPh+vkVSMp3lV6DKPw0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=h/xl7UMoEOkkPf1rHV591POTqZHQHfR4syZmc9zdHmaVepKFAqRLMzZx84yq6Pm0I
         VzI2UkTM8j91dyOPkMAF7Ch85JgT2ASDS43n52EUimd7OCMguP5GjP1xicNFD/eVJh
         O6wsAeb0Szo26MR+f8EBgBYw5prS61OZP7gZXY1g=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3776B605A4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtl8xxxu: Remove set but not used variables 'usedesc40'
 and 'seq_number'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1539008219-149058-1-git-send-email-yuehaibing@huawei.com>
References: <1539008219-149058-1-git-send-email-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181013170554.3879D60B72@smtp.codeaurora.org>
Date:   Sat, 13 Oct 2018 17:05:54 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c: In function 'rtl8xxxu_tx':
> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:4925:7: warning:
>  variable 'usedesc40' set but not used [-Wunused-but-set-variable]
> 
> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:4921:6: warning:
>  variable 'seq_number' set but not used [-Wunused-but-set-variable]
> 
> 'usedesc40' and 'seq_number' are not used any more after
> commit b59415c2dd08 ("rtl8xxxu: Split filling of TX descriptors into separate functions")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

03ce6f8a6776 rtl8xxxu: Remove set but not used variables 'usedesc40' and 'seq_number'

-- 
https://patchwork.kernel.org/patch/10630829/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

