Return-Path: <SRS0=0mSa=WC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C4FFC32751
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Aug 2019 12:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CED972147A
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Aug 2019 12:35:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FWKBS6ON";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BfTgMDm8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730368AbfHFMez (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Aug 2019 08:34:55 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58136 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfHFMey (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Aug 2019 08:34:54 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E807660907; Tue,  6 Aug 2019 12:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565094893;
        bh=j3IQ8khHcAdJB6SI5pT6gGee/zo9CcFWWZR+13cdipw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=FWKBS6ONTqycTpdUvDznP/W/W8n3FAZpYWWJSX8EGFMZR1FD787Xrk3qWT5pboN5t
         cP7Ix1Kt4RbKNlDndDSB3UUUYdy1g0bVqrdx2PcEkgj2G9FwkMTDXDMAv9tL8pTwXp
         XaEU9dVygJIW1K6C+frBI4e92cq2kFyItCGd8WjY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9F2AE6038E;
        Tue,  6 Aug 2019 12:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565094893;
        bh=j3IQ8khHcAdJB6SI5pT6gGee/zo9CcFWWZR+13cdipw=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=BfTgMDm82Kk71nxz6v6+Ttk1yGWKAow1KxtBYkNVcEKGpMNSTYP/eXpUEmLjFJY86
         y/1E6rpo3gRJ+1TGUYuD9cukkivkG2t6FwlNOttBa1xkWc+cPVMo9hXS6eT9WAZr1f
         BVHRVaGnU4t/6weyz51tWTCHEseCGK/0zObWW56Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9F2AE6038E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: remove unneeded function _rtl_dump_channel_map()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190724141020.58800-1-yuehaibing@huawei.com>
References: <20190724141020.58800-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <pkshih@realtek.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <davem@davemloft.net>, YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190806123453.E807660907@smtp.codeaurora.org>
Date:   Tue,  6 Aug 2019 12:34:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Now _rtl_dump_channel_map() does not do any actual
> thing using the channel. So remove it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

a4a68f727fb8 rtlwifi: remove unneeded function _rtl_dump_channel_map()

-- 
https://patchwork.kernel.org/patch/11056997/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

