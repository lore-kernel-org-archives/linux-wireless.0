Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40820 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212Ab2DCGIJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 02:08:09 -0400
Received: by mail-lpp01m010-f46.google.com with SMTP id j13so3800277lah.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Apr 2012 23:08:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1333417250-24560-3-git-send-email-kubakici@wp.pl>
References: <1333417250-24560-1-git-send-email-kubakici@wp.pl>
	<1333417250-24560-3-git-send-email-kubakici@wp.pl>
Date: Tue, 3 Apr 2012 08:08:08 +0200
Message-ID: <CAL1gcdMS_oM03Je=imAVKC97SAk09q5dgLOUa9MJni-VUWvQ_Q@mail.gmail.com> (sfid-20120403_080812_358067_70FD9BAB)
Subject: Re: [PATCH v2 2/4] rt2800: add disabling of DMA before loading firmware
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Jakub Kicinski <kubakici@wp.pl>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 3, 2012 at 3:40 AM, Jakub Kicinski <kubakici@wp.pl> wrote:
> Legacy driver disables DMA before loading firmware.
>
> Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
> Reviewed-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> 2011_0406_RT5390_RT5392_Linux_STA_V2.5.0.3_DPO
> rtmp_init_inf.c:186
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 8aee6d4..cc6ca18 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -426,6 +426,8 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
>                rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000002);
>        }
>
> +       rt2800_disable_wpdma(rt2x00dev);
> +
>        /*
>         * Write firmware to the device.
>         */
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
---
Gertjan
