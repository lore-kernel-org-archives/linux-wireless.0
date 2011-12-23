Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:50909 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432Ab1LWI6U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 03:58:20 -0500
Received: by lahj13 with SMTP id j13so6008779lah.39
        for <linux-wireless@vger.kernel.org>; Fri, 23 Dec 2011 00:58:17 -0800 (PST)
Subject: Re: [PATCH 2/6] compat-wireless: remove platform_device_id for
 kernel < 2.6.30
From: Luciano Coelho <coelho@ti.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: mcgrof@gmail.com, mcgrof@qca.qualcomm.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1324586850-5212-3-git-send-email-hauke@hauke-m.de>
References: <1324586850-5212-1-git-send-email-hauke@hauke-m.de>
	 <1324586850-5212-3-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Dec 2011 10:58:14 +0200
Message-ID: <1324630694.2182.325.camel@cumari> (sfid-20111223_095839_870287_E0111588)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-22 at 21:47 +0100, Hauke Mehrtens wrote: 
> Kernel < 2.6.30 do not support struct platform_device_id, so remove it
> for them and hope that the probing will reject an invalid device.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---

This is not going to work.  The only way the wl12xx module gets probed
is when a "wl12xx" platform device is added to the system.  The
wl12xx_sdio or wl12xx_spi module instantiates a platform device with
"wl12xx" as the name, which causes the wl12xx module to be probed.

I don't know how modules handling platform devices were probed pre-.30.
Does anyone know?

Anything before 2.6.30 is *ancient*, and anyway, even before this change
we already needed changes in the "outer" kernel to get wl12xx to work.

The question is, should we even bother compiling wl12xx if the kernel is
< .30?

I'll update our wikipage to say athat starting from compat-wireless 3.2,
additional changes are required for < 2.6.30.

-- 
Cheers,
Luca.

