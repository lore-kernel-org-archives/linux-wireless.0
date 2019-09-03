Return-Path: <SRS0=FCSK=W6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B4AC3A5A2
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE04523402
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:28:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GmhbteQq";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cOiLnE8b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbfICN2d (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Sep 2019 09:28:33 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43640 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727667AbfICN2c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Sep 2019 09:28:32 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 06B08605A2; Tue,  3 Sep 2019 13:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567517312;
        bh=UPDX6OgSiKhPn73uoKfLUN84tKWC0UsUxKg7qiPDziI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=GmhbteQqPQjnAZ8QYiB6rrVvVseElNosQGAMNjvscqwK+CLVTOLP7h578MWb9YFmW
         WfQwvBhdFIxVicFRHcbJdq35cCbDqfgwKf1qEwnXhTOym1g1CR+ZKp3fQ9bLGc+4MM
         EwKN1g0L0XtAUI3JtUWxrv1X8URXj48lQs++OpWk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D93616058E;
        Tue,  3 Sep 2019 13:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567517310;
        bh=UPDX6OgSiKhPn73uoKfLUN84tKWC0UsUxKg7qiPDziI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=cOiLnE8bR+TiLPho47oqp5FD3LPgwG+OPY/dMEiQEOMtEKk44N9wpUbltUD9zRI5N
         43xJ39LoVYKpuUPrTSvhH62It+leoiZiYdGJq/tEZZxvtVUvAWSjUBqVUVWf/qg20u
         n8iAncYLe0c3iOCEaI+27kvsfh9+I2xWVsW7RFVk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D93616058E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 5/5] rtlwifi: rtl8192cu: Fix value set in descriptor
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190812192741.14479-1-Larry.Finger@lwfinger.net>
References: <20190812192741.14479-1-Larry.Finger@lwfinger.net>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190903132832.06B08605A2@smtp.codeaurora.org>
Date:   Tue,  3 Sep 2019 13:28:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> In the process of converting the bit manipulation macros were converted
> to use GENMASK(), the compiler reported a value too big for the field.
> The offending statement was trying to write 0x100 into a 5-bit field.
> An accompaning comment says to set bit 3, thus the code is changed
> appropriately.
> 
> This error has been in the driver since its initial submission.
> 
> Fixes: 29d00a3e46bb ("rtlwifi: rtl8192cu: Add routine trx")
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers-next.git, thanks.

01bb31de5262 rtlwifi: rtl8192cu: Fix value set in descriptor

-- 
https://patchwork.kernel.org/patch/11090677/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

