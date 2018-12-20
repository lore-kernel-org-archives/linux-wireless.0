Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3626DC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 06:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 030032176F
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 06:50:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TbeDesjs";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QA7vuXx2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbeLTGue (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 01:50:34 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60888 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbeLTGue (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 01:50:34 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D514560736; Thu, 20 Dec 2018 06:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545288633;
        bh=lIa8jMKu4+VDq3vfLGD9JvpBP43xhY0tdyahbPRGw2s=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=TbeDesjsX23t7nqLPVhfhdJhgO/0jnbbv7GjVnPCWM23uyFId8C+yXunYu5uyxuRK
         w38H/YOg0QTk3YI5GvF2GOXewO030BxqvYw8xY1oxJbA7pBhO/iaQLmFZe8+ntTidw
         FLvO2S+TCOKSEaiYa/lFdZUMqQgYTEDPlbs9NAiE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EE62160591;
        Thu, 20 Dec 2018 06:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545288633;
        bh=lIa8jMKu4+VDq3vfLGD9JvpBP43xhY0tdyahbPRGw2s=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=QA7vuXx2xHtFEoqHsQKrjjob6Q54rO2S72UyyNQ3Kvs41fhGKhVoCUo5/gan4Rc+1
         ulh0A5cABtfGxGdESF+y8kJRv0NhxuEmo6MB6Hj1axBjjpGjU2qbDNdFzY+6cWg1Tx
         8cO9ICH7viIshsGK16WxnR6K6/RHl/A4rGDUXsP0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EE62160591
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ipw2x00: cleanup dead code
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181219030013.13736-1-yuehaibing@huawei.com>
References: <20181219030013.13736-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <stas.yakovlev@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181220065033.D514560736@smtp.codeaurora.org>
Date:   Thu, 20 Dec 2018 06:50:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fix smatch warning:
> 
> drivers/net/wireless/intel/ipw2x00/ipw2100.c:5606
>  shim__set_security() warn: always true condition '(sec->active_key <= 3) => (0-3 <= 3)'
> drivers/net/wireless/intel/ipw2x00/ipw2200.c:10725
>  shim__set_security() warn: always true condition '(sec->active_key <= 3) => (0-3 <= 3)'
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

90a8c74a8d7b ipw2x00: cleanup dead code

-- 
https://patchwork.kernel.org/patch/10736741/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

