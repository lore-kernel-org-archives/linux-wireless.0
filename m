Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:36906 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937279AbeFSHAf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 03:00:35 -0400
Received: by mail-wr0-f179.google.com with SMTP id d8-v6so19301961wro.4
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2018 00:00:34 -0700 (PDT)
MIME-Version: 1.0
References: <986bbf4c-8fa1-4367-db9e-76a209594b81@gmail.com>
 <66e43eb5-2bc9-2ec3-af48-03248eecb727@gmail.com> <5B1E537F.2080502@broadcom.com>
 <CACna6rw9BnZvUM47-GEUpWp34eaDYeUz3yAyDpo6z+Z0TpKD8A@mail.gmail.com>
 <5B2809D7.9050503@broadcom.com> <CACna6rym2f3i6MvRPJNAgyoWVeUcsaxRGUqsL0wCNrmErKDQZQ@mail.gmail.com>
 <CACna6rwF+DEA10eUBL18U-Yt67LgdgVRRzOXe2Ms1d+OH=CdbA@mail.gmail.com>
In-Reply-To: <CACna6rwF+DEA10eUBL18U-Yt67LgdgVRRzOXe2Ms1d+OH=CdbA@mail.gmail.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 19 Jun 2018 08:58:31 +0200
Message-ID: <CACna6rzNmm1rqY7QAarKY3FQxobdqO7CHNU9Cmhn0FNxqOZwVA@mail.gmail.com> (sfid-20180619_090039_193674_4A689350)
Subject: Re: Research + questions on brcmfmac and support for monitor mode
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        <brcm80211-dev-list.pdl@broadcom.com>,"
        <brcm80211-dev-list@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 19 Jun 2018 at 07:36, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wr=
ote:
> On Mon, 18 Jun 2018 at 23:46, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> =
wrote:
> > On Mon, 18 Jun 2018 at 21:36, Arend van Spriel
> > <arend.vanspriel@broadcom.com> wrote:
> > >
> > > On 6/18/2018 1:54 PM, Rafa=C5=82 Mi=C5=82ecki wrote:
> > > > On Mon, 11 Jun 2018 at 12:48, Arend van Spriel
> > > > <arend.vanspriel@broadcom.com> wrote:
> > > >> On 5/30/2018 1:52 PM, Rafa=C5=82 Mi=C5=82ecki wrote:
> > > >>> I'm providing extra version info of tested firmware images as req=
uested
> > > >>> by Arend in another e-mail thread.
> > > >>
> > > >> Looking into our firmware repo it there are two flags, ie. WL_MONI=
TOR
> > > >> and WL_RADIOTAP. It seems both are set for firmware containing -st=
amon-
> > > >> feature. Your list below confirms that. I still plan to add indica=
tion
> > > >> for WL_RADIOTAP in the "cap" iovar, but a stamon feature check cou=
ld be
> > > >> used for older firmwares.
> > > >
> > > > The problem is that there isn't a direct mapping between what's
> > > > visible with the "tail" command and what firmware returns for the
> > > > "cap" iovar. Just to be sure I bumped #define MAX_CAPS_BUFFER_SIZE =
to
> > > > 1024. Firmware that has "stamon" when checked with "tail" command
> > > > doesn't report "stamon" over "cap" iovar. So I can't detect if
> > > > firmware was compiled with WL_MONITOR and WL_RADIOTAP using "cap"
> > > > iovar.
> > >
> > > All true. My suggestion is to look for "monitor" and "rtap" in the "c=
ap"
> > > iovar response to detect if firmware is compiled with WL_MONITOR and
> > > WL_RADIOTAP respectively. When one (or both) of these is not detected=
,
> > > we could fallback to try a stamon iovar and if it is supported enable
> > > both WL_MONITOR and WL_RADIOTAP. I am looking into a good candidate f=
or
> > > the stamon iovar so I can prepare a patch.
> >
> > Oh, I wasn't aware of the "stamon" iovar (or missed that in your
> > e-mails). If that works, it'll be a very nice fallback way of
> > detecting WL_MONITOR and WL_RADIOTAP!
>
> I just tried "stamon" iovar and it doesn't work. Following call:
> u32 var;
> brcmf_fil_iovar_int_get(ifp, "stamon", &var);
> returns -52
>
> Can you look at that "stamon" iovar again, please?

I kept looking around and noticed that "wl" user space tool supports
"sta_monitor" command. I tried "sta_monitor" iovar and it worked! I
guess that's the iovar you meant...

--=20
Rafa=C5=82
