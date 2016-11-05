Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33982 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753009AbcKEMzW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Nov 2016 08:55:22 -0400
Received: by mail-wm0-f65.google.com with SMTP id p190so8080898wmp.1
        for <linux-wireless@vger.kernel.org>; Sat, 05 Nov 2016 05:55:21 -0700 (PDT)
Subject: Re: [PATCH 04/10] rt2800: do not overwrite
 WPDMA_GLO_CFG_WP_DMA_BURST_SIZE
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
References: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
 <1478095865-8651-5-git-send-email-sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
From: Mathias Kresin <dev@kresin.me>
Message-ID: <48e4790b-7cb3-170e-eda1-11bce9934141@kresin.me> (sfid-20161105_135526_701981_25D1DD51)
Date: Sat, 5 Nov 2016 13:55:14 +0100
MIME-Version: 1.0
In-Reply-To: <1478095865-8651-5-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

02.11.2016 15:10, Stanislaw Gruszka:
> We already initlized WPDMA_GLO_CFG_WP_DMA_BURST_SIZE to 3 on
> rt2800_init_registers().
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> index feceb13..9ecdc4c 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> @@ -6756,7 +6756,6 @@ int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev)
>  	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
>  	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 1);
>  	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 1);
> -	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_WP_DMA_BURST_SIZE, 2);

More a notice than a potential issue since I don't have much knowledge 
about the driver/chip internals.

But WPDMA_GLO_CFG_WP_DMA_BURST_SIZE in rt2800_init_registers() is set 
conditionally for rt2x00_is_usb(rt2x00dev), where this one is set 
unconditionally. Not sure if this change has side effects.

Mathias
