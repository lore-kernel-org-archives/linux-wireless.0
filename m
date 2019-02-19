Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C96DC4360F
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 01:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DB15217D9
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 01:14:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="mHzPx+VI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732589AbfBSBON (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 20:14:13 -0500
Received: from conssluserg-06.nifty.com ([210.131.2.91]:51023 "EHLO
        conssluserg-06.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfBSBON (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 20:14:13 -0500
X-Greylist: delayed 69089 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Feb 2019 20:14:11 EST
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id x1J1E4kD028381;
        Tue, 19 Feb 2019 10:14:04 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com x1J1E4kD028381
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1550538844;
        bh=12GOMpHSdKq1T0/8pXwHzQ0yf/8DKFAjpoLne8aSI0A=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mHzPx+VIf2tFY4/s0Sm+qhugjJTEsxEeUZh/Axra1Z4NUzg+Ao52uwCft1zCuKVtI
         F7Cgo54OA5R2jD2f1ueIAICY+bVX0mvjKozOLsDyO7GG1jb61brtgck+MIvEWeqttE
         IZNrvIPmM91rTMeE5XXo0vLWFVKoKp4Fm139wKOpe8ByUV93xTPSGbM+mUajA85+oI
         KQixEWdcYHzU/NzdpHhNJC8YHCt7510jDtHW4uAYm3H6ZHHea9qSPBk1+GSJ8KTGyp
         BHsPB+erA3qQnKfRUPCHzFVwjvLeiK93gcqzfZb3DyhRr+jnHMMXgH318dy8Ri6dCf
         9DPgnh496TQjw==
X-Nifty-SrcIP: [209.85.217.44]
Received: by mail-vs1-f44.google.com with SMTP id u64so10731051vsc.12;
        Mon, 18 Feb 2019 17:14:04 -0800 (PST)
X-Gm-Message-State: AHQUAuYv+nrovpfgbEFLvgzXVF+3SN0gptu07LOmiDRsr/MeQGfx0Kti
        w4uwltL2nHXIdjEkPDXa2tYAMSQ7AYqYabK0g3w=
X-Google-Smtp-Source: AHgI3IYS1xQosfLMLt7IfKYeSFA7qXgC47MIextseXf408cL7JsP6OXTuuKu9KtdSNby9Mke9GzxSDWPItmjzXLIlUs=
X-Received: by 2002:a67:c913:: with SMTP id w19mr13504171vsk.179.1550538843511;
 Mon, 18 Feb 2019 17:14:03 -0800 (PST)
MIME-Version: 1.0
References: <1550469571-25933-1-git-send-email-yamada.masahiro@socionext.com>
 <1550469571-25933-2-git-send-email-yamada.masahiro@socionext.com>
 <877edxt1f1.fsf@kamboji.qca.qualcomm.com> <87tvh0syq2.fsf@kamboji.qca.qualcomm.com>
 <87pnrosy29.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87pnrosy29.fsf@kamboji.qca.qualcomm.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Tue, 19 Feb 2019 10:13:27 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQMgFXw=rtpdPNZ=xpLw-SiwKGAgM__Owvqd1EhTCUntQ@mail.gmail.com>
Message-ID: <CAK7LNAQMgFXw=rtpdPNZ=xpLw-SiwKGAgM__Owvqd1EhTCUntQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] wireless: mt76: call hweight8() instead of __sw_hweight8()
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        linux-wireless@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Felix Fietkau <nbd@nbd.name>,
        Matthias Brugger <matthias.bgg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Feb 19, 2019 at 4:38 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Kalle Valo <kvalo@codeaurora.org> writes:
>
> > Kalle Valo <kvalo@codeaurora.org> writes:
> >
> >> Masahiro Yamada <yamada.masahiro@socionext.com> writes:
> >>
> >>> __sw_hweight8() is just internal implementation.
> >>>
> >>> Drivers should use the common API, hweight8().
> >>>
> >>> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> >>
> >> Acked-by: Kalle Valo <kvalo@codeaurora.org>
> >>
> >>> This patch should go to x86 tree along with 2/2.
> >>>
> >>> Otherwise, all{yes,mod}config of x86 would be broken.
> >>>
> >>> This patch is trivial enough.
> >>> I want ACK from the net/wireless maintainer
> >>> so that this can go in via x86 tree.
> >>
> >> Sounds good to me, feel free to push via the x86 tree.
> >
> > Actually, can you wait a bit? Felix just reminded me that we have a
> > similar patch pending from Ben Hutchings:
> >
> > https://patchwork.kernel.org/patch/10808203/
> >
> > And it seems there are two instances of __sw_hweight8, at least in my
> > wireless-drivers-next tree:
> >
> > drivers/net/wireless/mediatek/mt76/mac80211.c: int i, nstream =
> > __sw_hweight8(dev->antenna_mask);
> > drivers/net/wireless/mediatek/mt76/mac80211.c: int n_chains =
> > __sw_hweight8(dev->antenna_mask);
> >
> > So we need to think what to do.
>
> I think the best would be that Felix applies Ben's patch to the wireless
> tree and I'll push it to Linus during the next merge window (via
> net-next). Simpler and less conflicts that way.
>
> So Masahiro, could you hold your x86 patch for a while until the mt76
> patch will be in Linus' tree? That should not take more than two weeks,
> I think.

Sure.
I will resend 2/2 later.




-- 
Best Regards
Masahiro Yamada
