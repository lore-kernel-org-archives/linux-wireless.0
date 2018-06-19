Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:34648 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756377AbeFSH3V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 03:29:21 -0400
Received: by mail-wm0-f51.google.com with SMTP id l15-v6so17719643wmc.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2018 00:29:20 -0700 (PDT)
MIME-Version: 1.0
References: <986bbf4c-8fa1-4367-db9e-76a209594b81@gmail.com>
 <66e43eb5-2bc9-2ec3-af48-03248eecb727@gmail.com> <5B1E537F.2080502@broadcom.com>
In-Reply-To: <5B1E537F.2080502@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 19 Jun 2018 09:27:17 +0200
Message-ID: <CACna6rxa4+UEOs1FjQUGnHpFJn4n_TO6v=Vx3SqNA32QvzQEGQ@mail.gmail.com> (sfid-20180619_092937_803930_ECCE5574)
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

On Mon, 11 Jun 2018 at 12:48, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 5/30/2018 1:52 PM, Rafa=C5=82 Mi=C5=82ecki wrote:
> > I'm providing extra version info of tested firmware images as requested
> > by Arend in another e-mail thread.
>
> Looking into our firmware repo it there are two flags, ie. WL_MONITOR
> and WL_RADIOTAP. It seems both are set for firmware containing -stamon-
> feature. Your list below confirms that. I still plan to add indication
> for WL_RADIOTAP in the "cap" iovar, but a stamon feature check could be
> used for older firmwares.

I just checked wl.mk (it's an open source file) and found following line:
WLFILES_SRC_HI +=3D src/wl/sys/wlc_stamon.c
not guarded by any ifeq.

It appears wlc_stamon.c is always being compiled in. Are you 100% sure
that wlc_stamon.c depends & uses radiotap? Are you sure it's
impossible to include stamon support without radiotap support?

I'm asking because we're going to check "sta_monitor" iovar to find
out if radiotap support is included. I'd like to be sure it's 100%
reliable.
