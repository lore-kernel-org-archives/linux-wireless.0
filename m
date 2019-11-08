Return-Path: <SRS0=s5sB=ZA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A92CEC5DF60
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Nov 2019 08:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7078121D6C
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Nov 2019 08:44:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nkRuvK4r";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CfmtE3lk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfKHIow (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Nov 2019 03:44:52 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38492 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727421AbfKHIow (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Nov 2019 03:44:52 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C010F60909; Fri,  8 Nov 2019 08:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573202691;
        bh=q2mJk7VwXyoKNejkLtZeKiAGzvIXEYJAYn1LqGhZmVI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=nkRuvK4rRMhiqCQtOztttWGGy0+cPy87DtryHJ/GfHcU6FQZodcLjMjBo2sDiaXpi
         UOa36dypk3aAdPq+0v+oPnqAs8ElJqHz4BMQP97HkazsY5H4sf8lsRu92SYJZFequy
         TcprPnN0ufhcC5kBvuPnknSutMi1gPHYi4ATw1yI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 81AF9606FB;
        Fri,  8 Nov 2019 08:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573202691;
        bh=q2mJk7VwXyoKNejkLtZeKiAGzvIXEYJAYn1LqGhZmVI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=CfmtE3lkHZqLI+Jyxe5InNcD0EJsGBu+cxhqSuvRXX+50iJ5SjCZ0i4thJ4zVEm4W
         xbRkp7vqrSgLVc2i6NtIaG/tMdr2c7YoQESGBObH6AQ00pZV0BCfsFIoGHvwPA8iR8
         2LPmJ6LcymzLjRhTGZzWQgepJo52VXdE8S/e4DMw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 81AF9606FB
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: fix potential issue of peer stats allocation
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1572486133-23516-1-git-send-email-zhichen@codeaurora.org>
References: <1572486133-23516-1-git-send-email-zhichen@codeaurora.org>
To:     Zhi Chen <zhichen@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Zhi Chen <zhichen@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191108084451.C010F60909@smtp.codeaurora.org>
Date:   Fri,  8 Nov 2019 08:44:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Zhi Chen <zhichen@codeaurora.org> wrote:

> STA number was not restored if OOM happened.
> 
> Tested: QCA9984 with firmware ver 10.4-3.9.0.1-00018
> Signed-off-by: Zhi Chen <zhichen@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

402838a05def ath10k: fix potential issue of peer stats allocation

-- 
https://patchwork.kernel.org/patch/11220555/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

