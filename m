Return-Path: <SRS0=36rf=O7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBB54C43387
	for <linux-wireless@archiver.kernel.org>; Sat, 22 Dec 2018 17:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5DD92146E
	for <linux-wireless@archiver.kernel.org>; Sat, 22 Dec 2018 17:03:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="WLyalLXF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730347AbeLVRDk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 22 Dec 2018 12:03:40 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:41777 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729637AbeLVRDk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Dec 2018 12:03:40 -0500
Received: by mail-ot1-f66.google.com with SMTP id u16so7910355otk.8
        for <linux-wireless@vger.kernel.org>; Sat, 22 Dec 2018 09:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RqJrwS1t2ctVxO6g9dYmB7KbG/2K3XVrcTmS6ensY/Y=;
        b=WLyalLXFBBzL0hfSk4tODo450J0Vjk/BlXBupQjxwUfRzBEk2okyuvrBRjfOTjqUOV
         XccoXPIzePvnYwVCy26poD9I0G1/7njklyhFM4aEGRvVZwhlyUTdeZpew5ZPYuPEDhGe
         JfWZJeuzONT+XdSsYBy1zvzaEZsK4DniZBxFg8yn7g/YVFljzM9HadYMDVRQ/5rfXSJt
         QHomHyTRRNI0vYvPM6Q6WAby229ilhNhJ5rNdkv6EFm7vBHcZNT9r6SbikJ7Y1I0RMOn
         WLlE1aaZDLiMOZGoGN7CrXLuwqMEaBKStQKOEsDZqON2xFJc+w6/8qscVP7trPGMD6zl
         vCyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RqJrwS1t2ctVxO6g9dYmB7KbG/2K3XVrcTmS6ensY/Y=;
        b=gWwyHdcTk9R7V3LDceRoacAIdtQJe4EZv9n+8cfLlGOUEQebHh/d+iIwfx/xUiFdwj
         MBJayKeA+kb8+y7Al+nqgnTnmlX3KLJ7c0mfWKje/VOE7+HqgJKa2raiuIVuSY5iGgSM
         brxR+b4Q8xbqZn1WEWKuI5gsM1iR+SIgAL7COhvgIKrZ7aUWWMHgxwk072kQui2G8aK8
         a7FYH3Y2aQF0yr9reoRl9PwmyWI7CviBLci7lkejM1pActcyt2iabbO/zbyKjCgrytNy
         nZOgraj8SJFc+5lG8EEEjbwyO/PifsJdJ9Civ4CnQRMbbgN7sLgn1SxdGZmKZhU8hsWg
         gORQ==
X-Gm-Message-State: AJcUukf/bQv7PpCA2hYEF7hXiVftPgiYGxEOtIZn2mvIvRFcs4OZFA5g
        jO55eLQEvlwYaaYrR0UIRmwS+ZRmcGV5QhgnZO8O5B6N
X-Google-Smtp-Source: ALg8bN72nht44IIMBsFPkJhS9B4zBcNkSRVNM12iP4xxV46FCkVJ/d8AtmnmR0KpvnhtRZnJxBQa/ooOEEQJgSdIe6Q=
X-Received: by 2002:a9d:a48:: with SMTP id 66mr4066082otg.308.1545476896177;
 Sat, 22 Dec 2018 03:08:16 -0800 (PST)
MIME-Version: 1.0
References: <20181222060913.28434-1-cshored@thecshore.com>
In-Reply-To: <20181222060913.28434-1-cshored@thecshore.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sat, 22 Dec 2018 12:08:05 +0100
Message-ID: <CAFBinCA3MTO=h9YpB0RkxSNy4ZpeYLOAuKTykAKz+68stAtMsg@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Avoid OF no-EEPROM quirks without qca,no-eeprom
To:     "Daniel F. Dickinson" <cshored@thecshore.com>
Cc:     ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        chunkeey@gmail.com, kvalo@codeaurora.org,
        Bas Vermeulen <bvermeul@blackstar.nl>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Dec 22, 2018 at 7:09 AM Daniel F. Dickinson
<cshored@thecshore.com> wrote:
>
> ath9k_of_init() function[0] was initially written on the assumption that
> if someone had an explicit ath9k OF node that "there must be something
> wrong, why would someone add an OF node if everything is fine"[1]
> (Quoting Martin Blumenstingl <martin.blumenstingl@googlemail.com>)
>
> "it turns out it's not that simple. with your requirements I'm now aware
> of two use-cases where the current code in ath9k_of_init() doesn't work
> without modifications"[1]
>
> The "your requirements" Martin speaks of is the result of the fact that I
> have a device (PowerCloud Systems CR5000) has some kind of default - not
> unique mac address - set and requires to set the correct MAC address via
> mac-address devicetree property, however:
>
> "some cards come with a physical EEPROM chip [or OTP] so "qca,no-eeprom"
> should not be set (your use-case). in this case AH_USE_EEPROM should be
> set (which is the default when there is no OF node)"[1]
>
> The other use case is:
>
> the firmware on some PowerMac G5 seems to add a OF node for the ath9k
> card automatically. depending on the EEPROM on the card AH_NO_EEP_SWAP
> should be unset (which is the default when there is no OF node). see [3]
>
> After this patch to ath9k_of_init() the new behavior will be:
>
>     if there's no OF node then everything is the same as before
>     if there's an empty OF node then ath9k will use the hardware EEPROM
>       (before ath9k would fail to initialize because no EEPROM data was
>       provided by userspace)
>     if there's an OF node with only a MAC address then ath9k will use
>       the MAC address and the hardware EEPROM (see the case above)
>     with "qca,no-eeprom" EEPROM data from userspace will be requested.
>       the behavior here will not change
> [1]
>
> Martin provides additional background on EEPROM swapping[1].
>
> Thanks to Christian Lamparter <chunkeey@gmail.com> for all his help on
> troubleshooting this issue and the basis for this patch.
>
> Fixes: 138b41253d9c ("ath9k: parse the device configuration from an OF node")
>
> [0]https://elixir.bootlin.com/linux/v4.20-rc7/source/drivers/net/wireless/ath/ath9k/init.c#L615
> [1]https://github.com/openwrt/openwrt/pull/1645#issuecomment-448027058
> [2]https://github.com/openwrt/openwrt/pull/1613
> [3]https://patchwork.kernel.org/patch/10241731/
+Cc Bas Vermeulen: can you please try Daniel's patch on your PowerMac
G5? I hope that this replaces your "endian_check" module parameter!

> Signed-off-by: Daniel F. Dickinson <cshored@thecshore.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
(to me the description makes sense, but that said: I contributed some
of the description)

as well as:
Tested-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
(on my BT HomeHub 5A - which sets qca,no-eeprom - using OpenWrt, which
is currently running backports v4.19.7)


Martin
