Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE2CC43218
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4583120684
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:57:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AGGNmyLw";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="D5aCkz3l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbfDYQ5c (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:57:32 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34180 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfDYQ5c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 12:57:32 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7090C60779; Thu, 25 Apr 2019 16:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211451;
        bh=Q8k4xL7cj8m8bg0LKutCbY98gJX/jHvOJSbmokiFyNM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=AGGNmyLwGjWljQ7Uc/DIQ9+qUS4fSrIdgo2kcFJBP/QGhIE7b54kbpEfr9TyMKx1P
         2fD9MPPewWQLBV6EwWbx5v4GRxPBHVOB/+0wJtkLoKmjL4fbji2InSDqcVTcR62ZzN
         cQJ5j3hFhrBglsuVR3gn/iQ19kDes+hQkWhPMK3s=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7DED160252;
        Thu, 25 Apr 2019 16:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211451;
        bh=Q8k4xL7cj8m8bg0LKutCbY98gJX/jHvOJSbmokiFyNM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=D5aCkz3lByFLuXfuP6/rI/pTrtEySTvi1bRB4q0RX72BArJ9x1g7fO8Lg0wuIaleO
         +haBrcwYMNBT6T334tCtBlo1xCgvym/TCqCGZB6CbeF8HctxNHnuiL6H9c8CltSx/o
         QIreExoTYC77s+5DrhK0c1MCKCS2VB0RYvpvhse8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7DED160252
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: p54: drop device reference count if fails to enable device
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1555494083-130833-1-git-send-email-bianpan2016@163.com>
References: <1555494083-130833-1-git-send-email-bianpan2016@163.com>
To:     Pan Bian <bianpan2016@163.com>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425165731.7090C60779@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 16:57:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Pan Bian <bianpan2016@163.com> wrote:

> The function p54p_probe takes an extra reference count of the PCI
> device. However, the extra reference count is not dropped when it fails
> to enable the PCI device. This patch fixes the bug.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> Acked-by: Christian Lamparter <chunkeey@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

8149069db818 p54: drop device reference count if fails to enable device

-- 
https://patchwork.kernel.org/patch/10905039/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

