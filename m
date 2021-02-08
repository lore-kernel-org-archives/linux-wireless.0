Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C7BC433DB
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Feb 2021 10:39:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC8CA64E87
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Feb 2021 10:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhBHKiq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Feb 2021 05:38:46 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:61304 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232512AbhBHKfJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Feb 2021 05:35:09 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612780488; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=nsYYyDQ8SFTkzKHxtSgLpNnRS1loGDDt83SA7JPx+vE=;
 b=JRvipYLtNCb089Cyz7YYg3ZFuIWtqzLW5/DrA0Xhnwkde7PGAXhthG33fXT1Ak3NQedvsIDy
 wl/n5E9HgwrpCUrt0p8W3uFuPAB78aZkQLPqz5N2T9wmGfhaRfjco7qBuv2+RarnJFVOHzQj
 qUZi30KWZKPPt2nyA2A4FrsbjRU=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 602113acf112b7872c236a7f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 08 Feb 2021 10:34:20
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C1FD5C43465; Mon,  8 Feb 2021 10:34:20 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 66967C433C6;
        Mon,  8 Feb 2021 10:34:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 66967C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rtlwifi: rtl8821ae: style: Simplify bool comparison
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1611632768-6293-1-git-send-email-abaci-bugfix@linux.alibaba.com>
References: <1611632768-6293-1-git-send-email-abaci-bugfix@linux.alibaba.com>
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210208103420.C1FD5C43465@smtp.codeaurora.org>
Date:   Mon,  8 Feb 2021 10:34:20 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Jiapeng Zhong <abaci-bugfix@linux.alibaba.com> wrote:

> Fix the following coccicheck warning:
> ./drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:3853:7-17:
> WARNING: Comparison of 0/1 to bool variable
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>

Please use your own email address and real name.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1611632768-6293-1-git-send-email-abaci-bugfix@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

