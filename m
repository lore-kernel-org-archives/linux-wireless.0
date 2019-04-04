Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD8DC4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BF8220643
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:24:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JzAk+usH";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dHs0wU3a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfDDKYT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 06:24:19 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44366 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfDDKYS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 06:24:18 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 985E861D45; Thu,  4 Apr 2019 10:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554373457;
        bh=bMOGrwB7TrrevcKU+kHzJwxLbGv/YSy+NairpLhSkXY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=JzAk+usHaDDPTzO6E2x4rKaSFOgTX+MRQ8x1RBtRjVK4m4zsMJanVHkElcCCKBGzo
         lOIcGFMooQGxK7Uic02Rl6Rxm2V0fwvqy1UjCQoXHHWwdOVcecP3UkkUj2uNSQ2yVH
         3+G40xi4JTrAgw4qr0B+KGZBnePY7fTXQ+3ok1V4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5ABA861D3D;
        Thu,  4 Apr 2019 10:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554373457;
        bh=bMOGrwB7TrrevcKU+kHzJwxLbGv/YSy+NairpLhSkXY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=dHs0wU3a/FcO7AoOgK5aouXlb4QzeFwKbq7ufqGznhuzxq7WCIExNtYD7jf/IdCFO
         SIPjsskvEDfG9jr8Ny6cMQIX/KwkaIzVtWXInG/0wpZR4Vk7t2Q05YUjocaQh8MsSd
         +cPc0DRbJxUJhkzsdTwM+xkjF5ZxdP00DparW+ik=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5ABA861D3D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] rtlwifi: Fix duplicate tests of one of the RX
 descriptors
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190304215940.2608-2-Larry.Finger@lwfinger.net>
References: <20190304215940.2608-2-Larry.Finger@lwfinger.net>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190404102417.985E861D45@smtp.codeaurora.org>
Date:   Thu,  4 Apr 2019 10:24:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> In drivers rtl8188ee, rtl8821ae, rtl8723be, and rtl8192ee, the reason
> for a wake-up is returned in the fourth RX descriptor in bits 29-31. Due
> to typographical errors, all but rtl8821ae test bit 31 twice and fail to
> test bit 29.
> 
> This error causes no problems as the tests are only used to set bits in
> a quantity output in an optional debugging statement.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Failed to apply:

fatal: sha1 information is lacking or useless (drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c).
error: could not build fake ancestor
Applying: rtlwifi: Convert the wake_match variable to local
Patch failed at 0001 rtlwifi: Convert the wake_match variable to local
The copy of the patch that failed is found in: .git/rebase-apply/patch

2 patches set to Changes Requested.

10838677 [1/2] rtlwifi: Fix duplicate tests of one of the RX descriptors
10838679 [2/2] rtlwifi: Convert the wake_match variable to local

-- 
https://patchwork.kernel.org/patch/10838677/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

