Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:56843 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751365AbdJJTJc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 15:09:32 -0400
Received: by mail-wm0-f47.google.com with SMTP id l68so8134059wmd.5
        for <linux-wireless@vger.kernel.org>; Tue, 10 Oct 2017 12:09:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e99d4daa-fdc2-ce26-8ffb-bd3cf131e87c@candelatech.com>
References: <e99d4daa-fdc2-ce26-8ffb-bd3cf131e87c@candelatech.com>
From: Adrian Chadd <adrian@freebsd.org>
Date: Tue, 10 Oct 2017 12:09:30 -0700
Message-ID: <CAJ-Vmok9rNij_hErSfArrf9A6U8wCaZZWhOEPphCODKnj5Xjog@mail.gmail.com> (sfid-20171010_210935_863492_60694A38)
Subject: Re: What should setting rate on 'AP' interface mean?
To: Ben Greear <greearb@candelatech.com>
Cc: ath10k <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

IIRC, I think it's the drivers job to determine per-peer fixed rate.



-adrian


On 10 October 2017 at 11:34, Ben Greear <greearb@candelatech.com> wrote:
> I was trying to use 'iw' to set rates on an AP interface, hoping it would
> set tx-rates on all of the stations (peers) to the same thing.
>
> It appears that the ath10k driver will set ratesets on all stations if
> we specify more than one rate, but if we specify a single rate, it does
> not iterate through all stations, and just sets the 'vdev' fixed rate.
>
> So, should the driver somehow attempt to set single rate on all the stations
> when
> using a single rate?
>
> Or, do we need an API to force rates for individual stations (peers) and
> leave
> the driver in the current configuration?
>
> Or is it the firmware's responsibility to set the rate for all peers when
> we set the vdev fixed rate on an AP vdev?
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
