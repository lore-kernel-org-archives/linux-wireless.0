Return-Path: <SRS0=yzGj=37=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2797EC352A3
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Feb 2020 14:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD65520675
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Feb 2020 14:21:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="HjDeYox4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730094AbgBKOVV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Feb 2020 09:21:21 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:51637 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729924AbgBKOVU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Feb 2020 09:21:20 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581430880; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=qM5SKJxSg1XIlNtdRw4IanLcv+dOPm/En7bKG7Wq5Y8=;
 b=HjDeYox4hcft5E7tIM0odybZVkOMJwP6wHbztBPdR4npHIxgnT2ZZQL4gBCuFlGSHbmBiLuw
 g2fjUmzC5+BNhcTR9ljmnLW6ndigbcuc64XPG5XmWB7Se/ZefcXxQhx9wOorQmfACDHnYnGz
 XgYKHydxPTNdA/X5GwrCeUu4vg8=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e42b85c.7f37be216ed8-smtp-out-n01;
 Tue, 11 Feb 2020 14:21:16 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 09D0FC4479F; Tue, 11 Feb 2020 14:21:16 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C69E8C43383;
        Tue, 11 Feb 2020 14:21:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C69E8C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: fix few checkpatch warnings
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1581411578-26388-1-git-send-email-kvalo@codeaurora.org>
References: <1581411578-26388-1-git-send-email-kvalo@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200211142116.09D0FC4479F@smtp.codeaurora.org>
Date:   Tue, 11 Feb 2020 14:21:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> wrote:

> Fix warnings which were recently introduced:
> 
> drivers/net/wireless/ath/ath10k/ahb.c:462: Alignment should match open parenthesis
> drivers/net/wireless/ath/ath10k/ahb.c:470: Alignment should match open parenthesis
> drivers/net/wireless/ath/ath10k/sdio.c:697: space prohibited before that close parenthesis ')'
> 
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

9a5fccc1e807 ath10k: fix few checkpatch warnings

-- 
https://patchwork.kernel.org/patch/11375089/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
