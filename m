Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 186C4C43219
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E8D1206BF
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:45:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LyYYPmMr";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YolNM+Vh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfDYQpe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:45:34 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:56216 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbfDYQpe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 12:45:34 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8BD0160736; Thu, 25 Apr 2019 16:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556210733;
        bh=F2zUwV7rU2LvMM0/RdZSDNiQnXARXf+rSSHE0/3V1sI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LyYYPmMrv1u4vtk+FyuiE3HrerjOtH1j/OV67RKZN6aHDgttwamTGfxQUExK95xuh
         w2NmNVay4clAv2aqGxjgwQp/77hWeiWfRndkEz9IK34fE1KAEJavx9S4Hnkpbplebv
         s1FAcIvqODvrJcOBFgwyGsry25qmjdppkMOIhmxA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D1FFB601B4;
        Thu, 25 Apr 2019 16:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556210733;
        bh=F2zUwV7rU2LvMM0/RdZSDNiQnXARXf+rSSHE0/3V1sI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=YolNM+VhcqK33I3K7IDaXi1hHzA3/Ard2Vn9mB9SCL4/36ihwaVnM05xa/1kT5+oo
         mMl4FjJWVdN+mfP+J1PKcCMxE8UZjeO5HOoZIClsVFe45MauDGG9lp4cn3ttCvOCFH
         mhTp8Q8KFxLqbNygMsKPtG4GnAAvAdxTOCqksnGM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D1FFB601B4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] mwifiex: use struct_size() in kzalloc()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190403164052.GA26381@embeddedor>
References: <20190403164052.GA26381@embeddedor>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425164533.8BD0160736@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 16:45:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> One of the more common cases of allocation size calculations is finding
> the size of a structure that has a zero-sized array at the end, along
> with memory for some number of elements for that array. For example:
> 
> struct foo {
>     int stuff;
>     struct boo entry[];
> };
> 
> size = sizeof(struct foo) + count * sizeof(struct boo);
> instance = kzalloc(size, GFP_KERNEL)
> 
> Instead of leaving these open-coded and prone to type mistakes, we can
> now use the new struct_size() helper:
> 
> instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL)
> 
> Notice that, in this case, variable regd_size is not necessary,
> hence it is removed.
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Patch applied to wireless-drivers-next.git, thanks.

ae187ba91541 mwifiex: use struct_size() in kzalloc()

-- 
https://patchwork.kernel.org/patch/10884249/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

