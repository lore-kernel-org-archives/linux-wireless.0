Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 655D1C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 16:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32E54217D8
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 16:47:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Pa7ufC5K";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="i9GAXFJ5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731825AbeLTQrC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 11:47:02 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37716 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727652AbeLTQrC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 11:47:02 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CED3C607F1; Thu, 20 Dec 2018 16:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545324421;
        bh=4oyYXGjkpOZl26cLvErlG0A8BVdvbjbNVqZLLArHy+w=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Pa7ufC5Kgwlm8AGec+cLYEnD/kzZsaiw7WN2rwuJ4gBiEkhgpM/XjuHi5OwxxnBC5
         eseEfzCCv0QI+AJI8Ta3GiweP4XkVBPLecLFAWpaluT6wIjBR8M0cVAt5SOh9vdXln
         7/KkA490y6fABuM6i7j548Qslsbenq0fbtI4KLNs=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CE0656053B;
        Thu, 20 Dec 2018 16:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545324421;
        bh=4oyYXGjkpOZl26cLvErlG0A8BVdvbjbNVqZLLArHy+w=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=i9GAXFJ5dlvwYal8EDvgEUpT3eOU94btjNPv+oG2FDFpiksC1ShmMTy8FTRyISEKH
         0xUcrnLm4CV5zUo16R8/arBHaSXKJ3fI8h93CcB90r1X+fvgBfgDTDpJB8GRyPVIQf
         CaZ6w/mASr71I9xwIguhQX5ohMIaEdo0mg5EZ5pE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CE0656053B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: remove set but not used variable 'num_tdls_vifs'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1541669570-110540-1-git-send-email-yuehaibing@huawei.com>
References: <1541669570-110540-1-git-send-email-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     YueHaibing <yuehaibing@huawei.com>, <ath10k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181220164701.CED3C607F1@smtp.codeaurora.org>
Date:   Thu, 20 Dec 2018 16:47:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/ath/ath10k/mac.c: In function 'ath10k_sta_state':
> drivers/net/wireless/ath/ath10k/mac.c:6238:7: warning:
>  variable 'num_tdls_vifs' set but not used [-Wunused-but-set-variable]
> 
> 'num_tdls_vifs' not used any more after
>   9a993cc1ea95 ("ath10k: fix the logic of limiting tdls peer counts")
> 
> Also, remove the single called function ath10k_mac_tdls_vifs_count
> and ath10k_mac_tdls_vifs_count_iter.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

bff70e5f78e9 ath10k: remove set but not used variable 'num_tdls_vifs'

-- 
https://patchwork.kernel.org/patch/10673841/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

