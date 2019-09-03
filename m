Return-Path: <SRS0=FCSK=W6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24757C3A5A2
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED6A32343A
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:39:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Q0Q1Erqg";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="eA5RvaFz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbfICNjy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Sep 2019 09:39:54 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51270 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727667AbfICNjy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Sep 2019 09:39:54 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 61D1960850; Tue,  3 Sep 2019 13:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567517993;
        bh=7hPFcehlPa85l6foIa5Gm56+ZEB9rujwf8ydL+8VJHI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Q0Q1Erqg4XkP9bd5ydFGY9blE/NubtXkM6yZvu506NCPo85j1D/5xHeHYDT+FU5NK
         x5oa8ZK9omZJGy9LsKmNz8CZwd8ykQreJyyIKcXtChS3qrckq9ChL5oNpXgw5obX6e
         VtDfaHoSfFDnvhHVIRryZinPrIUaNVjByzdyvYe8=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 78EF26058E;
        Tue,  3 Sep 2019 13:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567517992;
        bh=7hPFcehlPa85l6foIa5Gm56+ZEB9rujwf8ydL+8VJHI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=eA5RvaFzagAPxv1V71soPYn/1viZpLisUVr2etI3SNKSu6T/OKwbb+28PpWBeCtoN
         x890VqPNXJslYXRLNDpTNRiZM4nt1wnhikYKnJMGzq1HErEQ2OOEz7yoiEj52A8Pma
         H5159biyMif2/v9hIgYOMgjp92H81vPt9r7Vm4cQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 78EF26058E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] airo: fix memory leaks
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1565927404-4755-1-git-send-email-wenwen@cs.uga.edu>
References: <1565927404-4755-1-git-send-email-wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190903133953.61D1960850@smtp.codeaurora.org>
Date:   Tue,  3 Sep 2019 13:39:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wenwen Wang <wenwen@cs.uga.edu> wrote:

> In proc_BSSList_open(), 'file->private_data' is allocated through kzalloc()
> and 'data->rbuffer' is allocated through kmalloc(). In the following
> execution, if an error occurs, they are not deallocated, leading to memory
> leaks. To fix this issue, free the allocated memory regions before
> returning the error.
> 
> Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>

Patch applied to wireless-drivers-next.git, thanks.

145a32fe57e3 airo: fix memory leaks

-- 
https://patchwork.kernel.org/patch/11096733/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

