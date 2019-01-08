Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 584ACC43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 16:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C8A62070B
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 16:31:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NKJKBGfN";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SDVp1Y69"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbfAHQa6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 11:30:58 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35376 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728238AbfAHQa6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 11:30:58 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B801A60C87; Tue,  8 Jan 2019 16:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546965057;
        bh=9bK1G9kbhxt5A4pFHkUy6wvbmBdIkmh57PlBlSH297c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=NKJKBGfNTxZMTB+BtOAdinzoQnqc/8EHwJR7TwuqW5FXDtrmhgV3X1pu28KW6a5mm
         7U8uzRLzxzG8jNGvRsB608WTEKY5V4iMwvz9C93uwYxT1LKn6JvKDvDAlYh+K0Q0ts
         GpcYeA7QqBt5XjIlbafpmTv3/qoNFn+L0NwnDE2U=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 144696079B;
        Tue,  8 Jan 2019 16:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546965055;
        bh=9bK1G9kbhxt5A4pFHkUy6wvbmBdIkmh57PlBlSH297c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SDVp1Y69TbW+7WdGa7d+ltostzrVeAb60PR7/dJtxU82l6Yo4Fq8W9KDJx6zK/CFN
         HpYPEib3o/R8VwtkS/CkcE1mmziQ4TtegOIEcxodzBpsMQ/bwKHLXgvZEa68bIh0ut
         lVuf9k3yQTTdE3ndVLNWnt96v5uK5fyFxmqGljTo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 144696079B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Julia Lawall <Julia.Lawall@lip6.fr>
Cc:     Solomon Peachy <pizza@shaftnet.org>,
        kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/20] cw1200: drop useless LIST_HEAD
References: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
        <1545555435-24576-21-git-send-email-Julia.Lawall@lip6.fr>
Date:   Tue, 08 Jan 2019 18:30:49 +0200
In-Reply-To: <1545555435-24576-21-git-send-email-Julia.Lawall@lip6.fr> (Julia
        Lawall's message of "Sun, 23 Dec 2018 09:57:15 +0100")
Message-ID: <87bm4rru12.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Julia Lawall <Julia.Lawall@lip6.fr> writes:

> Drop LIST_HEAD where the variable it declares has never
> been used.
>
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> identifier x;
> @@
> - LIST_HEAD(x);
>   ... when != x
> // </smpl>
>
> Fixes: a910e4a94f692 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
> Successfully 0-day tested on 151 configurations.

I assume I can take this to wireless-drivers-next. If you are planning
to push this via some other tree please let me know.

-- 
Kalle Valo
