Return-Path: <SRS0=8PMz=6U=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18081C28CBC
	for <linux-wireless@archiver.kernel.org>; Wed,  6 May 2020 08:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD89220714
	for <linux-wireless@archiver.kernel.org>; Wed,  6 May 2020 08:33:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="SsN3CY6h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbgEFIdn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 May 2020 04:33:43 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:48716 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727956AbgEFIdn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 May 2020 04:33:43 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588754022; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=OYPocL6ZxseLuWGxFBZEyax0vx9qJqRECyqW/QbfKx8=;
 b=SsN3CY6hXCMJiJCPMjEimbOkxj7AXDpXLJ5IWfW1RGsm4kxpSX6l73yqFjyfTyg4hGTEfZj/
 lLAW9jHWTQrZ56uIX1/bMk4QKSOOIbiHYzNN4bp3186xXpaB7Tf4DX8k1tOYtHLyZynOFft6
 jd6kRc6Y7UKRsaYZxL8jtCjMvDQ=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb27665.7fc66887c6f8-smtp-out-n05;
 Wed, 06 May 2020 08:33:41 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7EA5FC43637; Wed,  6 May 2020 08:33:41 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E8935C433BA;
        Wed,  6 May 2020 08:33:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E8935C433BA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ray_cs: use true,false for bool variable
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200426103709.6730-1-yanaijie@huawei.com>
References: <20200426103709.6730-1-yanaijie@huawei.com>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <davem@davemloft.net>, <adobriyan@gmail.com>, <tglx@linutronix.de>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <sergei.shtylyov@cogentembedded.com>,
        Jason Yan <yanaijie@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200506083341.7EA5FC43637@smtp.codeaurora.org>
Date:   Wed,  6 May 2020 08:33:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Jason Yan <yanaijie@huawei.com> wrote:

> Fix the following coccicheck warning:
> 
> drivers/net/wireless/ray_cs.c:2797:5-14: WARNING: Comparison of 0/1 to
> bool variable
> drivers/net/wireless/ray_cs.c:2798:2-11: WARNING: Assignment of 0/1 to
> bool variable
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

1f15d7c8f3fc ray_cs: use true,false for bool variable

-- 
https://patchwork.kernel.org/patch/11510389/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
