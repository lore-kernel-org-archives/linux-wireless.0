Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CED8C4151A
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 18:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28C572192C
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 18:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbfBISqu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 13:46:50 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:53541 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbfBISqt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 13:46:49 -0500
Received: by mail-it1-f193.google.com with SMTP id g85so17064372ita.3
        for <linux-wireless@vger.kernel.org>; Sat, 09 Feb 2019 10:46:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hYn90LLYwCyKMPQvfMjeVNpofeF6CIirnzwCD354ksw=;
        b=j3X/dxBPNqGmKweK2is18qTp6L/tkuBhvMfep7yiNawAjJ8WdwrFIJoKzZLl7x4HcK
         Ge0qIqc1qrK+X2AQBu4jNtR3i4nKkxeb4nn3snpJjiGYatdiK3nB/BpOws6KJkgfXxfS
         KtM35BoLwvfSCujDPLcHbloU+zo6CS3w4Z5uhAg3GbF7Q3pFzF6S5Bi0sMlABld6MYpD
         iCjedr4j9YkIHjwmq0gEC5wrgdZyr5LLq5ytB0Mfy17JSgDX/nAO21bKcdcA9QaEIeqM
         G+Zu+V7XX7dr1ob0klqBy262oj8qThIDz8Bx45zoF1eHsHnRNh343Wt/ZQY3g6cWMlYf
         CiTg==
X-Gm-Message-State: AHQUAubb0GEFI6o21KtR+bTgIzvmbNJjd6hoNVp2LXJURvAPJSz1gNBr
        MOhXVf/yT7BJ2yGcDpyp1aKY4IdjTbZwVCcE/lK4jw==
X-Google-Smtp-Source: AHgI3IaGMvreQ3mh8R69XQqVP09oKm7VCS1McJxdb/p4fp351oUJ7wcOUGP6xo2WDaaoapyZQIu0ylUYGo9rq4R0s1A=
X-Received: by 2002:a24:2e55:: with SMTP id i82mr2822210ita.68.1549738008784;
 Sat, 09 Feb 2019 10:46:48 -0800 (PST)
MIME-Version: 1.0
References: <2003727085.234456.1549714119945@email.ionos.de>
In-Reply-To: <2003727085.234456.1549714119945@email.ionos.de>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sat, 9 Feb 2019 19:46:37 +0100
Message-ID: <CAJ0CqmXSuNQ_tQOatyKwO9O2KsxqD5NZRQnngOme5PURssiv5Q@mail.gmail.com>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> Hi,
>
> as already reported here [1], that there are probing issues of mt76 using TP-Link Archer T2UH (wifi USB dongle) on Raspberry Pi 3 B+.
>
> I retested it with recent linux-next 20190208 (aarch64 defconfig + enabling mt76 driver) and got the following output after plugin the wifi dongle:
>
> [   29.778524] usb 1-1.3: new high-speed USB device number 6 using dwc2
> [   31.794581] usb 1-1.3: reset high-speed USB device number 6 using dwc2
> [   31.919916] mt76x0u 1-1.3:1.0: ASIC revision: 76100002 MAC revision: 76502000
> [   32.304412] dwc2 3f980000.usb: dwc2_update_urb_state(): trimming xfer length
> [   32.325724] dwc2 3f980000.usb: dwc2_update_urb_state(): trimming xfer length
> [   32.346866] dwc2 3f980000.usb: dwc2_update_urb_state(): trimming xfer length
> [   33.410559] mt76x0u 1-1.3:1.0: firmware upload timed out
> [   33.435458] mt76x0u: probe of 1-1.3:1.0 failed with error -110
> [   33.454829] usbcore: registered new interface driver mt76x0u
>
> I took the firmware files from here [2].
>
> Btw there is another issue, if i disconnect the wifi dongle during probe i'm getting a endless flood of the following output:
>
> mt76x0u 1.1.3:1.0: rx urb failed: -71
>
> Any chance to narrow down these issues?

Hi Stefan,

could you please test the following series:
https://patchwork.kernel.org/cover/10764453/
Applying this series I am able to connect to my home AP using an Asus
USB-AC51 (mt76x0u) connected to a Raspberry Pi 3 B+.
I am running rpi-5.0.y branch of https://github.com/raspberrypi/linux.git

Regards,
Lorenzo

>
> [1] - https://marc.info/?l=linux-wireless&m=154875316703367
> [2] - https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/mediatek
