Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA11C43219
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E3C820693
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:38:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W7cULGLb";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TYwyiF38"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbfDYQio (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:38:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52446 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfDYQin (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 12:38:43 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3BB7E607DE; Thu, 25 Apr 2019 16:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556210323;
        bh=f/SlGReMnHfevwanich/a22n0gvsnwVify2i8KLyHWc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=W7cULGLbJWA+2D8NygyEhmp/E1Brxxf1js4p55f6qsipOnnRgbDOtKuSJ6ZZojiFX
         ag1prSRNGDZeZXY6zycMBxj9NbSBbuk4bMgfQLM7wefp6c6JnK7LC4+0kBb9xoM2NQ
         aqEeUfeENYNMr7EnxTcQnESqCQ/YqlB+ufJCwK9w=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 532B56034D;
        Thu, 25 Apr 2019 16:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556210322;
        bh=f/SlGReMnHfevwanich/a22n0gvsnwVify2i8KLyHWc=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=TYwyiF380szAWL/H5gWmiaxSXu8KhLNAKdLmuQoHlCIHF8R+UPQ4xVZlOs/TC5VjV
         LXG5Mv1GmoADYHUTPLoRXr+dsF6/py4p4P9tefhf9A9QmRljmzmFVUmH8SbSTUCpE7
         g0YtEPk0Jml1fx5i3vzrxLf5vuOi58wAw0UpOk0E=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 532B56034D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ray_cs: Check return value of pcmcia_register_driver
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190306114614.19116-1-yuehaibing@huawei.com>
References: <20190306114614.19116-1-yuehaibing@huawei.com>
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425163843.3BB7E607DE@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 16:38:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yue Haibing <yuehaibing@huawei.com> wrote:

> From: YueHaibing <yuehaibing@huawei.com>
> 
> init_ray_cs does not check value of pcmcia_register_driver,
> if it fails, there maybe cause a NULL pointer dereference in
> exit_ray_cs.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

444efbde3281 ray_cs: Check return value of pcmcia_register_driver

-- 
https://patchwork.kernel.org/patch/10840927/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

