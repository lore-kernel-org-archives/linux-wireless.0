Return-Path: <SRS0=yzGj=37=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45865C35242
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Feb 2020 18:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A94920842
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Feb 2020 18:36:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="jWww/lnF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730685AbgBKSg3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Feb 2020 13:36:29 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:37697 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728725AbgBKSg3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Feb 2020 13:36:29 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581446188; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=q3qC0u38uWvEvCPBrSDihtZpWQNVqoFcQm8J7M1dZu8=;
 b=jWww/lnFAaXGbRXMr64qvxjzR1aKrvK9DOnb/3W1ARi9P05XJ7R4PL2EopGd4SPiyiZQXATr
 zTlENc1ZonficyheCV7kwlElWdydGQRXTNowocAk13/ZSFB0+ajyM2lFIq6QBd13qBmdkwEh
 2UzPZNcU/FB9/WwCUqxXc9Ksyx0=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e42f42b.7fa73263c9d0-smtp-out-n01;
 Tue, 11 Feb 2020 18:36:27 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EE2C1C4479C; Tue, 11 Feb 2020 18:36:26 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8671FC43383;
        Tue, 11 Feb 2020 18:36:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8671FC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: fix incorrect peer stats counters update
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1580891730-23868-1-git-send-email-vnaralas@codeaurora.org>
References: <1580891730-23868-1-git-send-email-vnaralas@codeaurora.org>
To:     Venkateswara Rao Naralasetty <vnaralas@codeaurora.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200211183626.EE2C1C4479C@smtp.codeaurora.org>
Date:   Tue, 11 Feb 2020 18:36:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Venkateswara Rao Naralasetty <vnaralas@codeaurora.org> wrote:

> Convert mac80211 bw to ath11k bw before updating peer stats
> bw counters, which fixes incorrect peer stats counters update.
> 
> Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

92bacd1c165c ath11k: fix incorrect peer stats counters update

-- 
https://patchwork.kernel.org/patch/11365883/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
