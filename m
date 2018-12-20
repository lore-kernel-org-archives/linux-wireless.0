Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F419C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D33620815
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:07:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LBCli6n+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jMUmJLFi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387485AbeLTRHG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 12:07:06 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36154 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729720AbeLTRHG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 12:07:06 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 28A1F60595; Thu, 20 Dec 2018 17:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545325625;
        bh=KvF6mfEZ4+mbaYkL553ULnM4JDAQOhbuH7FtB9ZNZV4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LBCli6n+EeHSAfWq1e+KYtrQVvbzS19TfO1kTpa+1iivMV57rG/49B0wF01mf59XN
         k47212YVNXMDGwt2Ejh+hwXlFw2gqdDLtueSvGeSYEL4ouR7TzbwGJMqbjSorqOSas
         nQDFjeIkjXgZUS04nEOyNysC18eqy4Pf5EOB3Wqk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 77E02602CB;
        Thu, 20 Dec 2018 17:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545325624;
        bh=KvF6mfEZ4+mbaYkL553ULnM4JDAQOhbuH7FtB9ZNZV4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=jMUmJLFixgFVG906xBAQqKw1CyK6iV/NYc7lcOE0UN5qITZC0WaXZpiBEbnBmSgbI
         AMxJmGDY+gBGvWEU983OqOUsxdNT42MMK0yIeHqecephy3GZ0mCHxCYUGpr366G9YM
         CABKpKSnFZzpXjLiS8RVePHPDx2OjSwFTv5HkH6U=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 77E02602CB
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: remove an unnecessary NULL check
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181129142406.GV3073@unbuntlaptop>
References: <20181129142406.GV3073@unbuntlaptop>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Rakesh Pillai <pillair@codeaurora.org>, ath10k@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181220170705.28A1F60595@smtp.codeaurora.org>
Date:   Thu, 20 Dec 2018 17:07:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> The "survey" pointer is the address of an array element.  We know that
> it can't be NULL so this check can be removed.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

27120f2ac995 ath10k: remove an unnecessary NULL check

-- 
https://patchwork.kernel.org/patch/10704625/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

