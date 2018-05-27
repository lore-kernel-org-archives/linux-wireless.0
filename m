Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33385 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932115AbeE0Feb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 May 2018 01:34:31 -0400
Received: by mail-wr0-f195.google.com with SMTP id a15-v6so15257858wrm.0
        for <linux-wireless@vger.kernel.org>; Sat, 26 May 2018 22:34:30 -0700 (PDT)
MIME-Version: 1.0
References: <20180522131836.26858-1-zajec5@gmail.com> <20180522131836.26858-2-zajec5@gmail.com>
 <5B070A5D.3080400@broadcom.com>
In-Reply-To: <5B070A5D.3080400@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sun, 27 May 2018 15:34:16 +1000
Message-ID: <CAGRGNgXMUTBhjGA_Rk=_ASaOcYNM+udAN8=HhutxFP5kwQYLww@mail.gmail.com> (sfid-20180527_073450_768576_226A56D5)
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
On Fri, May 25, 2018 at 12:38 PM Arend van Spriel <
arend.vanspriel@broadcom.com> wrote:

> On 5/22/2018 3:18 PM, Rafa=C5=82 Mi=C5=82ecki wrote:
> > From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> >
> > New Broadcom firmwares mark monitor mode packets using a newly defined
> > bit in the flags field. Use it to filter them out and pass to the
> > monitor interface. These defines were found in bcmmsgbuf.h from SDK.
> >
> > As not every firmware generates radiotap header this commit introduces
> > BRCMF_FEAT_MON_FMT_RADIOTAP that has to be set per firmware version. If
> > not present brcmf_netif_mon_rx() assumed packet being a raw 802.11 fram=
e
> > and prepends it with an empty radiotap header.
> >
> > It's limited to the msgbuf protocol. Adding support for SDIO/USB device=
s
> > will require some extra research.

> So I went looking on my shelf and found the patch I made for SDIO a
> while back. It relies on firmware change and I did not introduce a
> firmware flag for it. I will send the patch as RFT so you can have a
> look at it.

> I checked our internal driver and it turns out the raw vs. radiotap is a
> compilation option. So depending on customer they would get either
> firmware doing the radiotap header generation or the host driver,
> without any run-time way to determine it. Not nice for brcmfmac.

I pretty sure I know what the answer to this is going to be, however I
still have to ask:

Is it possible to open up _any_ part of the firmware? (Even if it's just
the host-interface end and the hardware end is a big ugly blob) It'd make
dealing with stuff like this so much easier if we can just toggle a flag
and recompile. (I'm also sure that we'd be more than happy to pass some
flag through telling us/you that it's unofficial firmware and has probably
broken the hardware, etc.)

Thanks,

--=20
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
