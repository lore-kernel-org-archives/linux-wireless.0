Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E04E1C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE7A221738
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:10:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gZQ7JEay";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="J9QLFV0J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbfBSPKr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:10:47 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38476 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbfBSPKr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 10:10:47 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 27659608FB; Tue, 19 Feb 2019 15:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589046;
        bh=4/mSjN26wCngu4mmMvQFlx243qMka40OkQJAS1l7Slo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=gZQ7JEayrPtPMxnQz2IF1xUv9uKCIZWasQw6bD5GJug18nvTayJbrywauXJrjcweD
         VSwYiuSOGlUgBgdAh1eA27b1nDaa8hLJxA3CUcNvG0GeKRu+WAKwFiuyisZdswYkwD
         az2CSfiAtmmWMsR1LoQwLiCOQWMTe6+hRrV4U4Ik=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 89B1A6085F;
        Tue, 19 Feb 2019 15:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589045;
        bh=4/mSjN26wCngu4mmMvQFlx243qMka40OkQJAS1l7Slo=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=J9QLFV0J+PLhMbpB33xZ4Vw6gflaAflo201IsH44gk58pa6NM05J0J9cFY8CAgJmu
         tE2OH32V6QXkWnLJceSIdWmQYO6IimTQjE9/eNmexTrWfLNSGpY3p4lGy+3WuOel1U
         9fb5s3wcXqPhYPfnEzAnKTknkmKKA3zFHTgGD1UA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 89B1A6085F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] libertas_tf: don't set URB_ZERO_PACKET on IN USB transfer
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190210194749.18135-1-lkundrak@v3.sk>
References: <20190210194749.18135-1-lkundrak@v3.sk>
To:     Lubomir Rintel <lkundrak@v3.sk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>, stable@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190219151046.27659608FB@smtp.codeaurora.org>
Date:   Tue, 19 Feb 2019 15:10:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lubomir Rintel <lkundrak@v3.sk> wrote:

> It doesn't make sense and the USB core warns on each submit of such
> URB, easily flooding the message buffer with tracebacks.
> 
> Analogous issue was fixed in regular libertas driver in commit 6528d8804780
> ("libertas: don't set URB_ZERO_PACKET on IN USB transfer").
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> Reviewed-by: Steve deRosier <derosier@cal-sierra.com>

Patch applied to wireless-drivers-next.git, thanks.

607076a904c4 libertas_tf: don't set URB_ZERO_PACKET on IN USB transfer

-- 
https://patchwork.kernel.org/patch/10804875/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

