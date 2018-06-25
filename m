Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35254 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934597AbeFYPAu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Jun 2018 11:00:50 -0400
Received: by mail-io0-f196.google.com with SMTP id q4-v6so12856377iob.2
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2018 08:00:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b8a41e3a-7100-ae17-1275-d1b40a026201@zonque.org>
References: <b8a41e3a-7100-ae17-1275-d1b40a026201@zonque.org>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Mon, 25 Jun 2018 17:00:48 +0200
Message-ID: <CAPDyKFrgcFrah34+eFMsBQYWr03bTSMMUuYw61jYfpffSQrQAg@mail.gmail.com> (sfid-20180625_170119_182554_990B844B)
Subject: Re: Suspend of SDIO function devices
To: Daniel Mack <daniel@zonque.org>
Cc: Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
        linux-wireless@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 June 2018 at 22:46, Daniel Mack <daniel@zonque.org> wrote:
> Hi,
>
> I'm currently looking into the suspend callbacks of drivers of hardware that
> use an SDIO interface, specifically the libertas_sdio driver:
>
>    drivers/net/wireless/marvell/libertas/if_sdio.c

Great news, I am happy to help!

>
> The comments in if_sdio_suspend() suggest that by returning -ENOSYS due to
> runtime-dependant circumstances, the MMC core will remove the card entirely
> at suspend time. I then searched for the bits that do that and failed, until
> I came across this old commit, which first appeared in 3.16:
>
>    573185cc7e6 mmc: core: Invoke sdio func driver's PM callbacks from the
> sdio bus

Oh, so it's been broken for quite some time. :-(

My bad!

>
> Before that commit, the mmc core did in fact invoke the card's .suspend()
> callback manually and if it returned a non-zero result, it would remove the
> card. Now that the generic pm functions are in place, this does no longer
> happen because the host and its clients are independent entities.
> Consequently, systems fail to suspend when the libertas_sdio module is
> loaded.
>
> The pm notifier code in drivers/mmc/core/core.c does still handle cases
> where no pm functions are provided at all (in which case it removes the
> card), but it doesn't handle -ENOSYS return values at runtime.

Correctly observed!

>
> Now I'm wondering how this is supposed to work, and which end needs fixing.
> The mmc/sdio core by restoring the old logic from before 573185cc7e6, or the
> libertas driver.

I believe the proper solution is to fix the libertas driver. At least
we don't want to go back to the previous solution of returning -ENOSYS
from SDIO drivers.

However, let's see what fits best here.

>
> The platform I'm working on does not retain power for the SDIO slaves, so a
> complete re-init is necessary after resume.

Right.

>
> Please advise, I'm happy to test approaches and send patches.

>From a top level point of view, I think this needs to be changed:

1)
In cases when the libertas sdio driver's ->suspend() callback, thinks
of returning -ENOSYS, it should instead call if_sdio_power_off().
Depending if if_sdio_power_save() has already been called, this shall
be skipped.

The important thing here is to disable the SDIO func device and to
release the SDIO irq.

2)
During resume, depending on whether the earlier ->suspend() callback
invoked if_sdio_power_off(),  libertas sdio driver's ->resume()
callback should call if_sdio_power_on().

This should re-initiate the libertas sdio device and re-program the
firmware. To complete these actions, the firmware file also needs to
be fetched, which requires file system accesses also to be resumed.

We also need to wait for the firmware programming to be completed,
hence also do a "wait_event(card->pwron_waitq, priv->fw_ready);" from
somewhere.

Kind regards
Uffe
