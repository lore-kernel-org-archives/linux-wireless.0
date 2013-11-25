Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:62387 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab3KYOPB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 09:15:01 -0500
Received: by mail-ie0-f172.google.com with SMTP id qd12so7047351ieb.17
        for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2013 06:15:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <000801cee981$02414cd0$06c3e670$%han@samsung.com>
References: <000601cee980$a2d1b0a0$e87511e0$%han@samsung.com>
	<000801cee981$02414cd0$06c3e670$%han@samsung.com>
Date: Mon, 25 Nov 2013 15:15:00 +0100
Message-ID: <CAL1gcdMT-070iRCosOQo_oGpok2szFFs9nW3qhXmYiTDQB8r0Q@mail.gmail.com> (sfid-20131125_151510_269253_C19F5CD9)
Subject: Re: [PATCH 3/3] wireless: rt2x00: remove unnecessary pci_set_drvdata()
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 25, 2013 at 2:52 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00pci.c |    3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
> index 25da20e..af72183 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
> @@ -156,8 +156,6 @@ exit_release_regions:
>  exit_disable_device:
>         pci_disable_device(pci_dev);
>
> -       pci_set_drvdata(pci_dev, NULL);
> -
>         return retval;
>  }
>  EXPORT_SYMBOL_GPL(rt2x00pci_probe);
> @@ -177,7 +175,6 @@ void rt2x00pci_remove(struct pci_dev *pci_dev)
>         /*
>          * Free the PCI device data.
>          */
> -       pci_set_drvdata(pci_dev, NULL);
>         pci_disable_device(pci_dev);
>         pci_release_regions(pci_dev);
>  }
> --
> 1.7.10.4
>
>



-- 
---
Gertjan
