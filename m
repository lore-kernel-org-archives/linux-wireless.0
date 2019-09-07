Return-Path: <SRS0=XcSR=XC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05859C43331
	for <linux-wireless@archiver.kernel.org>; Sat,  7 Sep 2019 05:07:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9F8C208C3
	for <linux-wireless@archiver.kernel.org>; Sat,  7 Sep 2019 05:07:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J4DvzOcj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394250AbfIGFHp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 7 Sep 2019 01:07:45 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:44441 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389786AbfIGFHo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Sep 2019 01:07:44 -0400
Received: by mail-yb1-f193.google.com with SMTP id y21so2985514ybi.11
        for <linux-wireless@vger.kernel.org>; Fri, 06 Sep 2019 22:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dyS+Zl5MlS8vYqiZGcSZhpOPXkZwaFS+5jdXG4eF5PE=;
        b=J4DvzOcjwNQKsS9WpMqWwtr2sIRIylYesX/a/8Ae4s7m0bSzuuHLUt757kiOEcr1X/
         x7U0yx9bvMPJ+hGOYSo+mDIpEGsALIbCIGMon2rb19qITycAKOnzJ+JHE+hnE2NXw32P
         dj3okVvEi+NU36CYpA5NHRO0L0DPZP38KfOPYVTq9mzFrtOQ50DgBGtxIt7i3AtwpOMj
         /LlY6jRMJIzfq6ZARPKzPGMnyA3E51jFYhHT4dJ6ShjVPLKALVAQPDqEkRxX9A0fbORj
         6DX+3ur/ViBWHvyuL92bjPV1wq/r4cxFZ/cFDyQwxRjn2C3ovgV1hVNySOD91etkASB8
         WftA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dyS+Zl5MlS8vYqiZGcSZhpOPXkZwaFS+5jdXG4eF5PE=;
        b=ph5YSvmzvmCD+qqnWuUp/rOkhazW88vvWIb6EvbjzdxWv9NoVWTsE224JcVCqbh9Gy
         F9yLIuUsUokLT7KxgdGw53yzKiZQZBILRlNvSgF1aJwtaMhdxt0ylrZyMWvgvkluGukS
         an/A/X/1B+/A/a2ku0M5xmGHoDOAkMbLcJPlIRSWGQM2s3ojMFMKKxttzkkL4qOzH4l5
         8NRh1gGSQCJfvXR0cnFI5Qg+awIiDM9qVAx2SaRac841pj7heKl5advLaWi8TotTT14m
         nPGYeI+L0nJLok3s+O7y9a1dH7lgF51xxknYI0GB/JLihZTFHrvW2ShvoZbbDMJG+Bd4
         qzvw==
X-Gm-Message-State: APjAAAWE8SXppnfMudlK6D9NsyADL1S7pQwOpGL6pKBKB4Vt/G8D8KIf
        6Og4maRASjr4Fwwy7doX0imC8oCVyRjFjNAAgVY=
X-Google-Smtp-Source: APXvYqy+s4JLUUkJW0piWaizGzLs5DODf0Bj3dWKpAEacsNtTL5c26UdagyfyZFx1ivvNPMMAU7WuhbNcwWdXyPFSJY=
X-Received: by 2002:a25:6944:: with SMTP id e65mr9096868ybc.213.1567832863496;
 Fri, 06 Sep 2019 22:07:43 -0700 (PDT)
MIME-Version: 1.0
References: <5933942ffd23f71b925cc6be26e9918fd663ed46.1567783646.git.lorenzo@kernel.org>
 <87mufhz5e9.fsf@toke.dk>
In-Reply-To: <87mufhz5e9.fsf@toke.dk>
From:   Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Date:   Sat, 7 Sep 2019 07:07:33 +0200
Message-ID: <CAA2SeNJKXzCNDEzCg7=F7vQoL2d1mnM4JiaDfomqwWLy_oj+Qw@mail.gmail.com>
Subject: Re: [PATCH] mt76: mt7615: enable SCS by default
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>, Roy Luo <royluo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>
> > Enable Smart Carrier Sense algorithm by default in order to improve
> > performances in a noisy environment
>
> What does that do (the algorithm, that is)? :)
>
> -Toke

Hi Toke,

it is used for tuning device sensitivity according to RTS error rate
and False CCA reported by the radio (e.g decrease radio sensitivity to
cut off interference stations).
It has been ported from vendor sdk.
https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/drivers/net/wireless/mediatek/mt76/mt7615?id=49de79ad9a748c86277f39613ade72dc56421454

Regards,
Lorenzo
