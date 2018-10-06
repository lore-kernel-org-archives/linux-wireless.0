Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37DB1ECDE43
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 19:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 011AD21473
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 19:30:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cqTX2xYh";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lyVyQvrw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 011AD21473
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbeJGCeu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 22:34:50 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35182 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbeJGCeu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 22:34:50 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 974A160C64; Sat,  6 Oct 2018 19:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538854219;
        bh=nvmBEWKaqrrmBrKgaCCI+tEon/SXkoK+j9x0HHJCUTM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=cqTX2xYhvAeLIQ+nncaApC51vQ8SWNbPxlI/LXB8yjhnS4JZlxOH6wIo7Je1vdjkL
         +RB5i3FyPHVLKDCGL8r7cobxsRy6PQYPsu81nWpGF3uxZ6O1wztlDwE3xQNndwxtnE
         INbLqvnSwfy7fm8WTC4W17fjmh0ivXCC0LPGQf4U=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B2C656079B;
        Sat,  6 Oct 2018 19:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538854218;
        bh=nvmBEWKaqrrmBrKgaCCI+tEon/SXkoK+j9x0HHJCUTM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=lyVyQvrwa31nle8IuxoB7pJzSVdP0PERcN/zeeWQGouvmEC6j4YjpiLjrgDa9rKoR
         vi9RntOIiYTOtyzm7ia8g8K38UvYU+0eNarlsCoAYtUCPpFFEptiqkvJkL4UgOf7Wx
         u4+q3dbXvy/vDChTh0OIM3kUziR57r0ZdyZvfQu0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B2C656079B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Colin King <colin.king@canonical.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Tsang-Shian Lin <thlin@realtek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8821ae: add in a missing break in switch statement
References: <20181006184246.29985-1-colin.king@canonical.com>
Date:   Sat, 06 Oct 2018 22:30:13 +0300
In-Reply-To: <20181006184246.29985-1-colin.king@canonical.com> (Colin King's
        message of "Sat, 6 Oct 2018 19:42:46 +0100")
Message-ID: <87r2h2euuy.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> writes:

> From: Colin Ian King <colin.king@canonical.com>
>
> The switch case RATR_INX_WIRELESS_MC has a missing break, this seems
> to be unintentional as the setting of variable ret gets overwritten
> when the case falls through to the following RATR_INX_WIRELESS_AC_5N
> case.  Fix this by adding in the missing break.
>
> Detected by CoverityScan, CID#1167237 ("Missing break in switch")
>
> Fixes: 3c05bedb5fef ("Staging: rtl8812ae: Add Realtek 8821 PCI WIFI driver")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c | 1 +

Is the fixes line correct? This patch is not for staging.

-- 
Kalle Valo
