Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36440 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750944AbdHRLuj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 07:50:39 -0400
Received: by mail-oi0-f68.google.com with SMTP id b130so9088974oii.3
        for <linux-wireless@vger.kernel.org>; Fri, 18 Aug 2017 04:50:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1496299074.13131.3.camel@embedded.rocks>
References: <20170524073326.3a16481b@Vantage> <1496299074.13131.3.camel@embedded.rocks>
From: Fabio Estevam <festevam@gmail.com>
Date: Fri, 18 Aug 2017 08:50:38 -0300
Message-ID: <CAOMZO5A1485fcgVRcSKy7QoJnLgoSQerX=MmP_exhsdxOctG6A@mail.gmail.com> (sfid-20170818_135043_210198_CB13DB31)
Subject: Re: brcmfmac experiment for a specific use case - tx throughput
 maximization for slow CPU with glomming
To: =?UTF-8?B?SsO2cmcgS3JhdXNl?= <joerg.krause@embedded.rocks>
Cc: =?UTF-8?B?SsOpcsO0bWUgQ2FycmV0ZXJv?= <cJ-ko@zougloub.eu>,
        Franky Lin <franky.lin@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi J=C3=B6rg,

On Thu, Jun 1, 2017 at 3:37 AM, J=C3=B6rg Krause <joerg.krause@embedded.roc=
ks> wrote:

> I'm experiencing low throughput with a BCM43362 wifi chip attached via
> SDIO to an i.MX28 [1,2]. After disabling some Kernel debug features I'm
> getting now a TCP throughput of 12.5 Mbps for the wifi interface, which
> is still below the throughput I get for the Cubietruck.

Does it help if you disable CONFIG_PROVE_LOCKING?

--- a/arch/arm/configs/mxs_defconfig
+++ b/arch/arm/configs/mxs_defconfig
@@ -175,7 +175,6 @@ CONFIG_MAGIC_SYSRQ=3Dy
 CONFIG_DEBUG_KERNEL=3Dy
 CONFIG_LOCKUP_DETECTOR=3Dy
 CONFIG_TIMER_STATS=3Dy
-CONFIG_PROVE_LOCKING=3Dy
 CONFIG_BLK_DEV_IO_TRACE=3Dy
 CONFIG_STRICT_DEVMEM=3Dy
 CONFIG_DEBUG_USER=3Dy
