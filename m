Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.142]:50896 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753152AbdHUSRI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Aug 2017 14:17:08 -0400
Message-ID: <1503338982.18019.1.camel@embedded.rocks> (sfid-20170821_201711_865059_0BA75CE0)
Subject: Re: brcmfmac experiment for a specific use case - tx throughput
 maximization for slow CPU with glomming
From: =?ISO-8859-1?Q?J=F6rg?= Krause <joerg.krause@embedded.rocks>
To: Fabio Estevam <festevam@gmail.com>
Cc: =?ISO-8859-1?Q?J=E9r=F4me?= Carretero <cJ-ko@zougloub.eu>,
        Franky Lin <franky.lin@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 21 Aug 2017 20:09:42 +0200
In-Reply-To: <CAOMZO5A1485fcgVRcSKy7QoJnLgoSQerX=MmP_exhsdxOctG6A@mail.gmail.com>
References: <20170524073326.3a16481b@Vantage>
         <1496299074.13131.3.camel@embedded.rocks>
         <CAOMZO5A1485fcgVRcSKy7QoJnLgoSQerX=MmP_exhsdxOctG6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Fabio,

On Fri, 2017-08-18 at 08:50 -0300, Fabio Estevam wrote:
> Hi Jörg,
> 
> On Thu, Jun 1, 2017 at 3:37 AM, Jörg Krause <joerg.krause@embedded.rocks> wrote:
> 
> > I'm experiencing low throughput with a BCM43362 wifi chip attached via
> > SDIO to an i.MX28 [1,2]. After disabling some Kernel debug features I'm
> > getting now a TCP throughput of 12.5 Mbps for the wifi interface, which
> > is still below the throughput I get for the Cubietruck.
> 
> Does it help if you disable CONFIG_PROVE_LOCKING?

No, it does not. I've disabled all settings in "Lock Debugging", but
the TCP throughput is still at ~12.5 Mpbs.

> --- a/arch/arm/configs/mxs_defconfig
> +++ b/arch/arm/configs/mxs_defconfig
> @@ -175,7 +175,6 @@ CONFIG_MAGIC_SYSRQ=y
>  CONFIG_DEBUG_KERNEL=y
>  CONFIG_LOCKUP_DETECTOR=y
>  CONFIG_TIMER_STATS=y
> -CONFIG_PROVE_LOCKING=y
>  CONFIG_BLK_DEV_IO_TRACE=y
>  CONFIG_STRICT_DEVMEM=y
>  CONFIG_DEBUG_USER=y
