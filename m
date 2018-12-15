Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD97C43387
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 03:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06AB12171F
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 03:38:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=rsalveti-net.20150623.gappssmtp.com header.i=@rsalveti-net.20150623.gappssmtp.com header.b="QM8L7DFm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbeLODh7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 22:37:59 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44316 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727668AbeLODh6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 22:37:58 -0500
Received: by mail-lj1-f195.google.com with SMTP id k19-v6so6539762lji.11
        for <linux-wireless@vger.kernel.org>; Fri, 14 Dec 2018 19:37:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rsalveti-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZDvSrR2dDj2nhh8FS0PWB2zu4M0rknV4rYQWLbftLD4=;
        b=QM8L7DFmDXcQ/MD/w6d6JtD+suApl0vGhsKBHIyAUaTAGGnCvpuE3XQpGhawUyKHHv
         6jqEsYn2mjLPQrVWnT6mWZDtyxmZromZ3TLzhrV4lApj+xmjn57EZTotR3ZQSPoz2Q9E
         24IczO0aF0hrNQ7UEmWjB8b8q7lLRmuywwvcspw5BxUX8r6fBRP+crnmJ7bJzuwAifYN
         pqhJ6T13fRusUqTAUiagTJpAiyRsBzpvZsWwnbWvrOraRNTbudP6BFAsZkZAjs/braTV
         mfRux7LGRTBxK9noFLFdQCGPwuw/5AAuZkNEalQHVf69XqAzJia7ZH4fdV4FdfTzrIh4
         qqUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZDvSrR2dDj2nhh8FS0PWB2zu4M0rknV4rYQWLbftLD4=;
        b=FVTmIKLBTnKA9ULT4ZSZKK92wjZVN5f0nNaZ2eA4JQguEWssVRSIv7xHpjEQ0i7GGi
         LS1QVeECkbrqGGT/xd+Z04OHqrdKNRBQTd26EhIqdYqYwgqjnkNdwsErNK45ckRBJFzm
         dRxGoQjN856Q0Ex9meu28A7WOvEHlgll4wUtHkLwRthflK2q934WiyWyjYHOMaDFwwdJ
         wa6p4rw3O1kFRyS1/Cx+rpFxedIy9+yDxKaH5gMTMmHDeDG1ZPJE1e8YvAnOwN6yUzHc
         tQt684wjZeG5yPDH1htpqKjjccxpDMVbBTdehgZhjLBXfwEN4Jcnoo9N07r4zMn79AcN
         eVAQ==
X-Gm-Message-State: AA+aEWbQSdHW5SoVAbgSKqTraBOZu1jA19NnlNOTJYkG6hTQ5YxVm2lr
        gfsgMI/kI6JKmY8g1FrJrIFYy5q1xLmk51B17u1nMQ==
X-Google-Smtp-Source: AFSGD/XCUWV1PeC+kjrcbRdPwvKSpCSvCcnLKOqc0j2Li/TYFg3osB+Da+IgxCs8gWkZ8W8TGYrGFiMkYHUYJ7Ydwlo=
X-Received: by 2002:a2e:94ce:: with SMTP id r14-v6mr2853957ljh.34.1544845076478;
 Fri, 14 Dec 2018 19:37:56 -0800 (PST)
MIME-Version: 1.0
References: <CAHYQr0qffa_G2ZVnSsDfjqSgxuBBZB+8e6ZODpAWV_TMhqzFYg@mail.gmail.com>
 <CAHYQr0qhqce2QcwMLRMWnqhZTL4KzHKJLzt6tfCNLHUcEt9pyQ@mail.gmail.com>
 <20181212014556.GC39861@atomide.com> <c8625c42f04a4721b7efb7d7b6b3931c@ti.com>
 <20181212183116.GH39861@atomide.com> <CAHYQr0ojkf3CvFb_zuEK4Vuz1w-rm9Sb=+dk5BkqYkWoxy8+aQ@mail.gmail.com>
 <9060b4655e064665a1812d9fae00f1ec@ti.com> <CAHYQr0r4eQNSqZEr-vbCiVN6G_O1CXxX9cxemANSRY-jqDMZ=A@mail.gmail.com>
 <20181213144522.GO39861@atomide.com> <CAHYQr0qg31hqyzm9uK03qz=DmUkA9idqTrhLaP9A6nuXPEW73w@mail.gmail.com>
 <20181214232857.GZ39861@atomide.com>
In-Reply-To: <20181214232857.GZ39861@atomide.com>
From:   Ricardo Salveti <rsalveti@rsalveti.net>
Date:   Sat, 15 Dec 2018 01:37:19 -0200
Message-ID: <CAHYQr0r90pLVzMus6n7Pdj5MELeQPK7nt9LnFWNHsoBM=eKhkg@mail.gmail.com>
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

On Fri, Dec 14, 2018 at 9:29 PM Tony Lindgren <tony@atomide.com> wrote:
> * Ricardo Salveti <rsalveti@rsalveti.net> [181214 12:42]:
> > Basically since commit 60f36637bbbd ("wlcore: sdio: allow pm to handle
> > sdio power") PM is now handling the sdio power off/on process, and if
> > wl12xx_sdio_power_on gets called right after wl12xx_sdio_power_off (if
> > down/up), the device will not go to the required power off/on sequence
> > (since PM will abort the suspend process), and the firmware loading
> > process will fail. I would guess the problem only happens with
> > autosuspend because of the extra delay it causes (pm_runtime_put
> > always returns -EBUSY on wl12xx_sdio_power_off with autosuspend).
>
> OK thanks for the update, that's interesting.
>
> > Is there a way to force the suspend on wl12xx_sdio_power_off, or
> > should we partially restore the old behavior?
>
> Well usually we could do pm_runtime_put_sync_suspend() but
> here it won't help as the pm_runtime_put() is already in
> progress by the SDIO subsystem and that's why we get -EBUSY.
>
> Does adding a little wait at the end of wl12xx_sdio_power_off()
> before return? Maybe something like:
>
>         /* Make sure the card gets powered off */
>         while (error == -EBUSY && !pm_runtime_suspended(&card->dev) &&
>                 retries--) {
>                 msleep(100);
>         }

Yes, this is enough to force the power off process and fixes the hang
I was having.

Also tried playing a bit with the msleep value and can confirm it
usually needs to wait between 30-40 milliseconds before powering the
card off.

Do you mind sending a patch with the above changes then? I can help
testing with the boards I have.

Thanks,
-- 
Ricardo Salveti de Araujo
