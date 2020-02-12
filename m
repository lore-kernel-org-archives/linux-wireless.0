Return-Path: <SRS0=Oc7L=4A=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE19EC2BA83
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Feb 2020 16:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8187B20714
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Feb 2020 16:21:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="XJaSxevl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgBLQVq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Feb 2020 11:21:46 -0500
Received: from mail27.static.mailgun.info ([104.130.122.27]:63748 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726728AbgBLQVp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Feb 2020 11:21:45 -0500
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Feb 2020 11:21:35 EST
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581524504; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=OoyxNrvtfLp8mqOZwsILM1Ll6axWpNYEYu5wGGIGobw=;
 b=XJaSxevlqGThx8gemBtRfJblT/YzHi9ldT6AS5DCwFRDFaa3M1O77/NoarkzrCx1S4SGfM9O
 /3Kp791dYlOEalhhvMFTDLRcRJhxAwZs9d/OUBz/P7CUXBvK5F5AS0is04jrVSStl7Gs6LW/
 FeNDuawWX9rGbEAgFEWAbQa4C1M=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e442618.7f2229033730-smtp-out-n02;
 Wed, 12 Feb 2020 16:21:44 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0A561C447A0; Wed, 12 Feb 2020 16:21:44 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 53258C433A2;
        Wed, 12 Feb 2020 16:21:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 53258C433A2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/2] rtw88: Use secondary channel offset enumeration
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200130053112.28162-2-yhchuang@realtek.com>
References: <20200130053112.28162-2-yhchuang@realtek.com>
To:     <yhchuang@realtek.com>
Cc:     <linux-wireless@vger.kernel.org>, <briannorris@chromium.org>,
        <chiu@endlessm.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200212162144.0A561C447A0@smtp.codeaurora.org>
Date:   Wed, 12 Feb 2020 16:21:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<yhchuang@realtek.com> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> The hardware value of secondary channel offset isn't very intuitive. This
> commit adds enumeration, so we can easier to check the logic with the
> suffix of enumeration name, likes _UPPER or _LOWER.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Reviewed-by: Chris Chiu <chiu@endlessm.com>

2 patches applied to wireless-drivers-next.git, thanks.

40fb04b22f31 rtw88: Use secondary channel offset enumeration
9c714b7caa17 rtw88: 8822c: modify rf protection setting

-- 
https://patchwork.kernel.org/patch/11357419/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
