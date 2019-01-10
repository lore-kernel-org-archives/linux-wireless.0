Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6A4AC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:35:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D0DE206B6
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:35:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BBQt1hSj";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hB1XCMXh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbfAJLfX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 06:35:23 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:49350 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727938AbfAJLfX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 06:35:23 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D437D608A5; Thu, 10 Jan 2019 11:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547120122;
        bh=J121eeVTMUuBifPpsiqVfRvif4ymjfAEQn2ImmpedyY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=BBQt1hSjZoYmvhcnrgPdmkQJH4dt2Lws+XsC3ZoEqpF3ReE3iSHcYSnlObvq4VoeD
         JRB7dTdboA2XKcNOLpnuAgY6qObn0k/Kmajb04+t5DbhXCtRJIhpN9aDzdINDTZ3tG
         RH33kbt3S0YuzZ5AvRnnNQiDHikuIyAs5N4QuBCE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 088D7601D1;
        Thu, 10 Jan 2019 11:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547120122;
        bh=J121eeVTMUuBifPpsiqVfRvif4ymjfAEQn2ImmpedyY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=hB1XCMXhVDTQjtodf03Sww7yG6GdU87YPeH/oCoLUKA9FRUtPa26MPEt/1bMtpUWF
         4+unTTK8wVttP3WbPwnQbVA9dd6w5LTxqyUhl7kbI4ZmmDa+LBpiGVP16vzMxB/9IW
         md895WZ8vJvniDt6MVQVZGWHN+KGC1k3Rldlmh6Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 088D7601D1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next] cw1200: fix missing unlock on error in
 cw1200_hw_scan()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1545474894-124328-1-git-send-email-weiyongjun1@huawei.com>
References: <1545474894-124328-1-git-send-email-weiyongjun1@huawei.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Solomon Peachy <pizza@shaftnet.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-wireless@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190110113522.D437D608A5@smtp.codeaurora.org>
Date:   Thu, 10 Jan 2019 11:35:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wei Yongjun <weiyongjun1@huawei.com> wrote:

> Add the missing unlock before return from function cw1200_hw_scan()
> in the error handling case.
> 
> Fixes: 4f68ef64cd7f ("cw1200: Fix concurrency use-after-free bugs in cw1200_hw_scan()")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> Acked-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

51c8d24101c7 cw1200: fix missing unlock on error in cw1200_hw_scan()

-- 
https://patchwork.kernel.org/patch/10741431/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

