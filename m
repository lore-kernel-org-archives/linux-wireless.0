Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77DE3C10F00
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42B1E20700
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:14:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="j0bKIK9O";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="J9SRBzK5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfBSPOv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:14:51 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42084 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbfBSPOu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 10:14:50 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2A3F9608D2; Tue, 19 Feb 2019 15:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589290;
        bh=b2VAM+NHAC+lDq3xa/K3548LLuLIneGgjBAXH67rTBU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=j0bKIK9OIJDK9ybVrb5/JkoyyCchaAKTCLMnbn4Wt9828yHK9UzEGofp/oT9h2sgk
         hg0MLY8FWbkHhP3Yza95LcQ6Wa3A3tZPcXIx1cxUogliH6RZoJuUES1RCnASpjF8mk
         mwgolzP8YilDCDbd+SJbuOAI42tkMVvLI3UERt/g=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 985C960791;
        Tue, 19 Feb 2019 15:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589289;
        bh=b2VAM+NHAC+lDq3xa/K3548LLuLIneGgjBAXH67rTBU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=J9SRBzK524N0WsNsVhJC9HiJKOByhSbctLh3O6HqrvbVw2u1sXeV9MTF17C+3VVUr
         q9PLzh8urTs6MjA0eHM3nstaD5EPaNPVLuZuYU3SgpZVBNJDSYW84GyrZ3RQZe8mrr
         6AV8YYUwWYHfICvEYbJ00R9PInWuOykjeP+bnL58=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 985C960791
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] libertas_tf: remove set but not used variable 'flags'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190213014917.164506-1-yuehaibing@huawei.com>
References: <20190213014917.164506-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Colin Ian King <colin.king@canonical.com>,
        YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <netdev@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190219151450.2A3F9608D2@smtp.codeaurora.org>
Date:   Tue, 19 Feb 2019 15:14:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/marvell/libertas_tf/main.c: In function 'lbtf_rx':
> drivers/net/wireless/marvell/libertas_tf/main.c:554:15: warning:
>  variable 'flags' set but not used [-Wunused-but-set-variable]
> 
> It never used and can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Acked-by: Steve deRosier <derosier@cal-sierra.com>

Patch applied to wireless-drivers-next.git, thanks.

e97cb6ea71b0 libertas_tf: remove set but not used variable 'flags'

-- 
https://patchwork.kernel.org/patch/10808997/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

