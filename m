Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:41918 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751518AbeB0Rks (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 12:40:48 -0500
Received: by mail-wr0-f174.google.com with SMTP id f14so25728118wre.8
        for <linux-wireless@vger.kernel.org>; Tue, 27 Feb 2018 09:40:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALLGbRJxwOUkxnNCyCt2sBuoZacs60AcDnFfWMQQuVdj5YykOw@mail.gmail.com>
References: <CAPcv9S3wyPd5jD1PZWtDf-mRicmzRmz00qh5Jbov_N_egBAEZg@mail.gmail.com>
 <5A953DBE.9070805@broadcom.com> <CAPcv9S1fZfrg3AV3GoWG-CaTkonpQyiHY6twvhS_ikXnj00t4g@mail.gmail.com>
 <68f5549d-b8ad-85fb-4e80-50c53cac8108@lwfinger.net> <CAPcv9S0TmMhrL0qcxq-8NStd=fYQreXribrA+GQmppLvrB_avg@mail.gmail.com>
 <CALLGbRJxwOUkxnNCyCt2sBuoZacs60AcDnFfWMQQuVdj5YykOw@mail.gmail.com>
From: Steve deRosier <derosier@gmail.com>
Date: Tue, 27 Feb 2018 09:34:44 -0800
Message-ID: <CALLGbRKrnnmsNtzpkABn+xOTjDaFKZz0jNxGkyJXMT1=XLa_3g@mail.gmail.com> (sfid-20180227_184053_310447_F10C3F73)
Subject: Re: Support on vendor id and device id
To: Harsha Rao <harshrao464@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Harsha,

Part 2 - the darn cmd-enter shortcut in gmail got me again. Sorry for
the premature send.

>
> As both Larry and Arend mention, while it's possible to have multiple
> drivers with the same IDs, for obvious reasons it's not desirable.
>
> In theory the vendor IDs shouldn't be duplicated on fundamentally
> different devices, assuming that the manufacturers are doing things
> "right". The VID is paid for by buying it from the SD Association.
>
> My suspicion is that your device, is fundamentally a wilc1000 and that
> the existing wilc1000 driver will likely largely work for it and all
> you really need to do is modify the existing driver to handle the
> quirks of your particular implementation of the wilc1000 chip. And,
> often WiFi chips will let you change the VID/PID somewhere within
> whatever non-volatile storage it has (like where it stores the MAC
> address).

What I was going to mention is this is how it's worked for me many
times on several chips from QCA, Broadcom and Marvell included. The
use-case in this case would be building a custom WiFi module using a
vendor's chip. Very common - Silex, Laird and others do this all the
time: buy a chip from QCA (or Broadcom or Marvell or...), put it on a
board with lna, pa, passives, antennas, etc...  And you package it and
sell that often with value-add software.  Sometimes it's fine if it
represents like the original chip (for example on the ath6kl chips
Laird sells, it just uses the QCA IDs), but sometimes you want it to
represent as "my chip" (again, as Laird has to do on the chips they
sell to the Windows market to avoid the kind of driver conflicts
you're encountering). All of these chips usually have a way to store a
MAC address and at least all that I've worked on will also allow you
to change the SDIO VID in the same one-time-programable memory.
Obviously the method changes depending on the chip.

However, in nearly every case, the chip is still fundamentally
whatever it was and we still use the upstream driver, though often
with tweaks and customizations based on our implementation. In the
cases where we've added a custom VID, we've also had to add the new
VID to the original driver and then key our quirks off that.

I'm not saying this is definitely applicable in your case, but it is
common and maybe it will help.

Also thanks for bringing this issue up. Something I haven't thought
about in a long time but I'm adding it to my talk at ELC on WiFi
module interfacing. http://sched.co/DXn3

- Steve

--
Steve deRosier
Cal-Sierra Consulting LLC
https://www.cal-sierra.com/
