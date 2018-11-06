Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0600AC32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C23302081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:02:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Js2DbMoT";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lzlFgZVu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C23302081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389595AbeKGC2R (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:28:17 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59012 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389285AbeKGC2R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:28:17 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E556C602F4; Tue,  6 Nov 2018 17:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523728;
        bh=eeiqNdrRFI7trLoLr3+q+8XA4YeawslobX6HU2bUkss=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Js2DbMoTrU90fxRMvLEmfmXuQ4yhT5LLloo9dpxdpsCfSrdgbv4FULFrVYthTylSM
         PodZjSc6eZ3JJVKM74ceE2ERpa6YVr0JlrcK1eZu8nc2ySf035O+yL6aa1q7YnXwAt
         Mc2ACfAMB5W7ipzmAKYLqVcSaPqhJRrXOBOBOO9M=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 481B5601D7;
        Tue,  6 Nov 2018 17:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523728;
        bh=eeiqNdrRFI7trLoLr3+q+8XA4YeawslobX6HU2bUkss=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=lzlFgZVu2BJq79zLKtGo6eSbA2jgdyQWpAJLQhtdPFHmuiLtLbOOlgC5oCwRkf63S
         CHEL1BLs9CBFwe8MU0H21tjfljJhpwq8d47iOM5b86euo2aw+sxvVldn8U8V64UAtP
         9VR2wR7Fl1sM1cNSs3BIaMdbGjjHCVf6PY1bF4z4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 481B5601D7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: Remove same duplicated includes
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1540361256-678-1-git-send-email-zhongjiang@huawei.com>
References: <1540361256-678-1-git-send-email-zhongjiang@huawei.com>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     <pkshih@realtek.com>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106170208.E556C602F4@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 17:02:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

zhong jiang <zhongjiang@huawei.com> wrote:

> Just remove same duplicated includes.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

963b307361bd rtlwifi: Remove same duplicated includes

-- 
https://patchwork.kernel.org/patch/10654183/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

