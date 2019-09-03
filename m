Return-Path: <SRS0=FCSK=W6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 120E2C3A5A5
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:36:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D97C423431
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:36:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="eu4SuX4X";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="n4N6oMCI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbfICNg1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Sep 2019 09:36:27 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48834 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbfICNg1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Sep 2019 09:36:27 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DD0A3605A2; Tue,  3 Sep 2019 13:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567517785;
        bh=T4+qthdIa+JdtJ1JZNw78DDAC6sdnSeXsq52RWos8i8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=eu4SuX4XJTg98x2tGFMxG20wx4cFDttZSQzpbJg3b6Wn1pO346QTjqcrRO3rxZxjJ
         KUYy1H6vDhwFTMKl0B4xb+w+mEmMtbryFE88MC7ogW7bf+f5yHdmFPpt1cYRe74B2z
         rybsJ5EqkOjXuBHzp4eS6OSoZAUib3VzPelsncUA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CB942602CA;
        Tue,  3 Sep 2019 13:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567517785;
        bh=T4+qthdIa+JdtJ1JZNw78DDAC6sdnSeXsq52RWos8i8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=n4N6oMCI7ZAh48ltOR5O3mymXNlUO4JcKKK99is1xAel8K0RsIq0Mrj8yLzJLlctL
         gr79ARrs4bsck8Od+R9MUGVVnLj3WhaC/HwYmQDERP7t4fOGClJUggt0H4bnpZwlcL
         JLPn0o7Fm41sqbVjRi0Q1rqaTvhu3NZvjQHeQhwQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CB942602CA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtw88: remove redundant assignment to pointer
 debugfs_topdir
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190822113728.25494-1-colin.king@canonical.com>
References: <20190822113728.25494-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190903133625.DD0A3605A2@smtp.codeaurora.org>
Date:   Tue,  3 Sep 2019 13:36:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Pointer debugfs_topdir is initialized to a value that is never read
> and it is re-assigned later. The initialization is redundant and can
> be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

9f7d65fb3935 rtw88: remove redundant assignment to pointer debugfs_topdir

-- 
https://patchwork.kernel.org/patch/11109159/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

