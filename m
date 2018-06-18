Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:40218 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932762AbeFRL4d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 07:56:33 -0400
Received: by mail-wm0-f43.google.com with SMTP id n5-v6so14998405wmc.5
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2018 04:56:33 -0700 (PDT)
MIME-Version: 1.0
References: <986bbf4c-8fa1-4367-db9e-76a209594b81@gmail.com>
 <66e43eb5-2bc9-2ec3-af48-03248eecb727@gmail.com> <5B1E537F.2080502@broadcom.com>
In-Reply-To: <5B1E537F.2080502@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Mon, 18 Jun 2018 13:54:38 +0200
Message-ID: <CACna6rw9BnZvUM47-GEUpWp34eaDYeUz3yAyDpo6z+Z0TpKD8A@mail.gmail.com> (sfid-20180618_135638_423374_E7A56944)
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

The problem is that there isn't a direct mapping between what's
visible with the "tail" command and what firmware returns for the
"cap" iovar. Just to be sure I bumped #define MAX_CAPS_BUFFER_SIZE to
1024. Firmware that has "stamon" when checked with "tail" command
doesn't report "stamon" over "cap" iovar. So I can't detect if
firmware was compiled with WL_MONITOR and WL_RADIOTAP using "cap"
iovar.
