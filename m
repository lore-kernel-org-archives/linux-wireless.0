Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA56CC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 13:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89AF0217D8
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 13:12:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lwTAxOtu";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W5CWV7LQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732538AbeLTNMm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 08:12:42 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36918 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730884AbeLTNMl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 08:12:41 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1BDBD60867; Thu, 20 Dec 2018 13:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545311561;
        bh=REEJn9AdM/EMIpyj5AGdvfP5/SAXzUzyr5xgpY8LL0s=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=lwTAxOtuIKGLlxDJMtWKIh2zEIMYzODkk9cE81T1SUS2WBvqH27Oldf06ruipmeyu
         hvHUuIm30oMMrAY+H3FofccTCMq8LJsdvcNmOCDfZZ3mZPqfEmI93j+vtUCIqlOk/a
         hW0HU+z+3MqD0/5vF24L2zCT6SJI4Vuc8+4WJkhs=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 86E1B60867;
        Thu, 20 Dec 2018 13:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545311559;
        bh=REEJn9AdM/EMIpyj5AGdvfP5/SAXzUzyr5xgpY8LL0s=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=W5CWV7LQb53kCdmcWXDBuFjZCyO/BueVVi7o4N/UOYhaoHTSlwpkblmPshLZTp6wP
         OxYimnVS+anFpgGDMuuBdojDKTWymWwD4Ro9l2AomVk4OXzrodIlgbgGwnonxJDyI4
         /nNAoixbu+xgyirOJ+aNAgoTr1vXXALyvDJtrtXc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 86E1B60867
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: out of bounds read in drivers/net/wireless/ray_cs.c
References: <9a94eeb3-0146-5e64-1e35-54f925fb14d2@canonical.com>
Date:   Thu, 20 Dec 2018 15:12:35 +0200
In-Reply-To: <9a94eeb3-0146-5e64-1e35-54f925fb14d2@canonical.com> (Colin Ian
        King's message of "Thu, 20 Dec 2018 13:06:58 +0000")
Message-ID: <87pntwtk8s.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin Ian King <colin.king@canonical.com> writes:

> Static analysis with CoverityScan picked up an out of bounds read issue
> that has been in the Raylink wireless LAN card driver since it appeared
> in the kernel:
>
> drivers/net/wireless/ray_cs.c:
>
> accessing org[3] is out of bounds, the array has just 3 elements.
>
>  959                if (proto == htons(ETH_P_AARP) || proto ==
> htons(ETH_P_IPX)) {
>  960                        /* This is the selective translation table,
> only 2 entries */
>
>     CID undefined (#1 of 1): Out-of-bounds read
>     overrun-local: Overrunning array of 3 bytes at byte offset 3 by
> dereferencing pointer &((struct snaphdr_t *)ptx->var)->org[3].
>
>  961                        writeb(0xf8,
>  962                               &((struct snaphdr_t __iomem
> *)ptx->var)->org[3]);
>  963                }
>
> I suspect the org[3] is a typo and should be org[2], but I don't have
> any info on the H/W so I'm speculating that this is the issue. Any ideas
> anyone?

I have never heard anyone using this driver so I suspect you won't get
any help with testing. Just send a patch fixing the issue, and if it
breaks something then at least we know someone is using the driver :)

-- 
Kalle Valo
