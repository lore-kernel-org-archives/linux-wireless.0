Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:47370 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751021AbaLBJaW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 04:30:22 -0500
From: Avinash Patil <patila@marvell.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: linux-mmc <linux-mmc@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Marc Yang <yangyang@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	"bin9zha0@gmail.com" <bin9zha0@gmail.com>,
	Bing Zhao <bzhao@marvell.com>
Date: Tue, 2 Dec 2014 01:25:20 -0800
Subject: RE: [PATCH] mmc: new API for data write using scatter gather DMA
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC66736E7987@SC-VEXCH2.marvell.com> (sfid-20141202_103028_691018_6734EAAD)
References: <1417000056-16920-1-git-send-email-patila@marvell.com>,<CAPDyKFr-iaPWKWWgk-5_XcJm9sag=y=uZjfJvo-DQiJFM8BVLw@mail.gmail.com>
In-Reply-To: <CAPDyKFr-iaPWKWWgk-5_XcJm9sag=y=uZjfJvo-DQiJFM8BVLw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ulf,

Purpose of patch is to offload scatter gather list population to host driver.
Patch provides MMC API using which host driver can directly use to program SG DMA. 


Thanks,
Avinash
________________________________________
From: Ulf Hansson [ulf.hansson@linaro.org]
Sent: Wednesday, November 26, 2014 7:13 PM
To: Avinash Patil
Cc: linux-mmc; linux-wireless@vger.kernel.org; Amitkumar Karwar; Cathy Luo; Marc Yang; Xinming Hu; bin9zha0@gmail.com; Bing Zhao
Subject: Re: [PATCH] mmc: new API for data write using scatter gather DMA

On 26 November 2014 at 12:07, Avinash Patil <patila@marvell.com> wrote:
> From: Bing Zhao <bzhao@marvell.com>
>
> This patch adds new API to handle scatter gather aggregation.

Why is this needed?

>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> ---
>  drivers/mmc/core/sdio_ops.c   | 65 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mmc/sdio_func.h |  5 ++++
>  2 files changed, 70 insertions(+)
>
> diff --git a/drivers/mmc/core/sdio_ops.c b/drivers/mmc/core/sdio_ops.c
> index 62508b4..4c5e362 100644
> --- a/drivers/mmc/core/sdio_ops.c
> +++ b/drivers/mmc/core/sdio_ops.c
> @@ -15,6 +15,7 @@
>  #include <linux/mmc/card.h>
>  #include <linux/mmc/mmc.h>
>  #include <linux/mmc/sdio.h>
> +#include <linux/export.h>
>
>  #include "core.h"
>  #include "sdio_ops.h"
> @@ -204,6 +205,70 @@ int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
>         return 0;
>  }
>
> +int mmc_io_rw_extended_sg(struct mmc_card *card, int write, unsigned fn,
> +                         unsigned addr, int incr_addr,
> +                         struct sg_table *sgt, unsigned blksz)
> +{
> +       struct mmc_request mrq = {NULL};
> +       struct mmc_command cmd = {0};
> +       struct mmc_data data = {0};
> +       struct scatterlist *sg_ptr;
> +       unsigned blocks = 0;
> +       int i;
> +
> +       BUG_ON(!card || !card->host);
> +       BUG_ON(fn > 7);
> +       BUG_ON(!blksz);

No BUG_ON() here please. Better to return an error.

> +       for_each_sg(sgt->sgl, sg_ptr, sgt->nents, i) {
> +               WARN_ON(sg_ptr->length > card->host->max_seg_size);
> +               blocks += DIV_ROUND_UP(sg_ptr->length, blksz);
> +       }
> +
> +       /* sanity check */
> +       if (addr & ~0x1FFFF)
> +               return -EINVAL;
> +
> +       mrq.cmd = &cmd;
> +       mrq.data = &data;
> +
> +       cmd.opcode = SD_IO_RW_EXTENDED;
> +       cmd.arg = write ? 0x80000000 : 0x00000000;
> +       cmd.arg |= fn << 28;
> +       cmd.arg |= incr_addr ? 0x04000000 : 0x00000000;
> +       cmd.arg |= addr << 9;
> +       cmd.arg |= 0x08000000 | blocks;
> +       cmd.flags = MMC_RSP_SPI_R5 | MMC_RSP_R5 | MMC_CMD_ADTC;
> +
> +       data.blksz = blksz;
> +       data.blocks = blocks;
> +       data.flags = write ? MMC_DATA_WRITE : MMC_DATA_READ;
> +
> +       data.sg = sgt->sgl;
> +       data.sg_len = sgt->nents;
> +
> +       mmc_set_data_timeout(&data, card);
> +       mmc_wait_for_req(card->host, &mrq);
> +
> +       if (cmd.error)
> +               return cmd.error;
> +       if (data.error)
> +               return data.error;
> +
> +       if (mmc_host_is_spi(card->host)) {
> +               /* host driver already reported errors */
> +       } else {
> +               if (cmd.resp[0] & R5_ERROR)
> +                       return -EIO;
> +               if (cmd.resp[0] & R5_FUNCTION_NUMBER)
> +                       return -EINVAL;
> +               if (cmd.resp[0] & R5_OUT_OF_RANGE)
> +                       return -ERANGE;
> +       }
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(mmc_io_rw_extended_sg);
> +
>  int sdio_reset(struct mmc_host *host)
>  {
>         int ret;
> diff --git a/include/linux/mmc/sdio_func.h b/include/linux/mmc/sdio_func.h
> index 50f0bc9..927ea8f 100644
> --- a/include/linux/mmc/sdio_func.h
> +++ b/include/linux/mmc/sdio_func.h
> @@ -14,6 +14,7 @@
>
>  #include <linux/device.h>
>  #include <linux/mod_devicetable.h>
> +#include <linux/scatterlist.h>
>
>  #include <linux/mmc/pm.h>
>
> @@ -153,6 +154,10 @@ extern int sdio_memcpy_toio(struct sdio_func *func, unsigned int addr,
>  extern int sdio_writesb(struct sdio_func *func, unsigned int addr,
>         void *src, int count);
>
> +int mmc_io_rw_extended_sg(struct mmc_card *card, int write, unsigned fn,
> +                         unsigned addr, int incr_addr,
> +                         struct sg_table *sgt, unsigned blksz);
> +
>  extern unsigned char sdio_f0_readb(struct sdio_func *func,
>         unsigned int addr, int *err_ret);
>  extern void sdio_f0_writeb(struct sdio_func *func, unsigned char b,
> --
> 1.8.1.4
>

Kind regards
Uffe
