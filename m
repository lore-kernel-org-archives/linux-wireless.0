Return-Path: <SRS0=pdv6=UY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 242EDC48BD5
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 04:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8A0220665
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 04:46:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cc9O3Jxc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bl7tIist"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfFYEqx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Jun 2019 00:46:53 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51744 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbfFYEqw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jun 2019 00:46:52 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 46FF6607CA; Tue, 25 Jun 2019 04:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561438012;
        bh=cxsRIxQmt5k0VDteF1etHiSTqllY+KohLERMiwTkGL8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=cc9O3Jxc65QZ8BdPSkCINP9mf7EUm/9KykoPzPziVcdUNnCFtIYSFHC2Qww25BgB6
         Rdx0RBUIEPbKCL92Kmwh3rvYpZOvwXdZ2BBDs0xhbOMpwrZkW63hajeXQOEB0BDkgs
         WLp++v56lTJt0NeJnNBQFq9ZmYHNdH3BlQslkTtY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 478D1606DC;
        Tue, 25 Jun 2019 04:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561438012;
        bh=cxsRIxQmt5k0VDteF1etHiSTqllY+KohLERMiwTkGL8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=bl7tIistKu9ZhRglCz+ASG1VqEJVr3Y9stZG2O5ZtKXFQMuN4izIOeGcyxV+YTI86
         eUtOMmWi7BtneG2XV3141WPyHd2dM4YDT+s76V9X7i6jA2w2E+Cl6lJWI/vDgbgp2l
         2jLk3F3MkLgbeBVF8oNHyFOiPDAd8CAHGaj0XMeM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 478D1606DC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: print PCI mmap with %pK
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190604173144.109142-1-briannorris@chromium.org>
References: <20190604173144.109142-1-briannorris@chromium.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190625044652.46FF6607CA@smtp.codeaurora.org>
Date:   Tue, 25 Jun 2019 04:46:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> wrote:

> Unadorned '%p' has restrictive policies these days, such that it usually
> just prints garbage at early boot (see
> Documentation/core-api/printk-formats.rst, "kernel will print
> ``(ptrval)`` until it gathers enough entropy"). Annotating with %pK
> (for "kernel pointer") allows the kptr_restrict sysctl to control
> printing policy better.
> 
> We might just as well drop this message entirely, but this fix was easy
> enough for now.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

2fc0aa454473 mwifiex: print PCI mmap with %pK

-- 
https://patchwork.kernel.org/patch/10975827/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

