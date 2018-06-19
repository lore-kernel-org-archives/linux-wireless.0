Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:53659 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030448AbeFSUBD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 16:01:03 -0400
Received: by mail-wm0-f66.google.com with SMTP id x6-v6so2300123wmc.3
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2018 13:01:02 -0700 (PDT)
Subject: Re: [PATCH V3 0/2] brcmfmac: initial work for adding monitor mode
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20180619154809.25698-1-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B2960FD.9010604@broadcom.com> (sfid-20180619_220108_515873_099252C5)
Date: Tue, 19 Jun 2018 22:01:01 +0200
MIME-Version: 1.0
In-Reply-To: <20180619154809.25698-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/19/2018 5:48 PM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
>
> After a bit long discussions in various e-mail threads I'm coming with
> this simple & small patchset. It isn't complete support for monitor mode
> but just a pair of preparing patches that should be clear & well
> discussed by now to make them acceptable.
>
> The main missing bit is code setting MONITOR_FMT_RADIOTAP which I expect
> Arend to handle soon, as he already has a patch using "sta_monitor"
> iovar for that. Then we have to discuss a flag for marking firmwares
> which are capable for tagging monitor frames.
>
> While still incomplete, I believe that with my previous patches, we can
> agree this is a good direction.
>
> Arend: if you find these 2 patches OK, could you ack them, to make it
> clear for Kalle if they look OK now (or not yet)? I'd be great if you
> could sent your "sta_monitor" work on top of this.

I acked them and I will submit my changes later. Either after these are 
applied or simply indicate the dependency.

Now as for where we are with this. With what we have here we know 
firmware can monitor packets with and without radiotap. However, we do 
not have an indication whether firmware can transport these monitor 
packets to the host. What I need to look into next is whether the 802.11 
flag in msgbuf is linked to a particular version of the protocol, but we 
may need to resort to the fwid table.

Regards,
Arend
