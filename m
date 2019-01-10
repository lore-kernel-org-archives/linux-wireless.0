Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 612A8C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F901206B6
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:33:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Dhyu1/8O";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kD8FnjOu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbfAJLdB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 06:33:01 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:47868 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727938AbfAJLdB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 06:33:01 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4CE44608FC; Thu, 10 Jan 2019 11:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547119980;
        bh=rt2syXZzjNbk2wprE6B4i/Bsf9+xLtx+x3Axa7R9fE4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Dhyu1/8OmDi/kfqzI3osCfwWOG8V/SRFSCrVhRlVM4V7cD9xGw1xw5OlQXT/hcwAI
         fXZbBjnfgKSX+yMCPWvbgTRAL7tvBVHd6npafwzZ0HTUADR1/guF3N6goUe8hfv7QL
         A+NfTGZpKp1fd9NTWyY1DQ89Shjpcj21tI2tppdM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B2B89608CB;
        Thu, 10 Jan 2019 11:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547119979;
        bh=rt2syXZzjNbk2wprE6B4i/Bsf9+xLtx+x3Axa7R9fE4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=kD8FnjOu7bHwI/dyfm8+nYIGmOraK78nG/D01dunGqBS3qiqZRoIq5WriFMzQHAL+
         f8/jppMq04UAeGM/IUXVXFEfOCEt+VVnTJF5/Gf+qr35/DBrb+CKvdh9CCxdkLDrfY
         SrOM4Nm8jpv5zhUSFKzAqq1276mmgnjTC96cloQs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B2B89608CB
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ray_cs: fix array out-of-bounds access
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181220140550.18853-1-colin.king@canonical.com>
References: <20181220140550.18853-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190110113300.4CE44608FC@smtp.codeaurora.org>
Date:   Thu, 10 Jan 2019 11:32:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently array element org[3] is being accessed, however the array is
> only 3 elements in size, so this looks like an off-by-one out-of-bounds
> error. Fix this by using org[2], which I believe was the original
> intent.
> 
> This issue has existed in the driver back in the pre-git days, so no
> idea when it was introduced.
> 
> Detected by CoverityScan, CID#711344 ("Out-of-bounds read")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

72255c807156 ray_cs: fix array out-of-bounds access

-- 
https://patchwork.kernel.org/patch/10738943/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

