Return-Path: <SRS0=qTSE=YH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A05CC4CECE
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Oct 2019 09:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E820220854
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Oct 2019 09:11:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="a5mf68sx";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="N9it/WNm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730711AbfJNJLw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Oct 2019 05:11:52 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49836 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730438AbfJNJLw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Oct 2019 05:11:52 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9CCEC60721; Mon, 14 Oct 2019 09:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571044311;
        bh=/D2J8bLG8v0KuuGyQkFZgTKpx+6h5nauz0Ylftxx4SQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=a5mf68sx2dtIJcdi7+7whj8p5efHHmlkZTkpWnNGdMCjzWUWcCcRGKKlhYpKmQLYB
         QZv0zTZO1W4R3+254FHr34ZpjsLIg8LaL89kQs1Zg1A8oDOw4qpwy7VGJxO37d35H8
         q0LdUyHCz4cLBezvI1QQFr9QLjez7QT54fJYtWo4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B108F6074F;
        Mon, 14 Oct 2019 09:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571044309;
        bh=/D2J8bLG8v0KuuGyQkFZgTKpx+6h5nauz0Ylftxx4SQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=N9it/WNmygoY6svknDsjx3xkEgALQnLaZi76qssoaS4fNkG/BzpJXGGi9jkKJAons
         6x7k/FgGsb8gwVuXEn3DyRbpFSkBROKZlx9+UjVvZU4u5NAuRoa0D5mT2cHju94pjm
         ct8fArjQOUOuj+kmllqG19r/1Y78XwMex+nyN+nA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B108F6074F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtw88: use a for loop in rtw_power_mode_change(), not goto
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191012012720.227399-1-briannorris@chromium.org>
References: <20191012012720.227399-1-briannorris@chromium.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     <linux-wireless@vger.kernel.org>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Brian Norris <briannorris@chromium.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191014091151.9CCEC60721@smtp.codeaurora.org>
Date:   Mon, 14 Oct 2019 09:11:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> wrote:

> No change in logic.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Acked-by: Yan-Hsuan Chuang <yhchuang@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

4ee2f3426699 rtw88: use a for loop in rtw_power_mode_change(), not goto

-- 
https://patchwork.kernel.org/patch/11186533/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

