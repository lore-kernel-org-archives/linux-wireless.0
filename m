Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B09F0C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 10:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DBED2087B
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 10:41:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbfBTKl5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 05:41:57 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37258 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbfBTKl5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 05:41:57 -0500
Received: by mail-wm1-f67.google.com with SMTP id x10so5857170wmg.2
        for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2019 02:41:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rb9qNldJOnNvQWHTaMOlGzNHQH9HEdpwbN/0DQR+jSc=;
        b=d3eMaPzh0cEyX68HA0IqFhu19DpaiFwUk/XvvVDq0+Y4g2NHdCmxywdFWqB4S9bL7d
         +K1pdfJOlxmqFdxvgKqUjTyUsCcsgk2swrOsoTTrgzKXgMrsc2hwJDv9BqKKwW7oYSHa
         kALLRgXGX1JaZgQZvqC+ITbbz/leJfdyOfkSFyjaZT1Ufg4gbkxXyb8txcoUSujeUO6D
         RSoXs8bMrM6s8qApUstKj6IbWUM2Q/L/tEbcuMDLxcDPAxqzb9f2yLbNKIJHGcCCn5vR
         yMF6vIGm6+06K1KGtGwrqPxMog2bCcnrwS0em+zpIJitc5zvCW9JvyBYcy+WaKSkJF2V
         IELQ==
X-Gm-Message-State: AHQUAube5vxymAVnhgZpa+5+129A/0DfRBceo9OiCeADNXGC7sDHhAmb
        qhcgDj0ApU0SNs5YBen6K/VXUg==
X-Google-Smtp-Source: AHgI3Iage5U9fVxWzpA90mEyGBdFgMuZRHXXdMG3ekKvgMvhXwi4shOqhNhAx+/N7+0qsfZAO56fAw==
X-Received: by 2002:a1c:f916:: with SMTP id x22mr6453991wmh.87.1550659315721;
        Wed, 20 Feb 2019 02:41:55 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id v4sm4745496wmg.1.2019.02.20.02.41.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Feb 2019 02:41:55 -0800 (PST)
Date:   Wed, 20 Feb 2019 11:41:53 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] mt76usb: remove usb_mcu.c
Message-ID: <20190220104152.GD2626@localhost.localdomain>
References: <1550657565-7263-1-git-send-email-sgruszka@redhat.com>
 <1550657565-7263-3-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1550657565-7263-3-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Don't need separate file just for kmalloc/kfree.
> 

same comments here kmalloc() --> devm_kmalloc().
Maybe this patch can be squashed with 2/3?

Regards,
Lorenzo

> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76.h          |  2 --
>  drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |  5 ----
>  .../net/wireless/mediatek/mt76/mt76x2/usb_init.c   |  5 ----
>  drivers/net/wireless/mediatek/mt76/usb.c           |  8 +++++
>  drivers/net/wireless/mediatek/mt76/usb_mcu.c       | 34 ----------------------
>  5 files changed, 8 insertions(+), 46 deletions(-)
>  delete mode 100644 drivers/net/wireless/mediatek/mt76/usb_mcu.c
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
> index ce53069461ec..972f0ca7c818 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76.h
> @@ -774,7 +774,5 @@ struct sk_buff *mt76_mcu_get_response(struct mt76_dev *dev,
>  				      unsigned long expires);
>  
>  void mt76u_mcu_complete_urb(struct urb *urb);
> -int mt76u_mcu_init_rx(struct mt76_dev *dev);
> -void mt76u_mcu_deinit(struct mt76_dev *dev);
>  
>  #endif
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> index f0c33890f1a5..91718647da02 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> @@ -79,7 +79,6 @@ static void mt76x0u_cleanup(struct mt76x02_dev *dev)
>  	clear_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
>  	mt76x0_chip_onoff(dev, false, false);
>  	mt76u_queues_deinit(&dev->mt76);
> -	mt76u_mcu_deinit(&dev->mt76);
>  }
>  
>  static void mt76x0u_mac_stop(struct mt76x02_dev *dev)
> @@ -193,10 +192,6 @@ static int mt76x0u_register_device(struct mt76x02_dev *dev)
>  	if (err < 0)
>  		goto out_err;
>  
> -	err = mt76u_mcu_init_rx(&dev->mt76);
> -	if (err < 0)
> -		goto out_err;
> -
>  	err = mt76x0u_init_hardware(dev);
>  	if (err < 0)
>  		goto out_err;
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
> index 090aaf71b3ef..1da90e58d942 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
> @@ -214,10 +214,6 @@ int mt76x2u_register_device(struct mt76x02_dev *dev)
>  	if (err < 0)
>  		goto fail;
>  
> -	err = mt76u_mcu_init_rx(&dev->mt76);
> -	if (err < 0)
> -		goto fail;
> -
>  	err = mt76x2u_init_hardware(dev);
>  	if (err < 0)
>  		goto fail;
> @@ -259,5 +255,4 @@ void mt76x2u_cleanup(struct mt76x02_dev *dev)
>  	mt76x02_mcu_set_radio_state(dev, false);
>  	mt76x2u_stop_hw(dev);
>  	mt76u_queues_deinit(&dev->mt76);
> -	mt76u_mcu_deinit(&dev->mt76);
>  }
> diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
> index 5c3b7f735aae..4fe025b92302 100644
> --- a/drivers/net/wireless/mediatek/mt76/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> @@ -577,9 +577,14 @@ EXPORT_SYMBOL_GPL(mt76u_submit_rx_buffers);
>  
>  static int mt76u_alloc_rx(struct mt76_dev *dev)
>  {
> +	struct mt76_usb *usb = &dev->usb;
>  	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
>  	int i, err;
>  
> +	usb->mcu.data = kmalloc(MCU_RESP_URB_SIZE, GFP_KERNEL);
> +	if (usb->mcu.data)
> +		return -ENOMEM;
> +
>  	spin_lock_init(&q->rx_page_lock);
>  	spin_lock_init(&q->lock);
>  	q->entry = devm_kcalloc(dev->dev,
> @@ -610,6 +615,7 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
>  
>  static void mt76u_free_rx(struct mt76_dev *dev)
>  {
> +	struct mt76_usb *usb = &dev->usb;
>  	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
>  	struct page *page;
>  	int i;
> @@ -626,6 +632,8 @@ static void mt76u_free_rx(struct mt76_dev *dev)
>  	memset(&q->rx_page, 0, sizeof(q->rx_page));
>  out:
>  	spin_unlock_bh(&q->rx_page_lock);
> +
> +	kfree(usb->mcu.data);
>  }
>  
>  static void mt76u_stop_rx(struct mt76_dev *dev)
> diff --git a/drivers/net/wireless/mediatek/mt76/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
> deleted file mode 100644
> index 747231edc57d..000000000000
> --- a/drivers/net/wireless/mediatek/mt76/usb_mcu.c
> +++ /dev/null
> @@ -1,34 +0,0 @@
> -/*
> - * Copyright (C) 2018 Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
> - *
> - * Permission to use, copy, modify, and/or distribute this software for any
> - * purpose with or without fee is hereby granted, provided that the above
> - * copyright notice and this permission notice appear in all copies.
> - *
> - * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> - * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> - * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
> - * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> - * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
> - * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
> - * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> - */
> -
> -#include "mt76.h"
> -
> -int mt76u_mcu_init_rx(struct mt76_dev *dev)
> -{
> -	struct mt76_usb *usb = &dev->usb;
> -
> -	usb->mcu.data = kmalloc(MCU_RESP_URB_SIZE, GFP_KERNEL);
> -	return usb->mcu.data ? 0 : -ENOMEM;
> -}
> -EXPORT_SYMBOL_GPL(mt76u_mcu_init_rx);
> -
> -void mt76u_mcu_deinit(struct mt76_dev *dev)
> -{
> -	struct mt76_usb *usb = &dev->usb;
> -
> -	kfree(usb->mcu.data);
> -}
> -EXPORT_SYMBOL_GPL(mt76u_mcu_deinit);
> -- 
> 2.7.5
> 
