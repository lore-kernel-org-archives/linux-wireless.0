Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.142]:58517 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751013AbdFAGrv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 02:47:51 -0400
Message-ID: <1496299074.13131.3.camel@embedded.rocks> (sfid-20170601_084755_564094_5958B66F)
Subject: Re: brcmfmac experiment for a specific use case - tx throughput
 maximization for slow CPU with glomming
From: =?ISO-8859-1?Q?J=F6rg?= Krause <joerg.krause@embedded.rocks>
To: =?ISO-8859-1?Q?J=E9r=F4me?= Carretero <cJ-ko@zougloub.eu>,
        Franky Lin <franky.lin@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Date: Thu, 01 Jun 2017 08:37:54 +0200
In-Reply-To: <20170524073326.3a16481b@Vantage>
References: <20170524073326.3a16481b@Vantage>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jérôme,

On Wed, 2017-05-24 at 07:33 -0400, Jérôme Carretero wrote:
> Hi,
> 
> 
> I've crippled a Raspberry Pi 3 (1 core, 200 MHz) and observed that the
> glomming feature has a definite impact on TX performance, but it looks
> like at this CPU frequency, the work queue is solicited "too often"
> by brcmf_sdio_trigger_dpc() and glomming is only doing 4 packets at
> once, resulting in maybe a sub-optimal throughput.

I'm experiencing low throughput with a BCM43362 wifi chip attached via
SDIO to an i.MX28 [1,2]. After disabling some Kernel debug features I'm
getting now a TCP throughput of 12.5 Mbps for the wifi interface, which
is still below the throughput I get for the Cubietruck.

> 
> I have a vague idea that deliberately delaying the transmissions so as
> to wait for either a small timeout, or the glomming level has been
> reached, would be something worth exploring.
> But I haven't spent a long time looking at the driver.

If you are in need for any testing I'm willing to help!

[1] https://www.spinics.net/lists/linux-wireless/msg153257.html	
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-October/
461137.html

Jörg
