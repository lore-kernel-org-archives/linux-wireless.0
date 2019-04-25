Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 399A2C282E3
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 11:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 087A7214AE
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 11:05:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="geGqhXmD";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cBnJWkPG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730647AbfDYLFw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 07:05:52 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59000 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbfDYLFw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 07:05:52 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B78C060769; Thu, 25 Apr 2019 11:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556190351;
        bh=oPDPICGg8a+aHTjcYuPf0lbLYrCvtVasE6Dp6etuXo8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=geGqhXmD1lCrzQY4LmVyllMC17k1BNyjmkkhtQTsGRfLhlpHa+LlfgulyxdvUvCBL
         /LodxzDx12N/FHJ8IZMKLlVjpP/nrvdWSnmgWl2FRXyD6DpHryUJ2E/mTub4yKk87w
         q5oEfKzcdCWgttJ+Y3VObOWG7kiHIc25fyDvnAC0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D961B60275;
        Thu, 25 Apr 2019 11:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556190350;
        bh=oPDPICGg8a+aHTjcYuPf0lbLYrCvtVasE6Dp6etuXo8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=cBnJWkPGX2vW6s6bwBLV/lNiv4kvSbTSmsRSOjKo+UrJOimpxMu4LH7e0bY0h8d1r
         UoZlctdMFd8WMKoHpxLPw9/5QwJkGgcMj79S750+yMyCyyst/jBAgMmm/wO/zhS3OM
         WVmLMYSTzM3SQAtp6uBU/iBM7dmR2vb/nV8wZCgc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D961B60275
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: Make resume actually do something useful again
 on SDIO cards
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190404040106.40519-1-dianders@chromium.org>
References: <20190404040106.40519-1-dianders@chromium.org>
To:     Douglas Anderson <dianders@chromium.org>
Cc:     linux-rockchip@lists.infradead.org, briannorris@chromium.org,
        mka@chromium.org, ryandcase@chromium.org, heiko@sntech.de,
        Douglas Anderson <dianders@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ganapathi Bhat <gbhat@marvell.com>,
        linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-kernel@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        netdev@vger.kernel.org, Xinming Hu <huxinming820@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425110551.B78C060769@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 11:05:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Douglas Anderson <dianders@chromium.org> wrote:

> The commit fc3a2fcaa1ba ("mwifiex: use atomic bitops to represent
> adapter status variables") had a fairly straightforward bug in it.  It
> contained this bit of diff:
> 
>  - if (!adapter->is_suspended) {
>  + if (test_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags)) {
> 
> As you can see the patch missed the "!" when converting to the atomic
> bitops.  This meant that the resume hasn't done anything at all since
> that commit landed and suspend/resume for mwifiex SDIO cards has been
> totally broken.
> 
> After fixing this mwifiex suspend/resume appears to work again, at
> least with the simple testing I've done.
> 
> Fixes: fc3a2fcaa1ba ("mwifiex: use atomic bitops to represent adapter status variables")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers.git, thanks.

b82d6c1f8f82 mwifiex: Make resume actually do something useful again on SDIO cards

-- 
https://patchwork.kernel.org/patch/10884883/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

