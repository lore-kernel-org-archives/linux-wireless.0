Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E3DC282D9
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 16:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 963C7218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 16:57:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UDb6CmPS";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="D7xGCZZr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388747AbfAaQ5T (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 11:57:19 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60632 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728401AbfAaQ5T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 11:57:19 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6E983601CF; Thu, 31 Jan 2019 16:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548953838;
        bh=1SffNXnEViC7e+xmGRpiUTI68ibNdWIyc/SqK+KJ03g=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=UDb6CmPSG/QUR3z659j2r4qZAdsLlc4r681F+yyQQCZBvW4hxBrI/Z0z77+CmB5XQ
         OhNqrBJieI2xk9bJKw1r0gtDD7lxvxBMQKx/AbzH2Sz4SrMF5zKSCzgDRvVSWYx1EW
         t3guAVV1V+L29tVjf3coRn/vPsjt5yBHfL1BtcRY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7825260159;
        Thu, 31 Jan 2019 16:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548953837;
        bh=1SffNXnEViC7e+xmGRpiUTI68ibNdWIyc/SqK+KJ03g=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=D7xGCZZrseBtshU9Oe4U3XFpDGBzYJZDzxWGK3KJnc5Mq5xvvLwVPdLqTiguD08B5
         TTUg1+PTbo//vHmEZohPPZG88pnxedyrYIufeWFpGlAPceGOqeL8us40XHI9iqacGM
         Ryz2BxyTwpDV6d21wrRsTMDZvZGGOJpmqAPdlcww=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7825260159
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH for-5.0] ath10k: correct bus type for WCN3990
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190129231201.42230-1-briannorris@chromium.org>
References: <20190129231201.42230-1-briannorris@chromium.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        Wen Gong <wgong@codeaurora.org>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190131165718.6E983601CF@smtp.codeaurora.org>
Date:   Thu, 31 Jan 2019 16:57:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> wrote:

> WCN3990 is SNOC, not PCI. This prevents probing WCN3990.
> 
> Fixes: 367c899f622c ("ath10k: add bus type check in ath10k_init_hw_params")
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Patch applied to wireless-drivers.git, thanks.

2c2008a63e48 ath10k: correct bus type for WCN3990

-- 
https://patchwork.kernel.org/patch/10787301/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

