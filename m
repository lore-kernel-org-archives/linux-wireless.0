Return-Path: <SRS0=gBLi=2I=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83AC4C43603
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Dec 2019 18:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B1772082E
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Dec 2019 18:55:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="Uqobc6qV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfLRSzr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 18 Dec 2019 13:55:47 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:27698 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727453AbfLRSzq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Dec 2019 13:55:46 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576695345; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Q129bDfo2EZNxP4oLnfzWOAYnwh3z0vJrKECLwqtVj8=;
 b=Uqobc6qViprbGEh/gFeHEW+3Ib5gQ19RcmMLHZYRE+X4jAtpm5Ysrv6VZ2kfBOTa9xemQvAM
 HVZ2gyMebJrGhiZjZGbBudSasmNPW+xXr4/eXJVW4E327krKBdEmceIXWeLD2/CQYdoQUSgH
 hIygRDd2PVdyDaVsBGw0zeDMx38=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5dfa762d.7fb6080f2848-smtp-out-n01;
 Wed, 18 Dec 2019 18:55:41 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9F335C447B1; Wed, 18 Dec 2019 18:55:41 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 10886C43383;
        Wed, 18 Dec 2019 18:55:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 10886C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bcma: remove set but not used variable 'sizel'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191127124433.34301-1-yukuai3@huawei.com>
References: <20191127124433.34301-1-yukuai3@huawei.com>
To:     yu kuai <yukuai3@huawei.com>
Cc:     <zajec5@gmail.com>, <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <yi.zhang@huawei.com>,
        <zhengbin13@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191218185541.9F335C447B1@smtp.codeaurora.org>
Date:   Wed, 18 Dec 2019 18:55:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

yu kuai <yukuai3@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/bcma/scan.c: In function ‘bcma_erom_get_addr_desc’:
> 
> drivers/bcma/scan.c:222:20: warning: variable ‘sizel’ set but
> not used [-Wunused-but-set-variable]
> 
> It is never used, and so can be removed.
> 
> Fixes: 8369ae33b705 ("bcma: add Broadcom specific AMBA bus driver")
> Signed-off-by: yu kuai <yukuai3@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

f427939391f2 bcma: remove set but not used variable 'sizel'

-- 
https://patchwork.kernel.org/patch/11263913/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
