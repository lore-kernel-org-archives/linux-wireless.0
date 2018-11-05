Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2E8C46475
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 10:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1071620825
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 10:11:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dMuGAR2d";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BouiNW9Z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1071620825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbeKETab (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 14:30:31 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:45762 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbeKETab (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 14:30:31 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 152A36130B; Mon,  5 Nov 2018 10:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541412694;
        bh=RNi37scPqUc5+4ByLx3689lFCL0+dzRDB/SDQrNuCAw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=dMuGAR2dXV5MQkI3Q2EK1smO/GHDUGrpL0w1KvmtMkeW1frdWHgMWj8NRPW/ql+Z1
         Z682bAIdCAwJt9zHL2ise1BVbQzI2I9oVc22gmSqsRkRyEsroA0ZvG6XhwKX1i712n
         GNqLLjJjYuM+KyisOV5WjYAD2vYAIs6smxwyWcuk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C1D4B61308;
        Mon,  5 Nov 2018 10:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541412693;
        bh=RNi37scPqUc5+4ByLx3689lFCL0+dzRDB/SDQrNuCAw=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=BouiNW9ZhgJ6P7YBjLQsTAWfuD2f6jdELltFQPJV7werG9B9Hg7QUhvHfzqmwR+KJ
         KW1g7pxKZHBl9O2Mx5EGw69gRTqhYDqpdzTvaa+CJ4/kLc02umWZeQ9awLIYh0kjlt
         A+hog4dSOup0HRLLCZXeh4kT1KvellkPyFf6p8mI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C1D4B61308
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] ath10k: Add memory dump support for QCA4019
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1539324397-10597-1-git-send-email-akolli@codeaurora.org>
References: <1539324397-10597-1-git-send-email-akolli@codeaurora.org>
To:     Anilkumar Kolli <akolli@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181105101134.152A36130B@smtp.codeaurora.org>
Date:   Mon,  5 Nov 2018 10:11:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Anilkumar Kolli <akolli@codeaurora.org> wrote:

> This patch adds firmware crash memory dump support for QCA4019.
> 
> Tested on:
> 
> QCA4019 firmware 10.4-3.2.1.1-00017
> 
> Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

bbcfb343fa7f ath10k: add memory dump support for QCA4019
5f09037a0cc2 ath10k: assign proper firmware crash dump structure

-- 
https://patchwork.kernel.org/patch/10637935/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

