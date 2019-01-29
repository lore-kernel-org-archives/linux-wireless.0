Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E36C282CD
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 00:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 871482175B
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 00:21:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g6FSl0S4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfA2AVV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 19:21:21 -0500
Received: from mail-ot1-f44.google.com ([209.85.210.44]:32946 "EHLO
        mail-ot1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfA2AVV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 19:21:21 -0500
Received: by mail-ot1-f44.google.com with SMTP id i20so16414312otl.0
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2019 16:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jmS8q4cU9+67K43CABSqHECDwbrg7KOPQBflhdmgjtk=;
        b=g6FSl0S41GUfhCqfYjWssbPz7KwysxeEUxlkYMT1rj+CsJCFX5D2N8e4wC5NmqWdiN
         eTY+/fr9U512FPBaXX+yV0FyU54FJbjDfYKnnzJo7q5QC9crSCLSP3oFh9Ck9KoJrV29
         JqGh+UnECT5Y2TGBIW3IzTHeHPeB9EX/wg8Og23pv+HB+c75yiWtH38db2S/iTzEGXd/
         1Z1l4y+3mpG2uBzIORccDM7HGDX6c4m2ZYLimrinKNblDMA3038bQeTJ3Ej+c3jTYNEc
         MfS1BiC+vvdukefobUd4yiWqnnyNdV9yQFIEGXAGoAFe1Qg+1T6b7b9ZJ0Y+gJMEcczA
         L1dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jmS8q4cU9+67K43CABSqHECDwbrg7KOPQBflhdmgjtk=;
        b=TAYZ/teziCniwJw8hx28KzS9t39uXpcBBzvu8woONpYYNrTnelNuhniIXht8qOocUv
         WcS2qeYYVNldA7Y4K2oUhTfPAKR9OZIIsFZ0k/G0VrGu/1D8448h2XE6RyzSljOVtpEJ
         tZ84ZrdCvilRrszB+x9S7VTVNyHG/uIcQl2yo4Xs4e+0aIcj5hwhrTWNLYimLAlrFFOS
         N3Hg3H7QxZzlNwkfc0vjBnPN4vDZ/oE7NDiK9pUlR6Jc60vyhDBJWXSfQOqPMFUFoZ29
         wW/aO2aF6RMcGPm7VGu4qTCXk8rkRiKRyP9VblZ0XI2BJCEoY/E0dVHkF5pSXxUQ/SRu
         hd/g==
X-Gm-Message-State: AJcUukcs+qNromt2hsYVOZbSa5KMHfSY36YLywK22daE7N4Ti8J1u3qK
        RNJmEpxKkWJyMdcTfTt6tgJ7EpLk+Pz0HWtoKtM=
X-Google-Smtp-Source: ALg8bN7YPvJ8vTRUUfR/Sz/RsLscRWQ+JU9eEWcXdsaz4LPjFv6409LfXlV4PsO/hur4LueIzLXXJ1oNu69A5pF5gAo=
X-Received: by 2002:a9d:30d4:: with SMTP id r20mr18324674otg.277.1548721280643;
 Mon, 28 Jan 2019 16:21:20 -0800 (PST)
MIME-Version: 1.0
References: <CANP28d09JUQRB-iCBAGgkzv3zZ6k+irNB3uMYW3teN5xLX-eWw@mail.gmail.com>
In-Reply-To: <CANP28d09JUQRB-iCBAGgkzv3zZ6k+irNB3uMYW3teN5xLX-eWw@mail.gmail.com>
From:   Rosen Penev <rosenp@gmail.com>
Date:   Mon, 28 Jan 2019 16:21:09 -0800
Message-ID: <CAKxU2N87ghf5kFoUN1Ru57SNoyV=S=-NUpaPP6LTSgvAu_nscA@mail.gmail.com>
Subject: Re: Wi-Fi drivers/chipsets supporting 802.11w / PMF / MFP
To:     Raul Siles <raul.siles@gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jan 28, 2019 at 3:15 PM Raul Siles <raul.siles@gmail.com> wrote:
>
> Hello,
> I already published the following message in the
> hostapd/wpa_supplicant mailing list two weeks ago without any success.
>
> Is there any resource publicly available with the list of Wi-Fi
> drivers/chipsets providing support for Protected Management Frames
> (802.11w / PMF / FMP)?
>
> Based on my testing, PMF (a requirement for WPA3) works with the
> Atheros chipset and the ath9k driver.
>
> However, looking around for compatibility with other Wi-Fi cards, I
> have only been able to find the following references (aside from spare
> patches for other drivers, sometimes mentioned in this mailing list):
>
> https://wireless.wiki.kernel.org/welcome?do=search&id=11w
>     ath9k: https://wireless.wiki.kernel.org/en/users/drivers/ath9k?s[]=11w
>     p54: https://wireless.wiki.kernel.org/en/users/drivers/p54?s[]=11w
>     carl9170: https://wireless.wiki.kernel.org/en/users/drivers/carl9170?s[]=11w
> https://wireless.wiki.kernel.org/welcome?do=search&id=mfp
>     ath10k: https://wireless.wiki.kernel.org/en/users/drivers/ath10k/mesh?s[]=mfp
>
> What other Wi-Fi drivers/chipsets (or specific Wi-Fi cards) provide
> support for 802.11w / PMF / MFP?
https://elixir.bootlin.com/linux/v5.0-rc4/ident/MFP_CAPABLE
>
> Thanks!
> --
> Raul Siles
