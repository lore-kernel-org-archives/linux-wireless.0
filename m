Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:5266 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752154AbcFIPoz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 11:44:55 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Shawn Lin <shawn.lin@rock-chips.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Wei-Ning Huang <wnhuang@chromium.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH v3 1/2] mmc: API for accessing host supported maximum
 segment count and size
Date: Thu, 9 Jun 2016 15:44:51 +0000
Message-ID: <25b49010bda247bd9a96f7a57a35e71e@SC-EXCH04.marvell.com> (sfid-20160609_174459_307590_E1A85ADB)
References: <1465213989-32218-1-git-send-email-akarwar@marvell.com>
 <589930e6-f253-58cf-f0fd-91d0c80a11bf@rock-chips.com>
In-Reply-To: <589930e6-f253-58cf-f0fd-91d0c80a11bf@rock-chips.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Shawn,

> From: Shawn Lin [mailto:shawn.lin@rock-chips.com]
> Sent: Wednesday, June 08, 2016 7:31 AM
> To: Amitkumar Karwar; linux-wireless@vger.kernel.org
> Cc: Nishant Sarmukadam; Wei-Ning Huang; linux-mmc@vger.kernel.org; Cathy
> Luo; Xinming Hu; shawn.lin@rock-chips.com
> Subject: Re: [PATCH v3 1/2] mmc: API for accessing host supported
> maximum segment count and size
> 
> Hi
> 
> On 2016-6-6 19:53, Amitkumar Karwar wrote:
> > From: Xinming Hu <huxm@marvell.com>
> >
> > sdio device drivers need be able to get the host supported max_segs
> > and max_seg_size, so that they know the buffer size to allocate while
> > utilizing the scatter/gather DMA buffer list.
> >
> > This patch provides API for this purpose.
> >
> > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > ---
> > v2: v2 was submitted with minor improvement like replacing BUG_ON()
> > with WARN_ON()
> > v3: Addressed below review comments from Ulf Hansson
> >      a) In v3, patch has been split into two separate patches.
> >      b) Patch 1/2 introduces an API to fetch max_seg_size and max_segs
> >      c) Replaced WARN_ON() with proper error code when sg_ptr->length
> is invalid
> >      d) Instead of duplicating the code in mmc_io_rw_extended(), extra
> bool parameter
> >         has been added to this function and used it in new APIs for
> SG.
> > ---
> >   drivers/mmc/core/sdio_io.c                         | 27
> ++++++++++++++++++++++
> >   .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  6 ++---
> >   include/linux/mmc/sdio_func.h                      |  3 +++
> >   3 files changed, 33 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
> > index 78cb4d5..a546c89 100644
> > --- a/drivers/mmc/core/sdio_io.c
> > +++ b/drivers/mmc/core/sdio_io.c
> > @@ -720,3 +720,30 @@ int sdio_set_host_pm_flags(struct sdio_func
> *func, mmc_pm_flag_t flags)
> >   	return 0;
> >   }
> >   EXPORT_SYMBOL_GPL(sdio_set_host_pm_flags);
> > +
> > +/**
> > + *	sdio_get_host_max_seg_size - get host maximum segment size
> > + *	@func: SDIO function attached to host
> > + */
> > +unsigned int sdio_get_host_max_seg_size(struct sdio_func *func) {
> > +	WARN_ON(!func);
> > +	WARN_ON(!func->card);
> > +
> > +	return func->card->host->max_seg_size; }
> > +EXPORT_SYMBOL_GPL(sdio_get_host_max_seg_size);
> > +
> > +/**
> > + *	sdio_get_host_max_seg_count - get host maximum segment count
> > + *	@func: SDIO function attached to host
> > + */
> > +unsigned short sdio_get_host_max_seg_count(struct sdio_func *func) {
> > +	WARN_ON(!func);
> > +	WARN_ON(!func->card);
> > +
> 
> I believe these two WARN_ON may be called too late because ...
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> 
> void brcmf_sdiod_sgtable_alloc(struct brcmf_sdio_dev *sdiodev)
> 
> func = sdiodev->func[2];
> host = func->card->host;
> 
> you have unconditionally thought it should be ready.
> 

Yes. The WARN_ONs in this patch are redundant. We will remove them and submit updated version.

Below is the function call flow.

brcmf_sdio_probe() -> brcmf_sdio_probe_attach() -> brcmf_sdiod_sgtable_alloc()

Looks like is sdiodev->func[2] is ready in brcmf_sdio_probe() itself.

It contains below line.

        bus->blocksize = bus->sdiodev->func[2]->cur_blksize;

Regards,
Amitkumar
