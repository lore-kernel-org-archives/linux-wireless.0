Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8FC0C43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 02:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF2F5206BB
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 02:46:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E1keLfNq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729467AbfAICqG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 21:46:06 -0500
Received: from mail-ua1-f65.google.com ([209.85.222.65]:37070 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728835AbfAICqG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 21:46:06 -0500
Received: by mail-ua1-f65.google.com with SMTP id u19so1954098uae.4
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jan 2019 18:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xy5tEKEZ3q3F7p+qYGG9RFs3LWVdZr0zuNxD/LsVKbQ=;
        b=E1keLfNqCAf6UKANgJckZiKcm73TqxOJoDv+Ogino8JFRrIMv4GASl7uxLH5YUKqOj
         wt2qlo1kMinLCkApPENj9Z1FvLXSH0NfpI3N5Q5iXlozgRYWoLbDvcUfF6n+ce1+UTBc
         dMjQKk9o179vEUwTVtQucrcy2UMg50AObq66gfvsRiNB7F3B9nUNagk3Gc63FIhE2OkY
         Twtokaz8nS6azzgPNIx4Daj+hxYQBQ0Zx5WxkzQwxPFlF2E5OYkyMFaewJiBukYDlcB/
         bHd3P+ZLBKHMXkzZDUn+lRe/NiZiv131imXoFI85T0+SZa6yjBlnp78rSsTrYMeZ6BnD
         wcCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xy5tEKEZ3q3F7p+qYGG9RFs3LWVdZr0zuNxD/LsVKbQ=;
        b=RImJcIw8kqbEwvi2DkpZbi4sLO3YShlLSYzEKpXXLl09wxlWeeFuF/SciVsQmTnsJa
         FqNphr+hBofsgLUisLFXao8RTs3b15y7aQSBvDvUL+yiwH2XyNgeT30/ZQM9CgsDsKGH
         vYy+Ry7icvCSItjer1jHI/IHtq0OJHDysSHfvWBPcyQ18ozKFhGKOJk2IKD7GKCyC/ea
         0uNtExBsx+/kNBLoCX8cCa62+0Hx0ZXoif8w0+SIOdVIJXVyDu7zkhjJxNMq4YaikTV5
         15V+QagujSwee5oe9x+3VceDXc10j7DWdkNLCxHD+BO3ZVJNFUE/+NSPn2rxSw57mSa6
         i95g==
X-Gm-Message-State: AJcUukcfvxnm6WEl3Re+le2QmWtzmmFni/PJsRvZCq+aSHsIsqszKsBK
        dnSNh5T2/Jj8t/ET/gTuO0AjvAezJBjySuuVf84=
X-Google-Smtp-Source: ALg8bN4QJDEO5oHF3cNrz38YVyATln3ULktQ1+zgK6KFgeaIBwF7E4Y6bT25H10FudV1eoQjMmPPriz0Uc54RYKVgyQ=
X-Received: by 2002:ab0:4a16:: with SMTP id q22mr1485665uae.1.1547001965153;
 Tue, 08 Jan 2019 18:46:05 -0800 (PST)
MIME-Version: 1.0
References: <1545902778-20205-1-git-send-email-siva8118@gmail.com> <87muobqeco.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87muobqeco.fsf@kamboji.qca.qualcomm.com>
From:   Siva Rebbagondla <siva8118@gmail.com>
Date:   Wed, 9 Jan 2019 08:15:47 +0530
Message-ID: <CANGSkXTuHK8uzOOjOTHo_Gkvk8f2ndD=1hEQw4ZUGD0kVSs81g@mail.gmail.com>
Subject: Re: [v4] rsi: add support for hardware scan offload
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Linux Wireless <linux-wireless@vger.kernel.org>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        rishikesh.basu@redpinesignals.com,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Jan 8, 2019 at 10:24 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Siva Rebbagondla <siva8118@gmail.com> writes:
>
> > From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> >
> > With the current approach of scanning, roaming delays are observed.
> > Firmware has support for back ground scanning. To get this advantage,
> > mac80211 hardware scan is implemented, which decides type of scan to
> > do based on connected state.
> >
> > When station is in not connected, driver returns with special value 1
> > to trigger software scan in mac80211. In case of connected state,
> > background scan will be triggered.
> >
> > Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> > Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> > ---
> > changes in v4: renamed return value in hw_scan from "-EPERM" -> "1" [Jberg]
> > changes in v3: replaced rsi_prepare_probe_request() with ieee80211_probereq_get() [Kvalo]
> > changes in v2: none
>
> This depends on:
>
> e9da68ddea60 mac80211: allow hardware scan to fall back to software
>
> But that's in w-d-next now so this is safe to be apply.
>
> --
> Kalle Valo

Yes Kvalo, you can apply this patch to w-d-next.

Brgds,
Siva Rebbagondla
