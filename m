Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 084DDC48BDF
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBC7761433
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbhFONmq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jun 2021 09:42:46 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:59875 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231716AbhFONm0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jun 2021 09:42:26 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623764422; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=a1WlzaO82iLMRE52JxldZdL+R8HjpJo5eZ9dZVqlH+E=;
 b=QvbI05QYUrgU8nznVG40csVd6hyFUCehJqPzuXWHRyEPoecapDAtEUhOTYHnIges2/PKN8yH
 NA1FJXnsANaSfEdE+8JWBym5INf6vFmx3UAHDI7/RfwcWPRyu+MLYadwZBqRoABBtgpy5h2X
 F1C8dA8BxX7vEbaQkUIrLkN1Fys=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 60c8adb7e27c0cc77f2475be (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Jun 2021 13:40:07
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5EC85C43144; Tue, 15 Jun 2021 13:40:06 +0000 (UTC)
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6BB2AC43460;
        Tue, 15 Jun 2021 13:40:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6BB2AC43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: Remove redundant assignments to ul_enc_algo
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1621303199-1542-1-git-send-email-yang.lee@linux.alibaba.com>
References: <1621303199-1542-1-git-send-email-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Yang Li <yang.lee@linux.alibaba.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210615134006.5EC85C43144@smtp.codeaurora.org>
Date:   Tue, 15 Jun 2021 13:40:06 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yang Li <yang.lee@linux.alibaba.com> wrote:

> Variable ul_enc_algo is being initialized with a value that is never
> read, it is being set again in the following switch statements in
> all of the case and default paths. Hence the unitialization is
> redundant and can be removed.
> 
> Clean up clang warning:
> 
> drivers/net/wireless/realtek/rtlwifi/cam.c:170:6: warning: Value stored
> to 'ul_enc_algo' during its initialization is never read
> [clang-analyzer-deadcode.DeadStores]
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Patch applied to wireless-drivers-next.git, thanks.

a99086057e03 rtlwifi: Remove redundant assignments to ul_enc_algo

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1621303199-1542-1-git-send-email-yang.lee@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

