Return-Path: <SRS0=/TLA=3P=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F089DC2D0DB
	for <linux-wireless@archiver.kernel.org>; Sun, 26 Jan 2020 10:51:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1E592083E
	for <linux-wireless@archiver.kernel.org>; Sun, 26 Jan 2020 10:51:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="pd5gqTi1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729378AbgAZKvo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 26 Jan 2020 05:51:44 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:23362 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729255AbgAZKvo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 26 Jan 2020 05:51:44 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580035903; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=jh3KcYIcK3fpyqI5D5qIbgxY95iJ5LcxRI3DTIlMrss=;
 b=pd5gqTi10Rm6vojFQb+3zWAnHkerKHclgFeKQuRrXJrRZtWuc7zfpGrnmMhT5O7j364znKmp
 NHoVaTn1nzuGp9rKzjIebiFyoA04qVmj/wjCMxdwvXrGbl+kwu6yVhDEjJDtRoo5iuPsz5Im
 9K3EE9jqYv9BHBWf35G5MdjyX5o=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2d6f3e.7f52250f6ea0-smtp-out-n01;
 Sun, 26 Jan 2020 10:51:42 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F0F6DC433CB; Sun, 26 Jan 2020 10:51:41 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B3051C43383;
        Sun, 26 Jan 2020 10:51:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B3051C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath11k: fix up some error paths
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200115174652.dvkmznhfvjaoc47l@kili.mountain>
References: <20200115174652.dvkmznhfvjaoc47l@kili.mountain>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org, John Crispin <john@phrozen.org>,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>,
        Anilkumar Kolli <akolli@codeaurora.org>,
        Bhagavathi Perumal S <bperumal@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200126105141.F0F6DC433CB@smtp.codeaurora.org>
Date:   Sun, 26 Jan 2020 10:51:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> There are two error paths where "ret" wasn't set.  Also one error path
> we set the error code to -EINVAL but we should just preserve the error
> code from ath11k_hal_srng_get_entrysize().  That function only returns
> -EINVAL so this doesn't change anything.
> 
> I removed the "ret = 0;" initializers so that hopefully GCC will be able
> to detect these sorts of bugs in the future.
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

7195c8747e87 ath11k: fix up some error paths

-- 
https://patchwork.kernel.org/patch/11335489/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
