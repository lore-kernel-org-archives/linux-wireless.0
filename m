Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A99C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 332EB206B6
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:34:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LIvJb7WA";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W3xjCpiY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbfAJLer (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 06:34:47 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:49110 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728323AbfAJLer (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 06:34:47 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 99CA960386; Thu, 10 Jan 2019 11:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547120086;
        bh=NwESBXpjPF5hX/poVqMEyfh55kqsCcI/2qw6urO4+TA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LIvJb7WANH29VGI8Z/41JE0Cb2YKTwt9pdjS+LNcWI+wugEm69Q1bxkXestDDNMQn
         Tg/ymIfsO5T+mkMeVmQce8xoC+dPcDByvLJXAd3hlVo31qWiVARjlY3DRn/wv22+7K
         oRoMbn1LUarsGE5dUi+RkEiU982fc5l/450uZYPs=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BF2DB601D1;
        Thu, 10 Jan 2019 11:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547120086;
        bh=NwESBXpjPF5hX/poVqMEyfh55kqsCcI/2qw6urO4+TA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=W3xjCpiYxVhbG9wIl963XklFwgkywBzkzqUwnsk09qxhZayXD86tU6Tub7ZQDCtRS
         dKuIoqyeGP5EAns12d9lnEDnKcnETy6liTARPXyWMWbADf/MwChJNyJnJNndJR/TSK
         5mjJGrP1IoD6r2B2do6kFfv0ovcp9zV0XJqKucIM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BF2DB601D1
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
Message-Id: <20190110113446.99CA960386@smtp.codeaurora.org>
Date:   Thu, 10 Jan 2019 11:34:46 +0000 (UTC)
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

cw1200 patches go to wireless-drivers-next, not net-next. In the future please
don't mark them for net-next to avoid any confusion.

-- 
https://patchwork.kernel.org/patch/10741431/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

