Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46431 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab0KWWaI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 17:30:08 -0500
Received: by iwn33 with SMTP id 33so634980iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 14:30:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1011232127490.21566@aurora.sdinet.de>
References: <alpine.DEB.2.02.1011232127490.21566@aurora.sdinet.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 23 Nov 2010 14:29:46 -0800
Message-ID: <AANLkTim751ys8=U7cBvXzkiFoe=SLWMra9Pxwgmq8-oG@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless: fix activesync devices
To: Sven-Haegar Koch <haegar@sdinet.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 23, 2010 at 12:39 PM, Sven-Haegar Koch <haegar@sdinet.de> wrote:
>
> Compiling support for ActiveSync devices in compat-wireless depends
> on USB_NET_CDCETHER to be set in main kernel.
>
> But USB_NET_CDCETHER can also be a module, in which case
> CONFIG_USB_NET_CDCETHER will not be defined inside compat_autoconf.h and
> the compat-wireless cdc_ether.ko will miss the support for it.
>
> So check also for CONFIG_USB_NET_CDCETHER_MODULE in config.mk to be safe
> in both cases.
>
> Signed-off-by: Sven-Haegar Koch <haegar@sdinet.de>
> ---
>
> I needed to also use an old windows mobile device (Palm Treo 750)
> connected over USB with my laptop which otherwise uses compat-wireless.
>
> But after connecting it I only got:
>        usb 2-1: bad CDC descriptors
>
> This happens when in drivers/net/usb/cdc_ether.c
> CONFIG_USB_NET_COMPAT_RNDIS_HOST and
> CONFIG_USB_NET_COMPAT_RNDIS_HOST_MODULE both are not defined, because it
> stubs out the rndis_host support.
>
> Perhaps not the most visually pleasing solution to just include the
> ifdef block in config.mk twice, but everything else would have needed a
> much deeper surgery - and as this is the only usage of ifdef in
> compat.mk where the symbol can also be a module I did not find it to be
> worth the additional complexity.
>
> Tested with compat-wireless-2.6.36-5-spn.tar.bz2, but also happened with
> earlier versions and should also apply to newer.

Thanks applied to the latest (always first) and will later push out a
new release for 2.6.36.

  Luis
