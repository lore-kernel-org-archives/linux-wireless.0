Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 558DBC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 16:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22B64205C9
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 16:05:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EVcFhGFJ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XHLaeSbi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405088AbfAPQEy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 11:04:54 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:49480 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbfAPQEy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 11:04:54 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7DB516084F; Wed, 16 Jan 2019 16:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547654693;
        bh=MOVexiOiHMTAacpKdUFZPZl3mDa+7g6+e2muKIUvgxU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=EVcFhGFJ07Y+FGGMSNMy2LiwTmCsLJRkvsL6ruqtLhzFWU7Kj2nXYJFgWJxfNvloU
         pb1OA6qbimQV+EQcg/dGw6NE9dDAmXaD7N/ml1cgluWruB8eqodx+gmeEEPfmIf/hd
         33C4KVpRPS97Sk8X/5HXz2R24QCc9VbqmbohH+PE=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7730960791;
        Wed, 16 Jan 2019 16:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547654692;
        bh=MOVexiOiHMTAacpKdUFZPZl3mDa+7g6+e2muKIUvgxU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=XHLaeSbiYIOEPKl3rD1j2zDxqR7yW6T1clGj5wqHbGq52EvYrIv9LsApc7UbTUAU1
         E6xQ9W6YCb6iTcmNL6L7hNKhJCMCGtBXfhww2CpecqUu/TJvYgHr1qfvt4ljYGO27A
         DhGOavnBTC6XJqWAp9m69i474rSkI1JzVw7LAGnQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7730960791
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lubomir Rintel <lkundrak@v3.sk>
Cc:     libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libertas: remove ifdef OLPC noise
References: <20190116151618.1972197-1-lkundrak@v3.sk>
Date:   Wed, 16 Jan 2019 18:04:48 +0200
In-Reply-To: <20190116151618.1972197-1-lkundrak@v3.sk> (Lubomir Rintel's
        message of "Wed, 16 Jan 2019 16:16:19 +0100")
Message-ID: <87zhs04mhr.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lubomir Rintel <lkundrak@v3.sk> writes:

> <asm/olpc.h> provides machine_is_olpc() stub for CONFIG_OLPC=n,
> compiler should just optimize the unneeded bits away.
>
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> ---
>  drivers/net/wireless/marvell/libertas/if_usb.c | 10 ----------
>  1 file changed, 10 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
> index 220dcdee8d2b..7b61c599948e 100644
> --- a/drivers/net/wireless/marvell/libertas/if_usb.c
> +++ b/drivers/net/wireless/marvell/libertas/if_usb.c
> @@ -12,9 +12,7 @@
>  #include <linux/usb.h>
>  #include <linux/olpc-ec.h>
>  
> -#ifdef CONFIG_OLPC
>  #include <asm/olpc.h>
> -#endif

Using asm directory looked odd to me so I did some investigation:

$ find -name olpc.h
./arch/x86/include/asm/olpc.h

Did you build this on something else than x86? For example, will the
compiler find olpc.h when building for arm?

-- 
Kalle Valo
