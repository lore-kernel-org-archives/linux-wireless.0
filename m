Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90244C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FDA021872
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:52:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KE8VYc2a";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fnSSwoiD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfBGOwb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 09:52:31 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56450 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbfBGOwb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 09:52:31 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 00053608FD; Thu,  7 Feb 2019 14:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549551150;
        bh=hKP85RPVuXD6mqKl+ZpHPKc4fqmFwkxIrni2BOvLx6o=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=KE8VYc2azs9oMRju5el+CuqzWxVUQH2PjEx4yv+FvoL0yJNWPdun3r7u13txRLbE/
         qY9uULaTSR2L9yrCP0HPZ7u6k9vuPZXLRVrk812WPVzaXIYxPkYLt/BKHwOgFmFlbh
         j91dSYQpXwydcgPE0ctIhWZXLTO5pssuELngS+DE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C87C160878;
        Thu,  7 Feb 2019 14:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549551148;
        bh=hKP85RPVuXD6mqKl+ZpHPKc4fqmFwkxIrni2BOvLx6o=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=fnSSwoiD1bv/mTEnEuU4vJcdsr4JRvbOi+c7qxjmGe+7ormQ12qmiJW2C1JdDxodA
         JLLSYVTdfjr0frMw87RsUnRL2US2WwH89DDkW5CeH9UgyBQKGNO2csrs6y32wEdtfN
         eWTX9HjBZzFtw4UtZlb89xSnQ7d/UlU5r5g0ltks=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C87C160878
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Change swap mail box check after htc ready
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1548763392-3378-1-git-send-email-wgong@codeaurora.org>
References: <1548763392-3378-1-git-send-email-wgong@codeaurora.org>
To:     Wen Gong <wgong@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190207145230.00053608FD@smtp.codeaurora.org>
Date:   Thu,  7 Feb 2019 14:52:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wen Gong <wgong@codeaurora.org> wrote:

> The swap box flag of firmware is not set before htc ready, then it
> will not set swap box flag in ath10k driver, and it will let swap
> box setting not same between firmware and ath10k driver, then it
> will trigger firmware assert failure.
> 
> Check the flag and set swap box after htc ready will fix the firmware
> assert failure.
> 
> Tested with QCA6174 SDIO with firmware
> WLAN.RMH.4.4.1-00005-QCARMSWP-1.
> 
> Signed-off-by: Wen Gong <wgong@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

40194e3b36bf ath10k: change swap mail box check after htc ready

-- 
https://patchwork.kernel.org/patch/10786095/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

