Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44001 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab0DTAZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 20:25:24 -0400
Received: by vws5 with SMTP id 5so2554988vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 17:25:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1271707616-4150-1-git-send-email-hauke@hauke-m.de>
References: <4BCCA1D9.30208@hauke-m.de> <1271707616-4150-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 19 Apr 2010 17:25:03 -0700
Message-ID: <i2o43e72e891004191725waa5246e8v591601921b4ec109@mail.gmail.com>
Subject: Re: [PATCH v2] compat: backport convert multicast list to list_head.
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	proski@gnu.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 19, 2010 at 1:06 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  include/linux/compat-2.6.35.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/compat-2.6.35.h b/include/linux/compat-2.6.35.h
> index 964e8dc..4d3483a 100644
> --- a/include/linux/compat-2.6.35.h
> +++ b/include/linux/compat-2.6.35.h
> @@ -4,6 +4,7 @@
>  #include <linux/version.h>
>
>  #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35))
> +#include <linux/etherdevice.h>
>
>  #define IW_HANDLER(id, func)                   \
>        [IW_IOCTL_IDX(id)] = func
> @@ -11,6 +12,8 @@
>  #define  SDIO_BUS_ECSI         0x20    /* Enable continuous SPI interrupt */
>  #define  SDIO_BUS_SCSI         0x40    /* Support continuous SPI interrupt */
>
> +#define netdev_hw_addr dev_mc_list
> +
>  #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)) */
>
>  #endif /* LINUX_26_35_COMPAT_H */

Lets go with this approach for now, and if it bites us in the ass we
now not to do that again :)

BTW Thanks so much for all these patches, I'm merging them now, I
counted 6, 3 for compat, 3 for compat-wireless, if I missed anything
please let me know. Going to force out a new tarball now.

compat:

    compat: backport convert multicast list to list_head.
    compat: Add linux/version.h include before using it.
    compat: Add definitions needed for libertas sdio driver.

compat-wireless:

    compat-wireless: include net and trace includes form compat
    compat-wireless: Remove use of sdio quirks attribute
    compat-wireless: backport convert multicast list to list_head.

  Luis
