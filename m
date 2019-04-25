Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E748FC43219
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5782720651
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:52:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EmFwySRp";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZFalyVNg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfDYQwF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:52:05 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59664 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbfDYQwF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 12:52:05 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A437460388; Thu, 25 Apr 2019 16:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211124;
        bh=Z+kUg9a6fzVaBBilsOvolccOgQuMnpcrrWCSI3rrZkg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=EmFwySRpMa2m66wkP0dYYiuzzooaAVo2DVOAcoveRO4Exfuc2cqR05S8xQsprSN2H
         i46byCuPylgSzLcqlMLqqYw0zJyYYBlAsDjLxICkknjCmC9uYaqVt/mKtycGv/u4pL
         i7zGh7go+MgiIMrhR2rjzTCnRfYqzoa3XnVcY2Gk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6336E6019D;
        Thu, 25 Apr 2019 16:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211124;
        bh=Z+kUg9a6fzVaBBilsOvolccOgQuMnpcrrWCSI3rrZkg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ZFalyVNgSIdmeftqj8xNsyM/3re01UFPgvdrpciTPrn50AR2drYFYrIIKDFJh9TJQ
         HLU2Alys8QFrt4ucXEKjRAhyQjTRG8Awu9whZp1RsVkvAZ2Lprp0tti3fqQi8lZvrl
         73iBUPoybRkWF/xaKFL0IFf29RiyfDa5G1hJz2Pg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6336E6019D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwl8k: fix error handling in mwl8k_post_cmd()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1554499598-29351-1-git-send-email-khoroshilov@ispras.ru>
References: <1554499598-29351-1-git-send-email-khoroshilov@ispras.ru>
To:     Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc:     Lennert Buytenhek <buytenh@wantstofly.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425165204.A437460388@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 16:52:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Alexey Khoroshilov <khoroshilov@ispras.ru> wrote:

> If pci_map_single() fails in mwl8k_post_cmd(),
> it returns -ENOMEM immediately, while cleanup is required.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Patch applied to wireless-drivers-next.git, thanks.

d1717282afd5 mwl8k: fix error handling in mwl8k_post_cmd()

-- 
https://patchwork.kernel.org/patch/10887851/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

