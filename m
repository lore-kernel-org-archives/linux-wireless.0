Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E03CC43219
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C08C520693
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:38:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LmNgSdxI";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EhGIKPJ6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbfDYQiH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:38:07 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52250 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfDYQiH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 12:38:07 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B7C8D60736; Thu, 25 Apr 2019 16:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556210286;
        bh=s3VENpXEzwylRROtQ+Nfq/2SG5O7+nthqhNeIrBgFqY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LmNgSdxItF/eW3zxYzXQbYe/oTkcS1cLiR6DitaIub7RXZT60DBEMhgdnLb9cj50v
         ZXxbBmGwrszN5aOLCYNigTGINS1WUWFybjQkkC5xafG9dQLodBItuaxBUmfphE5Skl
         Dd7aWaAbkSJPhahb7UO7/vdxxq0SyFSgr7n/F7BI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A69286034D;
        Thu, 25 Apr 2019 16:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556210286;
        bh=s3VENpXEzwylRROtQ+Nfq/2SG5O7+nthqhNeIrBgFqY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=EhGIKPJ6GGay4WNLCRB7+HWFpMTthhkJfs8IpuTAvLLXXgnJ888eCf9GeI1j1Tiwa
         WWqwJKr+6ic1PJ1TiUxuds/g3EdnnJUyAO/yyD3nv+iICD/DSsgBeil9PbsmvZJ6Tw
         UjSJT9XN759aRZ51CjRJGabPMFL2ThNLe4LdcNug=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A69286034D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] rndis_wlan: use struct_size() helper
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190403182334.GA3986@embeddedor>
References: <20190403182334.GA3986@embeddedor>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425163806.B7C8D60736@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 16:38:06 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes, in particular in the
> context in which this code is being used.
> 
> So, replace code of the following form:
> 
> sizeof(*pmkids) + max_pmkids * sizeof(pmkids->bssid_info[0])
> 
> with:
> 
> struct_size(pmkids, bssid_info, num_pmkids)
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Patch applied to wireless-drivers-next.git, thanks.

d442af2e1bcb rndis_wlan: use struct_size() helper

-- 
https://patchwork.kernel.org/patch/10884341/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

