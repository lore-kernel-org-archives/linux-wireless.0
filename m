Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D60CC433DB
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Feb 2021 06:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4863F64E2E
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Feb 2021 06:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhBRGQ3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Feb 2021 01:16:29 -0500
Received: from z11.mailgun.us ([104.130.96.11]:37380 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231871AbhBRGC0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Feb 2021 01:02:26 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613628099; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=gI+1h/G/WUEx8DeaPM4hymi+yrn5my1Zpz77PPJ4bho=;
 b=rk6SHMEUAMAgkES7szlQhIEKDi7gpyOGBIkZXnrPsEerDmLL3T2oTtJEgwOqg6wVtA5aTvJZ
 GfultLlFnK7xxsI9pF0TNs4sHz9SGuM+YSnCNY8EtLxpWqWvpCorf1dCvwRoK4RcuP0p8ql8
 LEOAdtHDCZhu/ALaJBoGVrxICYo=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 602e029497484ee2ac05a1c1 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 18 Feb 2021 06:00:52
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1BE16C433CA; Thu, 18 Feb 2021 06:00:52 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 82D47C433C6;
        Thu, 18 Feb 2021 06:00:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 82D47C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCHv2] ath11k: Enable radar detection for 160MHz secondary
 segment
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1613480547-28810-1-git-send-email-lavaks@codeaurora.org>
References: <1613480547-28810-1-git-send-email-lavaks@codeaurora.org>
To:     Lavanya Suresh <lavaks@codeaurora.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Lavanya Suresh <lavaks@codeaurora.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210218060052.1BE16C433CA@smtp.codeaurora.org>
Date:   Thu, 18 Feb 2021 06:00:52 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lavanya Suresh <lavaks@codeaurora.org> wrote:

> WMI_CHAN_INFO_DFS_FREQ2 needs to be set in wmi vdev start command chan
> info parameter, to enable radar detection for secondary segment in 160MHz.
> 
> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.4.0.1-01717-QCAHKSWPL_SILICONZ-1
> 
> Signed-off-by: Lavanya Suresh <lavaks@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

788f805e8c0a ath11k: Enable radar detection for 160MHz secondary segment

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1613480547-28810-1-git-send-email-lavaks@codeaurora.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

