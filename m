Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CEAFC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C51CC208D9
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:09:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="n/C6dgI6";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gVFBL6yQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C51CC208D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbeJAUq5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 16:46:57 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38280 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728979AbeJAUq5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 16:46:57 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 36A7260C1B; Mon,  1 Oct 2018 14:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538402938;
        bh=s+YLz7KxtAWc7Rib6IsHtEGaS5IxPPM7inw/rFoE/8w=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=n/C6dgI6fv663jwedq/rtU8ENydNJ9qlGmJpvboNXNlf1qcPcXpqtPMLSL8XNyaQ4
         ect5q0gaGiB/kHbVAwzP+hMb1YBY+wqLXXitnHuYHGJ5E2LkR95mwpUlv8yGuhDlHb
         VuxUdKh43qg03DUJQi7Noao9BcHz94XYgtBNkSGY=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6CB64607DC;
        Mon,  1 Oct 2018 14:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538402937;
        bh=s+YLz7KxtAWc7Rib6IsHtEGaS5IxPPM7inw/rFoE/8w=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=gVFBL6yQNw/sZrd7a26oD7akhTUa6DIb2KKbQWQruEWkirclolVpTau7mSIM/TgC6
         WhyoWrqWNB8LTPtlYFN0GcgvDJCg3r7Ge0G10QJqimOt/iDuMjWFBD0k5N3FgzzKpK
         X3FqO7WFend4WVysTXk8STIfgnmi16wQcfEc23/Q=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6CB64607DC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wil6210: remove set but not used variable 'start'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1536669139-14848-1-git-send-email-yuehaibing@huawei.com>
References: <1536669139-14848-1-git-send-email-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Maya Erez <merez@codeaurora.org>,
        YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <wil6210@qti.qualcomm.com>,
        <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181001140858.36A7260C1B@smtp.codeaurora.org>
Date:   Mon,  1 Oct 2018 14:08:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/ath/wil6210/pm.c: In function 'wil_suspend_keep_radio_on':
> drivers/net/wireless/ath/wil6210/pm.c:193:16: warning:
>  variable 'start' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Reviewed-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

ec95e84c3955 wil6210: remove set but not used variable 'start'

-- 
https://patchwork.kernel.org/patch/10595613/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

