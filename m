Return-Path: <SRS0=49bh=RV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A33C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 22:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B24AD2133D
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 22:35:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VV9EFZQ8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbfCRWfb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Mar 2019 18:35:31 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:42728 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbfCRWfb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Mar 2019 18:35:31 -0400
Received: by mail-oi1-f193.google.com with SMTP id w139so5685366oie.9;
        Mon, 18 Mar 2019 15:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=rYP16VrOUwZhH4ErLiKWsnq5vp5lLh2E0oBz/QH57JE=;
        b=VV9EFZQ8TaVLj+BHrRceaXXvy1uaaJB6GLluRYWni6kxjgOm82T3Y5QNKZrrRE3Bbb
         2CDozwDqaksp1VWaL35/+PQjiVNEmA+ndSUKq2Bv/NpLdMZnYL0Ts0UT6sxiFVql/L1V
         HrttYwrIJj1Xn5aTjxB4dNmNGXfH5f0pj8i3UI66ojODTNh6LrMYbstG4O47IAe92c8g
         SKFFZ8O8wQFpzEvZYTxPu1wyIc4Sqy+C3+b/R14Gb85XnzNdw9Qh8Mlu6+e5dN2Gvojc
         Tld6/gsSDIu2NqS01+8ELKUkAKN1UnNvocojegFQpkGpGzJ8DQSeKGJejjnxcLoZ8s+l
         /Txg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=rYP16VrOUwZhH4ErLiKWsnq5vp5lLh2E0oBz/QH57JE=;
        b=MlfxF+EkAXAl79Li14l6TtsAgQZQ5uSBxNEb3UKNjC/J1Y78RzsFE/3dl/CbtQcySk
         fmhrCDJQGbr/J4s19f/6KgtXagI9hA0gDVF8CNoskyBP86UPEXPY0+OrqSlD1Lh3M5Da
         JHp/58MytWq19YCGRirBiJa+u71/4nPiQGSVBO6xLwXvJZPJwM0j+GbYRJ3rkSPKka1S
         rnJVJyDCqwP5VcRpkCR5gIzOUvYEY5PHR07vIK1kp/qNLh4BEVjLjXQ1k/NxvyQblppX
         Vu2Orugo0UAsbnQlF5nE6hVwVdUmUacNxAHqHmhHmXQ62vG4MWyxvHkg18GsqCat1mLn
         27TA==
X-Gm-Message-State: APjAAAVTfrojPlbokmorfRxE7UtPF+BS6rhPfslvz/oeagxVM3tv2Mac
        1o8MoRPvuId9g0IYWnZcVp2DYms9EWP4/L3+nlU=
X-Google-Smtp-Source: APXvYqw+VJk3iFo7sgpw5Sb3Wy3XsVxbkhNlbMkno1yAi6Yyx7EnX60Urrk3dHyPGNDTA1DzWPmLDt3khU254inWGKo=
X-Received: by 2002:aca:dd0b:: with SMTP id u11mr818340oig.24.1552948530529;
 Mon, 18 Mar 2019 15:35:30 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:628c:0:0:0:0:0 with HTTP; Mon, 18 Mar 2019 15:35:30
 -0700 (PDT)
In-Reply-To: <20190318190557.21599-1-timschumi@gmx.de>
References: <20190318190557.21599-1-timschumi@gmx.de>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Mon, 18 Mar 2019 23:35:30 +0100
Message-ID: <CAKR_QV+wjuOZVfv9awX5bRLYC8xkoAy0h22LSPvL0DX6yg4-yw@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Check for errors when reading SREV register
To:     Tim Schumacher <timschumi@gmx.de>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 18/03/2019, Tim Schumacher <timschumi@gmx.de> wrote:
> Right now, if an error is encountered during the SREV register
> read (i.e. an EIO in ath9k_regread()), that error code gets
> passed all the way to __ath9k_hw_init(), where it is visible
> during the "Chip rev not supported" message.
>
>     ath9k_htc 1-1.4:1.0: ath9k_htc: HTC initialized with 33 credits
>     ath: phy2: Mac Chip Rev 0x0f.3 is not supported by this driver
>     ath: phy2: Unable to initialize hardware; initialization status: -95
>     ath: phy2: Unable to initialize hardware; initialization status: -95
>     ath9k_htc: Failed to initialize the device
>
> Check for -EIO explicitly in ath9k_hw_read_revisions() and return
> a boolean based on the success of the operation. Check for that in
> __ath9k_hw_init() and abort with a more debugging-friendly message
> if reading the revisions wasn't successful.
>

you are still passing it all the way from ath9k_hw_init

>     ath9k_htc 1-1.4:1.0: ath9k_htc: HTC initialized with 33 credits
>     ath: phy2: Failed to read SREV register
>     ath: phy2: Could not read hardware revision
>     ath: phy2: Unable to initialize hardware; initialization status: -95
>     ath: phy2: Unable to initialize hardware; initialization status: -95
>     ath9k_htc: Failed to initialize the device
>
> This helps when debugging by directly showing the first point of
> failure and it could prevent possible errors if a 0x0f.3 revision
> is ever supported.
>

I don't think this is required. Mac Chip Rev 0x0f.3 at least prints
what the problem is instead of generic SREV read failure. Either wrong
define in driver or address overlap caused by large/bad firmware in
ath9k_htc case.
