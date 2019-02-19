Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2421BC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC4A120700
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:18:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LvGHwx7l";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="pNkAh7dZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbfBSPSd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:18:33 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:45826 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbfBSPSd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 10:18:33 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 77563608CB; Tue, 19 Feb 2019 15:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589511;
        bh=qXj6MhjL+2dPTWnaY8P/u98l+FRGmQcFXYxqq1r3Rvw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LvGHwx7lCDqFavQ29PTbGKnCjX0Jphgvz3+7PyUuA2ejx/qmobblYoOH34JLMCU9n
         Z/iUqsQZoCzj0R6wdTpCqW9aNZVu5mXfXsFUiM82vGqdLxouZGbskC2TB76dm0Rcd8
         fRnmGe8rAe5Fznec6r2yVImZo/rhCmyjnIXeOMBA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0429660388;
        Tue, 19 Feb 2019 15:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589511;
        bh=qXj6MhjL+2dPTWnaY8P/u98l+FRGmQcFXYxqq1r3Rvw=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=pNkAh7dZwMLarh6y8V+H0IoU2paVMm3PgFMQmvkI2KJDIFN2nFqkohb7D57x4in8F
         TNeuPjp7rIccJrl15ovo9yv9lCp3NVJ0HDqOsnCy1TMxRixTosilhwKiTrosOlanN+
         ru06zLpppsp7jcTI7qesCZCtN1Jf7NfWhQFi8VX4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0429660388
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] carl9170: clean up a clamp() call
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190218093154.GC7712@kadam>
References: <20190218093154.GC7712@kadam>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190219151831.77563608CB@smtp.codeaurora.org>
Date:   Tue, 19 Feb 2019 15:18:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> The parameter order for clamp is supposed to be clamp(value, low, high).
> When we write it in this order it's equivalent to
> min(head->plcp[3] & 0x7f, 75) which works in this context where the min
> is zero.  But it's not a correct use of the API.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Acked-by: Christian Lamparter <chunkeey@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

dc76bb1e12e9 carl9170: clean up a clamp() call

-- 
https://patchwork.kernel.org/patch/10817541/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

