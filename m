Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D7FCC282CC
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFF122190A
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:55:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ap+GcrAt";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mTcwM5zF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfBGOzh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 09:55:37 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58730 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfBGOzh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 09:55:37 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 745936055C; Thu,  7 Feb 2019 14:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549551336;
        bh=Mf1qYoVzCZL3pkCUCfc0CudEz4N0pJiYocqSCJdDyaA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Ap+GcrAt3b6u1w/BpQLrpIcmq5Fmsh0fSX/ghy9vd8DUuktK8tDoYvNU8g9SO3Iwq
         nojdsIp93iITfjNOApbXeEFnO3kzknxZAVS0+SIRd7O3tQ2LoTMrWSDMXsDoPixmjU
         rCxbkZJXrPKnmqFCWmLYoFG9oHT1mKovHF+OONJg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2678A60247;
        Thu,  7 Feb 2019 14:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549551336;
        bh=Mf1qYoVzCZL3pkCUCfc0CudEz4N0pJiYocqSCJdDyaA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=mTcwM5zFesfQR1gW9SLzvroT7cS4xp1rvf8GV6+imSaQwlhe21de7qP9YSxLjy9Pz
         WCw+4/6a/IvSj21c+U/Jw+qdW4MbxF7vQRPDqGrLrYsvA/f7ye2aDCRBbX1eEGDzpT
         X4YCMdsKG0UVNF5C5hrLpM6OEX7/qPJK4jGQC+ps=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2678A60247
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: do not return invalid pointers as a *dentry
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190131131556.GB19807@kroah.com>
References: <20190131131556.GB19807@kroah.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190207145536.745936055C@smtp.codeaurora.org>
Date:   Thu,  7 Feb 2019 14:55:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> When calling debugfs functions, they can now return error values if
> something went wrong.  If that happens, return a NULL as a *dentry to
> the relay core instead of passing it an illegal pointer.
> 
> The relay core should be able to handle an illegal pointer, but add this
> check to be safe.
> 
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: ath10k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

0b38b4b44516 ath10k: do not return invalid pointers as a *dentry

-- 
https://patchwork.kernel.org/patch/10790493/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

