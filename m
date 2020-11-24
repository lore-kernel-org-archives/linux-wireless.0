Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F16CC2D0E4
	for <linux-wireless@archiver.kernel.org>; Tue, 24 Nov 2020 15:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB98920757
	for <linux-wireless@archiver.kernel.org>; Tue, 24 Nov 2020 15:04:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="JKLr/ohN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389467AbgKXPDo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 24 Nov 2020 10:03:44 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:63483 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389464AbgKXPDo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Nov 2020 10:03:44 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606230223; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=KDXmV71EC60K0tOeQ7AblldjkZpngUk0efdBa7uFwWE=;
 b=JKLr/ohNvrv3qM5yDJQ0vqAv9z1W4vBBdinhsebjb4dmf/t8YMsT3pzLXsz+eN2bC+nbmXmv
 4uQXpHPl25Auh+yFpfUfJMZGUmyikGTmDBKLrYL4c6HBZUp5+ibRjwLlaO01TG2225IKSeDX
 OArtbkT1FQAtnwOK6iyGnj2GkYM=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5fbd20cd1b731a5d9c3a89b7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 24 Nov 2020 15:03:41
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C33EFC43460; Tue, 24 Nov 2020 15:03:40 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8309BC433ED;
        Tue, 24 Nov 2020 15:03:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8309BC433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: Fix incorrect type in assignment
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201116001639.31958-1-rde@setrix.com>
References: <20201116001639.31958-1-rde@setrix.com>
To:     Remi Depommier <rde@setrix.com>
Cc:     linux-wireless@vger.kernel.org, Remi Depommier <rde@setrix.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201124150340.C33EFC43460@smtp.codeaurora.org>
Date:   Tue, 24 Nov 2020 15:03:40 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remi Depommier <rde@setrix.com> wrote:

> The left-hand side of the assignment from cpu_to_le32() should be of
> type __le32. This commit clears the warning reported by sparse when
> building with C=1 CF="-D__CHECK_ENDIAN__".
> 
> Fixes: d56fd83cf99c ("brcmfmac: fix SDIO access for big-endian host")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Remi Depommier <rde@setrix.com>

Patch applied to wireless-drivers-next.git, thanks.

fa3622bbea10 brcmfmac: Fix incorrect type in assignment

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201116001639.31958-1-rde@setrix.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

