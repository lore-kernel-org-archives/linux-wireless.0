Return-Path: <SRS0=wq86=OV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3341CC65BAF
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 19:25:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E13E120851
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 19:25:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=rsalveti-net.20150623.gappssmtp.com header.i=@rsalveti-net.20150623.gappssmtp.com header.b="pAYVhVGQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E13E120851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rsalveti.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbeLLTZO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Dec 2018 14:25:14 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44179 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbeLLTZN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Dec 2018 14:25:13 -0500
Received: by mail-lf1-f67.google.com with SMTP id z13so14407290lfe.11
        for <linux-wireless@vger.kernel.org>; Wed, 12 Dec 2018 11:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rsalveti-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iCghgwf2Mc2McBMd5W/5stIZX2tSndYRBKHglVd9EGE=;
        b=pAYVhVGQNkDpp2XTjtc+z2JY/mnUdMTGQVJBpghf/5nYIqdRNiYtXzWvGXst7HSljs
         SSX412iRwCDcUqUmCGJqCkgp9o1WwflSGcqRpQmSoAFs/gQ9fOzyUc/gCYMm6chwI9cM
         zGj4qiz1MXgFxCZ6Z29JcgYTbiGytlxxz42hv5qETChxxxL/le14EleFf681t4PzGLyK
         IJX+/xNE0Mfd4Cy6dj/l/eWUqzb0TsPVupss8lim/BAtHeSiFzQqFShwn0SycGRHqVHk
         nIVzCA48M1cL9veoj8izJO3U6wGMwXYnAEP6yIYCVUsBZVsvITle5CQTfMDGyA2V98rC
         3ZNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iCghgwf2Mc2McBMd5W/5stIZX2tSndYRBKHglVd9EGE=;
        b=TTZvZ/7tRBuagD94tXMqpPXJbalxX0Tme7uPQ6HW1HbcRYgYtUy1eueJfZQ4MUsHEB
         434nhWD1FbiwKqS+WdhikOns3qSYF208wvKanvDkh1sgGJeV8KJetbG9smycTtkaIiiP
         z4/luyhnu44YgVukOEAjXUdIXdsRfIhZGe9wDDGottQ+7681ArTg2MTbmqZ6+vXUphJR
         hhJYjCePel+vlC7l0/c7aJnULz0MwkSBDpybXIn7Pl9JB0xEB13Rz8zgBccIuXPKEFdQ
         NEOe4zdMVDqCvMmrsQ7ug2WMcKOzZIFT/U8crDNisnJ1UqykO2g0qNcSW+a1q2As/bWH
         MhHg==
X-Gm-Message-State: AA+aEWaG/EpVl4OPQjr/vuvpl+1O+b1lHXctyEzKxBajK2qiY/QEOeD3
        d09P4iTLx0cJdfPS4SkDwjV3Hn1cOhqIrKsg2KhFzg==
X-Google-Smtp-Source: AFSGD/Umr69zxiKU4SUJkUOwLX/YjCmOzYOqDwz1MmLq/4EVVA9Wx6VPTaE9bmb7CKnXoxzGyOa8ShA8ZA3qyWNnaGc=
X-Received: by 2002:a19:7dc2:: with SMTP id y185mr11839591lfc.27.1544642711605;
 Wed, 12 Dec 2018 11:25:11 -0800 (PST)
MIME-Version: 1.0
References: <20181211181944.GW39861@atomide.com> <CAHYQr0pk-WKM-aYR7ubM4GHx8PA82XP5ze9TW9WEJLzdO0f88A@mail.gmail.com>
 <20181211190128.GX39861@atomide.com> <CAHYQr0qc_Lav=1sEGcOmOykUftWRzd6+vis97eBpanEXzfUHaA@mail.gmail.com>
 <CALAqxLUVajBw_PkyhA0s=FhQQHWu1FBEMX+4oDTStRXr6L5Txw@mail.gmail.com>
 <20181211201221.GY39861@atomide.com> <CAHYQr0qffa_G2ZVnSsDfjqSgxuBBZB+8e6ZODpAWV_TMhqzFYg@mail.gmail.com>
 <CAHYQr0qhqce2QcwMLRMWnqhZTL4KzHKJLzt6tfCNLHUcEt9pyQ@mail.gmail.com>
 <20181212014556.GC39861@atomide.com> <c8625c42f04a4721b7efb7d7b6b3931c@ti.com>
 <20181212183116.GH39861@atomide.com>
In-Reply-To: <20181212183116.GH39861@atomide.com>
From:   Ricardo Salveti <rsalveti@rsalveti.net>
Date:   Wed, 12 Dec 2018 17:24:34 -0200
Message-ID: <CAHYQr0ojkf3CvFb_zuEK4Vuz1w-rm9Sb=+dk5BkqYkWoxy8+aQ@mail.gmail.com>
Subject: Re: [EXTERNAL] Re: wlcore getting stuck on hikey after the runtime PM
 autosuspend support change
To:     Tony Lindgren <tony@atomide.com>
Cc:     eyalr@ti.com, John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, anders.roxell@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Dec 12, 2018 at 4:31 PM Tony Lindgren <tony@atomide.com> wrote:
> * Reizer, Eyal <eyalr@ti.com> [181212 07:27]:
> > I Just tried on an available am335x-evm using 4.20.0-rc1 which I believe has all the patches merged already.
> > I am using the same script  and not seeing any failure yet.
> > See below:
> >
> > root@am335x-evm:/usr/share/wl18xx# uname -r
> > 4.20.0-rc1-11287-gf487c00
> > root@am335x-evm:/usr/share/wl18xx#
> > root@am335x-evm:/usr/share/wl18xx#
> > root@am335x-evm:/usr/share/wl18xx#
> > root@am335x-evm:/usr/share/wl18xx#
> > root@am335x-evm:/usr/share/wl18xx# while true; do ifconfig wlan0 down; ifconfig wlan0 up; done;
> > [1378786.491101] wlcore: down
> > [1378787.093006] wlcore: PHY firmware version: Rev 8.2.0.0.242
> > [1378787.168523] wlcore: firmware booted (Rev 8.9.0.1.79)
> > [1378787.215897] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> ...
>
> Yeah I was seeing the same yesterday when I tried it.
>
> Could it be that there needs to be a little msleep() after
> loading the firmware on some platforms and before enabling
> PM runtime?

The issue I'm having seems to happen when trying to load the firmware,
getting stuck in mmc_wait_for_req_done -> wait_for_completion, so the
firmware is never really fully loaded when the hang happens.

Cheers,
--
Ricardo Salveti de Araujo
