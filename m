Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CDB0C282CC
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 15:02:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A34321904
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 15:02:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Mjhg6qky";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OX5H6i7z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfBGPB4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 10:01:56 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36826 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfBGPBz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 10:01:55 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EBA7B6030D; Thu,  7 Feb 2019 15:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549551715;
        bh=7JQWRwavZIe2xdjZ6I2Rm6ZPPaLICGfk09NTkfMitGw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Mjhg6qkypVgMOJLYW/z3Q8dCkIUEgZnWMi5JeqwPtY7MC0D/s5IDhLIkjTEnTW+4z
         zW+Wu7wzapOsglyIpDKP09xlzCOGk9LruG163jcCzwrc3cBe8lc/YLa1To9Ga/U842
         kR95+3Qny7uUx4Pt/A+vuNloEFdKZCzLXLp5o7CA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CB1D2605FC;
        Thu,  7 Feb 2019 15:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549551714;
        bh=7JQWRwavZIe2xdjZ6I2Rm6ZPPaLICGfk09NTkfMitGw=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=OX5H6i7zAN45MvwCYgSRhpv5e6yzzHABOA+KcqoApYhaOXbJhkt5F53Gf+mLwjnSU
         KhjIL9ceV7qu9d+R6e7Iob1L9bxAA7BHpLLmHRJb5jRi7Vg3IG80F1AyXN0Rzx5KCT
         cVhxpxSBjApymn7X4yTuTE9hIJh9bqqZgPOzUXA8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CB1D2605FC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath: move spin_lock_bh to spin_lock in tasklet
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190122163033.51095-1-qq282012236@gmail.com>
References: <20190122163033.51095-1-qq282012236@gmail.com>
To:     Zhiwei Jiang <qq282012236@gmail.com>
Cc:     qq282012236@gmail.com, ath9k-devel@qca.qualcomm.com,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190207150154.EBA7B6030D@smtp.codeaurora.org>
Date:   Thu,  7 Feb 2019 15:01:54 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Zhiwei Jiang <qq282012236@gmail.com> wrote:

> as you are already in a tasklet, it is unnecessary to call
> spin_lock_bh, because softirq already disable BH.
> 
> Signed-off-by: Zhiwei Jiang <qq282012236@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

b789f333d7ac ath: move spin_lock_bh to spin_lock in tasklet

-- 
https://patchwork.kernel.org/patch/10775865/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

