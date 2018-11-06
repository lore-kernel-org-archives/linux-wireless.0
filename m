Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C1F5C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E989F20869
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:18:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="a/XcVvAt";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aAH0FG5E"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E989F20869
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389231AbeKGBn5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 20:43:57 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:55420 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389102AbeKGBn5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 20:43:57 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 81E366053D; Tue,  6 Nov 2018 16:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541521080;
        bh=7gFUWLtbegbx44OKrzSG1K5V7SQ8IaQEldTZgGfxv5Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=a/XcVvAtuHFECwN5LZx4BIhK+kQvn+PXe4jIkwxUsdempebPLkcsE9oZfsrd7irIr
         wIYudiQHynnYaPpfuzlVn8Tubuvg6kYptyvnYNIV4Rr4IyCja7DNVgSUiNdKkeRQIF
         bbnH7bNQS4i1dWyXC/rQl/2sA5yJNVBJBkaq47l0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 51059601D7;
        Tue,  6 Nov 2018 16:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541521080;
        bh=7gFUWLtbegbx44OKrzSG1K5V7SQ8IaQEldTZgGfxv5Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=aAH0FG5EyR/6GbSYrMlMvYjj073rz+0A/u4WBtvltVjq1wSPir/8yuL1Gpf+GQPB7
         w4SopAhwKS65PHCnmgMn5UPhdu8jXlM3EZG6YnMB1jyCFYg1AVfep2deBJvxqO3b+y
         C9etG10Tl+ZWxRspuZJ7KbVeJpOizC/Sr1YnEWQc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 51059601D7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/4] ath10k: snoc: remove 'wcn3990' from generic resource
 handling
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181013005504.46399-1-briannorris@chromium.org>
References: <20181013005504.46399-1-briannorris@chromium.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106161800.81E366053D@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 16:18:00 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> wrote:

> ath10k_wcn3990_clk_info and ath10k_wcn3990_vreg_info are not
> WCN3990-specific structures. They hold generic data. So don't name them
> with wcn3990 specifics.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Reviewed-by: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

4 patches applied to ath-next branch of ath.git, thanks.

887a3dcf5893 ath10k: snoc: remove 'wcn3990' from generic resource handling
1a1a0d5ccefc ath10k: snoc: fix unabalanced regulator error handling
bfe57a6ac75a ath10k: snoc: relax voltage requirements
82e60d920e8a ath10k: snoc: fix unbalanced clock error handling

-- 
https://patchwork.kernel.org/patch/10639795/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

