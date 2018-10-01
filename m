Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C1DC00449
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 15:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFDD520C0A
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 15:49:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="F5j/AibX";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SsLLrPl7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AFDD520C0A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbeJAW13 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 18:27:29 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:47856 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbeJAW12 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 18:27:28 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 466F660866; Mon,  1 Oct 2018 15:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538408943;
        bh=wXcUswX85Hdx4tRDXqHiDrBMNX+jzDX1LRayJRfeES8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=F5j/AibXUGl38oG5/DZiLeaOQilAJd8BcpPGMj5ptT3rOTJiN0SOz5ooyiW8NQpWq
         RJBp3N7JXtxwxl+eUwQdvDt+1uCjWtabHbbghxvEjp2xee0YPht/kOI3yGgwIDuVnd
         IZdnmnJpXG2z4Ce5vU/ScSP/xRbFyYtJSrWxJ61E=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 69F4A6076A;
        Mon,  1 Oct 2018 15:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538408943;
        bh=wXcUswX85Hdx4tRDXqHiDrBMNX+jzDX1LRayJRfeES8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=SsLLrPl7dfdsbj0aLS1nYUYfddMP3Lu98RL+gvg1jh4Sv6wbXEE7Xut1ysW9VcmCq
         xDVCmQgRqzlmoPHjNVhFbTRXJVaRyIOKA7Dby4Vf3pZID4GEp12Pwkkt7Q1q3dxUc8
         zsmkcIEf+q3HrTEC8g4hMq26AtkW9AYAdCg+oykg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 69F4A6076A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ipw2x00: clean up clang warning on extraneous parentheses
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180930223809.18136-1-colin.king@canonical.com>
References: <20180930223809.18136-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181001154903.466F660866@smtp.codeaurora.org>
Date:   Mon,  1 Oct 2018 15:49:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> There are extraneous parantheses that are causing clang to produce a
> warning so remove these.
> 
> Clean up clang warning:
> equality comparison with extraneous parentheses [-Wparentheses-equality]
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

I applied an identical patch few minutes ago:

c15ace868dd1 ipw2x00: Remove unnecessary parentheses

Patch set to Rejected.

-- 
https://patchwork.kernel.org/patch/10621549/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

