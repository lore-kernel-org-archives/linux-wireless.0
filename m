Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:39244 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbeE3KZR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 06:25:17 -0400
Received: by mail-wm0-f67.google.com with SMTP id f8-v6so46789619wmc.4
        for <linux-wireless@vger.kernel.org>; Wed, 30 May 2018 03:25:16 -0700 (PDT)
MIME-Version: 1.0
References: <20180522131836.26858-1-zajec5@gmail.com> <20180522131836.26858-2-zajec5@gmail.com>
 <5B070A5D.3080400@broadcom.com> <CAGRGNgXMUTBhjGA_Rk=_ASaOcYNM+udAN8=HhutxFP5kwQYLww@mail.gmail.com>
 <5B0E7783.7070309@broadcom.com>
In-Reply-To: <5B0E7783.7070309@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 30 May 2018 20:25:01 +1000
Message-ID: <CAGRGNgXCgp=b97KDGdfGiQEujQk2duJz=SqiwHYYt_v3Kut2RQ@mail.gmail.com> (sfid-20180530_122522_420828_9550A5C7)
Subject: Re: [PATCH 2/3] brcmfmac: handle monitor mode marked msgbuf packets
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        stanley.hsu@cypress.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, rafal@milecki.pl
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Wed, May 30, 2018 at 8:05 PM Arend van Spriel <
arend.vanspriel@broadcom.com> wrote:

> On 5/27/2018 7:34 AM, Julian Calaby wrote:
> > Hi Arend,
> > On Fri, May 25, 2018 at 12:38 PM Arend van Spriel <
> > arend.vanspriel@broadcom.com> wrote:
> >
> >> On 5/22/2018 3:18 PM, Rafa=C5=82 Mi=C5=82ecki wrote:
> >>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> >>>
> >>> New Broadcom firmwares mark monitor mode packets using a newly define=
d
> >>> bit in the flags field. Use it to filter them out and pass to the
> >>> monitor interface. These defines were found in bcmmsgbuf.h from SDK.
> >>>
> >>> As not every firmware generates radiotap header this commit introduce=
s
> >>> BRCMF_FEAT_MON_FMT_RADIOTAP that has to be set per firmware version.
If
> >>> not present brcmf_netif_mon_rx() assumed packet being a raw 802.11
frame
> >>> and prepends it with an empty radiotap header.
> >>>
> >>> It's limited to the msgbuf protocol. Adding support for SDIO/USB
devices
> >>> will require some extra research.
> >
> >> So I went looking on my shelf and found the patch I made for SDIO a
> >> while back. It relies on firmware change and I did not introduce a
> >> firmware flag for it. I will send the patch as RFT so you can have a
> >> look at it.
> >
> >> I checked our internal driver and it turns out the raw vs. radiotap is
a
> >> compilation option. So depending on customer they would get either
> >> firmware doing the radiotap header generation or the host driver,
> >> without any run-time way to determine it. Not nice for brcmfmac.
> >
> > I pretty sure I know what the answer to this is going to be, however I
> > still have to ask:
> >
> > Is it possible to open up _any_ part of the firmware? (Even if it's jus=
t
> > the host-interface end and the hardware end is a big ugly blob) It'd
make
> > dealing with stuff like this so much easier if we can just toggle a fla=
g
> > and recompile. (I'm also sure that we'd be more than happy to pass some
> > flag through telling us/you that it's unofficial firmware and has
probably
> > broken the hardware, etc.)

> Hah. Yeah, with next to nil uncertainty I know the answer to this as
> well. If you know how long it took before we committed to supporting the
> upstream drivers. Despite my better judgement I will pass your idea, but
> it is not something that is going to fall in the timeframe that Rafa=C5=
=82
> had in mind.

Fair enough, I can't ask for more than that.

Good Luck!

--=20
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
