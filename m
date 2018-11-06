Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F5D5C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 265212081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:04:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gIwqS3Bq";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="d9w+Mot7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 265212081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389586AbeKGCaV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:30:21 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:32908 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389245AbeKGCaV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:30:21 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 414A3603D2; Tue,  6 Nov 2018 17:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523852;
        bh=MHT0wBizMbd1XNYP+6WfJso6eOz+cxKSuzi99A0K5JY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=gIwqS3BqMPojI5mOq/ohmCg9oHvu+vhNTy0M5BdEiMkDWEwY295x8rx605FV0l3oY
         o+vvH37DpkEOTMWpLjQAfJO5JkPdo2ie8/AzqKWvWMeZxfa405ZFE3gKzJbVpE18S5
         wsL/3UAvxBvETN2UZfZZ5P+fRO46Pmz82ZNXcQIU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3BF81601D7;
        Tue,  6 Nov 2018 17:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523851;
        bh=MHT0wBizMbd1XNYP+6WfJso6eOz+cxKSuzi99A0K5JY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=d9w+Mot7GItg9C7/CgeEkCiY/7D/VT13/7z0VjMXCWQS/vKeb5kK4QS1+udG3dWpt
         kb4RMW/sEAhfZVLxYE2N8cZa6rrEwKRjzYRubvmOBOAlacVIw/8Ovas0E1cM/Bq7QV
         IjhQxkD1a4bMsZTeVmtp/1i27j+aIAyX/wuwx7Xo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3BF81601D7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] cw1200: fix small typo
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181101153319.22830-1-tiny.windzz@gmail.com>
References: <20181101153319.22830-1-tiny.windzz@gmail.com>
To:     Yangtao Li <tiny.windzz@gmail.com>
Cc:     pizza@shaftnet.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106170412.414A3603D2@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 17:04:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yangtao Li <tiny.windzz@gmail.com> wrote:

> Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

f4bd758f3f20 cw1200: fix small typo

-- 
https://patchwork.kernel.org/patch/10664149/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

