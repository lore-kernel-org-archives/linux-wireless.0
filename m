Return-Path: <SRS0=yVm+=OT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4FC5C04EB8
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 12:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A6C52086D
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 12:26:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="koQTP2P5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A6C52086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbeLJM0n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Dec 2018 07:26:43 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38841 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbeLJM0n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Dec 2018 07:26:43 -0500
Received: by mail-wm1-f67.google.com with SMTP id m22so11059053wml.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2018 04:26:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=imHFBi6fqPKGWojMXAKNCusQrOhG7lWltv9ZSR1+Dxo=;
        b=koQTP2P5m3EvMjudUZUHX0xmn49OUoYEndSrkfYC0bjoKJ87fQiQDUCiOfE1IANIRq
         X3uQh/YU15y7SKGk8FiCjvECQTBN7hC1y5F2wsH8g9/3IEDpGqzvNTdJ8JgZvu0aGQQl
         uH2QueOVBLMO53teHMo7sjNEecPfeaLUgHM9kQTZ8Nt/8AdeCoEvpuowLLcZiIR5QQMb
         u2W2Blv19BFC9szMzbmKMcVzYS9EFzkoc1xCLKriK49e0sUEgvZOsTTYn+6PdbTrVPtR
         Vo8hUj/oDaDlSREiwKQGfLUz6EwlSnvxzzD9nUGG7RJmJcZManCQ6fHORBL5A3a2996q
         tEUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=imHFBi6fqPKGWojMXAKNCusQrOhG7lWltv9ZSR1+Dxo=;
        b=Ja6LnKq5MplIr1jZ9Bizisx3wNNpZaqF3IsYu9hzjnledwEyWdpn6Jp/HNLNfUcOWy
         v8+KObNI5ulvBDFva2AsIiV2eAUxbGlHECsHyMc4qm2LtMHQV8gUBC2ycd0KZ01fxlE4
         q1Ud4cEBN4PpSCzaZn0bcHgG9jJSgSyUwxVhuHs/aeF4bm32NDAwLtg7SvK/fsOwW2SJ
         iFwChwT1NLPeIyhwqRtZX/GhbNk7LavbrQFvQakt063Z1sQtorS3zCG+Piyb9b4Ki3Q/
         3dSFEk5Lk8JSU8+8OP2eubhf0kCMix4tfudOY27C2J8G8qTci7V1eEQSvv0rMTxtKgrI
         10ag==
X-Gm-Message-State: AA+aEWab9kzaWvXfrdqDsy2jKBQkt5Cq7h46c2j6RvT7Djzsu54g1752
        BQjctMWPx/SAtGwehoK9J4U/RpP8axvolJ2wnaw=
X-Google-Smtp-Source: AFSGD/VRs5DbKiBjNWhlU4ociR390NQruPYzUZmOE3l1eBiFk0mGNzFmK5tWrZdSGTr3UyEgysHK1Hy5VNjGBf+65Ic=
X-Received: by 2002:a7b:cb18:: with SMTP id u24mr10046447wmj.138.1544444801412;
 Mon, 10 Dec 2018 04:26:41 -0800 (PST)
MIME-Version: 1.0
References: <1544433294-6997-1-git-send-email-arend.vanspriel@broadcom.com>
In-Reply-To: <1544433294-6997-1-git-send-email-arend.vanspriel@broadcom.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Mon, 10 Dec 2018 13:26:29 +0100
Message-ID: <CACna6rzj+yiQcRE+VwOnB0aC05vJVpZBp0hAZPpv7ZPdzMqWOg@mail.gmail.com>
Subject: Re: [PATCH 0/2] brcm: new firmware for BCM4366 chip family
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     linux-firmware@kernel.org,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 10 Dec 2018 at 10:32, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> This series includes the firmwares for the BCM4366 3x3 802.11ac chipset.
> The firmware for the bcm4366c0 has been long overdue.
>
> I did submit the firmware files early November in a single patch, but
> probably hit the majordomo limit of 100,000 character with it. So here
> is the 2nd attempt.
>
> These patches apply to the master branch of the linux-firmware repository.

Wow, this is a great news! Thank you!

I didn't receive patch 1/2 and I also don't see it in the archive:
https://marc.info/?l=linux-wireless&r=1&b=201812&w=2

Not sure if it has reached linux-firmware ML (I can't find its
archives anywhere).
