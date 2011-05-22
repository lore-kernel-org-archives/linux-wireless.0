Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54483 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab1EVMee convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 08:34:34 -0400
Received: by gxk21 with SMTP id 21so1860180gxk.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 May 2011 05:34:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305321990-22041-4-git-send-email-balbi@ti.com>
References: <1305321990-22041-1-git-send-email-balbi@ti.com>
	<1305321990-22041-4-git-send-email-balbi@ti.com>
Date: Sun, 22 May 2011 15:34:33 +0300
Message-ID: <BANLkTinPipSVdsH5cTb24HKex_h7pOwpAg@mail.gmail.com> (sfid-20110522_143438_367354_E6956B1D)
Subject: Re: [RFC/PATCH 03/13] net: wl12xx: remove some unnecessary prints
From: Eliad Peller <eliad@wizery.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 14, 2011 at 12:26 AM, Felipe Balbi <balbi@ti.com> wrote:
> Those have little value. Remove those to make
> the driver less noisy.
>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
[...]
> @@ -287,8 +287,6 @@ static int __devinit wl1271_probe(struct sdio_func *func,
>        /* Tell PM core that we don't need the card to be powered now */
>        pm_runtime_put_noidle(&func->dev);
>
> -       wl1271_notice("initialized");
> -
>        return 0;
>

>  static void __exit wl1271_exit(void)
>  {
>        sdio_unregister_driver(&wl1271_sdio_driver);
> -
> -       wl1271_notice("unloaded");
>  }
>

in fact, i find these prints pretty useful.
does changing wl1271_notice to wl1271_debug(DEBUG_MAC80211) will solve
the "nosiness"?
(i use DEBUG_MAC80211 rather than DEBUG_SDIO, as DEBUG_SDIO is really
*very* noisy)

(i'll send it as a new patch as the original patch was already applied)

Eliad.
