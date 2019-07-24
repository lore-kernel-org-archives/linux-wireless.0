Return-Path: <SRS0=rB3s=VV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 447E4C7618B
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Jul 2019 11:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CF1D21926
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Jul 2019 11:56:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JxFr8r0L";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JptXuPHV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387412AbfGXL4Z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Jul 2019 07:56:25 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:54858 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387399AbfGXL4Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jul 2019 07:56:25 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 85D4660237; Wed, 24 Jul 2019 11:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563969384;
        bh=T1mEInhQsvO7b+rmkBPC8By80T/v6+xJ1QiOuv+qJJQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=JxFr8r0LyCw+7bhin0h6Q1MTyTlLlye9x2BP5B93f5DuqOFr29bUC1n2oVMi/518E
         /vCrUwQzH7V0J3rq1rHtKYXnrnpG92BjNYWfpjVmQGEGXyqtlMWkhv2ClQb3Wabh7O
         +hFwZAaCl1o6o6CHOi+bJSUlXscuvKvW+ty8XbfQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7D54560214;
        Wed, 24 Jul 2019 11:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563969384;
        bh=T1mEInhQsvO7b+rmkBPC8By80T/v6+xJ1QiOuv+qJJQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=JptXuPHVjFzh+m9EdAJ5qVrnVpIS1m/gNrw6G9mInnFg7nxoJhOOEZh0ytZmen4c+
         Dkpy+cFK5OgTBFeCoPd5x5jLWM9aD44YVmHUIG3Q77/Fz6XHnc0j/RkhmlkCA5YKjM
         FiJPIQ/1JV6rskSHdSCCs9vlYhISZfpI+JoVNRgw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7D54560214
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH wireless-drivers-next v2] mwifiex: use
 eth_broadcast_addr() to assign broadcast address
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190724062545.119041-1-maowenan@huawei.com>
References: <20190724062545.119041-1-maowenan@huawei.com>
To:     Mao Wenan <maowenan@huawei.com>
Cc:     <amitkarwar@gmail.com>, <nishants@marvell.com>,
        <gbhat@marvell.com>, <huxinming820@gmail.com>,
        <linux-wireless@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190724115624.85D4660237@smtp.codeaurora.org>
Date:   Wed, 24 Jul 2019 11:56:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Mao Wenan <maowenan@huawei.com> wrote:

> This patch is to use eth_broadcast_addr() to assign broadcast address
> insetad of memcpy().
> 
> Signed-off-by: Mao Wenan <maowenan@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

15e830e90fde mwifiex: use eth_broadcast_addr() to assign broadcast address

-- 
https://patchwork.kernel.org/patch/11056129/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

