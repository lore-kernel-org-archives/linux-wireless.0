Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47882 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab1HOM0e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 08:26:34 -0400
Received: by wwf5 with SMTP id 5so4796992wwf.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Aug 2011 05:26:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4e472623.xXZaXUueNVRpfmG+%Larry.Finger@lwfinger.net>
References: <4e472623.xXZaXUueNVRpfmG+%Larry.Finger@lwfinger.net>
Date: Mon, 15 Aug 2011 17:56:33 +0530
Message-ID: <CAD2nsn2sO+Lj+DntbFVa8QMYq8eTtFqdX06aQGHtNEbnbVTJzQ@mail.gmail.com> (sfid-20110815_142638_896439_6FD4BE45)
Subject: Re: [RFC/RFT] ath9k_htc: Fix memory leak
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, lrodriguez@atheros.com,
	vasanth@atheros.com, senthilkumar@atheros.com,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rmanohar@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 14, 2011 at 7:04 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Kmemleak shows the following kind of memory leak for ath9k_htc:
>
> unreferenced object 0xffff88004542f200 (size 512):
>  comm "khubd", pid 977, jiffies 4317632516 (age 16855.868s)
>  hex dump (first 32 bytes):
>    00 00 00 0a 00 00 00 00 00 02 01 05 00 00 02 01  ................
>    00 00 00 00 00 00 81 38 02 00 00 00 33 33 30 30  .......8....3300
>  backtrace:
>    [<ffffffff81122d77>] create_object+0x127/0x2b0
>    [<ffffffff813580b1>] kmemleak_alloc+0x21/0x50
>    [<ffffffff8111f383>] __kmalloc_node_track_caller+0x153/0x220
>    [<ffffffff812b703e>] __alloc_skb+0x7e/0x170
>    [<ffffffffa0833331>] htc_connect_service+0x111/0x200 [ath9k_htc]
>    [<ffffffffa083bb90>] ath9k_init_htc_services+0x240/0x2b0 [ath9k_htc]
>    [<ffffffffa083c1ca>] ath9k_htc_probe_device+0xea/0xa50 [ath9k_htc]
>    [<ffffffffa08338dc>] ath9k_htc_hw_init+0xc/0x30 [ath9k_htc]
>    [<ffffffffa08356ba>] ath9k_hif_usb_probe+0x1ca/0x420 [ath9k_htc]
>    [<ffffffffa00a2279>] usb_probe_interface+0xb9/0x160 [usbcore]
>    [<ffffffff81279379>] driver_probe_device+0x89/0x1a0
>    [<ffffffff8127958b>] __device_attach+0x4b/0x60
>    [<ffffffff81278024>] bus_for_each_drv+0x64/0x90
>    [<ffffffff81279231>] device_attach+0xa1/0xb0
>    [<ffffffff81278a25>] bus_probe_device+0x25/0x40
>    [<ffffffff81276d2a>] device_add+0x55a/0x630
>
> The device is a TP-Link TL-WN722N. The output from lsusb is "ID 0cf3:9271
> Atheros Communications, Inc. AR9271 802.11n".
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@kernel.org>
> ---
>
> This patch certainly fixes a leak. I'm testing to see if there are
> others.

Hi Larry,

thanks for finding this.
I remember seeing this memleaks sometime back and thought this patch
might help(i think same as yours with some more corner cases)
https://patchwork.kernel.org/patch/1016752/
but I found there were still some memory leaks, I was unsure where I
am missing. if you are sure that this addresses the issue, we can send
a patch.

>
> How far back should the patch go for stable kernels?
>
> Larry
> ---
>
> Index: wireless-testing-new/drivers/net/wireless/ath/ath9k/htc_hst.c
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/ath/ath9k/htc_hst.c
> +++ wireless-testing-new/drivers/net/wireless/ath/ath9k/htc_hst.c
> @@ -276,7 +276,8 @@ int htc_connect_service(struct htc_targe
>        if (!time_left) {
>                dev_err(target->dev, "Service connection timeout for: %d\n",
>                        service_connreq->service_id);
> -               return -ETIMEDOUT;
> +               ret = -ETIMEDOUT;
> +               goto err;
>        }
>
>        *conn_rsp_epid = target->conn_rsp_epid;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
shafi
