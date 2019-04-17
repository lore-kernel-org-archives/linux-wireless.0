Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88992C10F14
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 02:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EE412073F
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 02:55:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Y+vCoie2";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Y4Ka1IYP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbfDQCzV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 22:55:21 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45404 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbfDQCzV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 22:55:21 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 686FE60FEA; Wed, 17 Apr 2019 02:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555469720;
        bh=ywRSGVIU5CIS1tsI6Gdm7ABVZlki6N6+dX0q91JPqPs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Y+vCoie2lTXGGyJpcSTzW47+JnWZvroDC0nWm/fQpAuAeacpNbS2dwtAxCEeGXAy3
         wE1p//CUyrWxeijoWXi8il4rS+U79fz/OXV0Rt28+azzb9YQtRWj77fx+4fHGPeuK6
         8xD66xhO2YUrh12h6XgVOovPLOvRI/82vt0n/zjk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AFC6E60A43;
        Wed, 17 Apr 2019 02:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555469719;
        bh=ywRSGVIU5CIS1tsI6Gdm7ABVZlki6N6+dX0q91JPqPs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Y4Ka1IYPah41dYrRs5FapERMmSFKPLKL1yNkeyfZqMWuMGGoMkcak6aOg1ifjRMFm
         nkZZEGwcGkEmR4SbMYodMMoe/0H3Au2SL1C6GNHeaMfoUGcfW/cPDFkmw23e+x8PgK
         zWXXOX25jGAzzD5LValLvtszYG50lCWbpiN6xyBg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AFC6E60A43
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] rtlwifi: rtl8188ee: Remove extraneous file
References: <20190417003547.26271-1-Larry.Finger@lwfinger.net>
Date:   Wed, 17 Apr 2019 05:55:16 +0300
In-Reply-To: <20190417003547.26271-1-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Tue, 16 Apr 2019 19:35:47 -0500")
Message-ID: <87tvex49yj.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> Somehow file drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej was
> incorporated into the sources. Obviously, it can be removed.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
> Andrew,
>
> Thanks.
>
> Larry
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej | 10 ----------
>  1 file changed, 10 deletions(-)
>  delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej
> b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej
> deleted file mode 100644
> index aa03d4605d8c..000000000000
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej
> +++ /dev/null

What tree is this? On wireless-drivers I can't find this file:

$ ls drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej
/bin/ls: cannot access 'drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej': No such file or directory
$

Actually I cannot find any .rej files:

$ find -name '*.rej'
$

-- 
Kalle Valo
