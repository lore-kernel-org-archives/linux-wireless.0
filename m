Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:50218 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752250AbeF0WJx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 18:09:53 -0400
Received: by mail-it0-f67.google.com with SMTP id u4-v6so9820935itg.0
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2018 15:09:52 -0700 (PDT)
MIME-Version: 1.0
References: <20180616155621.30539-3-lorenzo.bianconi@redhat.com> <878t709r56.fsf@purkki.adurom.net>
In-Reply-To: <878t709r56.fsf@purkki.adurom.net>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Thu, 28 Jun 2018 00:09:42 +0200
Message-ID: <CAJ0CqmXbePZyu9mopnOvCjnb2X8stNGHZo-T_9YqC1oqH6daTg@mail.gmail.com> (sfid-20180628_000956_758350_A59D0FB1)
Subject: Re: [PATCH 2/4] mt76x2: dfs: add sw event ring buffer
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>
> > Introduce sw event ring buffer to queue DFS pulses loaded from the hw.
> > Radar pulses will be used in DFS sw detector
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
>
> [...]
>
> > +static bool mt76x2_dfs_fetch_event(struct mt76x2_dev *dev,
> > +                                struct mt76x2_dfs_event *event)
> > +{
> > +     u32 i, data[4];
> > +
> > +     for (i = 0; i < ARRAY_SIZE(data); i++) {
> > +             /* 1st: DFS_R37[31]: 0 (engine 0) - 1 (engine 2)
> > +              * 2nd: DFS_R37[21:0]: pulse time
> > +              * 3rd: DFS_R37[11:0]: pulse width
> > +              * 3rd: DFS_R37[25:16]: phase
> > +              * 4th: DFS_R37[12:0]: current pwr
> > +              * 4th: DFS_R37[21:16]: pwr stable counter
> > +              *
> > +              * 1st: DFS_R37[31:0] set to 0xffffffff means no event detected
> > +              */
> > +             data[i] = mt76_rr(dev, MT_BBP(DFS, 37));
> > +     }
> > +
> > +     if (data[0] == GENMASK(31, 0))
> > +             return false;
> > +
> > +     event->engine = (data[0] & BIT(31)) ? 2 : 0;
> > +     event->ts = data[1] & GENMASK(21, 0);
> > +     event->width = data[2] & GENMASK(11, 0);
>
> No magic values and that data[2] stuff, please. Instead create a proper
> struct and defines for the GENMASKs.

Hi Kalle,

thx for the review, I will fix your comments in v2
Regards,

Lorenzo

>
> --
> Kalle Valo
