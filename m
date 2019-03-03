Return-Path: <SRS0=pcPV=RG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6943C43381
	for <linux-wireless@archiver.kernel.org>; Sun,  3 Mar 2019 09:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7808720836
	for <linux-wireless@archiver.kernel.org>; Sun,  3 Mar 2019 09:26:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=jrdltd-co-uk.20150623.gappssmtp.com header.i=@jrdltd-co-uk.20150623.gappssmtp.com header.b="Zd2dlDuM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbfCCJWr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 3 Mar 2019 04:22:47 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:39369 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfCCJWr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Mar 2019 04:22:47 -0500
Received: by mail-oi1-f195.google.com with SMTP id b4so1579153oif.6
        for <linux-wireless@vger.kernel.org>; Sun, 03 Mar 2019 01:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jrdltd-co-uk.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=xRLhC7YuH42yTzEug1tCmGG6qsPNzC0EUdWa+807XPA=;
        b=Zd2dlDuMCmXC75dOE/bVGpxPCjE4zVRZFpMJ7R6KhlfN1fhJNJ3viZepIgD4S02ya+
         wk+pH976YXHEzJfmN3yrIy4OjxKea5EpQmac6G4RNoXuf/ahJjaJ3WhhgVtpLrOewDgU
         h4JmERtfKaruAgWLB7pIlCCRKQJAPP+ouEkw7bi9FNRB/jkhOjGx5U6S+q2nRR9WNQQa
         qt5OHylOFdFXnVhRHobHJPKhFpsJCS/oxJWB1ARMq1sjscVPm0G/B9MlCTgnoTqP76cv
         QR+tPETPqgiSdWdsuiwce9RyQxmxsRdeNyLwoIqxG8W8hGPQ0Cvze1eJ6BmzukJa3FiB
         Ec3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=xRLhC7YuH42yTzEug1tCmGG6qsPNzC0EUdWa+807XPA=;
        b=olFL0NrkQt40qUtCjTmC3q4YhiYLNOgE3bBIlR5/+Wik3g6MYb0X3UiCAX6Kra4b7l
         AtCKN5W0o/yZAMHEwlwtMn6np4Ol85c6xpv+wR5hpuLLnsbbo7orTlsovWPqBeD1094a
         TWrYUnoctzdPlwW/pTeRfj9S/1esgu2TI0+r7ovssXuJMVmZkmbdkcdB+foTLmjMotq2
         l+eX9XJ3x4rHlA7Lzf469/g1pQT6ebz/4koC5jYrnMoXaCXvnWg872JgNeNjwjQ2Of/2
         nBFEDzhEiIaokmzJj59g9fiaJULzUWfQDpngIyNj9XaJeU1FFsyjYUCoo2DeuLVCYjMH
         8hwA==
X-Gm-Message-State: AHQUAuYR7T88p7+6ZzNfUS+wmpRHJ/u3Lonv24/7Bk3h5dd+tluVQFCH
        lYE6l+ASl7920VhrpaM/TgbgTfR9bA0B+uiuDZvDKXT9zYQ=
X-Google-Smtp-Source: AHgI3IZAEdzUB5jAsgh+c09MwVii5mf6k6QzaoIrYjuGudp2pcz6szCyLQZyDey9TdLDpWxNjJSDBNp34luFZWGBoQ4=
X-Received: by 2002:aca:6043:: with SMTP id u64mr8224865oib.32.1551604966145;
 Sun, 03 Mar 2019 01:22:46 -0800 (PST)
MIME-Version: 1.0
From:   Krzysiek Rosinski <krzysiek@jrdltd.co.uk>
Date:   Sun, 3 Mar 2019 10:22:35 +0100
Message-ID: <CAAUgxQLVXy4X-h+dLK0WrU5_cvbx0+mxvyFRFuNkYkybP4f_1g@mail.gmail.com>
Subject: brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
To:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

I'm working on a custom board with cyw4343 connected to osd3358-sm (TI
am3358), when I load the brcmfmac driver I get 'HT Avail timeout'
error. The same combination of driver+firmware works fine on Raspberry
Pi Zero W.

I've tried to gather as much information I can from both; the custom
board and pi. This is available here:

https://www.dropbox.com/s/vqejyrixbxx1z8d/logs.tar.gz?dl=0

I have a custom board with cyw4343 chip fitted and also flyleded
Murata 1DX to the PocketBeagle, both give the same error code.

My setup is as follows:

osd335x-sm (TI am3348), cyw4343, 37.4 MHz xtal.
Linux beaglebone 4.14.93-bone17.1 #1 PREEMPT Mon Feb 25 16:27:58 UTC
2019 armv7l GNU/Linux
brcmfmac: cypress v4.14.52-backports
brcm43430-sdio.bin: Version: 7.45.98.38

Is there something obvious which I'm doing wrong? Can you give me a
hint on how to move with this further, please?

Kind regards,
Krzysztof
