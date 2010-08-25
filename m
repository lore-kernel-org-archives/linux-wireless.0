Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab0HYV5G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Aug 2010 17:57:06 -0400
Subject: Re: [PATCH] libertas: if_sdio: fix buffer alignment in struct
 if_sdio_card
From: Dan Williams <dcbw@redhat.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Mike Rapoport <mike@compulab.co.il>, rusty@rustcorp.com.au,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <201008221557.44607.marek.vasut@gmail.com>
References: <1282476160-6913-1-git-send-email-mike@compulab.co.il>
	 <201008221459.25574.marek.vasut@gmail.com>
	 <4C712480.1090006@compulab.co.il>
	 <201008221557.44607.marek.vasut@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 16:59:00 -0500
Message-ID: <1282773540.28250.29.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-08-22 at 15:57 +0200, Marek Vasut wrote:
> Dne Ne 22. srpna 2010 15:22:08 Mike Rapoport napsal(a):
> > Marek Vasut wrote:
> > > Dne Ne 22. srpna 2010 13:22:40 Mike Rapoport napsal(a):
> > >> The commit 886275ce41a9751117367fb387ed171049eb6148 (param: lock
> > >> if_sdio's lbs_helper_name and lbs_fw_name against sysfs changes)
> > >> introduced new fields into the if_sdio_card structure. It caused
> > >> missalignment of the if_sdio_card.buffer field and failure at driver
> > >> 
> > >> load time:
> > >>   ~# modprobe libertas_sdio
> > >>   [   62.315124] libertas_sdio: Libertas SDIO driver
> > >>   [   62.319976] libertas_sdio: Copyright Pierre Ossman
> > >>   [   63.020629] DMA misaligned error with device 48
> > >>   [   63.025207] mmci-omap-hs mmci-omap-hs.1: unexpected dma status 800
> > >>   [   66.005035] libertas: command 0x0003 timed out
> > >>   [   66.009826] libertas: Timeout submitting command 0x0003
> > >>   [   66.016296] libertas: PREP_CMD: command 0x0003 failed: -110
> > >> 
> > >> Adding explicit alignment attribute for the if_sdio_card.buffer field
> > >> fixes this problem.
> > >> 
> > >> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> > >> ---
> > >> 
> > >>  drivers/net/wireless/libertas/if_sdio.c |    2 +-
> > >>  1 files changed, 1 insertions(+), 1 deletions(-)
> > >> 
> > >> diff --git a/drivers/net/wireless/libertas/if_sdio.c
> > >> b/drivers/net/wireless/libertas/if_sdio.c index ba854c7..87b6349 100644
> > >> --- a/drivers/net/wireless/libertas/if_sdio.c
> > >> +++ b/drivers/net/wireless/libertas/if_sdio.c
> > >> @@ -128,7 +128,7 @@ struct if_sdio_card {
> > >> 
> > >>  	bool			helper_allocated;
> > >>  	bool			firmware_allocated;
> > >> 
> > >> -	u8			buffer[65536];
> > >> +	u8			buffer[65536] __attribute__((aligned(4)));
> > >> 
> > >>  	spinlock_t		lock;
> > >>  	struct if_sdio_packet	*packets;
> > > 
> > > Will this work even on platforms that need some weird DMA destination
> > > address alignment ? I might be totally off with this question though ;-)
> > 
> > I've tested it on PXA and OMAP and it works on both.
> > I think that on platforms with weird DMA destination address alignment
> > libertas_sdio will fail anyway because of if_sdio_packet alignment.
> 
> You're right ... thanks for clearing this.
> 
> Acked-by: Marek Vasut <marek.vasut@gmail.com>

Acked-by: Dan Williams <dcbw@redhat.com>


