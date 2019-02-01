Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B549C282DB
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D745E2082C
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:27:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="czZ9JysG";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="oFbT4ju3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbfBAM1c (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:27:32 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36638 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728311AbfBAM1c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 07:27:32 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2F68660867; Fri,  1 Feb 2019 12:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024051;
        bh=Lof2d16E8dRmPl+DyxaN6eybd2pS/GJ9Jg9geDkVS18=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=czZ9JysGfFICvh2NklFrziXBdNPwBmfjXdMC5AnUUTm222+LDJKF39Twq/0GN0QeO
         0tYwJGjjW2wyi7oig8IZnin1kMiy5xhJQd02RW/z6uzJxLD+drB54M0nzA4mnr0rDN
         W9Cg9GUxIWZoy5/GplB738561MubIjPkGmQ71yD8=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6800B60398;
        Fri,  1 Feb 2019 12:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024050;
        bh=Lof2d16E8dRmPl+DyxaN6eybd2pS/GJ9Jg9geDkVS18=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=oFbT4ju3W6AbHjoesthUpqZvuoOTHiyIqn5v6OqPYTPhA9EwDP13oeeYDLlzVQqsm
         N6ohKRbgM+Q8+Zscj1g3f2rNRN1aXm/qIZPkDoPzmKxuKJ3r46DApner7YrRootQ8N
         sMCH8x71Wztoes/BjwLJ7Nu3wZIlRZozFYZaCokM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6800B60398
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wlcore: clean up an indentation issue
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190118231231.31577-1-colin.king@canonical.com>
References: <20190118231231.31577-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Tony Lindgren <tony@atomide.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190201122731.2F68660867@smtp.codeaurora.org>
Date:   Fri,  1 Feb 2019 12:27:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a goto statement that is missing a tab for indentation. Fix this.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

112ec26fcdc5 wlcore: clean up an indentation issue

-- 
https://patchwork.kernel.org/patch/10771801/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

