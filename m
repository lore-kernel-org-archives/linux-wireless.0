Return-Path: <SRS0=kZdm=TH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 653F5C004C9
	for <linux-wireless@archiver.kernel.org>; Tue,  7 May 2019 14:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15D1B20825
	for <linux-wireless@archiver.kernel.org>; Tue,  7 May 2019 14:05:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dN8jiqC9";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gxwYORSW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfEGOFk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 7 May 2019 10:05:40 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39434 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbfEGOFk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 May 2019 10:05:40 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4597E6087A; Tue,  7 May 2019 14:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557237939;
        bh=v7qjRgtjkDLbuRHaqLLhB5f9cQm29Ik3EIwdZG4r99A=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=dN8jiqC9WokcwTIFOe7oKQuhuA1NiXi/jywbv3NjZSr5ySxdYy3+DqNt53beWoLqe
         onpdso4efBgu8mQqSYwRa12YbqIWqcyF99E7RV+zd377+94Ph+mLuFNklSZrhulpvx
         /ZtpytQ1vhuEuvyX4ddDYodYeUBGZpRCKBUCxmuo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0778460350;
        Tue,  7 May 2019 14:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557237938;
        bh=v7qjRgtjkDLbuRHaqLLhB5f9cQm29Ik3EIwdZG4r99A=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=gxwYORSWZr+tTAkFgtn5cLyC30eQFL00bJ5NHd5fHhqTGW7ZXyzOR6cKylm2LepB2
         VIo8MtTO2tybLNxOG6aLNs7LWbdul5sAARWp1pCTNjHGBS7pUlQSWHmtvM0jrk0wGh
         e/eOUKFYSCAH5+CWMdqIZL4EFmuY6/3A+q9gZp8Q=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0778460350
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath10k: fix different tx duration output
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1555489045-18070-1-git-send-email-leiwa@codeaurora.org>
References: <1555489045-18070-1-git-send-email-leiwa@codeaurora.org>
To:     Lei Wang <leiwa@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Lei Wang <leiwa@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190507140539.4597E6087A@smtp.codeaurora.org>
Date:   Tue,  7 May 2019 14:05:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lei Wang <leiwa@codeaurora.org> wrote:

> TX duration output of tx_stats in debugfs and station dump had big
> difference because they got tx duration value from different statistic
> data. We should use the same statistic data.
> 
> Tested: QCA988X with firmware ver 10.2.4-1.0-00043
> 
> Signed-off-by: Lei Wang <leiwa@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Dropping per discussion, please resend once everything is clarified.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10904909/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

