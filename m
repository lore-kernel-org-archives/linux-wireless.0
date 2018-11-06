Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A4E2C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:52:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F17120685
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:52:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XpEPBtno";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="O96ZRKpS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F17120685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389404AbeKGCSc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:18:32 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54478 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389214AbeKGCSc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:18:32 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0066360B62; Tue,  6 Nov 2018 16:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523147;
        bh=vkL/sQbn1V4G376VvRcFZxMrt9+MtLjOVSB4PNJrLJ4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=XpEPBtnoDiIiC4IIwJBgYQyj5Xa/I/uQgcjqrLByXhWJG9A77CVte7sg1oMpMn6ql
         ErX93oR/PaxCGhpsOhKrkr/4WwhKSxrON9kdh1OPWcFUmYDhJYmcJ7ZIH3XgDGIXK/
         7+3xh7j6TWlj/QV3iMKBFCblK0//XLmUqXyJGNcQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8911F60741;
        Tue,  6 Nov 2018 16:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523146;
        bh=vkL/sQbn1V4G376VvRcFZxMrt9+MtLjOVSB4PNJrLJ4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=O96ZRKpSEQNy4raUJloZW7kp66pSWFxbf+feXoA40KJnOcw0wWS0X/24a6y3+AqR4
         wEZrrUDmcGJvr8GwoZwcnFVGauUN4tLlYM0DvsrNGZc/bnPZOYhUy6VmuVF9KITwgj
         av14U/3aA6xLzjk6t8KpHqLunHmIGXXSQxIQEGuY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8911F60741
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rsi: fix spelling mistake "Initialzing" -> "Initializing"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181013153730.5761-1-colin.king@canonical.com>
References: <20181013153730.5761-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106165227.0066360B62@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 16:52:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Trivial fix to spelling mistake in rsi_dbg debug message
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

55930d2bf79b rsi: fix spelling mistake "Initialzing" -> "Initializing"

-- 
https://patchwork.kernel.org/patch/10640377/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

