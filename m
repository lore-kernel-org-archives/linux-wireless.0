Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB33C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40BCB2082E
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:15:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jh2UWwWd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732095AbfA1QGz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 11:06:55 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:39652 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731655AbfA1QGy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 11:06:54 -0500
Received: by mail-it1-f196.google.com with SMTP id a6so20065051itl.4;
        Mon, 28 Jan 2019 08:06:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ainC5+FxfBRDAyW0E2awXq/Wrv+5OoMBDlThxZzPy1s=;
        b=Jh2UWwWdiZ1tgeIvSgVueCzS/nkNrsfhiCD46f6jYqQlQGRoslKj8Xo2czox74b9LT
         lgOcTHqaXcLXum0g6+4HbZRG7v4/OnIErmxuMh+W7wL7WYtJHFd7/SmekC2pJRDcs0Fp
         1f2kLuo2AGnQNCpXPpFnMYqTtDq9mOz4AQxsoY7MeGpigqlDY08S4H6K2kBFIw+UXghP
         +9XeWjj1F6jW2SQihuuYmZWe5MrR4M89WlhAXFro9D/P48DDRprWD2RktncbEEXqtrVP
         BrmEz9GruS0kERYyRZWcrk7v4NH9firukNUv6rOqLtn9LpTJa9xnUUb7NZJKmEqP0vzk
         CAQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ainC5+FxfBRDAyW0E2awXq/Wrv+5OoMBDlThxZzPy1s=;
        b=fGy2QCJ77cPVPTtDmB0PwU4fI9AyTm07GzJ4NDfR2Zhx4rCyBleGQ24DpchuAqGuMV
         ky4EqBv0Rdtcvrj+EeOQIk2e+dvuq8i/iglMMCIKWoD12KD9ihuPjcEUfsKIVIZjnbj9
         vVRhQi4y+tBWNfJp+zmz5PBxM6T2ToV3WeNnkR4K22EcLe1Cr9+UACTOI9MHHZE1jhqj
         VzJ4vJd8noSSl72pu9Ayj8J1uikIFHqFRTUhtwNXRtRp8qAZqYJGFJPCaYNama+iJ7Ow
         dWyy17F4VrOiDS9gSsPcgcdZ8RyzCEdEqxyOTGdm+wEuwrUNXKofZ8L232CtOamVRNeR
         Oxug==
X-Gm-Message-State: AJcUukf/Tc/9GfbcTDIpBzXy2cFqgS9pCJMgm8wJLlJLcPy+EwI+0AgS
        +4/M3m8vmeDQxQYIAn3QTibSeTlArBIncGlB7GY=
X-Google-Smtp-Source: ALg8bN73BBpn2IsLNsG/goVy64DQgCXEzARDVnECsyb8u7WQMZrQoHCOf7z513Ut+MyyXwhr/juW6Q4Wb/3ev+mzoW8=
X-Received: by 2002:a24:c342:: with SMTP id s63mr7667298itg.43.1548691613736;
 Mon, 28 Jan 2019 08:06:53 -0800 (PST)
MIME-Version: 1.0
References: <1548160717-4059-1-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1548160717-4059-1-git-send-email-sgruszka@redhat.com>
From:   Sid Hayn <sidhayn@gmail.com>
Date:   Mon, 28 Jan 2019 11:06:41 -0500
Message-ID: <CAM0KTbBz4hLWuN5oAGJV9rXEGuHP1UDPsL2fYaKJA6pRJG1MDA@mail.gmail.com>
Subject: Re: [PATCH 4.20.x 0/7] mt76x0 fixes for 4.20 stable
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Jan 22, 2019 at 7:41 AM Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>
> There ware several bugs introduced in 4.20 development cycle
> for mt76x0 driver, that were fixed later but missed 4.20
> release. This patche set fixes issues for MT7610U and
> MT7630E.
>
> Bug reference:
> https://bugzilla.kernel.org/show_bug.cgi?id=202243
>
> Lorenzo Bianconi (1):
>   mt76x0: phy: unify calibration between mt76x0u and mt76x0e
>
> Stanislaw Gruszka (6):
>   mt76x0: do not overwrite other MT_BBP(AGC, 8) fields
>   mt76x0: use band parameter for LC calibration
>   mt76x02: run calibration after scanning
>   mt76x02: assure we update gain after scan
>   mt76x0: do not perform MCU calibration for MT7630
>   mt76x0: antenna select corrections
>
>  drivers/net/wireless/mediatek/mt76/mt76.h          |   1 +
>  drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |   9 +-
>  drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |   5 +
>  drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    | 170 +++++++--------------
>  drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |   1 +
>  drivers/net/wireless/mediatek/mt76/mt76x02.h       |   1 +
>  .../net/wireless/mediatek/mt76/mt76x02_eeprom.h    |  10 +-
>  drivers/net/wireless/mediatek/mt76/mt76x02_phy.c   |   1 +
>  .../net/wireless/mediatek/mt76/mt76x2/usb_main.c   |   3 +
>  9 files changed, 76 insertions(+), 125 deletions(-)
>
> --
> 1.9.3
>

Please forgive if I'm mistaken, but I haven't seen this hit the stable
queue or see any response at all.  Did this get missed or just hasn't
been reached yet?

Thanks,
Zero
