Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57274 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2CKV7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Mar 2012 17:59:38 -0400
MIME-Version: 1.0
In-Reply-To: <1331496505-18697-4-git-send-email-hauke@hauke-m.de>
References: <1331496505-18697-1-git-send-email-hauke@hauke-m.de> <1331496505-18697-4-git-send-email-hauke@hauke-m.de>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 12 Mar 2012 08:59:18 +1100
Message-ID: <CAGRGNgX116dRB03NTL_DFZ4b_PYcdY+Un_cVwt6ZUGR1bwZzHA@mail.gmail.com> (sfid-20120311_225945_113991_479DE759)
Subject: Re: [PATCH 3/7] bcma: scan for extra address space
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
	linux-mips@linux-mips.org, ralf@linux-mips.org, m@bues.ch,
	linux-usb@vger.kernel.org,
	=?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hauke,

On Mon, Mar 12, 2012 at 07:08, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Some cores like the USB core have two address spaces. In the USB host
> controller one address space is used for the OHCI and the other for the
> EHCI controller interface. The USB controller is the only core I found
> with two address spaces. This code is based on the AI scan function
> ai_scan() in shared/aiutils.c i the Broadcom SDK.
>
> CC: Rafał Miłecki <zajec5@gmail.com>
> CC: linux-wireless@vger.kernel.org
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/bcma/scan.c       |   18 +++++++++++++++++-
>  include/linux/bcma/bcma.h |    1 +
>  2 files changed, 18 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
> index 3a2f672..3c2eeed 100644
> --- a/drivers/bcma/scan.c
> +++ b/drivers/bcma/scan.c
> @@ -286,6 +286,22 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
>                        return -EILSEQ;
>        }
>
> +
> +       /* First Slave Address Descriptor should be port 0:
> +        * the main register space for the core
> +        */
> +       tmp = bcma_erom_get_addr_desc(bus, eromptr, SCAN_ADDR_TYPE_SLAVE, 0);
> +       if (tmp <= 0) {
> +               /* Try again to see if it is a bridge */
> +               tmp = bcma_erom_get_addr_desc(bus, eromptr,
> +                                             SCAN_ADDR_TYPE_BRIDGE, 0);
> +               if (tmp > 0) {
> +                       pr_info("found bridge");
> +                       return -ENXIO;
> +               }

Should this do something if the second bcma_erom_get_addr_desc() call
returns an error? We seem to be putting any errors from that call into
the addr member of the core structure below.

> +       }
> +       core->addr = tmp;
> +
>        /* get & parse slave ports */
>        for (i = 0; i < ports[1]; i++) {
>                for (j = 0; ; j++) {
> @@ -298,7 +314,7 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
>                                break;
>                        } else {
>                                if (i == 0 && j == 0)
> -                                       core->addr = tmp;
> +                                       core->addr1 = tmp;
>                        }
>                }
>        }
> diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
> index 83c209f..7fe41e1 100644
> --- a/include/linux/bcma/bcma.h
> +++ b/include/linux/bcma/bcma.h
> @@ -138,6 +138,7 @@ struct bcma_device {
>        u8 core_index;
>
>        u32 addr;
> +       u32 addr1;
>        u32 wrap;
>
>        void __iomem *io_addr;
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
