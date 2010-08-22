Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59431 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab0HVNAF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Aug 2010 09:00:05 -0400
Received: by fxm13 with SMTP id 13so2508318fxm.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Aug 2010 06:00:03 -0700 (PDT)
From: Marek Vasut <marek.vasut@gmail.com>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: if_sdio: fix buffer alignment in struct if_sdio_card
Date: Sun, 22 Aug 2010 14:59:25 +0200
Cc: Mike Rapoport <mike@compulab.co.il>,
	linux-wireless@vger.kernel.org, rusty@rustcorp.com.au
References: <1282476160-6913-1-git-send-email-mike@compulab.co.il>
In-Reply-To: <1282476160-6913-1-git-send-email-mike@compulab.co.il>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008221459.25574.marek.vasut@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dne Ne 22. srpna 2010 13:22:40 Mike Rapoport napsal(a):
> The commit 886275ce41a9751117367fb387ed171049eb6148 (param: lock
> if_sdio's lbs_helper_name and lbs_fw_name against sysfs changes)
> introduced new fields into the if_sdio_card structure. It caused
> missalignment of the if_sdio_card.buffer field and failure at driver
> load time:
> 
>   ~# modprobe libertas_sdio
>   [   62.315124] libertas_sdio: Libertas SDIO driver
>   [   62.319976] libertas_sdio: Copyright Pierre Ossman
>   [   63.020629] DMA misaligned error with device 48
>   [   63.025207] mmci-omap-hs mmci-omap-hs.1: unexpected dma status 800
>   [   66.005035] libertas: command 0x0003 timed out
>   [   66.009826] libertas: Timeout submitting command 0x0003
>   [   66.016296] libertas: PREP_CMD: command 0x0003 failed: -110
> 
> Adding explicit alignment attribute for the if_sdio_card.buffer field
> fixes this problem.
> 
> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> ---
>  drivers/net/wireless/libertas/if_sdio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_sdio.c
> b/drivers/net/wireless/libertas/if_sdio.c index ba854c7..87b6349 100644
> --- a/drivers/net/wireless/libertas/if_sdio.c
> +++ b/drivers/net/wireless/libertas/if_sdio.c
> @@ -128,7 +128,7 @@ struct if_sdio_card {
>  	bool			helper_allocated;
>  	bool			firmware_allocated;
> 
> -	u8			buffer[65536];
> +	u8			buffer[65536] __attribute__((aligned(4)));
> 
>  	spinlock_t		lock;
>  	struct if_sdio_packet	*packets;

Will this work even on platforms that need some weird DMA destination address 
alignment ? I might be totally off with this question though ;-)

Cheers
