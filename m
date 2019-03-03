Return-Path: <SRS0=pcPV=RG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E620C43381
	for <linux-wireless@archiver.kernel.org>; Sun,  3 Mar 2019 21:03:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5764E20830
	for <linux-wireless@archiver.kernel.org>; Sun,  3 Mar 2019 21:03:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UwWt30mF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfCCVDr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 3 Mar 2019 16:03:47 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:38008 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfCCVDr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Mar 2019 16:03:47 -0500
Received: by mail-yw1-f68.google.com with SMTP id o184so2568574ywo.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Mar 2019 13:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a5wCBYpLTWLQFqqdTQxXxV6nBDHOhQQz+E8Cl6uFHtA=;
        b=UwWt30mF5ZtTSdrIiEBO0k9c1gbsUeF8OBw0Dd1JiDHCd1q21RkWcF27U3o9yJaz6V
         aeLieTQN0vLXtWU5xp674nPTDGBj8+IrmrHNHH7/NVdSDQm8D9ECIuat2COkNlZR7Tc8
         WL/C9+Ox4bcp7iOiwty0CLpXP9GgPc8aPkHZ6fkXT+D+e5SumWa/IXcI91W0tD/FIIjN
         5pGzP7KVq3wlwF0KImjRK446k4LIThTpROe/DImyNYgoqxmwf5omIkwODItfvrLjzivb
         +KZAubJ9EgyeuyetrPY3U+tmjtkrPQF/4x5WR+rnw9OmzCtqIVRxqwU4JxwXUpc3Z8ii
         6BXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a5wCBYpLTWLQFqqdTQxXxV6nBDHOhQQz+E8Cl6uFHtA=;
        b=eSQm/8kUF862eoCYbaKT5wvhJ7G4sAISJ6/qQyeQThIs0lTC011i17dr/rL862aZco
         /4Kbuw1GwukoILI3ODH91tAC7AVY5CGFdiB/HsWrzxBmawQpWYsnPGrk9xhLE9Wfid6e
         +izn0jNAGA9S/4QT5AALT7HCe9sQbD2hVo2CxaUPTS4mM4pZaOZ3ixme69L1qbDBk4n4
         +69abuXYa6mrwWP5OchjslelHzZvw8vn86aY6bCkbpiHLum2OzNUhpBA/Hy7AFhBZVUp
         +KaRVBJOpnzZ1CEKHgY06L6QdtdXXsgjhCTdinLi9KmNxrUlFqru8MbooP3AOgQ0rkON
         qncA==
X-Gm-Message-State: APjAAAUnKQffk65G2ZPatd/oCN6EBuOFCS/3O0zFvyjzru86CwRGzTgO
        mqb5Ju8fVVmLXWXt+7s1A4QiWxvhDH6I4Ez0gYdFgKptuj8=
X-Google-Smtp-Source: APXvYqxDbFGJc50J/fpuArUEoyPBWQfQkFaS87Lh6XS4Ay+HnaqN6VPeQrWhbovj1e27WSwy45wm24nuPV+sfnLsZKY=
X-Received: by 2002:a81:788c:: with SMTP id t134mr11997660ywc.167.1551647026153;
 Sun, 03 Mar 2019 13:03:46 -0800 (PST)
MIME-Version: 1.0
References: <CAAUgxQLVXy4X-h+dLK0WrU5_cvbx0+mxvyFRFuNkYkybP4f_1g@mail.gmail.com>
 <CAAUgxQ+PU4Z5Nhj8K5r3ijKm87-GvTg9QffSjOenHWDRDauZSg@mail.gmail.com>
In-Reply-To: <CAAUgxQ+PU4Z5Nhj8K5r3ijKm87-GvTg9QffSjOenHWDRDauZSg@mail.gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Sun, 3 Mar 2019 22:03:34 +0100
Message-ID: <CACna6rx6GFWMDmcTN5CvOta3QDe8UT8gKFNCEf_gjuXBRoWyHg@mail.gmail.com>
Subject: Re: brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
To:     Krzysiek Rosinski <krzysiek@jrdltd.co.uk>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 3 Mar 2019 at 20:06, Krzysiek Rosinski <krzysiek@jrdltd.co.uk> wrote:
> On Sun, Mar 3, 2019 at 10:22 AM Krzysiek Rosinski <krzysiek@jrdltd.co.uk> wrote:
> > I'm working on a custom board with cyw4343 connected to osd3358-sm (TI
> > am3358), when I load the brcmfmac driver I get 'HT Avail timeout'
> > error. The same combination of driver+firmware works fine on Raspberry
> > Pi Zero W.
> >
> > I've tried to gather as much information I can from both; the custom
> > board and pi. This is available here:
> >
> > https://www.dropbox.com/s/vqejyrixbxx1z8d/logs.tar.gz?dl=0
> >
> > I have a custom board with cyw4343 chip fitted and also flyleded
> > Murata 1DX to the PocketBeagle, both give the same error code.
> >
> > My setup is as follows:
> >
> > osd335x-sm (TI am3348), cyw4343, 37.4 MHz xtal.
> > Linux beaglebone 4.14.93-bone17.1 #1 PREEMPT Mon Feb 25 16:27:58 UTC
> > 2019 armv7l GNU/Linux
> > brcmfmac: cypress v4.14.52-backports
> > brcm43430-sdio.bin: Version: 7.45.98.38
> >
> > Is there something obvious which I'm doing wrong? Can you give me a
> > hint on how to move with this further, please?

You have to find new enough bcmdevs.h.

Try Googling BFL3_FEMCTRL_SUB and you should find many BFL3_* defines easily.
