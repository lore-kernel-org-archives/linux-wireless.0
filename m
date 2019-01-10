Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD2DC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:31:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E8FC206B6
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:31:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RmWQM7P+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="D3q/xd4m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbfAJLbK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 06:31:10 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44970 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727455AbfAJLbK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 06:31:10 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B3E3660386; Thu, 10 Jan 2019 11:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547119869;
        bh=caKWDblzX721PymI774cykDlSlSMBTv7lkG4ZQSgZVI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=RmWQM7P+emp3TjYIiBIQk8WZPtY7qW1rIQO50mqeNrMl3MVYbA3lJqqnhBwF3qEm+
         /ox8kJWx8TxUNAsJUWgvLIpoVnEz1tMB2q6fzS1Unpk++steXQX2P99x8ytUH8u31i
         4mHI3gANgkO+hDc9JQSHqaGFZWgxLrS4BVVEoLOQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A17B060247;
        Thu, 10 Jan 2019 11:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547119868;
        bh=caKWDblzX721PymI774cykDlSlSMBTv7lkG4ZQSgZVI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=D3q/xd4mCUF0gfqvl9wCvU39PCVFqbPKuKnR/TxzkgYjhOJxMnrHlO0H84PZueS9n
         lFaRQfFA0olzwAiHyLUjjFFfvMGShwgu7QpgeKzUe8ytII3KYV/Zc6OllD2iY8Mkqs
         +wLYMbNs3OWfHIOso0qugD5jsio6zYloFeEI+5Gs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A17B060247
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmsmac: remove set but not used variables 'phybw40,
 maxtargetpwr'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181220035522.10640-1-yuehaibing@huawei.com>
References: <20181220035522.10640-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <plaes@plaes.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190110113109.B3E3660386@smtp.codeaurora.org>
Date:   Thu, 10 Jan 2019 11:31:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:1202:5: warning: variable 'phybw40' set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:4625:5: warning: variable 'phybw40' set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:4834:5: warning: variable 'phybw40' set but not used [-Wunused-but-set-variable]
> 
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:3085:17: warning: variable 'maxtargetpwr' set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:4215:17: warning: variable 'maxtargetpwr' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

6375d40322f0 brcmsmac: remove set but not used variables 'phybw40, maxtargetpwr'

-- 
https://patchwork.kernel.org/patch/10738529/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

