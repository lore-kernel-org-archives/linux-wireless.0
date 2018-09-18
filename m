Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:52866 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730103AbeIRT7H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 15:59:07 -0400
Received: by mail-it0-f65.google.com with SMTP id h3-v6so3460185ita.2
        for <linux-wireless@vger.kernel.org>; Tue, 18 Sep 2018 07:26:17 -0700 (PDT)
MIME-Version: 1.0
References: <20180907211312.17918-1-lorenzo.bianconi@redhat.com>
 <20180918114356.GB15285@redhat.com> <20180918120234.GD15285@redhat.com> <871s9r2d3g.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <871s9r2d3g.fsf@kamboji.qca.qualcomm.com>
From: Sid Hayn <sidhayn@gmail.com>
Date: Tue, 18 Sep 2018 10:26:09 -0400
Message-ID: <CAM0KTbAPHPK04SntA9UL0rGaaNjTy=E2hRoO7xiRkbMcq9b7Sw@mail.gmail.com> (sfid-20180918_162652_056910_94DAB095)
Subject: Re: [PATCH] mt76x0: run vco calibration for each channel configuration
To: Kalle Valo <kvalo@codeaurora.org>
Cc: sgruszka@redhat.com,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mt76x0 isn't in 4.18 at all, it's being added in 4.19 isn't it?  I'm
not sure you can call it a regression, but adding a new driver with a
known bug that breaks an entire use case (monitor mode) seems silly
when a small and tested fix is available.  Pretty please.

Thanks,
Zero
On Tue, Sep 18, 2018 at 8:43 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Stanislaw Gruszka <sgruszka@redhat.com> writes:
>
> > On Tue, Sep 18, 2018 at 01:43:56PM +0200, Stanislaw Gruszka wrote:
> >> On Fri, Sep 07, 2018 at 11:13:12PM +0200, Lorenzo Bianconi wrote:
> >> > According to vendor sdk, vco calibration has to be executed
> >> > for each channel configuration whereas mcu calibration has to be
> >> > performed during channel scanning. This patch fixes the mt76x0
> >> > monitor mode issue since in that configuration vco calibration
> >> > was never executed
> >> >
> >> > Fixes: 10de7a8b4ab9 ("mt76x0: phy files")
> >> > Tested-by: Sid Hayn <sidhayn@gmail.com>
> >> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> >>
> >> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
> >
> > For the record this is 4.19 material.
>
> I really want to minimise conflicts and because of so many mt76 patches
> conflicts are likely to happen, so I'm keeping the bar high for mt76
> patches going 4.19. Is this a regression from 4.18? If not, I think this
> should go to -next and cc stable. And besides, monitor mode isn't that
> critical anyway.
>
> --
> Kalle Valo
