Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39193 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1LVGj7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 01:39:59 -0500
Received: by pbdu13 with SMTP id u13so3407181pbd.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 22:39:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1324467662-10065-1-git-send-email-pontus.fuchs@gmail.com>
References: <1324467662-10065-1-git-send-email-pontus.fuchs@gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 22 Dec 2011 08:39:38 +0200
Message-ID: <CAK=WgbacGjAzXPSWd1sF0RwyJ3tbMYTrZM0v2sO-pd5heSawVQ@mail.gmail.com> (sfid-20111222_074002_978756_55E2E295)
Subject: Re: [PATCH] wl12xx: Fix power control for CONFIG_RUNTIME_PM off configurations
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: ido@wizery.com, coelho@ti.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pontus,

On Wed, Dec 21, 2011 at 1:41 PM, Pontus Fuchs <pontus.fuchs@gmail.com> wrote:
> On rmmod wl12xx will leave the sdio host powered off, regardless
> off runtime PM being enabled or not. This leads to probe failure on
> a second insmod, if runtime pm is disabled, because the sdio core
> expects the host to be powered on.

Just gave this patch a quick glance, and it looks rather nasty :)

> @@ -223,8 +229,8 @@ static int __devinit wl1271_probe(struct sdio_func *func,
>
>        sdio_set_drvdata(func, glue);
>
> -       /* Tell PM core that we don't need the card to be powered now */
> -       pm_runtime_put_noidle(&func->dev);
> +       /* Power off as we don't need the card to be powered now */
> +       wl12xx_sdio_power_off(func);

This in particular looks wrong.

You bypass runtime PM by manipulating the power state of the card
directly, and as a result you leave the runtime PM state out of sync
with the real power state of the device.

This is very unhealthy, and can lead to the system powering on the
card on certain events (e.g. on system resume) even when the wlan
interface is down.

Regards,
Ohad.
