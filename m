Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B96C10F0C
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A298B20882
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:19:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Kf/zw8Z3";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Uz+98Sh3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbfDDKTE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 06:19:04 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41004 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728688AbfDDKTD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 06:19:03 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 90F3E61CB5; Thu,  4 Apr 2019 10:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554373142;
        bh=/748pFHRg2O5s6nACHxOZm3Yat4xW+Iq170aV1sMXIE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Kf/zw8Z3nj/JFZc3Ek+TjLFtgzEW0hn0ALsTUl+zYqlu28hCWCVMaNP57BSndgDjD
         kfMF3PDpWJn7posQWG228FtXIXRzhVTrW+JVq+djiQgXFzDoOHENyDKJJqsJogwkAI
         VuOs75fY22j2bsgRTjvqDvsPtoCu9BmMxxHSXf1M=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6342F61CB7;
        Thu,  4 Apr 2019 10:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554373140;
        bh=/748pFHRg2O5s6nACHxOZm3Yat4xW+Iq170aV1sMXIE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Uz+98Sh3o47LZVg+vdKzR/2XZNiUxUlBxGEErGO1dcMZBso13FzadpeCedKPBZwnD
         141Nyg8GfqXrOUm/mD5vY7P6NLyRT2bP0kM4vFD+QNh09QHv/jYnG+ZG/XXk412xf3
         hnRB/321MF4kjtMsFOvto6LnGiH0j1gCQ92ipjeU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6342F61CB7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: Fix mem leak in mwifiex_tm_cmd
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190312070358.12700-1-yuehaibing@huawei.com>
References: <20190312070358.12700-1-yuehaibing@huawei.com>
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     <amitkarwar@gmail.com>, <nishants@marvell.com>,
        <gbhat@marvell.com>, <huxinming820@gmail.com>,
        <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190404101902.90F3E61CB5@smtp.codeaurora.org>
Date:   Thu,  4 Apr 2019 10:19:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yue Haibing <yuehaibing@huawei.com> wrote:

> From: YueHaibing <yuehaibing@huawei.com>
> 
> 'hostcmd' is alloced by kzalloc, should be freed before
> leaving from the error handling cases, otherwise it will
> cause mem leak.
> 
> Fixes: 3935ccc14d2c ("mwifiex: add cfg80211 testmode support")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

003b686ace82 mwifiex: Fix mem leak in mwifiex_tm_cmd

-- 
https://patchwork.kernel.org/patch/10848633/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

