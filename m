Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:35645 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752888Ab1JKNFx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 09:05:53 -0400
Received: by mail-bw0-f45.google.com with SMTP id zv15so10345529bkb.32
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 06:05:44 -0700 (PDT)
Subject: Re: [PATCH 0/8] wl12xx: forward ported Balbi's bus driver refactor
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1317928259-26437-1-git-send-email-coelho@ti.com>
References: <1317928259-26437-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 16:05:40 +0300
Message-ID: <1318338340.9690.522.camel@cumari> (sfid-20111011_150557_821835_9B20CE7F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-10-06 at 22:10 +0300, Luciano Coelho wrote: 
> Hi,
> 
> Felipe sent this series of patches a long time ago with very good
> suggestion on how to avoid the duplicate code we have in the sdio and
> spi drivers.
> 
> With this, we create a platform device that is handled by a platform
> driver.  The bus-specific module, creates a platform device and the
> core module implements the driver that supports both platform devices
> (namely "wl12xx-sdio" and "wl12xx-spi").
> 
> I didn't apply this earlier because I had concerns about the change in
> the platform data, but now I'm convinced it's not a real problem.  It
> may affect compat-wireless, but it's easy to solve.
> 
> I have now forward-ported the patches, fixed some bugs, removed some
> style changes and moved some other things around.  For the changes I
> made, see the commit message of each patch.  Some changes are not in
> the commit message, but are explained in the patch emails, after the
> Signed-off-by area.
> 
> I'm keeping Felipe as the author, since most of the work is his.  I
> have just tested and fixed it up.
> 
> Cheers,
> Luca.
> 
> Felipe Balbi (8):
>   wl12xx: add an sdio glue struct to keep wl and device side-by-side
>   wl12xx: add an spi glue struct to keep wl and device side-by-side
>   wl12xx: add a platform device to the sdio module
>   wl12xx: add a platform device to the spi module
>   wl12xx: add platform driver to the core module
>   wl12xx: move common init code from bus modules to main
>   wl12xx: mark some symbols static
>   wl12xx: drop unneeded plat_dev

Applied the whole series.

-- 
Cheers,
Luca.

