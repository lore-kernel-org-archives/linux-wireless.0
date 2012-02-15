Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:54433 "HELO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755090Ab2BOKWM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 05:22:12 -0500
Received: by mail-lpp01m010-f49.google.com with SMTP id g1so998914lah.36
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 02:22:10 -0800 (PST)
Message-ID: <1329301327.19569.47.camel@cumari> (sfid-20120215_112215_315660_5B89B439)
Subject: Re: [PATCH 0/4] wl12xx: support multiple vifs
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 15 Feb 2012 12:22:07 +0200
In-Reply-To: <1328525277-25334-1-git-send-email-eliad@wizery.com>
References: <1328525277-25334-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-02-06 at 12:47 +0200, Eliad Peller wrote: 
> Due to lack of space, wl12xx uses separate firmwares for PLT,
> single-role and multi-role (some advanced fw features are
> disabled in the multi-role fw, so we use the single-role fw
> when only a single vif is configured).
> 
> Add support for loading the different firmwares, and initiate
> a recovery when a single<->multi transition is needed.
> 
> Eliad Peller (4):
>   wl12xx: Use a dedicated fw for PLT
>   wl12xx: dynamically change fw according to number of active roles
>   wl12xx: enter forced-psm on fw change
>   wl12xx: delete wl->vif (and allow multiple vifs)
> 
>  drivers/net/wireless/wl12xx/debugfs.c |    2 +-
>  drivers/net/wireless/wl12xx/main.c    |  184 +++++++++++++++++++++++++++------
>  drivers/net/wireless/wl12xx/rx.c      |    2 +-
>  drivers/net/wireless/wl12xx/sdio.c    |    8 +-
>  drivers/net/wireless/wl12xx/spi.c     |    8 +-
>  drivers/net/wireless/wl12xx/wl12xx.h  |   24 ++++-
>  6 files changed, 186 insertions(+), 42 deletions(-)

Applied this series, with v2 of 2/4.

-- 
Cheers,
Luca.

