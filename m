Return-Path: <SRS0=/cM4=X3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2254FC352AA
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Oct 2019 04:16:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBD6B2086A
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Oct 2019 04:16:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="E/kpD2TK";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WlNBoBd4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfJBEQd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 2 Oct 2019 00:16:33 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44536 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbfJBEQd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Oct 2019 00:16:33 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 202C960A4E; Wed,  2 Oct 2019 04:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569989792;
        bh=ABMSwBPwGo1QU011XzMyCQf5av246ZTYkO7iYK1Iv8A=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=E/kpD2TKLbsKCl65STaq83aE+IVbolqVruutjM0ylvbvgSw8kO5T50441zM4iV2ku
         iHOaS/gmbXxJdicCZypVxbNHXyechFWNN5eU3vTrkYtkgyZVpEA+02g8jz505L/W9s
         pjnxFusWqknlHLc/Hh7n9DHIo/7JiJ8H+JPpjeo4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DDF1A6074F;
        Wed,  2 Oct 2019 04:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569989791;
        bh=ABMSwBPwGo1QU011XzMyCQf5av246ZTYkO7iYK1Iv8A=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=WlNBoBd4jLJRy7tJL0lWaKCnBxumVD9vivjPf5RU0WmEZ45W0gPnso1Vgkcd3nAwy
         ztfgsT6O66D5DF3NwBnnlW/CcEpWhCbMHO1Lu+lC+R+lGEeUltGee1AOQHERJu6kh3
         qzxO7htY7LWLkDjUbny2UhIaeOzCTbf++uAo5iOc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DDF1A6074F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 17/35] net/wireless: Use kmemdup rather than
 duplicating its implementation
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190703162934.32645-1-huangfq.daxian@gmail.com>
References: <20190703162934.32645-1-huangfq.daxian@gmail.com>
To:     Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     unlisted-recipients:; (no To-header on input)
        "David S . Miller" <davem@davemloft.net>,
        Solomon Peachy <pizza@shaftnet.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)"David S . Miller" <davem@davemloft.net>
                                                                     ^-missing end of address
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191002041632.202C960A4E@smtp.codeaurora.org>
Date:   Wed,  2 Oct 2019 04:16:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fuqian Huang <huangfq.daxian@gmail.com> wrote:

> kmemdup is introduced to duplicate a region of memory in a neat way.
> Rather than kmalloc/kzalloc + memcpy, which the programmer needs to
> write the size twice (sometimes lead to mistakes), kmemdup improves
> readability, leads to smaller code and also reduce the chances of mistakes.
> Suggestion to use kmemdup rather than using kmalloc/kzalloc + memcpy.
> 
> Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

ab8c31dd8c8a net/wireless: Use kmemdup rather than duplicating its implementation

-- 
https://patchwork.kernel.org/patch/11029833/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

